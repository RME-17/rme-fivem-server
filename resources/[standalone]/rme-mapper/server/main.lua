local QBCore = exports['qb-core']:GetCoreObject()

-- placements is keyed by string id: [id] = { id, model, pos = {x,y,z}, rot = {x,y,z} }
local placements = {}
local nextId = 1
local SAVE_FILE = 'placements.json'

local function persist()
    SaveResourceFile(GetCurrentResourceName(), SAVE_FILE, json.encode({ nextId = nextId, props = placements }), -1)
end

local function loadFromDisk()
    local raw = LoadResourceFile(GetCurrentResourceName(), SAVE_FILE)
    if not raw or raw == '' then return end
    local ok, data = pcall(json.decode, raw)
    if ok and type(data) == 'table' then
        placements = data.props or {}
        nextId = data.nextId or 1
    end
end

local function hasPerm(src)
    if src == 0 then return true end
    return QBCore.Functions.HasPermission(src, Config.Permission) or QBCore.Functions.HasPermission(src, 'god')
end

local function syncTo(target)
    TriggerClientEvent('rme-mapper:client:sync', target, placements)
end

AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    loadFromDisk()
    -- push current placements to everyone already connected (handles resource restart)
    syncTo(-1)
end)

RegisterNetEvent('rme-mapper:server:requestSync', function()
    syncTo(source)
end)

RegisterNetEvent('rme-mapper:server:add', function(model, pos, rot)
    local src = source
    if not hasPerm(src) then return end
    if type(pos) ~= 'table' or type(rot) ~= 'table' then return end
    local id = tostring(nextId)
    nextId = nextId + 1
    placements[id] = { id = id, model = model, pos = pos, rot = rot }
    persist()
    TriggerClientEvent('rme-mapper:client:add', -1, placements[id])
end)

RegisterNetEvent('rme-mapper:server:update', function(id, pos, rot)
    local src = source
    if not hasPerm(src) then return end
    local p = placements[id]
    if not p then return end
    if type(pos) ~= 'table' or type(rot) ~= 'table' then return end
    p.pos = pos
    p.rot = rot
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

QBCore.Commands.Add(Config.Command, 'Open the RME map editor', {}, false, function(source)
    TriggerClientEvent('rme-mapper:client:open', source)
end, Config.Permission)
