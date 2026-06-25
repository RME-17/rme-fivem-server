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
