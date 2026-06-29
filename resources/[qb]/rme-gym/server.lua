-- RME Gym (server)
-- Persists placed gym stations, removed props and the front-desk ped position
-- to JSON files, syncs them to clients, and handles membership purchases
-- (stored on the character via QBCore metadata so they survive relog).
-- Placement / removal commands are admin-gated.

local QBCore = exports['qb-core']:GetCoreObject()

local stations = {}
local removedProps = {}
local pedCoords = nil

-- ---------- persistence ----------
local function readJson(file)
    local raw = LoadResourceFile(GetCurrentResourceName(), file)
    if raw and raw ~= '' then
        local ok, decoded = pcall(json.decode, raw)
        if ok and type(decoded) == 'table' then return decoded end
    end
    return nil
end

local function writeJson(file, data)
    SaveResourceFile(GetCurrentResourceName(), file, json.encode(data), -1)
end

local function defaultPedCoords()
    local c = Config.Membership.pedCoords
    return { x = c.x + 0.0, y = c.y + 0.0, z = c.z + 0.0, h = c.w + 0.0 }
end

local function loadAll()
    stations = readJson('gym_stations.json') or {}
    removedProps = readJson('removed_props.json') or {}
    pedCoords = readJson('gym_ped.json') or defaultPedCoords()
end

AddEventHandler('onResourceStart', function(res)
    if res == GetCurrentResourceName() then loadAll() end
end)

-- ---------- permissions ----------
local function hasPerm(src, perm)
    local ok, res = pcall(function() return QBCore.Functions.HasPermission(src, perm) end)
    return ok and res
end

local function isAdmin(src)
    if hasPerm(src, 'admin') or hasPerm(src, 'god') then return true end
    return IsPlayerAceAllowed(src, 'rmegym.admin')
end

local function denyIfNotAdmin(src)
    if isAdmin(src) then return false end
    TriggerClientEvent('QBCore:Notify', src, 'You do not have permission to do that.', 'error')
    return true
end

-- ---------- sync ----------
RegisterNetEvent('rme-gym:server:request', function()
    local src = source
    TriggerClientEvent('rme-gym:client:sync', src, stations)
    TriggerClientEvent('rme-gym:client:syncRemoved', src, removedProps)
    TriggerClientEvent('rme-gym:client:syncPed', src, pedCoords)
end)

-- ---------- stations ----------
RegisterNetEvent('rme-gym:server:add', function(st)
    local src = source
    if denyIfNotAdmin(src) then return end
    if type(st) ~= 'table' or not st.kind or not st.x or not st.y or not st.z then return end
    stations[#stations + 1] = {
        kind = tostring(st.kind),
        x = tonumber(st.x) + 0.0,
        y = tonumber(st.y) + 0.0,
        z = tonumber(st.z) + 0.0,
        h = tonumber(st.h) or 0.0,
    }
    writeJson('gym_stations.json', stations)
    TriggerClientEvent('rme-gym:client:sync', -1, stations)
    TriggerClientEvent('QBCore:Notify', src, 'Gym station added: ' .. tostring(st.kind), 'success')
end)

RegisterNetEvent('rme-gym:server:deleteNearest', function(coords)
    local src = source
    if denyIfNotAdmin(src) then return end
    if type(coords) ~= 'table' or not coords.x then return end
    local bestIdx, bestDist = nil, 9999.0
    for i, st in ipairs(stations) do
        local dx, dy, dz = (st.x - coords.x), (st.y - coords.y), (st.z - coords.z)
        local d = math.sqrt(dx * dx + dy * dy + dz * dz)
        if d < bestDist then bestDist = d; bestIdx = i end
    end
    if bestIdx and bestDist <= 3.0 then
        local removed = table.remove(stations, bestIdx)
        writeJson('gym_stations.json', stations)
        TriggerClientEvent('rme-gym:client:sync', -1, stations)
        TriggerClientEvent('QBCore:Notify', src, 'Removed gym station: ' .. tostring(removed.kind), 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'No gym station within 3m to remove.', 'error')
    end
end)

-- ---------- removed props ----------
RegisterNetEvent('rme-gym:server:addRemovedProp', function(p)
    local src = source
    if denyIfNotAdmin(src) then return end
    if type(p) ~= 'table' or not p.model or not p.x then return end
    removedProps[#removedProps + 1] = {
        model = tonumber(p.model),
        x = tonumber(p.x) + 0.0,
        y = tonumber(p.y) + 0.0,
        z = tonumber(p.z) + 0.0,
    }
    writeJson('removed_props.json', removedProps)
    TriggerClientEvent('rme-gym:client:syncRemoved', -1, removedProps)
end)

-- ---------- front-desk ped ----------
RegisterNetEvent('rme-gym:server:setPed', function(c)
    local src = source
    if denyIfNotAdmin(src) then return end
    if type(c) ~= 'table' or not c.x then return end
    pedCoords = {
        x = tonumber(c.x) + 0.0,
        y = tonumber(c.y) + 0.0,
        z = tonumber(c.z) + 0.0,
        h = tonumber(c.h) or 0.0,
    }
    writeJson('gym_ped.json', pedCoords)
    TriggerClientEvent('rme-gym:client:syncPed', -1, pedCoords)
    TriggerClientEvent('QBCore:Notify', src, 'Gym front-desk ped placed here.', 'success')
end)

-- ---------- membership ----------
QBCore.Functions.CreateCallback('rme-gym:server:hasMembership', function(source, cb)
    local Player = exports['qb-core']:GetPlayer(source)
    if not Player then cb(false, 0) return end
    local now = os.time()
    local exp = tonumber(Player.PlayerData.metadata['gymmembership']) or 0
    if exp > now then cb(true, exp - now) else cb(false, 0) end
end)

RegisterNetEvent('rme-gym:server:buyMembership', function()
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    if not Player then return end
    local now = os.time()
    local cur = tonumber(Player.PlayerData.metadata['gymmembership']) or 0
    if cur > now then
        local mins = math.ceil((cur - now) / 60)
        TriggerClientEvent('QBCore:Notify', src, ('You already have a membership (%d min left).'):format(mins), 'error')
        return
    end
    local price = Config.Membership.price
    local cash = tonumber(Player.PlayerData.money['cash']) or 0
    local bank = tonumber(Player.PlayerData.money['bank']) or 0
    local paid = false
    if cash >= price then
        paid = Player.Functions.RemoveMoney('cash', price, 'gym-membership')
    elseif bank >= price then
        paid = Player.Functions.RemoveMoney('bank', price, 'gym-membership')
    end
    if not paid then
        TriggerClientEvent('QBCore:Notify', src, ('Not enough money. A membership costs $%d.'):format(price), 'error')
        return
    end
    local expiry = now + Config.Membership.duration
    Player.Functions.SetMetaData('gymmembership', expiry)
    TriggerClientEvent('QBCore:Notify', src, 'Gym membership purchased! Valid for 1 hour.', 'success')
    TriggerClientEvent('rme-gym:client:membershipBought', src, expiry)
end)
