-- RME Gym (client)
-- Walk up to a placed gym station, press E, and your character works out -
-- earning skill XP (via rme-playerstats) over time. Admins place stations with
-- /gymadd <type> while standing at the equipment.

local QBCore = exports['qb-core']:GetCoreObject()

local stations = {}
local stationsReady = false
local working = false

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

local function requestStations()
    TriggerServerEvent('rme-gym:server:request')
end

RegisterNetEvent('rme-gym:client:sync', function(list)
    stations = list or {}
    stationsReady = true
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    requestStations()
end)

AddEventHandler('onResourceStart', function(res)
    if res == GetCurrentResourceName() then requestStations() end
end)

CreateThread(function()
    Wait(1500)
    requestStations()
end)

local function stopWorkout()
    working = false
    ClearPedTasks(PlayerPedId())
end

local function startWorkout(st)
    if working then return end
    local def = Config.Stations[st.kind]
    if not def then return end
    working = true
    local ped = PlayerPedId()
    if st.h then SetEntityHeading(ped, st.h + 0.0) end
    TaskStartScenarioInPlace(ped, def.scenario, 0, true)
    notify('Workout started - press ~INPUT_PICKUP~ (E) to stop', 'primary')

    CreateThread(function()
        local started = GetGameTimer()
        local sinceTick = 0.0
        local origin = vector3(st.x, st.y, st.z)
        while working do
            Wait(0)
            local p = PlayerPedId()
            sinceTick = sinceTick + GetFrameTime() * 1000.0

            if sinceTick >= Config.TickMs then
                sinceTick = 0.0
                for skill, amt in pairs(def.train) do
                    exports['rme-playerstats']:train(skill, amt)
                end
                notify(def.label .. ' workout - keep going!', 'success')
            end

            local elapsed = GetGameTimer() - started
            if elapsed > 700 and IsControlJustReleased(0, 38) then break end
            if IsEntityDead(p) then break end
            if IsPedShooting(p) then break end
            if #(GetEntityCoords(p) - origin) > 2.5 then break end
        end
        stopWorkout()
        notify('Workout finished', 'primary')
    end)
end

-- proximity / marker / interact loop
CreateThread(function()
    while true do
        local sleep = 1000
        if stationsReady and not working and next(stations) ~= nil then
            local ped = PlayerPedId()
            local pc = GetEntityCoords(ped)
            local near = nil
            local nearDist = 999.0
            for _, st in ipairs(stations) do
                local d = #(pc - vector3(st.x, st.y, st.z))
                if d < Config.MarkerDistance then
                    sleep = 0
                    DrawMarker(1, st.x, st.y, st.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.25, 255, 90, 80, 120, false, false, 2, false, nil, nil, false)
                    if d < Config.UseDistance and d < nearDist then
                        near = st
                        nearDist = d
                    end
                end
            end
            if near then
                local def = Config.Stations[near.kind]
                helpText('Press ~INPUT_PICKUP~ to use the ' .. ((def and def.label) or near.kind))
                if IsControlJustReleased(0, 38) then
                    startWorkout(near)
                end
            end
        end
        Wait(sleep)
    end
end)

-- ---------- admin placement ----------
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
