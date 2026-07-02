ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('primeWeaponshop:getMoney', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    local cash = xPlayer.getMoney()
    local bank = xPlayer.getAccount('bank').money
    cb(cash, bank)

end)

RegisterNetEvent('primeWeaponshop:buy', function(name, buytype, payment, price, label, selectItemAmount)

    _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if buytype == 'weapon' then
        if not xPlayer.hasWeapon(name) then
            xPlayer.addWeapon(name, Config.DefaultWeaponAmmo)
            TriggerClientEvent('primeWeaponshop:notify', _source, Translation[Config.Locale]['boughtnotify'] .. label .. Translation[Config.Locale]['boughtnotify2'] .. price .. Config.Currency .. Translation[Config.Locale]['boughtnotify3'])
        else
            TriggerClientEvent('primeWeaponshop:notify', _source, Translation[Config.Locale]['gotweapon'])
        end
    elseif buytype == 'item' then
        if xPlayer.canCarryItem(name, selectItemAmount) then
            xPlayer.addInventoryItem(name, selectItemAmount)
            TriggerClientEvent('primeWeaponshop:notify', _source, Translation[Config.Locale]['boughtnotify'] .. selectItemAmount .. 'x ' .. label .. Translation[Config.Locale]['boughtnotify2'] .. price .. Config.Currency .. Translation[Config.Locale]['boughtnotify3'])
        else
            TriggerClientEvent('primeWeaponshop:notify', _source, Translation[Config.Locale]['cantcarry'])
        end

    end

    if payment == 'cash' then
        xPlayer.removeMoney(price)
    elseif payment == 'bank' then
        xPlayer.removeAccountMoney('bank', price)   
    end

end)