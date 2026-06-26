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
--
-- NOTE: if xSound streamer mode is ON (disableMusic), PlayUrlPos returns early
-- WITHOUT creating the sound, so calling Distance/Position/etc. afterwards would
-- index a nil sound and error. We guard every xSound call accordingly.

local POLL_MS = 750
local tracked = {}   -- rde_oxmedia device key -> xSound sound name
local warnedStreamer = false

local function xsReady()      return GetResourceState('xsound') == 'started' end
local function oxmediaReady() return GetResourceState('rde_oxmedia') == 'started' end

local function streamerOn()
    local ok, on = pcall(function() return exports['xsound']:isPlayerInStreamerMode() end)
    return ok and on == true
end

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
        if exports['xsound']:soundExists(name) then exports['xsound']:Destroy(name) end
        tracked[key] = nil
    end
end

-- ---- startup diagnostics ------------------------------------------------
CreateThread(function()
    Wait(2500)
    print(xsReady() and '^2[RME-TV] xsound: STARTED^7' or '^1[RME-TV] xsound: NOT STARTED^7')
    print(oxmediaReady() and '^2[RME-TV] rde_oxmedia: STARTED^7' or '^1[RME-TV] rde_oxmedia: NOT STARTED^7')
    if xsReady() and streamerOn() then
        print('^3[RME-TV] WARNING: xSound streamer mode is ON - ALL xSound audio is suppressed. Type /streamermode in chat to turn it OFF.^7')
    end
    print('^3[RME-TV] In-game test: /rmetvsound plays a test MP3 straight through xSound.^7')
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
                local suppressed = streamerOn()
                if suppressed and not warnedStreamer then
                    print('^3[RME-TV] xSound streamer mode is ON - audio suppressed. /streamermode to turn OFF.^7')
                    warnedStreamer = true
                elseif not suppressed then
                    warnedStreamer = false
                end

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
                            -- only attempt to start when NOT suppressed; PlayUrlPos
                            -- would otherwise drop the sound and the follow-up
                            -- Distance() call would index a nil sound and error.
                            if pos and not suppressed then
                                exports['xsound']:PlayUrlPos(name, url, vol, pos, false)
                                if exports['xsound']:soundExists(name) then
                                    exports['xsound']:Distance(name, range + 0.0)
                                    tracked[key] = name
                                    print(('^2[RME-TV] start audio [%s] vol=%.2f range=%.1f url=%s^7')
                                        :format(key, vol, range, tostring(url):sub(1, 60)))
                                end
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
RegisterCommand('rmetvsound', function()
    if not xsReady() then print('^1[RME-TV] /rmetvsound: xsound not started.^7') return end
    if streamerOn() then
        print('^3[RME-TV] /rmetvsound: xSound streamer mode is ON - turn it OFF with /streamermode first.^7')
        return
    end
    exports['xsound']:PlayUrl('rme_tv_selftest', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', 0.6, false)
    print('^2[RME-TV] /rmetvsound: playing test MP3. Hear it = xSound OK. Silent = NUI audio on this PC.^7')
end, false)

RegisterCommand('rmetvstoptest', function()
    if xsReady() and exports['xsound']:soundExists('rme_tv_selftest') then
        exports['xsound']:Destroy('rme_tv_selftest')
    end
end, false)

print('^2[RME-TV] loaded^7')
