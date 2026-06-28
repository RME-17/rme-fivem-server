-- RME custom Premium Deluxe Motorsport browse-and-buy menu
-- Press E at the sales desk -> screen fades -> you are teleported into a PRIVATE
-- viewing room (your own routing bucket, frozen in place) where you browse the
-- catalog. Closing the menu (ESC) or buying teleports you back to the showroom.
-- Multiple players can browse at the same time without seeing each other.
-- Reuses qb-vehicleshop's existing server events so money, DB inserts, plates
-- and keys all behave exactly like the stock shop.

local QBCore = exports['qb-core']:GetCoreObject()
local sharedVehicles = exports['qb-core']:GetShared('Vehicles')

local browseCoords = vector3(-57.5, -1096.76, 26.42)
local interactDistance = 3.0

-- Private viewing spot the player is frozen at while browsing. They are alone in
-- their own routing bucket, so this just needs to be somewhere out of the way.
-- Change these coords to any location you like (e.g. a showroom MLO).
local browseSpot = vector4(-30.0, -1090.0, 1000.0, 160.0)

local browseActive = false
local returnCoords = nil

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

-- ============================================================
--  Menus
-- ============================================================

function openBrowse()
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
            txt = 'Private viewing room',
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
    menu[#menu + 1] = {
        header = 'Leave Showroom',
        txt = 'Return to Premium Deluxe Motorsport',
        icon = 'fa-solid fa-door-open',
        params = { event = 'rme_pdm:client:exit' }
    }
    exports['qb-menu']:openMenu(menu)
end

RegisterNetEvent('rme_pdm:client:openBrowse', function()
    openBrowse()
end)

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
            params = { event = 'rme_pdm:client:confirmBuy', args = data }
        },
        {
            header = 'Finance',
            txt = 'Min ' .. Config.MinimumDown .. '% down, up to ' .. Config.MaximumPayments .. ' payments',
            icon = 'fa-solid fa-coins',
            params = { event = 'rme_pdm:client:finance', args = data }
        },
        {
            header = 'Back',
            icon = 'fa-solid fa-angle-left',
            params = { event = 'rme_pdm:client:openCategory', args = { category = data.category } }
        },
    }
    exports['qb-menu']:openMenu(menu)
end)

-- ============================================================
--  Private viewing room: enter / exit
-- ============================================================

-- Everything that makes the experience work is done CLIENT-SIDE here so it can
-- never get stuck waiting on the server. The routing-bucket request is sent as a
-- non-blocking extra purely for privacy; if it is delayed or unavailable the
-- player still gets teleported and the menu still opens.
local function enterBrowse()
    if browseActive then return end
    browseActive = true
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    returnCoords = vector4(pos.x, pos.y, pos.z, GetEntityHeading(ped))

    DoScreenFadeOut(500)
    local timeout = 0
    while not IsScreenFadedOut() and timeout < 1500 do
        Wait(10)
        timeout = timeout + 10
    end

    SetEntityCoords(ped, browseSpot.x, browseSpot.y, browseSpot.z, false, false, false, false)
    SetEntityHeading(ped, browseSpot.w)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)

    -- Privacy extra (non-blocking): drop us into our own routing bucket.
    TriggerServerEvent('rme_pdm:server:enterBrowse')

    Wait(400)
    DoScreenFadeIn(500)
    openBrowse()
end

local function exitBrowse()
    if not browseActive then return end
    browseActive = false
    exports['qb-menu']:closeMenu()
    local ped = PlayerPedId()
    DoScreenFadeOut(500)
    local timeout = 0
    while not IsScreenFadedOut() and timeout < 1500 do
        Wait(10)
        timeout = timeout + 10
    end

    -- Restore our normal instance BEFORE teleporting back so the world is there.
    TriggerServerEvent('rme_pdm:server:exitBrowse')

    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
    if returnCoords then
        SetEntityCoords(ped, returnCoords.x, returnCoords.y, returnCoords.z, false, false, false, false)
        SetEntityHeading(ped, returnCoords.w)
    end

    Wait(400)
    DoScreenFadeIn(500)
end

-- Explicit "Leave Showroom" button
RegisterNetEvent('rme_pdm:client:exit', function()
    exitBrowse()
end)

-- Player pressed ESC / Backspace to close the menu -> treat as leaving
RegisterNetEvent('qb-menu:client:menuClosed', function()
    if browseActive then
        exitBrowse()
    end
end)

-- Buying: leave the private room FIRST so the car spawns normally in the world,
-- then fire the stock purchase event.
RegisterNetEvent('rme_pdm:client:confirmBuy', function(data)
    exitBrowse()
    Wait(250)
    TriggerServerEvent('qb-vehicleshop:server:buyShowroomVehicle', { buyVehicle = data.model })
end)

-- Financing: leave first, then show the finance dialog back at the showroom.
RegisterNetEvent('rme_pdm:client:finance', function(data)
    exitBrowse()
    Wait(250)
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

-- Debug/test command: enters the private browse room from anywhere
RegisterCommand('pdmtest', function()
    print('^3[rme_pdm]^7 /pdmtest used - entering private browse room')
    enterBrowse()
end, false)

-- Safety command in case a player ever gets stuck (frozen) in the viewing room
RegisterCommand('pdmunstuck', function()
    if browseActive then
        exitBrowse()
    else
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, false)
        SetEntityInvincible(ped, false)
    end
end, false)

-- ============================================================
--  Press-E interaction point at the sales desk (with a marker)
-- ============================================================
CreateThread(function()
    while true do
        local sleep = 1000
        local pos = GetEntityCoords(PlayerPedId())
        local dist = #(pos - browseCoords)
        if dist < 15.0 and not browseActive then
            sleep = 0
            DrawMarker(2, browseCoords.x, browseCoords.y, browseCoords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.3, 0.3, 0.3, 0, 150, 255, 200, false, true, 2, false, nil, nil, false)
            if dist < interactDistance then
                DrawText3D(browseCoords.x, browseCoords.y, browseCoords.z + 0.2, '[E] Browse Vehicles')
                if IsControlJustReleased(0, 38) then
                    enterBrowse()
                end
            end
        end
        Wait(sleep)
    end
end)
