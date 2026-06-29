-- RME Gym (client)
-- Walk up to a placed gym station, press E, and your character works out -
-- earning skill XP (via rme-playerstats) over time. Each set lasts
-- Config.WorkoutSeconds (default 60s) then auto-stops; press E again to repeat.
-- A valid gym membership is required (bought from the front-desk ped). Admins
-- place stations with /gymadd, the front-desk ped with /gymsetped, remove
-- unwanted props with /gymremoveprop, and snapshot the build with /gymexport.

local QBCore = exports['qb-core']:GetCoreObject()

local stations = {}
local stationsReady = false
local working = false

local removedProps = {}
local membershipPed = nil
local pedCoords = nil

-- Cached membership state for the on-screen countdown. We refresh `remaining`
-- from the server periodically while at the gym and tick it down locally so the
-- timer counts smoothly without spamming the server.
local membershipChecked = false
local membershipRemaining = 0.0
local membershipRefreshAt = 0

local function kindList()
    local t = {}
    for k in pairs(Config.Stations) do t[#t + 1] = k end
    table.sort(t)
    return t
end

local function helpText(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local function notify(msg, kind)
    TriggerEvent('QBCore:Notify', msg, kind or 'primary')
end

local function requestData()
    TriggerServerEvent('rme-gym:server:request')
end

-- ---------- membership timer helpers ----------
local function refreshMembership()
    membershipRefreshAt = GetGameTimer()
    QBCore.Functions.TriggerCallback('rme-gym:server:hasMembership', function(valid, remaining)
        membershipChecked = true
        membershipRemaining = (valid and (remaining + 0.0)) or 0.0
        membershipRefreshAt = GetGameTimer()
    end)
end

local function currentRemaining()
    if not membershipChecked then return 0.0 end
    local elapsed = (GetGameTimer() - membershipRefreshAt) / 1000.0
    local r = membershipRemaining - elapsed
    if r < 0.0 then r = 0.0 end
    return r
end

local function fmtRemaining(sec)
    sec = math.floor(sec)
    local m = math.floor(sec / 60)
    local s = sec % 60
    if m >= 60 then
        local h = math.floor(m / 60)
        m = m % 60
        return ('%dh %02dm'):format(h, m)
    end
    return ('%02d:%02d'):format(m, s)
end

local function drawMembershipTimer()
    local rem = currentRemaining()
    local txt, r, g, b
    if rem > 0.0 then
        txt = 'Gym Membership  ~s~' .. fmtRemaining(rem)
        r, g, b = 120, 230, 140
    else
        txt = '~r~No Gym Membership~s~ - see the front desk'
        r, g, b = 235, 90, 80
    end
    SetTextFont(4)
    SetTextScale(0.0, 0.44)
    SetTextColour(r, g, b, 255)
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentSubstringPlayerName(txt)
    DrawText(0.5, 0.86)
end

-- ---------- prop removal (radio, etc.) ----------
local function applyRemovals()
    for _, p in ipairs(removedProps) do
        local model = p.model + 0
        local obj = GetClosestObjectOfType(p.x + 0.0, p.y + 0.0, p.z + 0.0, 2.0, model, false, false, false)
        if obj and obj ~= 0 then
            SetEntityAsMissionEntity(obj, true, true)
            DeleteObject(obj)
            if DoesEntityExist(obj) then DeleteEntity(obj) end
        end
        CreateModelHide(p.x + 0.0, p.y + 0.0, p.z + 0.0, 2.0, model, true)
    end
end

RegisterNetEvent('rme-gym:client:syncRemoved', function(list)
    removedProps = list or {}
    applyRemovals()
end)

local function getAimedObject()
    local ped = PlayerPedId()
    local camCoord = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)
    local z = math.rad(camRot.z)
    local x = math.rad(camRot.x)
    local num = math.abs(math.cos(x))
    local dir = vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
    local dest = camCoord + dir * 18.0
    local ray = StartShapeTestRay(camCoord.x, camCoord.y, camCoord.z, dest.x, dest.y, dest.z, 16, ped, 4)
    local _, hit, _, _, entity = GetShapeTestResult(ray)
    if hit == 1 and entity and entity ~= 0 and IsEntityAnObject(entity) then return entity end
    return 0
end

RegisterCommand('gymremoveprop', function()
    local obj = getAimedObject()
    if obj == 0 then
        notify('Look directly at the prop you want to remove, then run /gymremoveprop again.', 'error')
        return
    end
    local model = GetEntityModel(obj)
    local c = GetEntityCoords(obj)
    -- delete locally right away for instant feedback
    SetEntityAsMissionEntity(obj, true, true)
    DeleteObject(obj)
    if DoesEntityExist(obj) then DeleteEntity(obj) end
    TriggerServerEvent('rme-gym:server:addRemovedProp', { model = model, x = c.x + 0.0, y = c.y + 0.0, z = c.z + 0.0 })
    notify('Prop removed.', 'success')
end, false)

-- ---------- membership front-desk ped ----------
local function deletePed()
    if membershipPed and DoesEntityExist(membershipPed) then
        DeletePed(membershipPed)
    end
    membershipPed = nil
end

local function spawnPed()
    if not pedCoords then return end
    deletePed()
    local m = Config.Membership
    local hash = GetHashKey(m.pedModel)
    RequestModel(hash)
    local tries = 0
    while not HasModelLoaded(hash) and tries < 200 do
        Wait(10)
        tries = tries + 1
    end
    if not HasModelLoaded(hash) then return end
    -- /gymsetped captures the player's centre, which sits ~1m above the floor,
    -- so we drop the ped 1m to plant its feet on the ground. This is the same
    -- offset qb-core's own ped spawners use. Adjust Config.Membership.pedZOffset
    -- if it still sits slightly high/low on a particular MLO.
    local z = pedCoords.z - 1.0 + (m.pedZOffset or 0.0)
    membershipPed = CreatePed(4, hash, pedCoords.x + 0.0, pedCoords.y + 0.0, z + 0.0, pedCoords.h + 0.0, false, true)
    SetEntityCoordsNoOffset(membershipPed, pedCoords.x + 0.0, pedCoords.y + 0.0, z + 0.0, false, false, false)
    SetEntityHeading(membershipPed, pedCoords.h + 0.0)
    SetEntityInvincible(membershipPed, true)
    FreezeEntityPosition(membershipPed, true)
    SetBlockingOfNonTemporaryEvents(membershipPed, true)
    TaskStartScenarioInPlace(membershipPed, 'WORLD_HUMAN_CLIPBOARD', 0, true)
    SetModelAsNoLongerNeeded(hash)
    exports['qb-target']:AddTargetEntity(membershipPed, {
        options = {
            {
                type = 'client',
                event = 'rme-gym:client:openMembership',
                icon = 'fas fa-id-card',
                label = 'Buy Gym Membership ($' .. m.price .. ' / 1h)',
            },
        },
        distance = 2.5,
    })
end

RegisterNetEvent('rme-gym:client:syncPed', function(coords)
    pedCoords = coords
    spawnPed()
end)

RegisterNetEvent('rme-gym:client:openMembership', function()
    TriggerServerEvent('rme-gym:server:buyMembership')
end)

RegisterNetEvent('rme-gym:client:membershipBought', function()
    notify('Gym membership active. Get to work!', 'success')
    refreshMembership()
end)

-- ---------- stations sync ----------
RegisterNetEvent('rme-gym:client:sync', function(list)
    stations = list or {}
    stationsReady = true
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    requestData()
    refreshMembership()
end)

AddEventHandler('onResourceStart', function(res)
    if res == GetCurrentResourceName() then requestData() end
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then deletePed() end
end)

CreateThread(function()
    Wait(1500)
    requestData()
    refreshMembership()
end)

-- ---------- workout ----------
local function clearWeightProps()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    for _, obj in ipairs(GetGamePool('CObject')) do
        local model = GetEntityModel(obj)
        for _, name in ipairs(Config.WeightProps) do
            if model == GetHashKey(name) and #(GetEntityCoords(obj) - coords) < 3.0 then
                SetEntityAsMissionEntity(obj, true, true)
                DeleteObject(obj)
                if DoesEntityExist(obj) then DeleteEntity(obj) end
                break
            end
        end
    end
end

local function stopWorkout()
    working = false
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    CreateThread(function()
        Wait(50)
        clearWeightProps()
    end)
end

-- A workout set runs for Config.WorkoutSeconds and then stops on its own. The
-- proximity loop's help text reappears so the player just presses E to start
-- another set. No QBCore notifications are shown so nothing pops up on the side
-- of the screen while training or walking out of the gym.
local function startWorkout(st)
    if working then return end
    local def = Config.Stations[st.kind]
    if not def then return end
    working = true
    local ped = PlayerPedId()
    if st.h then SetEntityHeading(ped, st.h + 0.0) end
    TaskStartScenarioInPlace(ped, def.scenario, 0, true)

    CreateThread(function()
        local started = GetGameTimer()
        local sinceTick = 0.0
        local origin = vector3(st.x, st.y, st.z)
        local maxMs = (Config.WorkoutSeconds or 60) * 1000
        while working do
            Wait(0)
            local p = PlayerPedId()
            sinceTick = sinceTick + GetFrameTime() * 1000.0

            if sinceTick >= Config.TickMs then
                sinceTick = 0.0
                for skill, amt in pairs(def.train) do
                    exports['rme-playerstats']:train(skill, amt)
                end
            end

            local elapsed = GetGameTimer() - started
            if elapsed >= maxMs then break end
            if elapsed > 700 and IsControlJustReleased(0, 38) then break end
            if IsEntityDead(p) then break end
            if IsPedShooting(p) then break end
            if #(GetEntityCoords(p) - origin) > 2.5 then break end
        end
        stopWorkout()
    end)
end

local function tryStartWorkout(st)
    QBCore.Functions.TriggerCallback('rme-gym:server:hasMembership', function(valid, remaining)
        membershipChecked = true
        membershipRemaining = (valid and (remaining + 0.0)) or 0.0
        membershipRefreshAt = GetGameTimer()
        if valid then
            startWorkout(st)
        else
            notify('You need a gym membership. See the front desk to buy one ($' .. Config.Membership.price .. ').', 'error')
        end
    end)
end

-- proximity / marker / interact loop (also drives the membership timer overlay)
CreateThread(function()
    while true do
        local sleep = 1000
        if stationsReady and next(stations) ~= nil then
            local ped = PlayerPedId()
            local pc = GetEntityCoords(ped)
            local near = nil
            local nearDist = 999.0
            local atGym = false
            for _, st in ipairs(stations) do
                local d = #(pc - vector3(st.x, st.y, st.z))
                if d < Config.MarkerDistance then
                    sleep = 0
                    atGym = true
                    if not working then
                        DrawMarker(1, st.x, st.y, st.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.25, 255, 90, 80, 120, false, false, 2, false, nil, nil, false)
                        if d < Config.UseDistance and d < nearDist then
                            near = st
                            nearDist = d
                        end
                    end
                end
            end
            if atGym then
                -- keep the countdown fresh while in the gym
                if (GetGameTimer() - membershipRefreshAt) > 10000 then
                    refreshMembership()
                end
                drawMembershipTimer()
            end
            if near and not working then
                local def = Config.Stations[near.kind]
                helpText('Press ~INPUT_PICKUP~ to use the ' .. ((def and def.label) or near.kind))
                if IsControlJustReleased(0, 38) then
                    tryStartWorkout(near)
                end
            end
        end
        Wait(sleep)
    end
end)

-- ---------- admin commands ----------
RegisterCommand('gymadd', function(_, args)
    local kind = args[1]
    if not kind or not Config.Stations[kind] then
        notify('Usage: /gymadd <' .. table.concat(kindList(), ' | ') .. '>', 'error')
        return
    end
    local c = GetEntityCoords(PlayerPedId())
    local h = GetEntityHeading(PlayerPedId())
    TriggerServerEvent('rme-gym:server:add', { kind = kind, x = c.x + 0.0, y = c.y + 0.0, z = c.z + 0.0, h = h + 0.0 })
end, false)

RegisterCommand('gymdelete', function()
    local c = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('rme-gym:server:deleteNearest', { x = c.x + 0.0, y = c.y + 0.0, z = c.z + 0.0 })
end, false)

RegisterCommand('gymlist', function()
    notify(('%d gym stations loaded'):format(#stations), 'primary')
end, false)

RegisterCommand('gymsetped', function()
    local c = GetEntityCoords(PlayerPedId())
    local h = GetEntityHeading(PlayerPedId())
    TriggerServerEvent('rme-gym:server:setPed', { x = c.x + 0.0, y = c.y + 0.0, z = c.z + 0.0, h = h + 0.0 })
end, false)

-- Export the whole gym build (placed stations, removed props, front-desk ped)
-- to the F8 console as JSON. Copy it and hand it over to have it committed to
-- the repo as a permanent, version-controlled backup that survives even a full
-- server reinstall.
RegisterCommand('gymexport', function()
    local payload = {
        pedCoords = pedCoords,
        stations = stations,
        removedProps = removedProps,
    }
    local ok, txt = pcall(json.encode, payload)
    if not ok or not txt then
        notify('Export failed - try again in a moment.', 'error')
        return
    end
    print('\n[rme-gym] ======= GYM BUILD EXPORT (copy everything between the lines) =======')
    print(txt)
    print('[rme-gym] ======= END GYM BUILD EXPORT =======\n')
    notify(('Exported %d station(s) + %d removed prop(s) + ped to the F8 console. Copy it to save permanently.'):format(#stations, #removedProps), 'success')
end, false)
