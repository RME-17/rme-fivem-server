local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('rme-burgershot:server:cook', function(recipeId)
    local src = source
    local recipe = Config.Recipes[recipeId]
    if not recipe then return end

    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if Config.RequireJob and Player.PlayerData.job.name ~= Config.JobName then
        TriggerClientEvent('QBCore:Notify', src, 'You do not work at Burger Shot.', 'error')
        return
    end

    -- Verify the player has every ingredient (anti-cheat: server-side check)
    for _, ing in ipairs(recipe.ingredients) do
        local item = Player.Functions.GetItemByName(ing.item)
        if not item or item.amount < ing.amount then
            local itemData = QBCore.Shared.Items[ing.item]
            local lbl = itemData and itemData.label or ing.item
            TriggerClientEvent('QBCore:Notify', src, 'Missing ingredient: ' .. lbl, 'error')
            return
        end
    end

    -- Remove ingredients
    for _, ing in ipairs(recipe.ingredients) do
        Player.Functions.RemoveItem(ing.item, ing.amount)
        local itemData = QBCore.Shared.Items[ing.item]
        if itemData then
            TriggerClientEvent('qb-inventory:client:ItemBox', src, itemData, 'remove', ing.amount)
        end
    end

    -- Add the finished product
    Player.Functions.AddItem(recipe.output.item, recipe.output.amount)
    local outData = QBCore.Shared.Items[recipe.output.item]
    if outData then
        TriggerClientEvent('qb-inventory:client:ItemBox', src, outData, 'add', recipe.output.amount)
    end
    TriggerClientEvent('QBCore:Notify', src, 'Made ' .. (outData and outData.label or recipe.output.item), 'success')
end)
