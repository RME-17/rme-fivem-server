-- RME Gym (server)
-- Persists placed gym stations to gym_stations.json and syncs them to clients.
-- Placement commands are admin-gated.

local QBCore = exports['qb-core']:GetCoreObject()
local stations = {}

local function loadStations()
    local raw = LoadResourceFile(GetCurrentResourceName(), 'gym_stations.json')
    if raw and raw ~= '' then
        local ok, decoded = pcall(json.decode, raw)
        if ok and type(decoded) == 'table' then
            stations = decoded
            return
        end
    end
    stations = {}
end

local function saveStations()
    SaveResourceFile(GetCurrentResourceName(), 'gym_stations.json', json.encode(stations), -1)
end

AddEventHandler('onResourceStart', function(res)
    if res == GetCurrentResourceName() then loadStations() end
end)

local function hasPerm(src, perm)
    local ok, res = pcall(function() return QBCore.Functions.HasPermission(src, perm) end)
    return ok and res
end

local function isAdmin(src)
    if hasPerm(src, 'admin') or hasPerm(src, 'god') then return true end
    return IsPlayerAceAllowed(src, 'rmegym.admin')
end

RegisterNetEvent('rme-gym:server:request', function()
    TriggerClientEvent('rme-gym:client:sync', source, stations)
end)

RegisterNetEvent('rme-gym:server:add', function(st)
    local src = source
    if not isAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, 'You do not have permission to place gym stations.', 'error')
        return
    end
    if type(st) ~= 'table' or not st.kind or not st.x or not st.y or not st.z then return end
    stations[#stations + 1] = {
        kind = tostring(st.kind),
        x = tonumber(st.x) + 0.0,
        y = tonumber(st.y) + 0.0,
        z = tonumber(st.z) + 0.0,
        h = tonumber(st.h) or 0.0,
    }
    saveStations()
    TriggerClientEvent('rme-gym:client:sync', -1, stations)
    TriggerClientEvent('QBCore:Notify', src, 'Gym station added: ' .. tostring(st.kind), 'success')
end)

RegisterNetEvent('rme-gym:server:deleteNearest', function(coords)
    local src = source
    if not isAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, 'You do not have permission to remove gym stations.', 'error')
        return
    end
    if type(coords) ~= 'table' or not coords.x then return end
    local bestIdx, bestDist = nil, 9999.0
    for i, st in ipairs(stations) do
        local dx, dy, dz = (st.x - coords.x), (st.y - coords.y), (st.z - coords.z)
        local d = math.sqrt(dx * dx + dy * dy + dz * dz)
        if d < bestDist then
            bestDist = d
            bestIdx = i
        end
    end
    if bestIdx and bestDist <= 3.0 then
        local removed = table.remove(stations, bestIdx)
        saveStations()
        TriggerClientEvent('rme-gym:client:sync', -1, stations)
        TriggerClientEvent('QBCore:Notify', src, 'Removed gym station: ' .. tostring(removed.kind), 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'No gym station within 3m to remove.', 'error')
    end
end)
