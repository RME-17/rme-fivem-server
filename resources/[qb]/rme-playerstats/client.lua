-- RME Player Stats (client)
-- Tracks each player's activity (running, swimming, shooting, driving, flying,
-- combat) and turns it into levelled skills that grant real gameplay perks:
--   * Running level  -> faster sprint speed
--   * Swimming level -> faster swim speed
--   * Stamina level  -> how long you keep that boosted speed before tiring
--   * Strength level -> more melee damage
-- Skills run from Lv1 to Config.MaxLevel (5). Press END to open/close the
-- panel. Stats persist per character (citizenid) and slowly regress only while
-- the player is actively in the city (see the decay thread below). Run
-- /resetstats to wipe your own progress back to Level 1.
--
-- Other resources (e.g. the gym) can grant skill XP via:
--   exports['rme-playerstats']:train('strength', 10)
--
-- The panel is a display-only overlay (it does NOT grab input focus), so it can
-- never trap the player - END always toggles it.

local QBCore = exports['qb-core']:GetCoreObject()

local Stats = nil      -- live stat table for the current character
local statsOpen = false

-- Cached perk values (re-asserted every frame so other resources cannot
-- silently override them).
local curRunMult, curSwimMult, curMeleeMult = 1.0, 1.0, 1.0
local perkTestMax = false -- /statsmaxtest toggles a temporary max-perk preview

local validSkills = {
    running = true, swimming = true, shooting = true, driving = true,
    flying = true, stamina = true, strength = true,
}

-- ---------- helpers ----------
local function comma(n)
    local s = tostring(math.floor(tonumber(n) or 0))
    local k
    while true do
        s, k = s:gsub('^(-?%d+)(%d%d%d)', '%1,%2')
        if k == 0 then break end
    end
    return s
end

local function fmtDist(m)
    m = tonumber(m) or 0
    if m >= 1000 then return string.format('%.1f km', m / 1000.0) end
    return math.floor(m) .. ' m'
end

local function fmtTime(sec)
    sec = math.floor(tonumber(sec) or 0)
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    if h > 0 then return h .. 'h ' .. m .. 'm' end
    return m .. 'm'
end

-- Current level + percent-to-next from a raw XP value. Caps at Config.MaxLevel.
local function levelInfo(xp)
    xp = math.floor(tonumber(xp) or 0)
    local level = 1
    local rem = xp
    while level < Config.MaxLevel do
        local need = Config.PerLevelBase * level
        if rem < need then break end
        rem = rem - need
        level = level + 1
    end
    local need = Config.PerLevelBase * level
    local pct = (level >= Config.MaxLevel) and 100 or math.floor((rem / need) * 100)
    if pct < 0 then pct = 0 elseif pct > 100 then pct = 100 end
    return level, pct
end

-- Raw XP for each skill, derived from the stored activity counters + any bonus
-- XP earned through training (gym, etc.).
local function skillXp()
    local s = Stats or {}
    return {
        running  = (s.sprint_distance or 0) * Config.Xp.sprintPerMeter + (s.run_distance or 0) * Config.Xp.joggPerMeter + (s.bonus_running or 0),
        swimming = (s.swim_distance or 0) * Config.Xp.swimPerMeter + (s.bonus_swimming or 0),
        shooting = (s.shots_hit or 0) * Config.Xp.hit + (s.bonus_shooting or 0),
        driving  = (s.drive_distance or 0) * Config.Xp.drivePerMeter + (s.bonus_driving or 0),
        flying   = (s.fly_distance or 0) * Config.Xp.flyPerMeter + (s.bonus_flying or 0),
        stamina  = (s.sprint_distance or 0) * Config.Xp.staminaSprint + (s.swim_distance or 0) * Config.Xp.staminaSwim + (s.bonus_stamina or 0),
        strength = (s.kills or 0) * Config.Xp.kill + (s.bonus_strength or 0),
    }
end

-- ---------- gameplay perks ----------
-- Perks scale LINEARLY with level so a 5-level cap reads cleanly: Level 1
-- (untrained) gives no bonus and the full bonus is reached at Config.MaxLevel.
-- Returns a 0..1 factor (Lv1=0, Lv2=.25, Lv3=.5, Lv4=.75, Lv5=1 at MaxLevel 5).
local function perkFactor(level)
    local denom = Config.MaxLevel - 1
    if denom < 1 then return 1.0 end
    local f = (math.min(level, Config.MaxLevel) - 1) / denom
    if f < 0 then f = 0 elseif f > 1 then f = 1 end
    return f
end

local function recomputePerks()
    if not Stats then
        curRunMult, curSwimMult, curMeleeMult = 1.0, 1.0, 1.0
        return
    end
    local xp = skillXp()
    local rf = perkFactor((levelInfo(xp.running)))
    local sf = perkFactor((levelInfo(xp.swimming)))
    local stf = perkFactor((levelInfo(xp.strength)))
    if perkTestMax then rf, sf, stf = 1.0, 1.0, 1.0 end
    curRunMult = 1.0 + rf * Config.Perks.maxRunBonus
    curSwimMult = 1.0 + sf * Config.Perks.maxSwimBonus
    curMeleeMult = 1.0 + stf * Config.Perks.maxMeleeBonus
end

AddEventHandler('playerSpawned', function()
    Wait(1000)
    recomputePerks()
end)

-- Re-assert the perks every frame so they always win over other scripts.
CreateThread(function()
    while true do
        if Stats then
            local pid = PlayerId()
            SetRunSprintMultiplierForPlayer(pid, curRunMult)
            SetSwimMultiplierForPlayer(pid, curSwimMult)
            SetPlayerMeleeWeaponDamageModifier(pid, curMeleeMult)
            Wait(0)
        else
            Wait(500)
        end
    end
end)

-- Stamina perk: while sprinting (or swimming) top up stamina based on your
-- Stamina LEVEL so the boosted speed lasts longer before you tire. The restore
-- ramps linearly from 0 at level 1 (you tire at the normal rate - keeps the old
-- 'sprint forever at low level' bug fixed) up to Config.Stamina.maxRestore at
-- Config.Stamina.fullLevel and above (sprint effectively endless). Only ever
-- ADDS stamina, never reduces it.
CreateThread(function()
    while true do
        Wait(400)
        if Stats then
            local ped = PlayerPedId()
            if IsPedSprinting(ped) or IsPedSwimming(ped) then
                local lvl = (levelInfo(skillXp().stamina))
                local full = Config.Stamina.fullLevel or 5
                local t = 0.0
                if full > 1 then t = (lvl - 1) / (full - 1) end
                if t < 0.0 then t = 0.0 elseif t > 1.0 then t = 1.0 end
                local restore = t * (Config.Stamina.maxRestore or 0.07)
                if perkTestMax then restore = 1.0 end
                if restore > 0.0 then RestorePlayerStamina(PlayerId(), restore) end
            end
        end
    end
end)

-- ---------- load / save ----------
local function fetchStats()
    QBCore.Functions.TriggerCallback('rme-playerstats:server:get', function(data)
        if data and type(data) == 'table' then
            Stats = data
            recomputePerks()
        end
    end)
end

local function saveStats()
    if Stats then TriggerServerEvent('rme-playerstats:server:save', Stats) end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    fetchStats()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    saveStats()
    Stats = nil
    curRunMult, curSwimMult, curMeleeMult = 1.0, 1.0, 1.0
end)

AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    if LocalPlayer.state.isLoggedIn then fetchStats() end
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then saveStats() end
end)

CreateThread(function()
    while true do
        Wait(Config.SaveInterval * 1000)
        saveStats()
    end
end)

-- 'Use it or lose it' decay - applied ONLY while the player is actively in the
-- city (Stats loaded = connected + spawned). Each slice trims a small fraction
-- off every skill-driving counter so levels gradually trend down unless the
-- player keeps training. Time spent offline / away never decays anything (the
-- server does not decay on load), so this is purely active-play based.
CreateThread(function()
    while true do
        local interval = (Config.Decay and Config.Decay.intervalSeconds) or 60
        Wait(interval * 1000)
        if Stats and Config.Decay and Config.Decay.enabled and (Config.Decay.perActiveHour or 0) > 0 then
            local frac = Config.Decay.perActiveHour * (interval / 3600.0)
            local factor = 1.0 - frac
            if factor < 0.0 then factor = 0.0 end
            for _, k in ipairs(Config.Decay.keys or {}) do
                local v = tonumber(Stats[k])
                if v and v > 0 then Stats[k] = v * factor end
            end
            recomputePerks()
        end
    end
end)

-- External training hook: other resources grant skill XP through this.
exports('train', function(skill, amount)
    if not Stats then return false end
    if not skill or not validSkills[skill] then return false end
    amount = tonumber(amount) or 0
    if amount <= 0 then return false end
    local key = 'bonus_' .. skill
    Stats[key] = (Stats[key] or 0) + amount
    recomputePerks()
    return true
end)

-- Read-only access to current level of a skill (handy for other resources).
exports('getLevel', function(skill)
    if not Stats or not skill or not validSkills[skill] then return 0 end
    local lvl = levelInfo(skillXp()[skill])
    return lvl
end)

-- ---------- activity tracking ----------
CreateThread(function()
    local last = GetEntityCoords(PlayerPedId())
    local wasDead = false
    while true do
        Wait(500)
        if Stats then
            local ped = PlayerPedId()
            local cur = GetEntityCoords(ped)
            local d = #(cur - last)
            last = cur

            Stats.playtime = (Stats.playtime or 0) + 0.5

            if d > 0.05 and d < 120.0 then
                if IsPedSwimming(ped) then
                    Stats.swim_distance = (Stats.swim_distance or 0) + d
                elseif IsPedInAnyVehicle(ped, false) then
                    local veh = GetVehiclePedIsIn(ped, false)
                    if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
                        local class = GetVehicleClass(veh)
                        if (class == 15 or class == 16) and IsEntityInAir(veh) then
                            Stats.fly_distance = (Stats.fly_distance or 0) + d
                        else
                            Stats.drive_distance = (Stats.drive_distance or 0) + d
                        end
                    end
                else
                    if IsPedSprinting(ped) then
                        Stats.sprint_distance = (Stats.sprint_distance or 0) + d
                    else
                        Stats.run_distance = (Stats.run_distance or 0) + d
                    end
                end
            end

            local dead = IsEntityDead(ped)
            if dead and not wasDead then Stats.deaths = (Stats.deaths or 0) + 1 end
            wasDead = dead

            recomputePerks()
        end
    end
end)

-- Shots fired: count clip drops while actively shooting.
CreateThread(function()
    local lastClip = nil
    while true do
        if Stats then
            local ped = PlayerPedId()
            local wep = GetSelectedPedWeapon(ped)
            local _, clip = GetAmmoInClip(ped, wep)
            if IsPedShooting(ped) and lastClip and clip and clip < lastClip then
                Stats.shots_fired = (Stats.shots_fired or 0) + (lastClip - clip)
            end
            lastClip = clip
            Wait(0)
        else
            Wait(500)
        end
    end
end)

-- Hits & kills via the local player damaging peds.
--   * Shooting skill: only FIREARM hits count (IsPedArmed gun check), so melee
--     swings and punches never raise Shooting.
--   * Strength skill: fed by kills (takedowns), regardless of weapon used.
local countedDeaths = {}
AddEventHandler('gameEventTriggered', function(event, data)
    if event ~= 'CEventNetworkEntityDamage' then return end
    if not Stats then return end
    local victim = data[1]
    local attacker = data[2]
    local ped = PlayerPedId()
    if attacker ~= ped or not victim or victim == 0 or victim == ped then return end
    if not IsEntityAPed(victim) then return end

    -- Only count toward Shooting when the player is using a gun.
    if IsPedArmed(ped, 4) then
        Stats.shots_hit = (Stats.shots_hit or 0) + 1
    end

    local v = victim
    CreateThread(function()
        for _ = 1, 20 do
            Wait(50)
            if not DoesEntityExist(v) then return end
            if IsEntityDead(v) then
                if not countedDeaths[v] then
                    countedDeaths[v] = true
                    Stats.kills = (Stats.kills or 0) + 1
                end
                return
            end
        end
    end)
end)

CreateThread(function()
    while true do
        Wait(300000)
        countedDeaths = {}
    end
end)

-- ---------- UI payload ----------
local function buildPayload()
    local s = Stats or {}
    local xp = skillXp()
    local foot = (s.run_distance or 0) + (s.sprint_distance or 0)
    local acc = 0
    if (s.shots_fired or 0) > 0 then acc = math.floor(((s.shots_hit or 0) / s.shots_fired) * 100) end

    local skills = {}
    local function add(label, icon, xpVal, sub)
        local lvl, pct = levelInfo(xpVal)
        skills[#skills + 1] = { label = label, icon = icon, level = lvl, pct = pct, sub = sub, maxLevel = Config.MaxLevel }
    end

    add('Running', '\240\159\143\131', xp.running, fmtDist(s.sprint_distance) .. ' sprinted')
    add('Swimming', '\240\159\143\138', xp.swimming, fmtDist(s.swim_distance) .. ' swum')
    add('Shooting', '\240\159\142\175', xp.shooting, acc .. '% accuracy')
    add('Driving', '\240\159\154\151', xp.driving, fmtDist(s.drive_distance) .. ' driven')
    add('Flying', '\226\156\136\239\184\143', xp.flying, fmtDist(s.fly_distance) .. ' flown')
    add('Stamina', '\240\159\171\129', xp.stamina, fmtTime(s.playtime) .. ' active')
    add('Strength', '\240\159\146\170', xp.strength, comma(s.kills or 0) .. ' takedowns')

    local overview = {
        { label = 'Distance on foot', value = fmtDist(foot) },
        { label = 'Distance driven',  value = fmtDist(s.drive_distance) },
        { label = 'Distance swum',    value = fmtDist(s.swim_distance) },
        { label = 'Distance flown',   value = fmtDist(s.fly_distance) },
    }

    return { skills = skills, overview = overview }
end

-- ---------- open / close (END) ----------
local function openStats()
    if not Stats then
        TriggerEvent('QBCore:Notify', 'Your stats are still loading...', 'error')
        return
    end
    statsOpen = true
    SendNUIMessage({ action = 'open', data = buildPayload() })
end

local function closeStats()
    statsOpen = false
    SendNUIMessage({ action = 'close' })
end

RegisterCommand('rme_playerstats_toggle', function()
    if statsOpen then closeStats() else openStats() end
end, false)
RegisterKeyMapping('rme_playerstats_toggle', 'Open / close Player Stats panel', 'keyboard', 'END')

RegisterCommand('mystats', function()
    if statsOpen then closeStats() else openStats() end
end, false)

-- ---------- reset ----------
-- Server hands back a fresh (all-zero) stat table; swap it in live so perks and
-- the open panel update immediately without needing a relog.
RegisterNetEvent('rme-playerstats:client:reset', function(fresh)
    if type(fresh) == 'table' then Stats = fresh end
    recomputePerks()
    if statsOpen then SendNUIMessage({ action = 'update', data = buildPayload() }) end
    TriggerEvent('QBCore:Notify', 'Your stats have been reset to Level 1.', 'success')
end)

RegisterCommand('resetstats', function()
    if not Stats then
        TriggerEvent('QBCore:Notify', 'Your stats are still loading...', 'error')
        return
    end
    TriggerServerEvent('rme-playerstats:server:reset')
end, false)

-- ---------- debug / test ----------
RegisterCommand('statsmaxtest', function()
    perkTestMax = not perkTestMax
    recomputePerks()
    TriggerEvent('QBCore:Notify', perkTestMax and 'Perk TEST: MAX run/swim/stamina/strength ON' or 'Perk TEST: off (back to your real level)', 'primary')
end, false)

RegisterCommand('statsperk', function()
    recomputePerks()
    TriggerEvent('QBCore:Notify', string.format('Sprint x%.2f  |  Swim x%.2f  |  Melee x%.2f', curRunMult, curSwimMult, curMeleeMult), 'primary')
end, false)

CreateThread(function()
    while true do
        Wait(2000)
        if statsOpen and Stats then
            SendNUIMessage({ action = 'update', data = buildPayload() })
        end
    end
end)
