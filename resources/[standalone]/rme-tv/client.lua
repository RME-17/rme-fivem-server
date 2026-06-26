-- rme-tv  |  xSound audio layer for rde_oxmedia world TVs / radios
--
-- rde_oxmedia renders the VIDEO (DUI). On builds where DUI audio is not routed,
-- the picture plays but there is no sound. xSound plays audio through NUI, which
-- has working sound. This script mirrors rde_oxmedia's active devices and plays
-- each one's URL as a positional xSound stream at the screen.
--
-- Confirmed against rde_oxmedia client.lua getActiveDevices():
--   dev.entity, dev.coords, dev.data.url, dev.data.volume (0-100), dev.data.paused,
--   dev.config.audioRange, dev.config.type.

local POLL_MS = 750
local tracked = {}   -- rde_oxmedia device key -> xSound sound name

local function xsReady()      return GetResourceState('xsound') == 'started' end
local function oxmediaReady() return GetResourceState('rde_oxmedia') == 'started' end

local function soundNameFor(key)
    return 'rme_tv_' .. (tostring(key):gsub('[^%w]', '_'))
end

local function toXVolume(v)
    v = (tonumber(v) or 100) / 100.0
    if v < 0.0 then return 0.0 end
    if v > 1.0 then return 1.0 end
    return v
end

local function stopAll()
    if not xsReady() then tracked = {} return end
    for key, name in pairs(tracked) do
        if exports['xsound']:soundExists(name) then
            exports['xsound']:Destroy(name)
        end
        tracked[key] = nil
    end
end

-- ---- startup diagnostics ------------------------------------------------
CreateThread(function()
    Wait(2500)
    if xsReady() then
        print('^2[RME-TV] xsound: STARTED^7')
    else
        print('^1[RME-TV] xsound: NOT STARTED. Install the xsound folder in resources and add `ensure xsound` BEFORE rme-tv. No sound is possible until this is fixed.^7')
    end
    if oxmediaReady() then
        print('^2[RME-TV] rde_oxmedia: STARTED^7')
    else
        print('^1[RME-TV] rde_oxmedia: NOT STARTED.^7')
    end
    print('^3[RME-TV] In-game test: type /rmetvsound to play a test MP3 straight through xSound (bypasses rde_oxmedia).^7')
end)

-- ---- main bridge loop ---------------------------------------------------
CreateThread(function()
    while true do
        Wait(POLL_MS)
        if xsReady() and oxmediaReady() then
            local ok, devices = pcall(function()
                return exports['rde_oxmedia']:getActiveDevices()
            end)
            if ok and type(devices) == 'table' then
                local seen = {}
                for key, dev in pairs(devices) do
                    local data = dev and dev.data
                    local url  = data and data.url
                    if type(url) == 'string' and url ~= '' then
                        seen[key] = true
                        local name  = soundNameFor(key)
                        local vol   = toXVolume(data.volume)
                        local range = (dev.config and dev.config.audioRange) or 30.0
                        local pos   = dev.coords
                        if dev.entity and DoesEntityExist(dev.entity) then
                            pos = GetEntityCoords(dev.entity)
                        end

                        if not tracked[key] then
                            if pos then
                                print(('^2[RME-TV] start audio [%s] vol=%.2f range=%.1f url=%s^7')
                                    :format(key, vol, range, tostring(url):sub(1, 60)))
                                exports['xsound']:PlayUrlPos(name, url, vol, pos, false)
                                exports['xsound']:Distance(name, range + 0.0)
                                tracked[key] = name
                            end
                        elseif exports['xsound']:soundExists(name) then
                            if pos then exports['xsound']:Position(name, pos) end
                            exports['xsound']:setVolume(name, vol)
                            if data.paused then
                                if exports['xsound']:isPlaying(name) then exports['xsound']:Pause(name) end
                            else
                                if exports['xsound']:isPaused(name) then exports['xsound']:Resume(name) end
                            end
                        else
                            tracked[key] = nil
                        end
                    end
                end
                for key, name in pairs(tracked) do
                    if not seen[key] then
                        if exports['xsound']:soundExists(name) then exports['xsound']:Destroy(name) end
                        tracked[key] = nil
                    end
                end
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then stopAll() end
end)

-- ---- isolation self-test ------------------------------------------------
-- Plays a known-good MP3 through xSound at the player, with NO involvement from
-- rde_oxmedia. If you hear this, xSound works and the issue is the bridge/data.
-- If this is ALSO silent, the problem is xSound / NUI audio on this build.
RegisterCommand('rmetvsound', function()
    if not xsReady() then
        print('^1[RME-TV] /rmetvsound: xsound is not started.^7')
        return
    end
    local url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'
    exports['xsound']:PlayUrl('rme_tv_selftest', url, 0.6, false)
    print('^2[RME-TV] /rmetvsound: playing test MP3 through xSound. Hear it = xSound OK. Silent = xSound/NUI audio is the problem.^7')
end, false)

RegisterCommand('rmetvstoptest', function()
    if xsReady() and exports['xsound']:soundExists('rme_tv_selftest') then
        exports['xsound']:Destroy('rme_tv_selftest')
    end
end, false)

print('^2[RME-TV] loaded^7')
