local QBCore = exports['qb-core']:GetCoreObject()

local function reformatInt(i)
    return tostring(i):reverse():gsub('%d%d%d', '%1,'):reverse():gsub('^,', '')
end

local function ShowNotification(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, true)
end

local function ShowInfobar(msg)
    SetTextComponentFormat('STRING')
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local function attemptPurchase(v, payment, amount)
    local price = v.price * amount
    QBCore.Functions.TriggerCallback('primeWeaponshop:getMoney', function(cash, bank)
        local funds = (payment == 'cash') and cash or bank
        if funds >= price then
            TriggerServerEvent('primeWeaponshop:buy', v.name, v.type, payment, price, v.label, amount)
        else
            ShowNotification(Translation[Config.Locale]['notenough_money'])
        end
    end)
end

local function openBuyMenu(v)
    local amount = 1
    if v.type == 'item' then
        local input = lib.inputDialog(v.label, {
            { type = 'number', label = Translation[Config.Locale]['amount'], default = 1, min = 1, max = 50, required = true }
        })
        if not input then return end
        amount = math.floor(tonumber(input[1]) or 1)
        if amount < 1 then amount = 1 end
        if amount > 50 then amount = 50 end
    end
    local price = v.price * amount
    local options = {}
    if Config.Payments.cash then
        options[#options + 1] = {
            title = Translation[Config.Locale]['cash'],
            description = reformatInt(price) .. ' ' .. Config.Currency,
            icon = 'money-bill',
            onSelect = function() attemptPurchase(v, 'cash', amount) end
        }
    end
    if Config.Payments.bank then
        options[#options + 1] = {
            title = Translation[Config.Locale]['bank'],
            description = reformatInt(price) .. ' ' .. Config.Currency,
            icon = 'building-columns',
            onSelect = function() attemptPurchase(v, 'bank', amount) end
        }
    end
    lib.registerContext({
        id = 'primeWeaponshop_buy',
        title = v.label,
        menu = 'primeWeaponshop_main',
        options = options
    })
    lib.showContext('primeWeaponshop_buy')
end

local function openShopMenu()
    local options = {}
    for _, v in pairs(Config.Weapons) do
        options[#options + 1] = {
            title = v.label,
            description = reformatInt(v.price) .. ' ' .. Config.Currency,
            icon = (v.type == 'weapon') and 'gun' or 'box',
            onSelect = function() openBuyMenu(v) end
        }
    end
    lib.registerContext({
        id = 'primeWeaponshop_main',
        title = Translation[Config.Locale]['menu_title'],
        options = options
    })
    lib.showContext('primeWeaponshop_main')
end

RegisterNetEvent('primeWeaponshop:openMenu', openShopMenu)

RegisterNetEvent('primeWeaponshop:notify', function(message)
    ShowNotification(message)
end)

-- Blips
CreateThread(function()
    if not Config.Blip.enable then return end
    for _, v in pairs(Config.Weaponshops) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, Config.Blip.id)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Blip.size)
        SetBlipColour(blip, Config.Blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Translation[Config.Locale]['blip'])
        EndTextCommandSetBlipName(blip)
    end
end)

-- Shop peds (one per shop, spawned when nearby)
local peds = {}

CreateThread(function()
    local pedModel = joaat(Config.PedModels[math.random(1, #Config.PedModels)])
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        for k, v in pairs(Config.Weaponshops) do
            local distance = #(playerCoords - vector3(v.x, v.y, v.z))
            if distance < 50.0 then
                if not peds[k] then
                    RequestModel(pedModel)
                    while not HasModelLoaded(pedModel) do Wait(10) end
                    local npc = CreatePed(4, pedModel, v.x, v.y, v.z - 1.0, v.rot, false, false)
                    FreezeEntityPosition(npc, true)
                    SetEntityInvincible(npc, true)
                    SetBlockingOfNonTemporaryEvents(npc, true)
                    SetModelAsNoLongerNeeded(pedModel)
                    peds[k] = npc
                end
            elseif peds[k] then
                DeleteEntity(peds[k])
                peds[k] = nil
            end
        end
        Wait(1000)
    end
end)

-- Interaction (press E near a shop)
CreateThread(function()
    while true do
        local sleep = 1000
        local playerCoords = GetEntityCoords(PlayerPedId())
        for _, v in pairs(Config.Weaponshops) do
            local distance = #(playerCoords - vector3(v.x, v.y, v.z))
            if distance <= 3.0 then
                sleep = 0
                ShowInfobar(Translation[Config.Locale]['infobar'])
                if IsControlJustReleased(0, 38) then
                    openShopMenu()
                end
            end
        end
        Wait(sleep)
    end
end)
