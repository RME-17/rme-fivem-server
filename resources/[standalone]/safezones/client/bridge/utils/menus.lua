local Menus = {}

local MissionTargets = KojaCarmarketTargets

local npcBindings = {}
local vehicleListingBindings = {}
local menuCallbacks = {}

Menus.resolveMenuSystem = function()
    local checks = {
        ox_target = function()
            return GetResourceState('ox_target') == 'started' and exports and exports.ox_target ~= nil
        end,
        ox_lib = function()
            return GetResourceState('ox_lib') == 'started' and exports and exports.ox_lib ~= nil
        end,
        esx_menu_default = function()
            return GetResourceState('es_extended') == 'started'
        end,
        ['qb-menu-default'] = function()
            return GetResourceState('qb-menu') == 'started'
        end,
    }

    local wanted = Config and Config.InventoryMenuSystem or nil
    if (wanted == nil or wanted == '' or wanted == 'auto') and Config then
        wanted = Config.Interaction
    end

    local pick = checks[wanted]
    if wanted and pick and pick() then
        return wanted
    end
    if wanted == 'ox_target' then
        for _, id in ipairs({ 'ox_lib', 'esx_menu_default', 'qb-menu-default' }) do
            local fn = checks[id]
            if fn and fn() then return id end
        end
    end
    for _, id in ipairs({ 'ox_lib', 'esx_menu_default', 'qb-menu-default', 'ox_target' }) do
        local fn = checks[id]
        if fn and fn() then return id end
    end
    return 'none'
end

Menus.getAllowedActions = function(actions)
    local available = {}
    for _, action in ipairs(actions or {}) do
        local canUse = action.canInteract == nil or action.canInteract()
        if canUse then
            available[#available + 1] = action
        end
    end
    return available
end

Menus.openActionsMenu = function(bindingId, actions, title)
    local system = Menus.resolveMenuSystem()
    local available = Menus.getAllowedActions(actions)
    if #available == 0 then return end

    if system == 'ox_lib' then
        local options = {}
        for _, action in ipairs(available) do
            options[#options + 1] = {
                title = action.label,
                icon = action.icon,
                onSelect = function()
                    action.onSelect()
                end
            }
        end
        pcall(function()
            exports.ox_lib:registerContext({
                id = bindingId,
                title = title,
                options = options
            })
            exports.ox_lib:showContext(bindingId)
        end)
        return
    end

    if system == 'esx_menu_default' then
        local ESX = exports['es_extended'] and exports['es_extended']:getSharedObject() or nil
        if not ESX or not ESX.UI or not ESX.UI.Menu then return end
        local elements = {}
        for _, action in ipairs(available) do
            elements[#elements + 1] = {
                label = action.label,
                value = action.id
            }
        end
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), bindingId, {
            title = title,
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local selectedId = data and data.current and data.current.value
            for _, action in ipairs(available) do
                if action.id == selectedId then
                    action.onSelect()
                    break
                end
            end
            menu.close()
        end, function(_, menu)
            menu.close()
        end)
        return
    end

    if system == 'qb-menu-default' then
        local entries = {
            {
                header = title or 'Menu',
                isMenuHeader = true
            }
        }
        for _, action in ipairs(available) do
            local cbKey = ('%s_%s_%s'):format(action.id, tostring(GetGameTimer()), tostring(math.random(1000, 9999)))
            menuCallbacks[cbKey] = action.onSelect
            entries[#entries + 1] = {
                header = action.label,
                txt = '',
                params = {
                    isAction = true,
                    event = 'koja-carmarket/client/menuAction',
                    args = {
                        cbKey = cbKey
                    }
                }
            }
        end
        exports['qb-menu']:openMenu(entries)
    end
end

RegisterNetEvent('koja-carmarket/client/menuAction', function(data)
    if not data or not data.cbKey then return end
    local cb = menuCallbacks[data.cbKey]
    menuCallbacks[data.cbKey] = nil
    if cb then cb() end
end)

Menus.clearBinding = function(store, bindingId)
    local binding = store[bindingId]
    if not binding then return end
    if binding.targetNames and exports and exports.ox_target and binding.entity and DoesEntityExist(binding.entity) then
        pcall(function()
            exports.ox_target:removeLocalEntity(binding.entity, binding.targetNames)
        end)
    end
    if binding.pointId then
        MissionTargets.RemovePointInteraction(binding.pointId)
    end
    store[bindingId] = nil
end

Menus.setupBinding = function(entity, actions, title, pointLabel, pointRadius, store, bindingId, pointPriority, pointExtras)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return end
    local prev = store[bindingId]
    if prev and prev.targetNames and exports and exports.ox_target and prev.entity and DoesEntityExist(prev.entity) then
        pcall(function()
            exports.ox_target:removeLocalEntity(prev.entity, prev.targetNames)
        end)
    end
    if prev and prev.pointId then
        MissionTargets.RemovePointInteraction(prev.pointId)
    end

    local system = Menus.resolveMenuSystem()
    local nextBinding = {
        entity = entity,
        actions = actions,
        title = title,
        pointLabel = pointLabel,
        pointRadius = pointRadius or 2.5
    }

    if system == 'ox_target' and exports and exports.ox_target then
        local targetOptions = {}
        local targetNames = {}
        for _, action in ipairs(actions or {}) do
            targetOptions[#targetOptions + 1] = {
                name = action.id,
                label = action.label,
                icon = action.icon or 'fa-hand',
                distance = action.distance or 2.5,
                canInteract = action.canInteract,
                onSelect = function()
                    action.onSelect()
                end
            }
            targetNames[#targetNames + 1] = action.id
        end
        exports.ox_target:addLocalEntity(entity, targetOptions)
        nextBinding.targetNames = targetNames
    else
        local coords = GetEntityCoords(entity)
        local pr = type(pointPriority) == 'number' and pointPriority or 1
        local po = { priority = pr }
        if type(pointExtras) == 'table' and type(pointExtras.key) == 'number' then
            po.key = pointExtras.key
        end
        nextBinding.pointId = MissionTargets.AddPointInteraction(
            bindingId,
            vector3(coords.x, coords.y, coords.z),
            nextBinding.pointRadius,
            pointLabel,
            function()
                return #Menus.getAllowedActions(actions) > 0
            end,
            function()
                Menus.openActionsMenu(bindingId, actions, title)
            end,
            po
        )
    end

    store[bindingId] = nextBinding
end

Menus.SetupNpc = function(ped, zoneId, actions, title, pointLabel, radius, pointExtras)
    local bindingId = ('carmarket_npc_%s'):format(tostring(zoneId))
    Menus.setupBinding(ped, actions, title, pointLabel, radius or 2.5, npcBindings, bindingId, 2, pointExtras)
end

Menus.SetupVehicleListing = function(vehicle, zoneId, listingKey, actions, title, pointLabel, radius)
    local bindingId = ('carmarket_listing_%s_%s'):format(tostring(zoneId), tostring(listingKey))
    Menus.setupBinding(vehicle, actions, title, pointLabel, radius or 2.5, vehicleListingBindings, bindingId, 3)
end

Menus.CleanupVehicleListing = function(zoneId, listingKey)
    Menus.clearBinding(vehicleListingBindings, ('carmarket_listing_%s_%s'):format(tostring(zoneId), tostring(listingKey)))
end

Menus.CleanupAllBindings = function()
    local nk = {}
    for k in pairs(npcBindings) do nk[#nk + 1] = k end
    for _, k in ipairs(nk) do Menus.clearBinding(npcBindings, k) end
    local vk = {}
    for k in pairs(vehicleListingBindings) do vk[#vk + 1] = k end
    for _, k in ipairs(vk) do Menus.clearBinding(vehicleListingBindings, k) end
end

KojaCarmarketMenus = Menus

return Menus
