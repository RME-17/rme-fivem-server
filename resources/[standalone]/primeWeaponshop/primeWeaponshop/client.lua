ESX = exports['es_extended']:getSharedObject()

_menuPool = NativeUI.CreatePool()
local mainMenu
local background = Sprite.New(Config.UI.dictName, Config.UI.txtName, 0, 0, 256, 64)
local nearMenu = false

Citizen.CreateThread(function()
    while true do

        if _menuPool:IsAnyMenuOpen() then
            _menuPool:ProcessMenus()

            if not nearMenu then
                _menuPool:CloseAllMenus()
            end

        end

        Wait(1)
    end
end)

Citizen.CreateThread(function()
    if Config.Blip.enable then
        loadBlips()
    end
    while true do

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        nearMenu = false

        for k, v in pairs(Config.Weaponshops) do

            local distance = GetDistanceBetweenCoords(v.x, v.y, v.z, playerCoords)
            if distance <= 3.0 then
                nearMenu = true
                showInfobar(Translation[Config.Locale]['infobar'])
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('primeWeaponshop:openMenu')
                end
            end

        end

        Wait(1)
    end
end)

local isNearPed = false
local isAtPed = false
local isPedLoaded = false

local pedModel = GetHashKey(Config.PedModels[1])
local npc

Citizen.CreateThread(function()
    local randomIndex = math.random(1, #Config.PedModels)
    pedModel = GetHashKey(Config.PedModels[randomIndex])
end)

Citizen.CreateThread(function()
    
    while true do

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        isNearPed = false
        isAtPed = false

        for k, v in pairs(Config.Weaponshops) do
            local distance = GetDistanceBetweenCoords(v.x, v.y, v.z, playerCoords)

            if distance < 20.0 then
                isNearPed = true
                if not isPedLoaded then
                    RequestModel(pedModel)
                    while not HasModelLoaded(pedModel) do
                        Wait(10)
                    end

                    npc = CreatePed(4, pedModel, v.x, v.y, v.z - 1.0, v.rot, false, false)
                    FreezeEntityPosition(npc, true)
                    SetEntityHeading(npc, v.rot)
                    SetEntityInvincible(npc, true)
                    SetBlockingOfNonTemporaryEvents(npc, true)
                    
                    isPedLoaded = true
                end
            end

            if isPedLoaded and not isNearPed then
                DeleteEntity(npc)
                SetModelAsNoLongerNeeded(pedModel)
                isPedLoaded = false
            end

            if distance < 2.0 then
                isAtPed = true
            end

        end


        Wait(500)
    end

end)

function loadBlips()

    for k, v in pairs(Config.Weaponshops) do
        v.blip = AddBlipForCoord(v.x, v.y)
        SetBlipSprite(v.blip, Config.Blip.id)
        SetBlipDisplay(v.blip, 4)
        SetBlipScale  (v.blip, Config.Blip.size)
        SetBlipColour (v.blip, Config.Blip.color)
        SetBlipAsShortRange(v.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Translation[Config.Locale]['blip'])
        EndTextCommandSetBlipName(v.blip)
    end

end

RegisterNetEvent('primeWeaponshop:openMenu', function()

    _menuPool:CloseAllMenus()
    collectgarbage()

    _menuPool:Remove()
    _menuPool = NativeUI.CreatePool()

    mainMenu = NativeUI.CreateMenu(nil, Translation[Config.Locale]['menu_title'])
    mainMenu:SetMenuWidthOffset(-50)
    mainMenu:SetBannerSprite(background, true)
    _menuPool:Add(mainMenu)

    mainMenu.OnMenuClosed = function(menu)
        if menu == mainMenu then
            _menuPool:Remove()
        end
    end

    for k, v in pairs(Config.Weapons) do
        local buyCash
        local buyBank
        local selectItemAmount = 1

        local price = v.price
        local weapon_item = _menuPool:AddSubMenu(mainMenu, v.label, '')
        weapon_item.SubMenu:SetMenuWidthOffset(-50)
        weapon_item.SubMenu:SetBannerSprite(background, true)
        weapon_item.Item:RightLabel('~g~' .. reformatInt(price) .. ' ' .. Config.Currency)

        if v.type == 'item' then

            local selectItemAmountList = {}
            for i = 1, 50 do
                table.insert(selectItemAmountList, i)
            end

            local selectAmount = NativeUI.CreateListItem(Translation[Config.Locale]['amount'], selectItemAmountList, 1)
            weapon_item.SubMenu:AddItem(selectAmount)

    
            selectAmount.OnListChanged = function(sender, item, index)
                selectItemAmount = index
                price = v.price * selectItemAmount
                buyCash:RightLabel('~g~' .. reformatInt(price) .. ' ' .. Config.Currency)                
                buyBank:RightLabel('~g~' .. reformatInt(price) .. ' ' .. Config.Currency)  
            end

        end

        if Config.Payments.cash then

            buyCash = NativeUI.CreateItem(Translation[Config.Locale]['cash'], '')
            buyCash:RightLabel('~g~' .. reformatInt(price) .. ' ' .. Config.Currency)
            weapon_item.SubMenu:AddItem(buyCash)

            buyCash.Activated = function()

                ESX.TriggerServerCallback('primeWeaponshop:getMoney', function(cash)
                    if cash >= price then
                        TriggerServerEvent('primeWeaponshop:buy', v.name, v.type, 'cash', price, v.label, selectItemAmount)
                    else
                        ShowNotification(Translation[Config.Locale]['notenough_money'])
                    end
                
                end)

            end

        end

        if Config.Payments.bank then

            buyBank = NativeUI.CreateItem(Translation[Config.Locale]['bank'], '')
            buyBank:RightLabel('~g~' .. reformatInt(price) .. ' ' .. Config.Currency)
            weapon_item.SubMenu:AddItem(buyBank)

            buyBank.Activated = function()

                ESX.TriggerServerCallback('primeWeaponshop:getMoney', function(cash, bank)
                    if bank >= price then
                        TriggerServerEvent('primeWeaponshop:buy', v.name, v.type, 'bank', price, v.label, selectItemAmount)
                    else
                        ShowNotification(Translation[Config.Locale]['notenough_money'])
                    end
                
                end)

            end

        end

    end


    _menuPool:RefreshIndex()
    mainMenu:Visible(true)
    _menuPool:MouseControlsEnabled(false)
    _menuPool:MouseEdgeEnabled(false)
    _menuPool:ControlDisablingEnabled(false)

end)

function showInfobar(msg)
	CurrentActionMsg  = msg
	SetTextComponentFormat('STRING')
	AddTextComponentString(CurrentActionMsg)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function reformatInt(i)
	return tostring(i):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

function ShowNotification(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, true)
end

RegisterNetEvent('primeWeaponshop:notify')
AddEventHandler('primeWeaponshop:notify', function(message)
    ShowNotification(message)
end)