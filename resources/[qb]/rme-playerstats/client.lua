-- RME Player Stats (client)
-- Tracks each player's activity (running, swimming, shooting, driving, flying,
-- combat) and turns it into levelled skills that grant real gameplay perks:
--   * Running level  -> faster sprint speed
--   * Swimming level -> faster swim speed
--   * Stamina level  -> how long you keep that boosted speed before tiring
-- Press END to open/close the panel. Stats persist per character (citizenid)
-- and slowly regress while a player is away (handled server-side).
--
-- The panel is a display-only overlay (it does NOT grab input focus), so it can
-- never trap the player - END always toggles it.

local QBCore = exports['qb-core']:GetCoreObject()

local Stats = nil      -- live stat table for the current character
local statsOpen = false

-- Cached perk multipliers (re-asserted every frame so other resources cannot
-- silently override them).
local curRunMult, curSwimMult = 1.0, 1.0
local perkTestMax = false -- /statsmaxtest toggles a temporary max-perk preview

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

-- Current level + percent-to-next from a raw XP value.
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

-- Raw XP for each skill, derived from the stored activity counters.
local function skillXp()
    local s = Stats or {}
    return {
        running  = (s.sprint_distance or 0) * Config.Xp.sprintPerMeter + (s.run_distance or 0) * Config.Xp.joggPerMeter,
        swimming = (s.swim_distance or 0) * Config.Xp.swimPerMeter,
        shooting = (s.shots_hit or 0) * Config.Xp.hit, -- only hits earn XP, so accuracy matters
        driving  = (s.drive_distance or 0) * Config.Xp.drivePerMeter,
        flying   = (s.fly_distance or 0) * Config.Xp.flyPerMeter,
        stamina  = (s.sprint_distance or 0) * Config.Xp.staminaSprint + (s.swim_distance or 0) * Config.Xp.staminaSwim,
        strength = (s.kills or 0) * Config.Xp.kill,
    }
end

-- ---------- gameplay perks ----------
-- Front-loaded curve (sqrt) for run/swim speed so early levels give a noticeable
-- boost and it ramps to the full bonus at max level. Returns a 0..1 factor.
local function perkFactor(level)
    local f = math.sqrt(math.min(level, Config.MaxLevel) / Config.MaxLevel)
    if f < 0 then f = 0 elseif f > 1 then f = 1 end
    return f
end

local function recomputePerks()
    if not Stats then
        curRunMult, curSwimMult = 1.0, 1.0
        return
    end
    local xp = skillXp()
    local rf = perkFactor((levelInfo(xp.running)))
    local sf = perkFactor((levelInfo(xp.swimming)))
    if perkTestMax then rf, sf = 1.0, 1.0 end
    curRunMult = 1.0 + rf * Config.Perks.maxRunBonus
    curSwimMult = 1.0 + sf * Config.Perks.maxSwimBonus
end

AddEventHandler('playerSpawned', function()
    Wait(1000)
    recomputePerks()
end)

-- Re-assert the run/swim multipliers every frame so they always win over other
-- movement scripts. Values are cached, so this loop is cheap.
CreateThread(function()
    while true do
        if Stats then
            local pid = PlayerId()
            SetRunSprintMultiplierForPlayer(pid, curRunMult)
            SetSwimMultiplierForPlayer(pid, curSwimMult)
            Wait(0)
        else
            Wait(500)
        end
    end
end)

-- Stamina perk: while sprinting (or swimming) top up stamina based on Stamina
-- level, using a SQUARED curve so it is negligible at low level (you tire
-- normally) and only becomes meaningful at high level. It only ever ADDS
-- stamina, never removes it.
CreateThread(function()
    while true do
        Wait(400)
        if Stats then
            local ped = PlayerPedId()
            if IsPedSprinting(ped) or IsPedSwimming(ped) then
                local lf = math.min((levelInfo(skillXp().stamina)), Config.MaxLevel) / Config.MaxLevel -- linear 0..1
                local restore = lf * lf * Config.Perks.staminaRestore
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
    curRunMult, curSwimMult = 1.0, 1.0
end)

AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    if LocalPlayer.state.isLoggedIn then fetchStats() end
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then saveStats() end
end)

-- Auto-save on an interval.
CreateThread(function()
    while true do
        Wait(Config.SaveInterval * 1000)
        saveStats()
    end
end)

-- ---------- activity tracking ----------
-- Distance-based: measure how far the ped moves each tick and bucket that
-- distance by what they were doing (swimming / driving / flying / on foot).
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

            -- Ignore tiny jitter and large teleports/respawns.
            if d > 0.05 and d < 120.0 then
                if IsPedSwimming(ped) then
                    Stats.swim_distance = (Stats.swim_distance or 0) + d
                elseif IsPedInAnyVehicle(ped, false) then
                    local veh = GetVehiclePedIsIn(ped, false)
                    -- Only count distance when WE are the driver.
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

            -- Death counter (rising edge). Still tracked internally; not shown.
            local dead = IsEntityDead(ped)
            if dead and not wasDead then Stats.deaths = (Stats.deaths or 0) + 1 end
            wasDead = dead

            -- Keep perks in sync as levels change.
            recomputePerks()
        end
    end
end)

-- Shots fired: count how much the clip drops while actively shooting.
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

-- Hits & kills: when the local player damages a ped, count a hit; if that ped
-- dies shortly after, count a kill. Death is verified directly so we do not rely
-- on fragile damage-event argument indices.
local countedDeaths = {}
AddEventHandler('gameEventTriggered', function(event, data)
    if event ~= 'CEventNetworkEntityDamage' then return end
    if not Stats then return end
    local victim = data[1]
    local attacker = data[2]
    local ped = PlayerPedId()
    if attacker ~= ped or not victim or victim == 0 or victim == ped then return end
    if not IsEntityAPed(victim) then return end

    Stats.shots_hit = (Stats.shots_hit or 0) + 1

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

-- Periodically clear the dead-entity guard (entity handles get reused).
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
        skills[#skills + 1] = { label = label, icon = icon, level = lvl, pct = pct, sub = sub }
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

-- Chat fallback in case the key is unbound: /mystats
RegisterCommand('mystats', function()
    if statsOpen then closeStats() else openStats() end
end, false)

-- ---------- debug / test ----------
-- Toggle a TEMPORARY max-perk preview (not saved) so you can feel the maxed
-- run/swim speed + endless stamina right away to confirm the perks work.
RegisterCommand('statsmaxtest', function()
    perkTestMax = not perkTestMax
    recomputePerks()
    TriggerEvent('QBCore:Notify', perkTestMax and 'Perk TEST: MAX run/swim/stamina ON' or 'Perk TEST: off (back to your real level)', 'primary')
end, false)

-- Print the multipliers currently being applied.
RegisterCommand('statsperk', function()
    recomputePerks()
    TriggerEvent('QBCore:Notify', string.format('Sprint x%.2f  |  Swim x%.2f', curRunMult, curSwimMult), 'primary')
end, false)

-- Refresh the panel live while it is open.
CreateThread(function()
    while true do
        Wait(2000)
        if statsOpen and Stats then
            SendNUIMessage({ action = 'update', data = buildPayload() })
        end
    end
end)
