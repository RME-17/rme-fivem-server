local QBCore = exports['qb-core']:GetCoreObject()

-- Accept any mechanic shop. We match by job TYPE ('mechanic') OR by NAME, so a
-- character whose saved job object predates the type field (e.g. set to redline
-- before redline had type = 'mechanic') is not wrongly locked out of the tablet,
-- billing or the orders board.
local MechanicJobs = {
    mechanic = true,
    mechanic2 = true,
    mechanic3 = true,
    beeker = true,
    redline = true,
}

local function isMechanic(Player)
    if not Player or not Player.PlayerData or not Player.PlayerData.job then return false end
    local job = Player.PlayerData.job
    return job.type == 'mechanic' or MechanicJobs[job.name] == true
end

-- Consume the physical part required to apply a cosmetic. The member tablet calls
-- this BEFORE it applies any upgrade. Returns (ok, needLabel):
--   ok = false, 'not_mechanic'  -> caller is not a mechanic
--   ok = false, <label>         -> caller is missing that part
--   ok = true                   -> a part was consumed (or none was required)
-- 'skip' is passed true for OFF / Stock selections, which never consume a part.
QBCore.Functions.CreateCallback('qb-mechanicjob:server:consumePart', function(source, cb, kind, skip)
    local Player = exports['qb-core']:GetPlayer(source)
    if not isMechanic(Player) then cb(false, 'not_mechanic') return end
    if not Config.RequirePartItems then cb(true) return end
    if skip then cb(true) return end
    local map = Config.PartItems and Config.PartItems[kind]
    if not map then cb(true) return end
    local has = Player.Functions.GetItemByName(map.item)
    if not has or (has.amount or 0) < 1 then cb(false, map.label) return end
    Player.Functions.RemoveItem(map.item, 1)
    pcall(function()
        TriggerClientEvent('qb-inventory:client:ItemBox', source, QBCore.Shared.Items[map.item], 'remove', 1)
    end)
    cb(true)
end)

-- The generic 'tablet' item ships as useable = false; it is force-enabled inside
-- qb-core (shared/rme_useable_overrides.lua) so the inventory 'Use' option works
-- regardless of resource start order. This thread is a redundant safety net.
CreateThread(function()
    if QBCore.Shared and QBCore.Shared.Items and QBCore.Shared.Items['tablet'] then
        QBCore.Shared.Items['tablet'].useable = true
    end
end)

QBCore.Functions.CreateUseableItem('tablet', function(source)
    local Player = exports['qb-core']:GetPlayer(source)
    if not Player then return end
    if Config.RequireJob and not isMechanic(Player) then
        TriggerClientEvent('QBCore:Notify', source, 'Only mechanics can connect this tablet to a vehicle', 'error')
        return
    end
    TriggerClientEvent('qb-mechanicjob:client:useTablet', source)
end)

-- Customer billing -----------------------------------------------------------
-- A mechanic invoices a customer by server ID; the customer accepts/declines; on
-- accept the money is pulled (bank first, then cash) and deposited into the
-- mechanic shop's society account.

local pendingBills = {}

RegisterNetEvent('qb-mechanicjob:server:billCustomer', function(targetId, amount)
    local src = source
    local Mechanic = exports['qb-core']:GetPlayer(src)
    if not Mechanic then return end
    if not isMechanic(Mechanic) then
        TriggerClientEvent('QBCore:Notify', src, 'Only mechanics can bill customers', 'error')
        return
    end
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return end
    local Target = exports['qb-core']:GetPlayer(tonumber(targetId))
    if not Target then
        TriggerClientEvent('QBCore:Notify', src, 'No player online with that ID', 'error')
        return
    end
    local tgt = Target.PlayerData.source
    pendingBills[tgt] = {
        amount = amount,
        society = Mechanic.PlayerData.job.name,
        shopLabel = Mechanic.PlayerData.job.label,
        mechanic = src,
    }
    local mechName = ('%s %s'):format(Mechanic.PlayerData.charinfo.firstname, Mechanic.PlayerData.charinfo.lastname)
    TriggerClientEvent('qb-mechanicjob:client:billPrompt', tgt, mechName, amount)
    TriggerClientEvent('QBCore:Notify', src, ('Invoice sent to %s %s (ID %s)'):format(Target.PlayerData.charinfo.firstname, Target.PlayerData.charinfo.lastname, tgt), 'primary')
end)

RegisterNetEvent('qb-mechanicjob:server:billResponse', function(accepted)
    local src = source
    local bill = pendingBills[src]
    if not bill then return end
    pendingBills[src] = nil
    local Customer = exports['qb-core']:GetPlayer(src)
    if not Customer then return end
    if not accepted then
        TriggerClientEvent('QBCore:Notify', src, 'Invoice declined', 'error')
        if bill.mechanic then TriggerClientEvent('QBCore:Notify', bill.mechanic, 'Customer declined the invoice', 'error') end
        return
    end
    local amount = bill.amount
    local paid = false
    if Customer.PlayerData.money.bank >= amount then
        paid = Customer.Functions.RemoveMoney('bank', amount, 'redline-cosmetics')
    elseif Customer.PlayerData.money.cash >= amount then
        paid = Customer.Functions.RemoveMoney('cash', amount, 'redline-cosmetics')
    end
    if not paid then
        TriggerClientEvent('QBCore:Notify', src, 'You cannot afford this invoice', 'error')
        if bill.mechanic then TriggerClientEvent('QBCore:Notify', bill.mechanic, 'Customer could not afford the invoice', 'error') end
        return
    end
    -- deposit into the shop society account (qb-banking, fall back to qb-management)
    local ok = pcall(function()
        exports['qb-banking']:AddMoney(bill.society, amount, 'Vehicle cosmetics & work')
    end)
    if not ok then
        pcall(function() exports['qb-management']:AddMoney(bill.society, amount) end)
    end
    TriggerClientEvent('QBCore:Notify', src, ('You paid $%s to %s'):format(amount, bill.shopLabel or 'the shop'), 'success')
    if bill.mechanic then TriggerClientEvent('QBCore:Notify', bill.mechanic, ('Customer paid $%s'):format(amount), 'success') end
end)

-- Customer cosmetics order board --------------------------------------------
-- Customers build an order at the drive-in bay (client/custombay.lua) and submit
-- it. Orders are held in memory (cleared on restart), keyed by plate, and shown
-- in the Orders tab of the member tablet. Members apply each item one at a time
-- on the real car while it is present.

local orders = {} -- plate -> { plate, vehName, customer, customerName, items = {...}, total, time }
local history = {} -- completed orders (newest last): { plate, vehName, customerName, total, time }

-- Sum the price of each cosmetic CATEGORY represented in an order, counting a
-- category only once and skipping anything turned OFF or set back to Stock. This
-- is the single total the customer sees at submit and the member sees on the
-- order card -- there are never per-item amounts.
local function computeOrderTotal(items)
    if type(items) ~= 'table' then return 0 end
    local prices = Config.CosmeticPrices or {}
    local seen = {}
    local total = 0
    for _, it in ipairs(items) do
        if type(it) == 'table' then
            local kind = it.kind
            local skip = false
            if it.off == true then skip = true end
            if kind == 'wheel' and tonumber(it.index) == -1 then skip = true end
            if kind and not skip and not seen[kind] then
                seen[kind] = true
                total = total + (prices[kind] or 0)
            end
        end
    end
    return total
end

local function notifyMechanics(msg)
    local players = QBCore.Functions.GetQBPlayers()
    for _, Player in pairs(players) do
        if Player and Player.PlayerData and Player.PlayerData.job
            and isMechanic(Player) and Player.PlayerData.job.onduty then
            TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, msg, 'primary')
        end
    end
end

RegisterNetEvent('qb-mechanicjob:server:submitOrder', function(plate, vehName, items)
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    if not Player then return end
    if type(items) ~= 'table' or #items == 0 then return end
    if type(plate) ~= 'string' then return end
    local cname = ('%s %s'):format(Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
    local total = computeOrderTotal(items)
    orders[plate] = {
        plate = plate,
        vehName = vehName or 'Vehicle',
        customer = src,
        customerName = cname,
        items = items,
        total = total,
        time = os.time(),
    }
    TriggerClientEvent('QBCore:Notify', src, ('Your customization order ($%s) was sent to Redline Motorsport'):format(total), 'success')
    notifyMechanics(('New Redline order: %s (%s) - $%s'):format(vehName or 'Vehicle', plate, total))
end)

QBCore.Functions.CreateCallback('qb-mechanicjob:server:getOrders', function(source, cb)
    local Player = exports['qb-core']:GetPlayer(source)
    if not isMechanic(Player) then cb({}) return end
    local list = {}
    for _, o in pairs(orders) do
        list[#list + 1] = o
    end
    cb(list)
end)

-- Completed order history (newest first), shown in the History tab.
QBCore.Functions.CreateCallback('qb-mechanicjob:server:getHistory', function(source, cb)
    local Player = exports['qb-core']:GetPlayer(source)
    if not isMechanic(Player) then cb({}) return end
    local list = {}
    for i = #history, 1, -1 do
        list[#list + 1] = history[i]
    end
    cb(list)
end)

RegisterNetEvent('qb-mechanicjob:server:completeOrderItem', function(plate, index)
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    if not isMechanic(Player) then return end
    local o = orders[plate]
    if not o then return end
    index = tonumber(index)
    if index and o.items[index] then
        table.remove(o.items, index)
    end
    if #o.items == 0 then
        history[#history + 1] = {
            plate = o.plate,
            vehName = o.vehName,
            customerName = o.customerName,
            total = o.total or 0,
            time = os.time(),
        }
        orders[plate] = nil
        if o.customer then TriggerClientEvent('QBCore:Notify', o.customer, 'Your Redline order is complete', 'success') end
    end
end)

RegisterNetEvent('qb-mechanicjob:server:cancelOrder', function(plate)
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    if not isMechanic(Player) then return end
    local o = orders[plate]
    if not o then return end
    orders[plate] = nil
    if o.customer then TriggerClientEvent('QBCore:Notify', o.customer, 'Your Redline order was cancelled', 'error') end
end)

-- Shared Redline parts stash -------------------------------------------------
-- Opened from the physical box at the shop and from the Storage tab in the
-- member tablet. qb-inventory auto-initializes the stash on first open.
RegisterNetEvent('qb-mechanicjob:server:openRedlineStorage', function()
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    if not isMechanic(Player) then
        TriggerClientEvent('QBCore:Notify', src, 'Only Redline members can open this storage', 'error')
        return
    end
    local cfg = Config.RedlineStorage
    if not cfg then return end
    exports['qb-inventory']:OpenInventory(src, cfg.stash, {
        label = cfg.label,
        maxweight = cfg.maxweight,
        slots = cfg.slots,
    })
end)

AddEventHandler('playerDropped', function()
    pendingBills[source] = nil
end)
