local QBCore = exports['qb-core']:GetCoreObject()

-- placements: [id] = { id, model, pos = {x,y,z}, rot = {x,y,z} }  (props we spawn)
-- hides:      [id] = { id, model, pos = {x,y,z}, radius }          (MLO/map props removed via CreateModelHide)
local placements = {}
local hides = {}
local nextId = 1
local nextHideId = 1
local SAVE_FILE = 'placements.json'

local function persist()
    SaveResourceFile(GetCurrentResourceName(), SAVE_FILE, json.encode({
        nextId = nextId, props = placements,
        nextHideId = nextHideId, hides = hides,
    }), -1)
end

local function loadFromDisk()
    local raw = LoadResourceFile(GetCurrentResourceName(), SAVE_FILE)
    if not raw or raw == '' then return end
    local ok, data = pcall(json.decode, raw)
    if ok and type(data) == 'table' then
        placements = data.props or {}
        hides = data.hides or {}
        nextId = data.nextId or 1
        nextHideId = data.nextHideId or 1
    end
end

local function hasPerm(src)
    if src == 0 then return true end
    return QBCore.Functions.HasPermission(src, Config.Permission) or QBCore.Functions.HasPermission(src, 'god')
end

local function syncTo(target)
    TriggerClientEvent('rme-mapper:client:sync', target, { props = placements, hides = hides })
end

AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    loadFromDisk()
    syncTo(-1)
end)

RegisterNetEvent('rme-mapper:server:requestSync', function()
    syncTo(source)
end)

-- ---- props we own ----
RegisterNetEvent('rme-mapper:server:add', function(model, pos, rot)
    local src = source
    if not hasPerm(src) then return end
    if type(pos) ~= 'table' or type(rot) ~= 'table' then return end
    local id = tostring(nextId); nextId = nextId + 1
    placements[id] = { id = id, model = model, pos = pos, rot = rot }
    persist()
    TriggerClientEvent('rme-mapper:client:add', -1, placements[id])
end)

RegisterNetEvent('rme-mapper:server:update', function(id, pos, rot)
    local src = source
    if not hasPerm(src) then return end
    local p = placements[id]; if not p then return end
    if type(pos) ~= 'table' or type(rot) ~= 'table' then return end
    p.pos = pos; p.rot = rot
    persist()
    TriggerClientEvent('rme-mapper:client:update', -1, id, pos, rot)
end)

RegisterNetEvent('rme-mapper:server:remove', function(id)
    local src = source
    if not hasPerm(src) then return end
    if not placements[id] then return end
    placements[id] = nil
    persist()
    TriggerClientEvent('rme-mapper:client:remove', -1, id)
end)

-- ---- hides (remove existing MLO/map props) ----
RegisterNetEvent('rme-mapper:server:hide', function(model, pos, radius)
    local src = source
    if not hasPerm(src) then return end
    if type(pos) ~= 'table' or (type(model) ~= 'number' and type(model) ~= 'string') then return end
    local id = tostring(nextHideId); nextHideId = nextHideId + 1
    hides[id] = { id = id, model = model, pos = pos, radius = radius or 2.0 }
    persist()
    TriggerClientEvent('rme-mapper:client:hide', -1, hides[id])
end)

RegisterNetEvent('rme-mapper:server:unhideAll', function()
    local src = source
    if not hasPerm(src) then return end
    hides = {}
    nextHideId = 1
    persist()
    TriggerClientEvent('rme-mapper:client:unhideAll', -1)
end)

QBCore.Commands.Add(Config.Command, 'Open the RME map editor', {}, false, function(source)
    TriggerClientEvent('rme-mapper:client:open', source)
end, Config.Permission)
