local localProps = {}    -- [id] = entity handle (props we spawned)
local handleToId = {}    -- [entity handle] = id
local appliedHides = {}  -- [id] = { model, pos, radius } (so we can RemoveModelHide on undo)

-- ---------------------------------------------------------------------------
-- helpers
-- ---------------------------------------------------------------------------
local function rotToDir(rot)
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

local function loadModel(model)
    local hash = type(model) == 'number' and model or joaat(model)
    if not IsModelInCdimage(hash) or not IsModelValid(hash) then return nil end
    lib.requestModel(hash, 10000)
    if not HasModelLoaded(hash) then return nil end
    return hash
end

-- ---------------------------------------------------------------------------
-- props we own
-- ---------------------------------------------------------------------------
local function spawnLocal(p)
    if not p or not p.id or localProps[p.id] then return end
    local hash = loadModel(p.model)
    if not hash then return end
    local obj = CreateObject(hash, p.pos.x + 0.0, p.pos.y + 0.0, p.pos.z + 0.0, false, false, false)
    SetEntityRotation(obj, p.rot.x + 0.0, p.rot.y + 0.0, p.rot.z + 0.0, 2, true)
    FreezeEntityPosition(obj, true)
    SetModelAsNoLongerNeeded(hash)
    localProps[p.id] = obj
    handleToId[obj] = p.id
end

local function removeLocal(id)
    local obj = localProps[id]
    if obj then
        handleToId[obj] = nil
        if DoesEntityExist(obj) then DeleteEntity(obj) end
    end
    localProps[id] = nil
end

local function clearAllProps()
    for id in pairs(localProps) do removeLocal(id) end
    localProps = {}
    handleToId = {}
end

-- ---------------------------------------------------------------------------
-- hides (existing MLO/map props removed via CreateModelHide)
-- ---------------------------------------------------------------------------
local function applyHide(h)
    if not h or not h.id or appliedHides[h.id] then return end
    local hash = type(h.model) == 'number' and h.model or joaat(h.model)
    local r = (h.radius or 2.0) + 0.0
    CreateModelHide(h.pos.x + 0.0, h.pos.y + 0.0, h.pos.z + 0.0, r, hash, false)
    appliedHides[h.id] = { model = hash, pos = h.pos, radius = r }
end

local function unhideAllLocal()
    for _, h in pairs(appliedHides) do
        RemoveModelHide(h.pos.x + 0.0, h.pos.y + 0.0, h.pos.z + 0.0, h.radius + 0.0, h.model, false)
    end
    appliedHides = {}
end

-- ---------------------------------------------------------------------------
-- sync from server
-- ---------------------------------------------------------------------------
RegisterNetEvent('rme-mapper:client:sync', function(payload)
    payload = payload or {}
    clearAllProps()
    unhideAllLocal()
    for _, p in pairs(payload.props or {}) do spawnLocal(p) end
    for _, h in pairs(payload.hides or {}) do applyHide(h) end
end)

RegisterNetEvent('rme-mapper:client:add', function(p) spawnLocal(p) end)

RegisterNetEvent('rme-mapper:client:update', function(id, pos, rot)
    local obj = localProps[id]
    if obj and DoesEntityExist(obj) then
        SetEntityCoordsNoOffset(obj, pos.x + 0.0, pos.y + 0.0, pos.z + 0.0, false, false, false)
        SetEntityRotation(obj, rot.x + 0.0, rot.y + 0.0, rot.z + 0.0, 2, true)
    end
end)

RegisterNetEvent('rme-mapper:client:remove', function(id) removeLocal(id) end)
RegisterNetEvent('rme-mapper:client:hide', function(h) applyHide(h) end)
RegisterNetEvent('rme-mapper:client:unhideAll', function() unhideAllLocal() end)

AddEventHandler('onClientResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    TriggerServerEvent('rme-mapper:server:requestSync')
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    clearAllProps()
    unhideAllLocal()
end)

-- ---------------------------------------------------------------------------
-- raycast from the camera; returns hit(bool), endCoords(vec3), entity(handle)
-- ---------------------------------------------------------------------------
local function aimRaycast(flags)
    local cam = GetGameplayCamCoord()
    local dir = rotToDir(GetGameplayCamRot(2))
    local dest = cam + (dir * (Config.RaycastDistance + 0.0))
    local ray = StartShapeTestRay(cam.x, cam.y, cam.z, dest.x, dest.y, dest.z, flags or 16, PlayerPedId(), 4)
    local _, hit, endCoords, _, entity = GetShapeTestResult(ray)
    return hit == 1, endCoords, entity
end

local function getOurAimedId()
    local _, _, ent = aimRaycast(16)
    if ent and ent ~= 0 and handleToId[ent] then return handleToId[ent], ent end
    return nil, ent
end

-- ---------------------------------------------------------------------------
-- gizmo edit (blocks until the player finishes dragging the handles)
-- ---------------------------------------------------------------------------
local function gizmoEdit(handle)
    if not (handle and DoesEntityExist(handle)) then return nil end
    FreezeEntityPosition(handle, false)
    SetEntityCollision(handle, false, false)
    exports.object_gizmo:useGizmo(handle)
    SetEntityCollision(handle, true, true)
    FreezeEntityPosition(handle, true)
    local pos = GetEntityCoords(handle)
    local rot = GetEntityRotation(handle, 2)
    return { x = pos.x, y = pos.y, z = pos.z }, { x = rot.x, y = rot.y, z = rot.z }
end

local openMenu -- forward declaration

-- ---------------------------------------------------------------------------
-- actions: props we own
-- ---------------------------------------------------------------------------
local function actionSpawn()
    local input = lib.inputDialog('Spawn prop', {
        { type = 'input', label = 'Model name', description = 'e.g. prop_barrel_01a', default = Config.DefaultModel, required = true },
    })
    if not input then return end
    local model = input[1]
    local hash = loadModel(model)
    if not hash then
        lib.notify({ title = 'RME Mapper', description = ('Invalid model: %s'):format(tostring(model)), type = 'error' })
        return
    end
    local ped = PlayerPedId()
    local fwd = GetEntityForwardVector(ped)
    local base = GetEntityCoords(ped) + (fwd * (Config.SpawnDistance + 0.0))
    local temp = CreateObject(hash, base.x, base.y, base.z, false, false, false)
    PlaceObjectOnGroundProperly(temp)
    SetModelAsNoLongerNeeded(hash)
    local pos, rot = gizmoEdit(temp)
    if DoesEntityExist(temp) then DeleteEntity(temp) end -- server broadcast spawns the authoritative copy
    if pos then
        TriggerServerEvent('rme-mapper:server:add', model, pos, rot)
        lib.notify({ title = 'RME Mapper', description = 'Prop placed & saved.', type = 'success' })
    end
end

local function actionEdit()
    local id, ent = getOurAimedId()
    if not id then
        lib.notify({ title = 'RME Mapper', description = 'Aim at a mapper prop first.', type = 'inform' })
        return
    end
    local pos, rot = gizmoEdit(ent)
    if pos then
        TriggerServerEvent('rme-mapper:server:update', id, pos, rot)
        lib.notify({ title = 'RME Mapper', description = 'Prop updated & saved.', type = 'success' })
    end
end

local function actionDuplicate()
    local id, ent = getOurAimedId()
    if not id then
        lib.notify({ title = 'RME Mapper', description = 'Aim at a mapper prop to duplicate.', type = 'inform' })
        return
    end
    local model = GetEntityModel(ent)
    local hash = loadModel(model)
    if not hash then return end
    local base = GetEntityCoords(ent)
    local er = GetEntityRotation(ent, 2)
    local temp = CreateObject(hash, base.x + 1.0, base.y + 1.0, base.z + 0.0, false, false, false)
    SetEntityRotation(temp, er.x, er.y, er.z, 2, true)
    SetModelAsNoLongerNeeded(hash)
    local pos, rot = gizmoEdit(temp)
    if DoesEntityExist(temp) then DeleteEntity(temp) end
    if pos then
        TriggerServerEvent('rme-mapper:server:add', model, pos, rot)
        lib.notify({ title = 'RME Mapper', description = 'Duplicated & saved.', type = 'success' })
    end
end

local function actionSnap()
    local id, ent = getOurAimedId()
    if not id then
        lib.notify({ title = 'RME Mapper', description = 'Aim at a mapper prop to snap.', type = 'inform' })
        return
    end
    PlaceObjectOnGroundProperly(ent)
    local pos = GetEntityCoords(ent)
    local rot = GetEntityRotation(ent, 2)
    TriggerServerEvent('rme-mapper:server:update', id, { x = pos.x, y = pos.y, z = pos.z }, { x = rot.x, y = rot.y, z = rot.z })
    lib.notify({ title = 'RME Mapper', description = 'Snapped to ground.', type = 'success' })
end

local function actionDelete()
    local id = getOurAimedId()
    if not id then
        lib.notify({ title = 'RME Mapper', description = 'Aim at a mapper prop to delete.', type = 'inform' })
        return
    end
    TriggerServerEvent('rme-mapper:server:remove', id)
    lib.notify({ title = 'RME Mapper', description = 'Prop deleted.', type = 'success' })
end

-- ---------------------------------------------------------------------------
-- actions: existing MLO/map props
-- ---------------------------------------------------------------------------
local function actionHide()
    local hit, coords, entity = aimRaycast(1 + 16) -- world + objects
    if not hit then
        lib.notify({ title = 'RME Mapper', description = 'Aim at the object you want to remove.', type = 'inform' })
        return
    end
    if entity and entity ~= 0 and handleToId[entity] then
        lib.notify({ title = 'RME Mapper', description = 'That is a mapper prop \u2014 use Delete instead.', type = 'inform' })
        return
    end
    if entity and entity ~= 0 and GetEntityModel(entity) ~= 0 then
        local c = GetEntityCoords(entity)
        TriggerServerEvent('rme-mapper:server:hide', GetEntityModel(entity), { x = c.x, y = c.y, z = c.z }, Config.HideRadius)
        lib.notify({ title = 'RME Mapper', description = 'Object hidden & saved.', type = 'success' })
        return
    end
    -- no entity handle (baked MLO / static geometry): ask for the model, hide at the aim point
    local input = lib.inputDialog('Hide map object', {
        { type = 'input', label = 'Model name', description = 'No entity here. Enter the prop model to hide at this spot.', required = true },
        { type = 'number', label = 'Radius (m)', default = Config.HideRadius, min = 0.5, max = 25.0 },
    })
    if not input then return end
    TriggerServerEvent('rme-mapper:server:hide', input[1], { x = coords.x, y = coords.y, z = coords.z }, (input[2] or Config.HideRadius) + 0.0)
    lib.notify({ title = 'RME Mapper', description = 'Hidden (by model) & saved.', type = 'success' })
end

local function actionUnhideAll()
    local ok = lib.alertDialog({
        header = 'Restore hidden objects',
        content = 'This brings back ALL objects you have hidden in the city. Continue?',
        centered = true,
        cancel = true,
    })
    if ok ~= 'confirm' then return end
    TriggerServerEvent('rme-mapper:server:unhideAll')
    lib.notify({ title = 'RME Mapper', description = 'Restored all hidden objects.', type = 'success' })
end

-- ---------------------------------------------------------------------------
-- menu
-- ---------------------------------------------------------------------------
openMenu = function()
    lib.registerContext({
        id = 'rme_mapper_menu',
        title = 'RME Map Editor',
        options = {
            { title = 'Spawn new prop', description = 'Enter a model, then drag the gizmo to place it', icon = 'plus', onSelect = function() actionSpawn(); Wait(150); openMenu() end },
            { title = 'Move / rotate (aim at prop)', description = 'Look at a placed prop, then drag the gizmo handles', icon = 'up-down-left-right', onSelect = function() actionEdit(); Wait(150); openMenu() end },
            { title = 'Duplicate (aim at prop)', description = 'Copy the prop you are looking at', icon = 'clone', onSelect = function() actionDuplicate(); Wait(150); openMenu() end },
            { title = 'Snap to ground (aim at prop)', description = 'Drop the prop onto the surface below it', icon = 'arrows-down-to-line', onSelect = function() actionSnap(); Wait(150); openMenu() end },
            { title = 'Delete (aim at prop)', description = 'Remove a prop YOU placed', icon = 'trash', onSelect = function() actionDelete(); Wait(150); openMenu() end },
            { title = 'Hide MLO / map object (aim at it)', description = 'Remove an existing prop baked into the map/MLO', icon = 'eye-slash', onSelect = function() actionHide(); Wait(150); openMenu() end },
            { title = 'Restore ALL hidden objects', description = 'Undo every map object you have hidden', icon = 'rotate-left', onSelect = function() actionUnhideAll(); Wait(150); openMenu() end },
        },
    })
    lib.showContext('rme_mapper_menu')
end

RegisterNetEvent('rme-mapper:client:open', function()
    print('[rme-mapper] client open event received')
    if not lib then
        print('[rme-mapper] ERROR: ox_lib (lib) is nil on the client - ox_lib not loaded for this resource')
        return
    end
    openMenu()
    print('[rme-mapper] openMenu() called')
end)
