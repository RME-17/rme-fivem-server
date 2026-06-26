-- rme-tv  |  xSound audio layer for rde_oxmedia world TVs / radios
--
-- WHY THIS EXISTS:
--   rde_oxmedia renders video on world screens through a DUI. On FiveM builds
--   that do not route DUI audio, the picture plays but there is no sound.
--   xSound plays audio through NUI, which always has working sound. This script
--   watches rde_oxmedia's active devices and mirrors each one as a positional
--   xSound stream at the screen's location, so you get video (rde_oxmedia) plus
--   sound (xSound) on the same TV.
--
-- DEPENDENCIES: xsound, rde_oxmedia

local POLL_MS = 750

-- rde_oxmedia device key  ->  xSound sound name
local tracked = {}

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
    for key, name in pairs(tracked) do
        if exports['xsound']:soundExists(name) then
            exports['xsound']:Destroy(name)
        end
        tracked[key] = nil
    end
end

CreateThread(function()
    while true do
        Wait(POLL_MS)

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

                    local pos = dev.coords
                    if dev.entity and DoesEntityExist(dev.entity) then
                        pos = GetEntityCoords(dev.entity)
                    end

                    if not tracked[key] then
                        if pos then
                            exports['xsound']:PlayUrlPos(name, url, vol, pos, false)
                            exports['xsound']:Distance(name, range + 0.0)
                            tracked[key] = name
                        end
                    elseif exports['xsound']:soundExists(name) then
                        if pos then exports['xsound']:Position(name, pos) end
                        exports['xsound']:setVolume(name, vol)

                        if data.paused then
                            if exports['xsound']:isPlaying(name) then
                                exports['xsound']:Pause(name)
                            end
                        else
                            if exports['xsound']:isPaused(name) then
                                exports['xsound']:Resume(name)
                            end
                        end
                    else
                        -- track finished on its own
                        tracked[key] = nil
                    end
                end
            end

            for key, name in pairs(tracked) do
                if not seen[key] then
                    if exports['xsound']:soundExists(name) then
                        exports['xsound']:Destroy(name)
                    end
                    tracked[key] = nil
                end
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        stopAll()
    end
end)

print('^2[RME-TV]^7 xSound audio layer for rde_oxmedia loaded')
