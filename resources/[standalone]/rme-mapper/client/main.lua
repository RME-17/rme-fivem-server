local localProps = {}    -- [id] = entity handle (props we spawned)
local handleToId = {}    -- [entity handle] = id
local appliedHides = {}  -- [id] = { model, pos, radius } (so we can RemoveModelHide on undo)

-- Combinatorial entity-set name probing. GTA has no native to enumerate set
-- names, so we generate prefix x base x suffix combos and test each one.
local SET_PREFIXES = { '', 'set_', 'Set_', 'SET_', 'entity_set_', 'entityset_', 'es_', 'prop_', 'props_' }
local SET_BASES = {
    'clutter', 'decor', 'deco', 'details', 'detail', 'props', 'prop', 'extra', 'extras',
    'garbage', 'trash', 'rubbish', 'junk', 'mess', 'dirt', 'dust',
    'tools', 'tool', 'toolbox', 'tooling', 'boxes', 'box', 'crates', 'crate',
    'cars', 'car', 'vehicle', 'vehicles', 'carparts', 'parts', 'part', 'bonnet', 'bonnets',
    'hood', 'hoods', 'doors', 'door', 'tyres', 'tyre', 'wheels', 'wheel', 'engine', 'engines',
    'furniture', 'lights', 'light', 'lighting', 'lamp', 'lamps', 'neon',
    'shutters', 'shutter', 'displays', 'display', 'shelf', 'shelves', 'rack', 'racks',
    'bennys', 'benny', 'mechanic', 'shop', 'garage', 'stock', 'interior', 'misc',
    'wall', 'walls', 'floor', 'roof', 'group', 'layer', 'main', 'all', 'base',
    'a', 'b', 'c', 'one', 'two', 'three',
}
local SET_SUFFIXES = {
    '', '1', '2', '3', '4', '5', '01', '02', '03', '04', '05',
    '_1', '_2', '_3', '_4', '_5', '_01', '_02', '_03', '_04', '_05',
    '_a', '_b', '_c', 's',
}

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

-- Entity type guard: 1 ped, 2 vehicle, 3 object. World/buildings return 0 and
-- will hard-crash GetEntityModel, so only read a model from a real typed entity.
local function entityType(ent)
    if ent and ent ~= 0 and DoesEntityExist(ent) then
        return GetEntityType(ent)
    end
    return 0
end

local function safeEntityModel(ent)
    if entityType(ent) ~= 0 then
        return GetEntityModel(ent)
    end
    return 0
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
    local _, _, ent = aimRaycast(2 + 16) -- vehicles + objects
    if ent and ent ~= 0 and handleToId[ent] then return handleToId[ent], ent end
    return nil, ent
end

local function currentInterior()
    local ped = PlayerPedId()
    local interior = GetInteriorFromEntity(ped)
    if interior == 0 then
        local c = GetEntityCoords(ped)
        interior = GetInteriorAtCoords(c.x, c.y, c.z)
    end
    return interior
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

local openMenu          -- forward declaration
local openCategoryMenu  -- forward declaration

local function notify(msg, t)
    lib.notify({ title = 'RME Mapper', description = msg, type = t or 'inform' })
end

-- flatten the catalog into a single list (falls back to legacy PropList)
local function allItems()
    local out = {}
    if Config.Catalog then
        for _, cat in ipairs(Config.Catalog) do
            for _, it in ipairs(cat.items or {}) do out[#out + 1] = it end
        end
    elseif Config.PropList then
        for _, it in ipairs(Config.PropList) do out[#out + 1] = it end
    end
    return out
end

-- spawn a model with the gizmo, then save it on the server
local function spawnFromModel(model)
    if not model or model == '' then
        notify('Pick a prop or type a model name.', 'error')
        return
    end
    local hash = loadModel(model)
    if not hash then
        notify(('Invalid model: %s'):format(tostring(model)), 'error')
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
        notify('Prop placed & saved.', 'success')
    end
end

-- ---------------------------------------------------------------------------
-- actions: spawning
-- ---------------------------------------------------------------------------
local function actionSpawnCustom()
    local input = lib.inputDialog('Spawn by model name', {
        { type = 'input', label = 'Model name', description = 'Type any prop model (e.g. prop_barrel_01a)', required = true },
    })
    if not input then return end
    spawnFromModel(input[1])
end

local function actionSpawnSearch()
    local input = lib.inputDialog('Search all props', {
        { type = 'input', label = 'Keyword', description = 'e.g. wall, lift, beam, light, toolbox', required = true },
    })
    if not input or not input[1] then return end
    local term = string.lower(input[1])
    local matches = {}
    for _, it in ipairs(allItems()) do
        if string.find(string.lower(it.label), term, 1, true) or string.find(string.lower(it.model), term, 1, true) then
            matches[#matches + 1] = { value = it.model, label = it.label }
            if #matches >= 100 then break end
        end
    end
    if #matches == 0 then
        matches[1] = { value = input[1], label = ('Use \"%s\" as a model name'):format(input[1]) }
    end
    local pick = lib.inputDialog('Search results', {
        { type = 'select', label = 'Pick a prop', options = matches, searchable = true, clearable = true },
    })
    if pick and pick[1] then spawnFromModel(pick[1]) end
end

local function openCategoryItems(cat)
    local opts = {}
    for _, it in ipairs(cat.items or {}) do
        opts[#opts + 1] = { value = it.model, label = it.label }
    end
    local pick = lib.inputDialog(cat.category, {
        { type = 'select', label = 'Choose a prop', description = 'Search this category and pick one', options = opts, searchable = true, clearable = true },
    })
    if pick and pick[1] then spawnFromModel(pick[1]) end
end

openCategoryMenu = function()
    local options = {}
    for _, cat in ipairs(Config.Catalog or {}) do
        local c = cat
        options[#options + 1] = {
            title = c.category,
            description = ('%d items'):format(#(c.items or {})),
            icon = 'cubes',
            onSelect = function() openCategoryItems(c); Wait(150); openCategoryMenu() end,
        }
    end
    lib.registerContext({ id = 'rme_mapper_categories', title = 'Spawn by category', menu = 'rme_mapper_menu', options = options })
    lib.showContext('rme_mapper_categories')
end

-- ---------------------------------------------------------------------------
-- actions: editing props we own
-- ---------------------------------------------------------------------------
local function actionEdit()
    local id, ent = getOurAimedId()
    if not id then
        notify('Aim at a mapper prop first.', 'inform')
        return
    end
    local pos, rot = gizmoEdit(ent)
    if pos then
        TriggerServerEvent('rme-mapper:server:update', id, pos, rot)
        notify('Prop updated & saved.', 'success')
    end
end

local function actionNudge()
    local id, ent = getOurAimedId()
    if not id then
        notify('Aim at a mapper prop first.', 'inform')
        return
    end
    local pos = GetEntityCoords(ent)
    local rot = GetEntityRotation(ent, 2)
    local input = lib.inputDialog('Precise nudge / rotate', {
        { type = 'number', label = 'Move X (m)', default = 0.0, step = Config.NudgeStep },
        { type = 'number', label = 'Move Y (m)', default = 0.0, step = Config.NudgeStep },
        { type = 'number', label = 'Move Z (m)', default = 0.0, step = Config.NudgeStep },
        { type = 'number', label = 'Rotate yaw (deg)', default = 0.0, step = Config.RotateStep },
    })
    if not input then return end
    local np = { x = pos.x + (input[1] or 0.0), y = pos.y + (input[2] or 0.0), z = pos.z + (input[3] or 0.0) }
    local nr = { x = rot.x, y = rot.y, z = rot.z + (input[4] or 0.0) }
    TriggerServerEvent('rme-mapper:server:update', id, np, nr)
    notify('Nudged & saved.', 'success')
end

local function actionDuplicate()
    local id, ent = getOurAimedId()
    if not id then
        notify('Aim at a mapper prop to duplicate.', 'inform')
        return
    end
    local model = safeEntityModel(ent)
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
        notify('Duplicated & saved.', 'success')
    end
end

local function actionSnap()
    local id, ent = getOurAimedId()
    if not id then
        notify('Aim at a mapper prop to snap.', 'inform')
        return
    end
    PlaceObjectOnGroundProperly(ent)
    local pos = GetEntityCoords(ent)
    local rot = GetEntityRotation(ent, 2)
    TriggerServerEvent('rme-mapper:server:update', id, { x = pos.x, y = pos.y, z = pos.z }, { x = rot.x, y = rot.y, z = rot.z })
    notify('Snapped to ground.', 'success')
end

local function actionDelete()
    local id = getOurAimedId()
    if not id then
        notify('Aim at a mapper prop to delete.', 'inform')
        return
    end
    TriggerServerEvent('rme-mapper:server:remove', id)
    notify('Prop deleted.', 'success')
end

local function actionClearMine()
    local ok = lib.alertDialog({
        header = 'Clear all your props',
        content = 'Delete EVERY prop you have placed? This cannot be undone.',
        centered = true,
        cancel = true,
    })
    if ok ~= 'confirm' then return end
    local ids = {}
    for id in pairs(localProps) do ids[#ids + 1] = id end
    for _, id in ipairs(ids) do TriggerServerEvent('rme-mapper:server:remove', id) end
    notify(('Cleared %d props.'):format(#ids), 'success')
end

-- ---------------------------------------------------------------------------
-- actions: existing MLO/map props
-- ---------------------------------------------------------------------------
local function actionHide()
    local _, _, ent = aimRaycast(2 + 16) -- vehicles + objects (no world flag, so no invalid handles)
    if entityType(ent) ~= 0 then
        if handleToId[ent] then
            notify('That is a prop you placed - use Delete instead.', 'inform')
            return
        end
        local model = safeEntityModel(ent)
        if model ~= 0 then
            local c = GetEntityCoords(ent)
            TriggerServerEvent('rme-mapper:server:hide', model, { x = c.x, y = c.y, z = c.z }, Config.HideRadius)
            notify('Object hidden & saved.', 'success')
            return
        end
    end
    local hit, coords = aimRaycast(1 + 16) -- world + objects, just for the hit position
    if not hit then
        notify('Aim at the object you want to remove.', 'inform')
        return
    end
    local input = lib.inputDialog('Hide map object', {
        { type = 'input', label = 'Model name', description = 'No movable entity here. Enter the prop model to hide at this spot.', required = true },
        { type = 'number', label = 'Radius (m)', default = Config.HideRadius, min = 0.5, max = 25.0 },
    })
    if not input then return end
    TriggerServerEvent('rme-mapper:server:hide', input[1], { x = coords.x, y = coords.y, z = coords.z }, (input[2] or Config.HideRadius) + 0.0)
    notify('Hidden (by model) & saved.', 'success')
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
    notify('Restored all hidden objects.', 'success')
end

-- ---------------------------------------------------------------------------
-- actions: discovery / MLO interior
-- ---------------------------------------------------------------------------
local function actionInspect()
    print('[rme-mapper][inspect] ----- aiming probe -----')
    local found = {}
    for _, f in ipairs({ 16, 2, 1, 7, 511 }) do
        local hit, coords, ent = aimRaycast(f)
        local etype = entityType(ent)
        local model = (etype ~= 0) and GetEntityModel(ent) or 0
        print(('[rme-mapper][inspect] flag=%d hit=%s entity=%s type=%s model=%s coords=%s')
            :format(f, tostring(hit), tostring(ent), tostring(etype), tostring(model), tostring(coords)))
        if model ~= 0 then
            found[#found + 1] = ('flag %d -> type %d, model hash %s'):format(f, etype, model)
        end
    end
    local interior = currentInterior()
    local pc = GetEntityCoords(PlayerPedId())
    print(('[rme-mapper][inspect] interior id at player = %s  | player coords = %.2f, %.2f, %.2f')
        :format(tostring(interior), pc.x, pc.y, pc.z))
    if #found > 0 then
        lib.notify({ title = 'Inspect', description = table.concat(found, ' | ') .. ' (see F8)', type = 'inform', duration = 8000 })
    else
        lib.notify({ title = 'Inspect', description = ('No prop entity under crosshair (baked into MLO). Interior id %s. See F8.'):format(tostring(interior)), type = 'inform', duration = 8000 })
    end
end

local function actionScanSets()
    local interior = currentInterior()
    if not interior or interior == 0 then
        notify('No interior here - stand inside the MLO and scan again.', 'error')
        return
    end
    lib.notify({ title = 'Entity sets', description = 'Scanning ~9000 name combos... watch F8.', type = 'inform' })
    print(('[rme-mapper][sets] ----- scanning interior %s -----'):format(tostring(interior)))
    local active, tested = {}, 0
    for _, pre in ipairs(SET_PREFIXES) do
        for _, base in ipairs(SET_BASES) do
            for _, suf in ipairs(SET_SUFFIXES) do
                local name = pre .. base .. suf
                if IsInteriorEntitySetActive(interior, name) then
                    active[#active + 1] = name
                    print('[rme-mapper][sets] ACTIVE entity set: ' .. name)
                end
                tested = tested + 1
                if tested % 750 == 0 then Wait(0) end
            end
        end
    end
    print(('[rme-mapper][sets] done. tested %d names, %d active.'):format(tested, #active))
    if #active == 0 then
        lib.notify({ title = 'Entity sets', description = ('Tested %d names, none active in interior %s. Likely needs CodeWalker. See F8.'):format(tested, tostring(interior)), type = 'inform', duration = 9000 })
    else
        lib.notify({ title = 'Entity sets', description = 'ACTIVE: ' .. table.concat(active, ', ') .. ' (see F8)', type = 'success', duration = 12000 })
    end
end

local function actionEntitySet()
    local interior = currentInterior()
    if not interior or interior == 0 then
        notify('No interior here - entity sets only exist inside MLOs.', 'error')
        return
    end
    local input = lib.inputDialog('Toggle interior entity set', {
        { type = 'input', label = 'Entity set name', description = ('Exact set name (try Scan first). Interior id %s'):format(interior), required = true },
        { type = 'select', label = 'Action', options = { { value = 'off', label = 'Deactivate (hide)' }, { value = 'on', label = 'Activate (show)' } }, default = 'off' },
    })
    if not input then return end
    if input[2] == 'on' then
        ActivateInteriorEntitySet(interior, input[1])
    else
        DeactivateInteriorEntitySet(interior, input[1])
    end
    RefreshInterior(interior)
    notify(('Entity set \"%s\" %s.'):format(input[1], input[2] == 'on' and 'activated' or 'deactivated'), 'success')
end

-- ---------------------------------------------------------------------------
-- menu
-- ---------------------------------------------------------------------------
openMenu = function()
    lib.registerContext({
        id = 'rme_mapper_menu',
        title = 'RME Map Editor',
        options = {
            { title = 'Spawn by category', description = 'Browse walls, Bennys parts, lights, furniture...', icon = 'shapes', onSelect = function() openCategoryMenu() end },
            { title = 'Search all props', description = 'Type a keyword to find a prop fast', icon = 'magnifying-glass', onSelect = function() actionSpawnSearch(); Wait(150); openMenu() end },
            { title = 'Spawn by model name', description = 'Type any GTA prop model directly', icon = 'keyboard', onSelect = function() actionSpawnCustom(); Wait(150); openMenu() end },
            { title = 'Move / rotate (gizmo)', description = 'Aim at a prop, then drag the handles', icon = 'up-down-left-right', onSelect = function() actionEdit(); Wait(150); openMenu() end },
            { title = 'Precise nudge / rotate', description = 'Aim at a prop, enter exact offsets', icon = 'ruler', onSelect = function() actionNudge(); Wait(150); openMenu() end },
            { title = 'Duplicate', description = 'Aim at a prop to copy it', icon = 'clone', onSelect = function() actionDuplicate(); Wait(150); openMenu() end },
            { title = 'Snap to ground', description = 'Aim at a prop to drop it onto the surface', icon = 'arrows-down-to-line', onSelect = function() actionSnap(); Wait(150); openMenu() end },
            { title = 'Delete prop', description = 'Aim at a prop YOU placed to remove it', icon = 'trash', onSelect = function() actionDelete(); Wait(150); openMenu() end },
            { title = 'Clear ALL my props', description = 'Delete every prop you placed (with confirm)', icon = 'broom', onSelect = function() actionClearMine(); Wait(150); openMenu() end },
            { title = 'Hide map / MLO object', description = 'Aim at an existing door or prop to hide it', icon = 'eye-slash', onSelect = function() actionHide(); Wait(150); openMenu() end },
            { title = 'Restore ALL hidden', description = 'Bring back everything you hid', icon = 'rotate-left', onSelect = function() actionUnhideAll(); Wait(150); openMenu() end },
            { title = 'Inspect object', description = 'Print model + interior id to F8', icon = 'circle-info', onSelect = function() actionInspect(); Wait(150); openMenu() end },
            { title = 'Scan entity sets (F8)', description = 'Find active MLO decor sets', icon = 'radar', onSelect = function() actionScanSets(); Wait(150); openMenu() end },
            { title = 'Toggle interior entity set', description = 'Show/hide a named MLO decor set', icon = 'layer-group', onSelect = function() actionEntitySet(); Wait(150); openMenu() end },
        },
    })
    lib.showContext('rme_mapper_menu')
end

RegisterNetEvent('rme-mapper:client:open', function()
    if not lib then
        print('[rme-mapper] ERROR: ox_lib (lib) is nil on the client - ox_lib not loaded for this resource')
        return
    end
    openMenu()
end)
