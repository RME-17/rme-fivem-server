local localProps = {}   -- [id] = entity handle
local handleToId = {}   -- [entity handle] = id

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

local function clearAll()
    for id in pairs(localProps) do removeLocal(id) end
    localProps = {}
    handleToId = {}
end

-- ---------------------------------------------------------------------------
-- sync from server
-- ---------------------------------------------------------------------------
RegisterNetEvent('rme-mapper:client:sync', function(props)
    clearAll()
    for _, p in pairs(props) do spawnLocal(p) end
end)

RegisterNetEvent('rme-mapper:client:add', function(p)
    spawnLocal(p)
end)

RegisterNetEvent('rme-mapper:client:update', function(id, pos, rot)
    local obj = localProps[id]
    if obj and DoesEntityExist(obj) then
        SetEntityCoordsNoOffset(obj, pos.x + 0.0, pos.y + 0.0, pos.z + 0.0, false, false, false)
        SetEntityRotation(obj, rot.x + 0.0, rot.y + 0.0, rot.z + 0.0, 2, true)
    end
end)

RegisterNetEvent('rme-mapper:client:remove', function(id)
    removeLocal(id)
end)

AddEventHandler('onClientResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    TriggerServerEvent('rme-mapper:server:requestSync')
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    clearAll()
end)

-- ---------------------------------------------------------------------------
-- selection (aim a ray from the camera)
-- ---------------------------------------------------------------------------
local function getAimedEntity()
    local cam = GetGameplayCamCoord()
    local dir = rotToDir(GetGameplayCamRot(2))
    local dest = cam + (dir * (Config.RaycastDistance + 0.0))
    local ray = StartShapeTestRay(cam.x, cam.y, cam.z, dest.x, dest.y, dest.z, 16, PlayerPedId(), 4)
    local _, hit, _, _, entity = GetShapeTestResult(ray)
    if hit == 1 and entity and entity ~= 0 then return entity end
    return nil
end

local function getOurAimedId()
    local ent = getAimedEntity()
    if ent and handleToId[ent] then return handleToId[ent], ent end
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
-- actions
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
            { title = 'Delete (aim at prop)', description = 'Remove the prop you are looking at', icon = 'trash', onSelect = function() actionDelete(); Wait(150); openMenu() end },
        },
    })
    lib.showContext('rme_mapper_menu')
end

RegisterNetEvent('rme-mapper:client:open', function()
    openMenu()
end)
