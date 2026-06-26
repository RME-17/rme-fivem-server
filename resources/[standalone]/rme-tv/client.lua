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

-- ====================== TUNABLE ======================
-- Max distance (in metres) the TV/radio audio can be heard. This OVERRIDES
-- rde_oxmedia's per-device audioRange, so you can make a whole shop/club hear it.
--   ~20-30  = one room
--   ~70     = a whole mechanic shop interior
--   higher  = carries further outside too
-- Set to nil to use each device's own rde_oxmedia audioRange instead.
local AUDIO_RANGE = 70.0
-- =====================================================

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

local function rangeFor(dev)
    if AUDIO_RANGE then return AUDIO_RANGE + 0.0 end
    return ((dev.config and dev.config.audioRange) or 30.0) + 0.0
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
        print('^3[RME-TV] WARNING: xSound streamer mode is ON - audio suppressed. /streamermode to turn OFF.^7')
    end
    print(('^3[RME-TV] audio range = %s m. In-game test: /rmetvsound^7'):format(AUDIO_RANGE and tostring(AUDIO_RANGE) or 'per-device'))
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
                        local range = rangeFor(dev)
                        local pos   = dev.coords
                        if dev.entity and DoesEntityExist(dev.entity) then
                            pos = GetEntityCoords(dev.entity)
                        end

                        if not tracked[key] then
                            if pos and not suppressed then
                                exports['xsound']:PlayUrlPos(name, url, vol, pos, false)
                                if exports['xsound']:soundExists(name) then
                                    exports['xsound']:Distance(name, range)
                                    tracked[key] = name
                                    print(('^2[RME-TV] start audio [%s] vol=%.2f range=%.1f url=%s^7')
                                        :format(key, vol, range, tostring(url):sub(1, 60)))
                                end
                            end
                        elseif exports['xsound']:soundExists(name) then
                            if pos then exports['xsound']:Position(name, pos) end
                            exports['xsound']:setVolume(name, vol)
                            exports['xsound']:Distance(name, range)
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
        print('^3[RME-TV] /rmetvsound: xSound streamer mode is ON - /streamermode to turn OFF first.^7')
        return
    end
    exports['xsound']:PlayUrl('rme_tv_selftest', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', 0.6, false)
    print('^2[RME-TV] /rmetvsound: playing test MP3. Hear it = xSound OK.^7')
end, false)

RegisterCommand('rmetvstoptest', function()
    if xsReady() and exports['xsound']:soundExists('rme_tv_selftest') then
        exports['xsound']:Destroy('rme_tv_selftest')
    end
end, false)

-- ---- /tvmodel : identify the prop you are aiming at ---------------------
-- Aim your crosshair at the centre of the screen (a few metres away) and run
-- /tvmodel. It raycasts the entity, prints its model hash, the entity type, and
-- whether that model is already a configured rde_oxmedia device.
local CONFIGURED_MODELS = {
    'apa_mp_h_str_avunitl_01_b','apa_mp_h_str_avunitl_04','apa_mp_h_str_avunitm_01',
    'apa_mp_h_str_avunitm_03','apa_mp_h_str_avunits_01','apa_mp_h_str_avunits_04',
    'ba_prop_battle_club_speaker_large','ba_prop_battle_club_speaker_med',
    'ba_prop_battle_club_speaker_small','bkr_prop_clubhouse_jukebox_01a',
    'bkr_prop_clubhouse_jukebox_01b','bkr_prop_clubhouse_jukebox_02a',
    'ch_prop_arcade_jukebox_01a','ch_prop_ch_tv_rt_01a','des_tvsmash_start',
    'ex_prop_ex_tv_flat_01','gr_prop_gr_trailer_monitor_01','gr_prop_gr_trailer_monitor_02',
    'gr_prop_gr_trailer_monitor_03','gr_prop_gr_trailer_tv','gr_prop_gr_trailer_tv_02',
    'hei_heist_str_avunitl_03','hei_prop_dlc_tablet','p_tv_flat_01_s','prop_50s_jukebox',
    'prop_big_cin_screen','prop_boombox_01','prop_car_boot_01','prop_flatscreen_overlay',
    'prop_ghettoblast_01','prop_ghettoblast_02','prop_huge_display_01','prop_huge_display_02',
    'prop_jukebox_01','prop_monitor_01a','prop_monitor_01b','prop_monitor_02','prop_monitor_03b',
    'prop_monitor_w_large','prop_portable_hifi_01','prop_radio_01','prop_speaker_01',
    'prop_speaker_02','prop_speaker_03','prop_speaker_04','prop_speaker_05','prop_speaker_06',
    'prop_speaker_07','prop_speaker_08','prop_tapeplayer_01','prop_trev_tv_01','prop_tv_01',
    'prop_tv_02','prop_tv_03','prop_tv_03_overlay','prop_tv_04','prop_tv_05','prop_tv_06',
    'prop_tv_07','prop_tv_flat_01','prop_tv_flat_01_screen','prop_tv_flat_01b','prop_tv_flat_02',
    'prop_tv_flat_02b','prop_tv_flat_03','prop_tv_flat_03b','prop_tv_flat_michael',
    'sm_prop_smug_monitor_01','sm_prop_smug_radio_01','sm_prop_smug_tv_flat_01',
    'v_ilev_cin_screen','v_ilev_lest_bigscreen','v_ilev_mm_screen','v_ilev_mm_screen2',
    'vw_prop_vw_cinema_tv_01','xm_prop_x17_computer_02','xm_prop_x17_tv_flat_01',
    'xm_prop_x17dlc_monitor_wall_01a','xs_prop_arena_bigscreen_01','xs_prop_arena_screen_tv_01',
}

local function u32(x) return x & 0xFFFFFFFF end

local CONFIGURED_SET = {}
for _, n in ipairs(CONFIGURED_MODELS) do CONFIGURED_SET[u32(GetHashKey(n))] = n end

local function rotToDir(rot)
    local zr = math.rad(rot.z)
    local xr = math.rad(rot.x)
    local num = math.abs(math.cos(xr))
    return vector3(-math.sin(zr) * num, math.cos(zr) * num, math.sin(xr))
end

local function aimedEntity()
    local cam = GetGameplayCamCoord()
    local dir = rotToDir(GetGameplayCamRot(2))
    local dest = cam + (dir * 25.0)
    local ray = StartExpensiveSynchronousShapeTestLosProbe(cam.x, cam.y, cam.z, dest.x, dest.y, dest.z, -1, PlayerPedId(), 4)
    local _, hit, endCoords, _, entity = GetShapeTestResult(ray)
    return hit == 1, entity, endCoords
end

local function tvmsg(s)
    print('^5[tvmodel]^7 ' .. s)
    TriggerEvent('chat:addMessage', { color = { 0, 200, 255 }, args = { '[tvmodel]', (s:gsub('%^%d', '')) } })
end

RegisterCommand('tvmodel', function()
    local hit, entity, coords = aimedEntity()
    if not hit or not entity or entity == 0 or not DoesEntityExist(entity) then
        tvmsg('No entity in your crosshair. Stand 2-5m away, aim dead-centre at the screen, and run /tvmodel again.')
        return
    end
    local model = u32(GetEntityModel(entity))
    local etype = GetEntityType(entity)
    local typeStr = ({ [0] = 'none/map', [1] = 'ped', [2] = 'vehicle', [3] = 'object' })[etype] or ('type ' .. etype)
    local networked = NetworkGetEntityIsNetworked(entity)
    local name = CONFIGURED_SET[model]
    tvmsg(('entity=%s  type=%s  networked=%s'):format(entity, typeStr, tostring(networked)))
    tvmsg(('model hash = %d  (0x%X)'):format(model, model))
    if coords then
        tvmsg(('hit coords = %.2f, %.2f, %.2f'):format(coords.x, coords.y, coords.z))
    end
    if name then
        tvmsg(('MATCH -> this IS a configured rde_oxmedia device: %s'):format(name))
        tvmsg('Detection should work, so this is likely an MLO map-entity the E-key scan misses -> switch to target mode.')
    else
        tvmsg('NO MATCH -> this prop is NOT in the rde_oxmedia device list. Send me the model hash above to add it.')
    end
end, false)

print('^2[RME-TV] loaded^7')
