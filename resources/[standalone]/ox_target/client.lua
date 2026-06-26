--[[
    ox_target -> qb-target compatibility shim
    =========================================
    RME: The whole server uses qb-target (one eye, one key = Left Alt).
    nex_crafting hard-calls exports.ox_target:addLocalEntity(...). Rather than
    run a second real targeting system (which stole the key and broke every
    qb-target NPC/job), this resource is named 'ox_target' and simply forwards
    those calls into qb-target.

    It registers NO keybind and draws NO eye of its own -- qb-target owns the
    interaction. That is what removes the dual-target conflict.

    Supported ox_target API (the surface nex_crafting / typical scripts use):
      addLocalEntity / addEntity / removeLocalEntity / removeEntity
      addModel / removeModel
      addGlobalObject / addGlobalPed / addGlobalVehicle / addGlobalPlayer (+removes)
      addSphereZone / addBoxZone / removeZone
      disableTargeting
]]

local qbTarget = exports['qb-target']

-- ox identifies options by `name`; qb identifies them by `label`. Keep a map
-- so removal by ox option name still works against qb-target.
local nameToLabel = {}
local zoneCounter = 0

local function nextZoneId(prefix)
    zoneCounter = zoneCounter + 1
    return (prefix or 'oxzone') .. '_' .. zoneCounter
end

-- Convert a single ox_target option table into a qb-target option table.
local function convertOption(opt)
    if type(opt) ~= 'table' then return nil end
    local label = opt.label or opt.name or 'Interact'
    if opt.name then nameToLabel[opt.name] = label end

    local qbOpt = {
        label = label,
        icon = opt.icon,
        distance = opt.distance,
    }

    -- item gating (ox: items can be string or array)
    if opt.items then
        qbOpt.item = type(opt.items) == 'table' and opt.items[1] or opt.items
    end
    if opt.item then qbOpt.item = opt.item end

    -- job / gang gating (ox uses `groups`)
    if opt.groups then qbOpt.job = opt.groups end
    if opt.job then qbOpt.job = opt.job end
    if opt.gang then qbOpt.gang = opt.gang end

    -- selection handler
    if type(opt.onSelect) == 'function' then
        local onSelect = opt.onSelect
        qbOpt.action = function(entity)
            onSelect({
                entity = entity,
                coords = entity and DoesEntityExist(entity) and GetEntityCoords(entity) or nil,
                name = opt.name,
                distance = opt.distance,
            })
        end
    elseif opt.serverEvent then
        qbOpt.type = 'server'
        qbOpt.event = opt.serverEvent
    elseif opt.event then
        qbOpt.type = 'client'
        qbOpt.event = opt.event
    elseif opt.command then
        qbOpt.type = 'command'
        qbOpt.event = opt.command
    elseif type(opt.export) == 'string' then
        qbOpt.action = function(entity)
            local res, fn = opt.export:match('([^%.]+)%.(.+)')
            if res and fn then exports[res][fn](nil, { entity = entity }) end
        end
    end

    -- access check (ox: canInteract(entity, distance, coords, name, bone))
    if type(opt.canInteract) == 'function' then
        local canInteract = opt.canInteract
        qbOpt.canInteract = function(entity, distance, data)
            local coords = data and data.coords
            local ok = canInteract(entity, distance, coords, opt.name, data and data.bone)
            return ok ~= false
        end
    end

    return qbOpt
end

local function convertOptions(options)
    local out = {}
    local maxDist = 7.0
    if type(options) == 'table' then
        for i = 1, #options do
            local conv = convertOption(options[i])
            if conv then
                out[#out + 1] = conv
                if conv.distance and conv.distance > maxDist then maxDist = conv.distance end
            end
        end
    end
    return out, maxDist
end

local function resolveLabels(optionNames)
    if not optionNames then return nil end
    if type(optionNames) == 'table' then
        local labels = {}
        for i = 1, #optionNames do labels[#labels + 1] = nameToLabel[optionNames[i]] or optionNames[i] end
        return labels
    end
    return nameToLabel[optionNames] or optionNames
end

----------------------------------------------------------------
-- Entities (local + networked). qb-target handles netId internally.
----------------------------------------------------------------
local function addLocalEntity(entities, options)
    local opts, dist = convertOptions(options)
    qbTarget:AddTargetEntity(entities, { distance = dist, options = opts })
end
exports('addLocalEntity', addLocalEntity)
exports('addEntity', addLocalEntity)

local function removeLocalEntity(entities, optionNames)
    qbTarget:RemoveTargetEntity(entities, resolveLabels(optionNames))
end
exports('removeLocalEntity', removeLocalEntity)
exports('removeEntity', removeLocalEntity)

----------------------------------------------------------------
-- Models
----------------------------------------------------------------
local function addModel(models, options)
    local opts, dist = convertOptions(options)
    qbTarget:AddTargetModel(models, { distance = dist, options = opts })
end
exports('addModel', addModel)

local function removeModel(models, optionNames)
    qbTarget:RemoveTargetModel(models, resolveLabels(optionNames))
end
exports('removeModel', removeModel)

----------------------------------------------------------------
-- Global object / ped / vehicle / player
----------------------------------------------------------------
local function addGlobalObject(options)
    local opts, dist = convertOptions(options)
    qbTarget:AddGlobalObject({ distance = dist, options = opts })
end
exports('addGlobalObject', addGlobalObject)
exports('removeGlobalObject', function(optionNames) qbTarget:RemoveGlobalObject(resolveLabels(optionNames)) end)

local function addGlobalPed(options)
    local opts, dist = convertOptions(options)
    qbTarget:AddGlobalPed({ distance = dist, options = opts })
end
exports('addGlobalPed', addGlobalPed)
exports('removeGlobalPed', function(optionNames) qbTarget:RemoveGlobalPed(resolveLabels(optionNames)) end)

local function addGlobalVehicle(options)
    local opts, dist = convertOptions(options)
    qbTarget:AddGlobalVehicle({ distance = dist, options = opts })
end
exports('addGlobalVehicle', addGlobalVehicle)
exports('removeGlobalVehicle', function(optionNames) qbTarget:RemoveGlobalVehicle(resolveLabels(optionNames)) end)

local function addGlobalPlayer(options)
    local opts, dist = convertOptions(options)
    qbTarget:AddGlobalPlayer({ distance = dist, options = opts })
end
exports('addGlobalPlayer', addGlobalPlayer)
exports('removeGlobalPlayer', function(optionNames) qbTarget:RemoveGlobalPlayer(resolveLabels(optionNames)) end)

----------------------------------------------------------------
-- Zones (sphere / box) -> qb circle / box zones
----------------------------------------------------------------
local function addSphereZone(params)
    local opts, dist = convertOptions(params.options)
    local name = params.name or nextZoneId('oxsphere')
    qbTarget:AddCircleZone(name, params.coords, params.radius or 2.0,
        { name = name, useZ = true, debugPoly = params.debug or false },
        { distance = dist, options = opts })
    return name
end
exports('addSphereZone', addSphereZone)

local function addBoxZone(params)
    local opts, dist = convertOptions(params.options)
    local name = params.name or nextZoneId('oxbox')
    local size = params.size or vector3(2.0, 2.0, 2.0)
    local cz = params.coords.z or 0.0
    qbTarget:AddBoxZone(name, params.coords, size.x, size.y,
        {
            name = name,
            heading = params.rotation or 0.0,
            useZ = true,
            debugPoly = params.debug or false,
            minZ = cz - (size.z / 2.0),
            maxZ = cz + (size.z / 2.0),
        },
        { distance = dist, options = opts })
    return name
end
exports('addBoxZone', addBoxZone)

exports('removeZone', function(id) qbTarget:RemoveZone(id) end)

----------------------------------------------------------------
-- Misc compatibility
----------------------------------------------------------------
-- ox: disableTargeting(true) hides the eye -> qb: AllowTargeting(false)
exports('disableTargeting', function(state)
    qbTarget:AllowTargeting(not state)
end)

print('^2[ox_target shim]^7 Loaded -- forwarding ox_target calls to qb-target (single targeting system, single key).')
