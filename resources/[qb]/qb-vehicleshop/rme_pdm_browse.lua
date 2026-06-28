-- RME custom Premium Deluxe Motorsport browse-and-buy menu
-- Press E at a sales point -> screen fades -> you are taken into a PRIVATE viewing
-- room (your own routing bucket, invisible & frozen, with a scenic camera) where
-- you browse the catalog. Closing the menu (ESC) or buying takes you back.
-- Two sales points:
--   * PDM desk  -> all ground vehicles (no aircraft)
--   * Hangar    -> aircraft only (planes + helicopters)
-- Reuses qb-vehicleshop's existing server events so money, DB inserts, plates
-- and keys all behave exactly like the stock shop.

local QBCore = exports['qb-core']:GetCoreObject()
local sharedVehicles = exports['qb-core']:GetShared('Vehicles')

local interactDistance = 3.0

-- Private viewing spot (invisible ped is parked & frozen here while browsing).
local browseSpot = vector4(-30.0, -1090.0, 1000.0, 160.0)
-- Scenic camera shown while browsing (points away from the player at the city).
-- Tweak these to aim the view anywhere you like.
local camPos = vector3(-30.0, -1090.0, 1000.0)
local camLookAt = vector3(120.0, -900.0, 200.0)

-- Sales points. block = hide these categories; only = show ONLY these categories.
local browsePoints = {
    {
        coords = vector3(-57.5, -1096.76, 26.42),
        label = 'Browse Vehicles',
        title = 'PREMIUM DELUXE MOTORSPORT',
        block = { helicopters = true, planes = true },
    },
    {
        coords = vector3(-1656.63, -3150.84, 13.99),
        label = 'Browse Aircraft',
        title = 'AIRCRAFT HANGAR',
        only = { helicopters = true, planes = true },
    },
}

local browseActive = false
local activePoint = nil
local returnCoords = nil
local browseCam = nil

print('^2[rme_pdm]^7 browse-and-buy script LOADED')

-- Weaponized / armored vehicles that should NOT be sellable. Models not present
-- on the server are simply ignored.
local blockedModels = {
    ['ruiner2'] = true, ['deluxo'] = true, ['stromberg'] = true, ['toreador'] = true,
    ['oppressor'] = true, ['oppressor2'] = true, ['jb700'] = true, ['vigilante'] = true,
    ['scramjet'] = true, ['rcbandito'] = true, ['tampa3'] = true, ['menacer'] = true,
    ['voltic2'] = true,
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
    ['insurgent'] = true, ['insurgent2'] = true, ['insurgent3'] = true,
    ['technical'] = true, ['technical2'] = true, ['technical3'] = true,
    ['nightshark'] = true, ['halftrack'] = true, ['apc'] = true, ['barrage'] = true,
    ['chernobog'] = true, ['khanjali'] = true, ['rhino'] = true, ['trailersmall2'] = true,
    ['vetir'] = true,
    ['kuruma2'] = true, ['baller5'] = true, ['baller6'] = true,
    ['boxville5'] = true, ['dukes2'] = true, ['schafter5'] = true, ['schafter6'] = true,
    -- Weaponized aircraft (never sellable, even at the hangar)
    ['hydra'] = true, ['lazer'] = true, ['besra'] = true, ['savage'] = true,
    ['hunter'] = true, ['akula'] = true, ['annihilator'] = true, ['annihilator2'] = true,
    ['valkyrie'] = true, ['valkyrie2'] = true, ['buzzard'] = true, ['bombushka'] = true,
    ['volatol'] = true, ['molotok'] = true, ['rogue'] = true, ['nokota'] = true,
    ['pyro'] = true, ['starling'] = true, ['seabreeze'] = true, ['strikeforce'] = true,
    ['avenger'] = true, ['avenger2'] = true, ['tula'] = true, ['alkonost'] = true,
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

local function vehImage(model)
    return 'https://docs.fivem.net/vehicles/' .. tostring(model):lower() .. '.webp'
end

local function isSellable(model, v)
    if blockedModels[model] then return false end
    if v and v.shop == 'none' then return false end
    return true
end

-- Category filter based on which sales point we entered from.
local function categoryAllowed(cat)
    local p = activePoint
    if not p then return true end
    if p.only then return p.only[cat] == true end
    if p.block then return not p.block[cat] end
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
        if isSellable(model, v) and v.category and categoryAllowed(v.category) then
            cats[v.category] = true
        end
    end
    local sorted = {}
    for cat in pairs(cats) do sorted[#sorted + 1] = cat end
    table.sort(sorted)
    local menu = {
        {
            isMenuHeader = true,
            icon = 'fa-solid fa-warehouse',
            header = (activePoint and activePoint.title) or 'PREMIUM DELUXE MOTORSPORT',
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
        header = 'Leave',
        txt = 'Return outside',
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
        if isSellable(model, v) and v.category == data.category and categoryAllowed(v.category) then
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
            txt = 'Pay a deposit now, the rest in instalments',
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
--  Private viewing room: enter / exit (all client-side)
-- ============================================================

local function enterBrowse(point)
    if browseActive then return end
    browseActive = true
    activePoint = point
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    returnCoords = vector4(pos.x, pos.y, pos.z, GetEntityHeading(ped))

    DoScreenFadeOut(500)
    local timeout = 0
    while not IsScreenFadedOut() and timeout < 1500 do Wait(10); timeout = timeout + 10 end

    SetEntityCoords(ped, browseSpot.x, browseSpot.y, browseSpot.z, false, false, false, false)
    SetEntityHeading(ped, browseSpot.w)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetEntityVisible(ped, false, false) -- hide the player in this view

    -- Scenic camera pointing away from the player.
    browseCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', camPos.x, camPos.y, camPos.z, 0.0, 0.0, 0.0, 50.0, false, 0)
    PointCamAtCoord(browseCam, camLookAt.x, camLookAt.y, camLookAt.z)
    SetCamActive(browseCam, true)
    RenderScriptCams(true, false, 0, true, true)

    -- Privacy extra (non-blocking): own routing bucket.
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
    while not IsScreenFadedOut() and timeout < 1500 do Wait(10); timeout = timeout + 10 end

    RenderScriptCams(false, false, 0, true, true)
    if browseCam then DestroyCam(browseCam, false); browseCam = nil end

    TriggerServerEvent('rme_pdm:server:exitBrowse')

    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
    SetEntityVisible(ped, true, false)
    if returnCoords then
        SetEntityCoords(ped, returnCoords.x, returnCoords.y, returnCoords.z, false, false, false, false)
        SetEntityHeading(ped, returnCoords.w)
    end
    activePoint = nil

    Wait(400)
    DoScreenFadeIn(500)
end

RegisterNetEvent('rme_pdm:client:exit', function()
    exitBrowse()
end)

RegisterNetEvent('qb-menu:client:menuClosed', function()
    if browseActive then exitBrowse() end
end)

RegisterNetEvent('rme_pdm:client:confirmBuy', function(data)
    exitBrowse()
    Wait(250)
    TriggerServerEvent('qb-vehicleshop:server:buyShowroomVehicle', { buyVehicle = data.model })
end)

-- ============================================================
--  Finance: a clear breakdown screen, then the input form.
--  IMPORTANT: this whole flow stays INSIDE the private viewing
--  room. We only leave the room once a finance deal is actually
--  confirmed (so the financed car can spawn outside to collect).
--  Cancelling / going Back keeps you in the room.
-- ============================================================

-- Step 1: explain the deal with real numbers for THIS vehicle.
RegisterNetEvent('rme_pdm:client:finance', function(data)
    local price = data.price or 0
    local minDownPct = Config.MinimumDown
    local maxPayments = Config.MaximumPayments
    local interval = Config.PaymentInterval
    local minDown = math.floor(price * minDownPct / 100)
    local balanceMin = price - minDown
    local perPaymentMin = math.floor((balanceMin / maxPayments) + 0.5)
    local img = vehImage(data.model)

    local menu = {
        {
            isMenuHeader = true,
            icon = 'fa-solid fa-file-invoice-dollar',
            header = (data.brand .. ' ' .. data.name):upper() .. ' - FINANCE',
            txt = 'Drive now, pay it off over time',
        },
        {
            isMenuHeader = true,
            icon = img,
            image = img,
            header = 'Vehicle price: $' .. comma_value(price),
        },
        {
            isMenuHeader = true,
            icon = 'fa-solid fa-hand-holding-dollar',
            header = 'Minimum deposit: $' .. comma_value(minDown),
            txt = minDownPct .. '% of the price, paid now up front. Pay more to shrink your instalments.',
        },
        {
            isMenuHeader = true,
            icon = 'fa-solid fa-calendar-days',
            header = 'Up to ' .. maxPayments .. ' payments',
            txt = 'One instalment due every ' .. interval .. ' hours until it is paid off.',
        },
        {
            isMenuHeader = true,
            icon = 'fa-solid fa-calculator',
            header = 'Example: $' .. comma_value(perPaymentMin) .. ' per payment',
            txt = 'Deposit $' .. comma_value(minDown) .. ' now, then about $' .. comma_value(perPaymentMin) .. ' x ' .. maxPayments .. ' instalments.',
        },
        {
            isMenuHeader = true,
            icon = 'fa-solid fa-triangle-exclamation',
            header = 'Keep up with payments',
            txt = 'Miss an instalment and the vehicle can be repossessed. No extra interest is charged.',
        },
        {
            header = 'Enter finance details',
            txt = 'Choose your deposit & number of payments',
            icon = 'fa-solid fa-pen-to-square',
            params = { event = 'rme_pdm:client:financeInput', args = data, isAction = true }
        },
        {
            header = 'Back',
            icon = 'fa-solid fa-angle-left',
            params = { event = 'rme_pdm:client:vehicleOptions', args = data }
        },
    }
    exports['qb-menu']:openMenu(menu)
end)

-- Step 2: the actual input form (stays in the room).
RegisterNetEvent('rme_pdm:client:financeInput', function(data)
    local price = data.price or 0
    local minDown = math.floor(price * Config.MinimumDown / 100)
    local dialog = exports['qb-input']:ShowInput({
        header = (data.brand .. ' ' .. data.name):upper() .. ' - $' .. comma_value(price),
        submitText = 'Confirm finance',
        inputs = {
            { type = 'number', isRequired = true, name = 'downPayment', text = 'Deposit ($) - minimum $' .. minDown .. ' (' .. Config.MinimumDown .. '%)' },
            { type = 'number', isRequired = true, name = 'paymentAmount', text = 'Number of payments (max ' .. Config.MaximumPayments .. ')' }
        }
    })
    -- Cancelled or incomplete -> go back to the finance breakdown, stay in room.
    if not dialog or not dialog.downPayment or not dialog.paymentAmount then
        TriggerEvent('rme_pdm:client:finance', data)
        return
    end
    -- Confirmed: now leave the room so the financed car spawns outside to collect.
    local model = data.model
    local down = dialog.downPayment
    local pays = dialog.paymentAmount
    exitBrowse()
    Wait(250)
    TriggerServerEvent('qb-vehicleshop:server:financeVehicle', down, pays, model)
end)

RegisterCommand('pdmtest', function()
    print('^3[rme_pdm]^7 /pdmtest used - entering private browse room')
    enterBrowse(browsePoints[1])
end, false)

-- Safety command if a player ever gets stuck in the viewing room
RegisterCommand('pdmunstuck', function()
    if browseActive then
        exitBrowse()
    else
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, false)
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true, false)
        RenderScriptCams(false, false, 0, true, true)
        if browseCam then DestroyCam(browseCam, false); browseCam = nil end
    end
end, false)

-- ============================================================
--  Press-E interaction points (with markers)
-- ============================================================
CreateThread(function()
    while true do
        local sleep = 1000
        if not browseActive then
            local pos = GetEntityCoords(PlayerPedId())
            for _, point in ipairs(browsePoints) do
                local dist = #(pos - point.coords)
                if dist < 15.0 then
                    sleep = 0
                    DrawMarker(2, point.coords.x, point.coords.y, point.coords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.3, 0.3, 0.3, 0, 150, 255, 200, false, true, 2, false, nil, nil, false)
                    if dist < interactDistance then
                        DrawText3D(point.coords.x, point.coords.y, point.coords.z + 0.2, '[E] ' .. point.label)
                        if IsControlJustReleased(0, 38) then
                            enterBrowse(point)
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)
