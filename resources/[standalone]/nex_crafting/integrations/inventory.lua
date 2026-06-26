--[[
    nex-Crafting | Editable Server Inventory Functions
    =====================================================
    This file contains all atomic inventory operations that interact directly
    with your inventory system. Edit these functions to integrate with your
    preferred inventory resource (ox_inventory, qs-inventory, codem-inventory, etc.)

    These functions are loaded BEFORE core files and define the
    nexCrafting.Inventory namespace that the rest of the script uses.

    IMPORTANT: Do not rename the functions - only change their internal implementation.
    Each function documents its expected inputs/outputs below.

    RME EDIT: This server runs qb-core + qb-inventory (NOT ox_inventory), and the
    stock 'nex_bridge' fallback resource does not exist. All non-ox fallbacks below
    have been rewired to call qb-core/qb-inventory directly.
]]

nexCrafting = nexCrafting or {}
nexCrafting.Inventory = nexCrafting.Inventory or {}

----------------------------------------------------------------
-- Inventory Detection / Initialization
----------------------------------------------------------------
local ox_inventory = nil
local inventoryReady = false

if GetResourceState('ox_inventory') == 'started' then
    ox_inventory = exports.ox_inventory
    inventoryReady = true
    print('^2[nex-Crafting]^7 ox_inventory detected and loaded')
else
    print('^3[nex-Crafting]^7 ox_inventory not found, using qb-core/qb-inventory bridge')
end

CreateThread(function()
    Wait(2000)
    if not inventoryReady and GetResourceState('ox_inventory') == 'started' then
        ox_inventory = exports.ox_inventory
        inventoryReady = true
        print('^2[nex-Crafting]^7 ox_inventory detected (delayed)')
    end
end)

----------------------------------------------------------------
-- QBCore object helper (cached). Used by all non-ox fallbacks.
----------------------------------------------------------------
local QBCore = nil
local function getQB()
    if not QBCore then
        if GetResourceState('qb-core') == 'started' then
            local ok, core = pcall(function() return exports['qb-core']:GetCoreObject() end)
            if ok then QBCore = core end
        elseif GetResourceState('qbx_core') == 'started' then
            local ok, core = pcall(function() return exports['qbx_core']:GetCoreObject() end)
            if ok then QBCore = core end
        end
    end
    return QBCore
end

CreateThread(function() getQB() end)

----------------------------------------------------------------
-- nexCrafting.Inventory.IsOxInventory()
----------------------------------------------------------------
function nexCrafting.Inventory.IsOxInventory()
    return inventoryReady and ox_inventory ~= nil
end

----------------------------------------------------------------
-- nexCrafting.Inventory.GetItemCount(source, itemName)
-- @return: number - total count of the item across the player's inventory
----------------------------------------------------------------
function nexCrafting.Inventory.GetItemCount(source, itemName)
    if nexCrafting.Inventory.IsOxInventory() then
        local count = ox_inventory:GetItemCount(source, itemName)
        return count or 0
    end
    -- qb-core: sum amounts across all matching slots
    local qb = getQB()
    if qb then
        local Player = qb.Functions.GetPlayer(source)
        if Player and Player.PlayerData and Player.PlayerData.items then
            local count = 0
            for _, item in pairs(Player.PlayerData.items) do
                if item and item.name == itemName then
                    count = count + (item.amount or item.count or 0)
                end
            end
            return count
        end
    end
    return 0
end

----------------------------------------------------------------
-- nexCrafting.Inventory.CanCarryItem(source, itemName, amount)
----------------------------------------------------------------
function nexCrafting.Inventory.CanCarryItem(source, itemName, amount)
    amount = amount or 1
    if nexCrafting.Inventory.IsOxInventory() then
        local canCarry = ox_inventory:CanCarryItem(source, itemName, amount)
        return canCarry
    end
    -- qb-inventory exposes CanAddItem on newer builds; default to true otherwise
    local ok, can = pcall(function() return exports['qb-inventory']:CanAddItem(source, itemName, amount) end)
    if ok and can ~= nil then return can end
    return true
end

----------------------------------------------------------------
-- nexCrafting.Inventory.AddItem(source, itemName, amount, metadata)
----------------------------------------------------------------
function nexCrafting.Inventory.AddItem(source, itemName, amount, metadata)
    amount = amount or 1
    metadata = metadata or nil
    if nexCrafting.Inventory.IsOxInventory() then
        local success = ox_inventory:AddItem(source, itemName, amount, metadata)
        nexCrafting.Debug('AddItem:', itemName, 'x', amount, 'success:', success)
        return success
    end
    -- qb-inventory server export first (info = metadata)
    local ok, success = pcall(function()
        return exports['qb-inventory']:AddItem(source, itemName, amount, false, metadata, 'nex_crafting')
    end)
    if ok and success ~= nil then
        nexCrafting.Debug('AddItem (qb-inventory):', itemName, 'x', amount, 'success:', success)
        return success and true or false
    end
    -- fallback to qb-core player function
    local qb = getQB()
    if qb then
        local Player = qb.Functions.GetPlayer(source)
        if Player then
            local added = Player.Functions.AddItem(itemName, amount, false, metadata)
            nexCrafting.Debug('AddItem (player.fn):', itemName, 'x', amount, 'success:', added)
            return added and true or false
        end
    end
    return false
end

----------------------------------------------------------------
-- nexCrafting.Inventory.RemoveItem(source, itemName, amount, metadata, slot)
----------------------------------------------------------------
function nexCrafting.Inventory.RemoveItem(source, itemName, amount, metadata, slot)
    amount = amount or 1
    if nexCrafting.Inventory.IsOxInventory() then
        local success = ox_inventory:RemoveItem(source, itemName, amount, metadata, slot)
        nexCrafting.Debug('RemoveItem:', itemName, 'x', amount, 'success:', success)
        return success
    end
    -- qb-inventory server export first
    local ok, success = pcall(function()
        return exports['qb-inventory']:RemoveItem(source, itemName, amount, slot or false, 'nex_crafting')
    end)
    if ok and success ~= nil then
        nexCrafting.Debug('RemoveItem (qb-inventory):', itemName, 'x', amount, 'success:', success)
        return success and true or false
    end
    -- fallback to qb-core player function
    local qb = getQB()
    if qb then
        local Player = qb.Functions.GetPlayer(source)
        if Player then
            local removed = Player.Functions.RemoveItem(itemName, amount, slot)
            nexCrafting.Debug('RemoveItem (player.fn):', itemName, 'x', amount, 'success:', removed)
            return removed and true or false
        end
    end
    return false
end

----------------------------------------------------------------
-- nexCrafting.Inventory.GetItems(source)
-- @return: table - all items in the player's inventory (slot-keyed)
----------------------------------------------------------------
function nexCrafting.Inventory.GetItems(source)
    if nexCrafting.Inventory.IsOxInventory() then
        local items = ox_inventory:GetInventoryItems(source)
        return items or {}
    end
    local qb = getQB()
    if qb then
        local Player = qb.Functions.GetPlayer(source)
        if Player and Player.PlayerData and Player.PlayerData.items then
            return Player.PlayerData.items
        end
    end
    return {}
end

----------------------------------------------------------------
-- nexCrafting.Inventory.GetSlot(source, slot)
----------------------------------------------------------------
function nexCrafting.Inventory.GetSlot(source, slot)
    if nexCrafting.Inventory.IsOxInventory() then
        local item = ox_inventory:GetSlot(source, slot)
        return item
    end
    local qb = getQB()
    if qb then
        local Player = qb.Functions.GetPlayer(source)
        if Player and Player.PlayerData and Player.PlayerData.items then
            return Player.PlayerData.items[slot]
        end
    end
    return nil
end

----------------------------------------------------------------
-- nexCrafting.Inventory.GetItemData(itemName)
-- @return: table|nil - the item definition (label, weight, image, etc.)
----------------------------------------------------------------
function nexCrafting.Inventory.GetItemData(itemName)
    if nexCrafting.Inventory.IsOxInventory() then
        local item = ox_inventory:Items(itemName)
        return item
    end
    local qb = getQB()
    if qb and qb.Shared and qb.Shared.Items then
        return qb.Shared.Items[itemName]
    end
    return nil
end

----------------------------------------------------------------
-- nexCrafting.Inventory.SetMetadata(source, slot, metadata)
----------------------------------------------------------------
function nexCrafting.Inventory.SetMetadata(source, slot, metadata)
    if nexCrafting.Inventory.IsOxInventory() then
        ox_inventory:SetMetadata(source, slot, metadata)
        return true
    end
    -- qb-inventory: set item info on a slot when supported
    local ok = pcall(function()
        exports['qb-inventory']:SetItemData(source, slot, 'info', metadata)
    end)
    return ok and true or false
end

----------------------------------------------------------------
-- nexCrafting.Inventory.GetDamagedItems(source, threshold)
----------------------------------------------------------------
function nexCrafting.Inventory.GetDamagedItems(source, threshold)
    threshold = threshold or 100
    local damagedItems = {}
    if nexCrafting.Inventory.IsOxInventory() then
        local items = ox_inventory:GetInventoryItems(source)
        if items then
            for slot, item in pairs(items) do
                if item and item.metadata and item.metadata.durability then
                    if item.metadata.durability < threshold then
                        table.insert(damagedItems, {
                            slot = slot,
                            name = item.name,
                            label = item.label,
                            durability = item.metadata.durability,
                            metadata = item.metadata,
                            count = item.count
                        })
                    end
                end
            end
        end
        return damagedItems
    end
    -- qb fallback: durability lives in item.info
    local items = nexCrafting.Inventory.GetItems(source)
    for slot, item in pairs(items or {}) do
        local info = item and item.info
        if info and info.durability and info.durability < threshold then
            table.insert(damagedItems, {
                slot = item.slot or slot,
                name = item.name,
                label = item.label,
                durability = info.durability,
                metadata = info,
                count = item.amount or item.count or 1
            })
        end
    end
    return damagedItems
end

----------------------------------------------------------------
-- nexCrafting.Inventory.RepairItem(source, slot, restoreAmount)
----------------------------------------------------------------
function nexCrafting.Inventory.RepairItem(source, slot, restoreAmount)
    restoreAmount = restoreAmount or 100
    if nexCrafting.Inventory.IsOxInventory() then
        local item = ox_inventory:GetSlot(source, slot)
        if item and item.metadata then
            local currentDurability = item.metadata.durability or 100
            local newDurability = math.min(100, currentDurability + restoreAmount)
            local newMetadata = item.metadata
            newMetadata.durability = newDurability
            ox_inventory:SetMetadata(source, slot, newMetadata)
            nexCrafting.Debug('Repaired item at slot', slot, 'from', currentDurability, 'to', newDurability)
            return true, newDurability
        end
        return false, 0
    end
    -- qb fallback
    local item = nexCrafting.Inventory.GetSlot(source, slot)
    if item and item.info then
        local currentDurability = item.info.durability or 100
        local newDurability = math.min(100, currentDurability + restoreAmount)
        local newInfo = item.info
        newInfo.durability = newDurability
        local ok = pcall(function()
            exports['qb-inventory']:SetItemData(source, slot, 'info', newInfo)
        end)
        if ok then
            nexCrafting.Debug('Repaired item at slot', slot, 'from', currentDurability, 'to', newDurability)
            return true, newDurability
        end
    end
    return false, 0
end

----------------------------------------------------------------
-- nexCrafting.Inventory.CreateCraftedItem(source, itemName, amount, recipe)
----------------------------------------------------------------
function nexCrafting.Inventory.CreateCraftedItem(source, itemName, amount, recipe)
    amount = amount or 1
    local metadata = {}
    local itemData = nexCrafting.Inventory.GetItemData(itemName)
    if itemData then
        if itemData.durability then
            metadata.durability = 100
        end
        metadata.craftedBy = GetPlayerName(source)
        metadata.craftedAt = os.time()
        if recipe and recipe.name then
            metadata.recipe = recipe.name
        end
    end
    -- nil metadata is cleaner for qb when there is nothing meaningful to attach
    if next(metadata) == nil then metadata = nil end
    return nexCrafting.Inventory.AddItem(source, itemName, amount, metadata)
end

----------------------------------------------------------------
-- nexCrafting.Inventory.GetInventoryForUI(source)
----------------------------------------------------------------
function nexCrafting.Inventory.GetInventoryForUI(source)
    local items = nexCrafting.Inventory.GetItems(source)
    local formattedItems = {}
    local oxSettings = nexCrafting.Config and nexCrafting.Config.Get('settings.oxInventory') or {}
    local imagePath = nexCrafting.ItemImagePath or oxSettings.imagePath or 'nui://ox_inventory/web/images/'
    for slot, item in pairs(items) do
        if item then
            local itemData = nexCrafting.Inventory.GetItemData(item.name)
            local meta = item.metadata or item.info
            table.insert(formattedItems, {
                slot = item.slot or slot,
                name = item.name,
                label = item.label or (itemData and itemData.label) or item.name,
                count = item.count or item.amount or 1,
                weight = item.weight or (itemData and itemData.weight) or 0,
                durability = meta and meta.durability or nil,
                metadata = meta,
                image = imagePath .. (item.name) .. '.png'
            })
        end
    end
    return formattedItems
end

----------------------------------------------------------------
-- nexCrafting.Inventory.GetAllItems()
----------------------------------------------------------------
function nexCrafting.Inventory.GetAllItems()
    local result = {}

    local function formatItems(source, items, nameKey)
        local count = 0
        if not items then return 0 end
        for k, item in pairs(items) do
            if type(item) == 'table' then
                local name = item.name or item[nameKey or 'name'] or (type(k) == 'string' and k) or nil
                if name then
                    result[name] = {
                        name = name,
                        label = item.label or name,
                        weight = tonumber(item.weight) or 0,
                    }
                    count = count + 1
                end
            end
        end
        if count > 0 then
            nexCrafting.Debug('GetAllItems: Loaded', count, 'items from', source)
        end
        return count
    end

    if nexCrafting.Inventory.IsOxInventory() then
        local ok, items = pcall(function() return ox_inventory:Items() end)
        if ok and formatItems('ox_inventory', items) > 0 then return result end
    end

    local qbOk, QBShared = pcall(function()
        if GetResourceState('qb-core') == 'started' then
            return exports['qb-core']:GetCoreObject()
        elseif GetResourceState('qbx_core') == 'started' then
            return exports['qbx_core']:GetCoreObject()
        end
        return nil
    end)
    if qbOk and QBShared and QBShared.Shared and QBShared.Shared.Items then
        if formatItems('QBCore.Shared.Items', QBShared.Shared.Items) > 0 then return result end
    end

    local esxOk, ESX = pcall(function()
        if GetResourceState('es_extended') == 'started' then
            return exports['es_extended']:getSharedObject()
        end
        return nil
    end)
    if esxOk and ESX then
        local esxItems = nil
        if type(ESX.GetItems) == 'function' then
            local ok, items = pcall(function() return ESX.GetItems() end)
            if ok and items then esxItems = items end
        end
        if not esxItems and ESX.Items then
            esxItems = ESX.Items
        end
        if esxItems and formatItems('ESX', esxItems, 'item_name') > 0 then return result end
    end

    if GetResourceState('qs-inventory') == 'started' then
        local ok, items = pcall(function() return exports['qs-inventory']:GetItemList() end)
        if ok and formatItems('qs-inventory', items) > 0 then return result end
    end

    if GetResourceState('codem-inventory') == 'started' then
        local ok, items = pcall(function() return exports['codem-inventory']:GetItemList() end)
        if ok and formatItems('codem-inventory', items) > 0 then return result end
    end

    if GetResourceState('core_inventory') == 'started' then
        local ok, items = pcall(function() return exports['core_inventory']:getAllItems() end)
        if ok and formatItems('core_inventory', items) > 0 then return result end
    end

    local dbOk, dbItems = pcall(function()
        if MySQL and MySQL.query and MySQL.query.await then
            return MySQL.query.await('SELECT `name`, `label`, `weight` FROM `items`')
        elseif GetResourceState('oxmysql') == 'started' then
            return exports.oxmysql:executeSync('SELECT `name`, `label`, `weight` FROM `items`')
        elseif GetResourceState('mysql-async') == 'started' then
            return exports['mysql-async']:mysql_sync_fetchAll('SELECT `name`, `label`, `weight` FROM `items`')
        elseif GetResourceState('ghmattimysql') == 'started' then
            return exports['ghmattimysql']:executeSync('SELECT `name`, `label`, `weight` FROM `items`')
        end
        return nil
    end)
    if dbOk and dbItems and type(dbItems) == 'table' and #dbItems > 0 then
        for _, item in ipairs(dbItems) do
            local name = item.name
            if name then
                result[name] = {
                    name = name,
                    label = item.label or name,
                    weight = tonumber(item.weight) or 0,
                }
            end
        end
        nexCrafting.Debug('GetAllItems: Loaded', nexCrafting.TableLength(result), 'items from database')
        return result
    end

    nexCrafting.Debug('GetAllItems: No items found from any source')
    return result
end

----------------------------------------------------------------
-- nexCrafting.Inventory.RegisterBenchStash(benchId, benchName)
----------------------------------------------------------------
function nexCrafting.Inventory.RegisterBenchStash(benchId, benchName)
    local oxSettings = nexCrafting.Config and nexCrafting.Config.Get('settings.oxInventory') or {}
    local benchStash = oxSettings.benchStash or {}
    if not benchStash.enabled then return end
    if not nexCrafting.Inventory.IsOxInventory() then return end
    local stashId = 'nex_bench_' .. benchId
    ox_inventory:RegisterStash(stashId, benchName .. ' Storage', benchStash.slots or 10, benchStash.weight or 50000)
    nexCrafting.Debug('Registered stash for bench:', benchId)
end

----------------------------------------------------------------
-- nexCrafting.Inventory.OpenBenchStash(source, benchId)
----------------------------------------------------------------
function nexCrafting.Inventory.OpenBenchStash(source, benchId)
    local oxSettings = nexCrafting.Config and nexCrafting.Config.Get('settings.oxInventory') or {}
    local benchStash = oxSettings.benchStash or {}
    if not benchStash.enabled then return false end
    if not nexCrafting.Inventory.IsOxInventory() then return false end
    local stashId = 'nex_bench_' .. benchId
    ox_inventory:forceOpenInventory(source, 'stash', stashId)
    return true
end
