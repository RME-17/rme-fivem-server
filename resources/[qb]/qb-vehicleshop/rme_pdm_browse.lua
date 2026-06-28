-- RME custom Premium Deluxe Motorsport browse-and-buy menu
-- A single press-E interaction point at the sales desk that opens a browsable
-- vehicle catalog (category -> vehicle -> Buy / Finance).
-- Reuses qb-vehicleshop's existing server events so money, DB inserts, plates
-- and keys all behave exactly like the stock shop.

local QBCore = exports['qb-core']:GetCoreObject()
local sharedVehicles = exports['qb-core']:GetShared('Vehicles')

local shopName = 'pdm'
local browseCoords = vector3(-57.5, -1096.76, 26.42)
local interactDistance = 3.0

print('^2[rme_pdm]^7 browse-and-buy script LOADED')

local function comma_value(amount)
    local formatted = tostring(amount)
    local k
    while true do
        formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- Vehicle preview image URL (matches the carmarket convention).
-- Stock vehicles load from docs.fivem.net; modded ones can be overridden locally.
local function vehImage(model)
    return 'https://docs.fivem.net/vehicles/' .. tostring(model):lower() .. '.webp'
end

local function isInShop(v)
    if type(v.shop) == 'table' then
        for _, s in pairs(v.shop) do
            if s == shopName then return true end
        end
        return false
    end
    return v.shop == shopName
end

local function DrawText3D(x, y, z, text)
    SetDrawOrigin(x, y, z, 0)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 100)
    ClearDrawOrigin()
end

local function openBrowse()
    local cats = {}
    for _, v in pairs(sharedVehicles) do
        if isInShop(v) then cats[v.category] = true end
    end
    local sorted = {}
    for cat in pairs(cats) do sorted[#sorted + 1] = cat end
    table.sort(sorted)
    local menu = {
        {
            isMenuHeader = true,
            icon = 'fa-solid fa-warehouse',
            header = 'PREMIUM DELUXE MOTORSPORT',
            txt = 'Browse our showroom',
        },
    }
    if #sorted == 0 then
        menu[#menu + 1] = { header = 'No vehicles assigned to this shop', icon = 'fa-solid fa-ban' }
    end
    for _, cat in ipairs(sorted) do
        menu[#menu + 1] = {
            header = (cat):gsub('^%l', string.upper),
            icon = 'fa-solid fa-tags',
            params = { event = 'rme_pdm:client:openCategory', args = { category = cat } }
        }
    end
    exports['qb-menu']:openMenu(menu)
end

RegisterNetEvent('rme_pdm:client:openBrowse', function()
    openBrowse()
end)

-- Debug/test command: opens the browse menu from anywhere
RegisterCommand('pdmtest', function()
    print('^3[rme_pdm]^7 /pdmtest used - opening browse menu')
    openBrowse()
end, false)

RegisterNetEvent('rme_pdm:client:openCategory', function(data)
    local menu = {
        {
            isMenuHeader = true,
            icon = 'fa-solid fa-tags',
            header = (data.category):upper(),
        },
        {
            header = 'Back to categories',
            icon = 'fa-solid fa-angle-left',
            params = { event = 'rme_pdm:client:openBrowse' }
        },
    }
    local list = {}
    for _, v in pairs(sharedVehicles) do
        if isInShop(v) and v.category == data.category then
            list[#list + 1] = v
        end
    end
    table.sort(list, function(a, b) return a.name < b.name end)
    for _, v in ipairs(list) do
        local img = vehImage(v.model)
        menu[#menu + 1] = {
            header = v.brand .. ' ' .. v.name,
            txt = 'Price: $' .. comma_value(v.price),
            icon = img,
            image = img,
            params = {
                event = 'rme_pdm:client:vehicleOptions',
                args = {
                    model = v.model,
                    name = v.name,
                    brand = v.brand,
                    price = v.price,
                    category = v.category
                }
            }
        }
    end
    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent('rme_pdm:client:vehicleOptions', function(data)
    local img = vehImage(data.model)
    local menu = {
        {
            isMenuHeader = true,
            icon = 'fa-solid fa-circle-info',
            header = (data.brand .. ' ' .. data.name):upper() .. ' - $' .. comma_value(data.price),
        },
        {
            header = 'Buy Now',
            txt = 'Pay the full price up front',
            icon = img,
            image = img,
            params = {
                isServer = true,
                event = 'qb-vehicleshop:server:buyShowroomVehicle',
                args = { buyVehicle = data.model }
            }
        },
        {
            header = 'Finance',
            txt = 'Min ' .. Config.MinimumDown .. '% down, up to ' .. Config.MaximumPayments .. ' payments',
            icon = 'fa-solid fa-coins',
            params = {
                event = 'rme_pdm:client:finance',
                args = data
            }
        },
        {
            header = 'Back',
            icon = 'fa-solid fa-angle-left',
            params = { event = 'rme_pdm:client:openCategory', args = { category = data.category } }
        },
    }
    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent('rme_pdm:client:finance', function(data)
    local dialog = exports['qb-input']:ShowInput({
        header = (data.brand .. ' ' .. data.name):upper() .. ' - $' .. comma_value(data.price),
        submitText = 'Finance',
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'downPayment',
                text = 'Down payment ($) - min ' .. Config.MinimumDown .. '%'
            },
            {
                type = 'number',
                isRequired = true,
                name = 'paymentAmount',
                text = 'Number of payments - max ' .. Config.MaximumPayments
            }
        }
    })
    if dialog then
        if not dialog.downPayment or not dialog.paymentAmount then return end
        TriggerServerEvent('qb-vehicleshop:server:financeVehicle', dialog.downPayment, dialog.paymentAmount, data.model)
    end
end)

-- Press-E interaction point at the sales desk (with a visible marker)
CreateThread(function()
    while true do
        local sleep = 1000
        local pos = GetEntityCoords(PlayerPedId())
        local dist = #(pos - browseCoords)
        if dist < 15.0 then
            sleep = 0
            DrawMarker(2, browseCoords.x, browseCoords.y, browseCoords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.3, 0.3, 0.3, 0, 150, 255, 200, false, true, 2, false, nil, nil, false)
            if dist < interactDistance then
                DrawText3D(browseCoords.x, browseCoords.y, browseCoords.z + 0.2, '[E] Browse Vehicles')
                if IsControlJustReleased(0, 38) then
                    openBrowse()
                end
            end
        end
        Wait(sleep)
    end
end)
