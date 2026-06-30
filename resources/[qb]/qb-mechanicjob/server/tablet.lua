local QBCore = exports['qb-core']:GetCoreObject()

-- The generic 'tablet' item ships as useable = false. Flip it on at runtime so
-- it can act as the mechanic diagnostic tablet without rewriting qb-core items.
-- qb-mechanicjob and qb-inventory share the same live QBCore.Shared.Items table,
-- so mutating it here is enough for the inventory 'Use' action to fire.
CreateThread(function()
    if QBCore.Shared and QBCore.Shared.Items and QBCore.Shared.Items['tablet'] then
        QBCore.Shared.Items['tablet'].useable = true
    end
end)

QBCore.Functions.CreateUseableItem('tablet', function(source)
    local Player = exports['qb-core']:GetPlayer(source)
    if not Player then return end
    if Config.RequireJob and Player.PlayerData.job.type ~= 'mechanic' then
        TriggerClientEvent('QBCore:Notify', source, 'Only mechanics can connect this tablet to a vehicle', 'error')
        return
    end
    TriggerClientEvent('qb-mechanicjob:client:useTablet', source)
end)

-- Customer billing -----------------------------------------------------------
-- A mechanic invoices the nearest customer; the customer accepts/declines; on
-- accept the money is pulled (bank first, then cash) and deposited into the
-- mechanic shop's society account.

local pendingBills = {}

RegisterNetEvent('qb-mechanicjob:server:billCustomer', function(targetId, amount)
    local src = source
    local Mechanic = exports['qb-core']:GetPlayer(src)
    if not Mechanic then return end
    if Mechanic.PlayerData.job.type ~= 'mechanic' then
        TriggerClientEvent('QBCore:Notify', src, 'Only mechanics can bill customers', 'error')
        return
    end
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return end
    local Target = exports['qb-core']:GetPlayer(tonumber(targetId))
    if not Target then
        TriggerClientEvent('QBCore:Notify', src, 'Customer not found', 'error')
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

AddEventHandler('playerDropped', function()
    pendingBills[source] = nil
end)
