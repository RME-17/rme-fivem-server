-- RME custom Premium Deluxe Motorsport browse-and-buy menu
-- A single press-E interaction point at the sales desk that opens a browsable
-- vehicle catalog (category -> vehicle -> Buy / Finance).
-- Reuses qb-vehicleshop's existing server events so money, DB inserts, plates
-- and keys all behave exactly like the stock shop.

local QBCore = exports['qb-core']:GetCoreObject()
local sharedVehicles = exports['qb-core']:GetShared('Vehicles')

local browseCoords = vector3(-57.5, -1096.76, 26.42)
local interactDistance = 3.0

print('^2[rme_pdm]^7 browse-and-buy script LOADED')

-- Weaponized / armored vehicles that should NOT be sellable at PDM.
-- (Models not present on the server are simply ignored - harmless.)
local blockedModels = {
    -- Weaponized (machine guns / rockets)
    ['ruiner2'] = true, ['deluxo'] = true, ['stromberg'] = true, ['toreador'] = true,
    ['oppressor'] = true, ['oppressor2'] = true, ['jb700'] = true, ['vigilante'] = true,
    ['scramjet'] = true, ['rcbandito'] = true, ['tampa3'] = true, ['menacer'] = true,
    ['voltic2'] = true,
    -- Arena War weaponized
    ['issi4'] = true, ['issi5'] = true, ['issi6'] = true,
    ['dominator4'] = true, ['dominator5'] = true, ['dominator6'] = true,
    ['impaler2'] = true, ['impaler3'] = true, ['impaler4'] = true,
    ['imperator'] = true, ['imperator2'] = true, ['imperator3'] = true,
    ['deathbike'] = true, ['deathbike2'] = true, ['deathbike3'] = true,
    ['scarab'] = true, ['scarab2'] = true, ['scarab3'] = true,
    ['zr380'] = true, ['zr3802'] = true, ['zr3803'] = true,
    ['brutus'] = true, ['brutus2'] = true, ['brutus3'] = true,
    ['cerberus'] = true, ['cerberus2'] = true, ['cerberus3'] = true,
    ['bruiser'] = true, ['bruiser2'] = true, ['bruiser3'] = true,
    ['monster3'] = true, ['monster4'] = true, ['monster5'] = true,
    ['slamvan4'] = true, ['slamvan5'] = true, ['slamvan6'] = true,
    ['dune3'] = true, ['dune4'] = true, ['dune5'] = true,
    -- Military / armored troop carriers and tanks
    ['insurgent'] = true, ['insurgent2'] = true, ['insurgent3'] = true,
    ['technical'] = true, ['technical2'] = true, ['technical3'] = true,
    ['nightshark'] = true, ['halftrack'] = true, ['apc'] = true, ['barrage'] = true,
    ['chernobog'] = true, ['khanjali'] = true, ['rhino'] = true, ['trailersmall2'] = true,
    ['vetir'] = true,
    -- Armored civilian (bullet resistant)
    ['kuruma2'] = true, ['baller5'] = true, ['baller6'] = true,
    ['boxville5'] = true, ['dukes2'] = true, ['schafter5'] = true, ['schafter6'] = true,
}

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

-- A vehicle is sellable at PDM if it is NOT on the weaponized/armored blocklist.
-- We intentionally ignore the per-vehicle 'shop' field so the whole catalog is
-- available here.
local function isSellable(model, v)
    if blockedModels[model] then return false end
    if v and v.shop == 'none' then return false end
    return true
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
    for model, v in pairs(sharedVehicles) do
        if isSellable(model, v) and v.category then cats[v.category] = true end
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
        menu[#menu + 1] = { header = 'No vehicles available', icon = 'fa-solid fa-ban' }
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
    for model, v in pairs(sharedVehicles) do
        if isSellable(model, v) and v.category == data.category then
            v._model = model
            list[#list + 1] = v
        end
    end
    table.sort(list, function(a, b) return (a.name or '') < (b.name or '') end)
    for _, v in ipairs(list) do
        local model = v._model
        local img = vehImage(model)
        menu[#menu + 1] = {
            header = (v.brand or '') .. ' ' .. (v.name or model),
            txt = 'Price: $' .. comma_value(v.price or 0),
            icon = img,
            image = img,
            params = {
                event = 'rme_pdm:client:vehicleOptions',
                args = {
                    model = model,
                    name = v.name or model,
                    brand = v.brand or '',
                    price = v.price or 0,
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
