local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('primeWeaponshop:getMoney', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then cb(0, 0) return end
    cb(Player.PlayerData.money.cash, Player.PlayerData.money.bank)
end)

RegisterNetEvent('primeWeaponshop:buy', function(name, buytype, payment, price, label, selectItemAmount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if payment ~= 'cash' and payment ~= 'bank' then return end

    -- Server-side validation: only sell what's in the config, at config prices
    local entry
    for _, v in pairs(Config.Weapons) do
        if v.name == name then
            entry = v
            break
        end
    end
    if not entry then return end

    local amount = 1
    if entry.type == 'item' then
        amount = math.floor(tonumber(selectItemAmount) or 1)
        if amount < 1 then amount = 1 end
        if amount > 50 then amount = 50 end
    end
    local realPrice = entry.price * amount
    local itemName = entry.name:lower()

    if not QBCore.Shared.Items[itemName] then
        print(('^1[primeWeaponshop] Item \'%s\' does not exist in QBCore.Shared.Items - fix the config!^0'):format(itemName))
        return
    end

    if Player.PlayerData.money[payment] < realPrice then
        TriggerClientEvent('primeWeaponshop:notify', src, Translation[Config.Locale]['notenough_money'])
        return
    end

    if entry.type == 'weapon' then
        if Player.Functions.GetItemByName(itemName) then
            TriggerClientEvent('primeWeaponshop:notify', src, Translation[Config.Locale]['gotweapon'])
            return
        end
        if Player.Functions.AddItem(itemName, 1) then
            Player.Functions.RemoveMoney(payment, realPrice, 'weaponshop-purchase')
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'add')
            TriggerClientEvent('primeWeaponshop:notify', src, Translation[Config.Locale]['boughtnotify'] .. entry.label .. Translation[Config.Locale]['boughtnotify2'] .. realPrice .. Config.Currency .. Translation[Config.Locale]['boughtnotify3'])
        else
            TriggerClientEvent('primeWeaponshop:notify', src, Translation[Config.Locale]['cantcarry'])
        end
    else
        if Player.Functions.AddItem(itemName, amount) then
            Player.Functions.RemoveMoney(payment, realPrice, 'weaponshop-purchase')
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'add', amount)
            TriggerClientEvent('primeWeaponshop:notify', src, Translation[Config.Locale]['boughtnotify'] .. amount .. 'x ' .. entry.label .. Translation[Config.Locale]['boughtnotify2'] .. realPrice .. Config.Currency .. Translation[Config.Locale]['boughtnotify3'])
        else
            TriggerClientEvent('primeWeaponshop:notify', src, Translation[Config.Locale]['cantcarry'])
        end
    end
end)
