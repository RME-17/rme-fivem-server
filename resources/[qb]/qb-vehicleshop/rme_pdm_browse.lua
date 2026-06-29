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

-- Background music for the PDM showroom (MLO). It is a CONTINUOUS loop that is
-- NON-positional and started SILENT the moment xsound is ready, so the track
-- plays on one unbroken timeline from server load and NEVER restarts. It does
-- NOT start or restart when a player enters - we only fade its VOLUME up while a
-- player is near the PDM (so it is not heard across the whole map) and fade it
-- back to 0 when they walk away. Walking in just reveals the song already in
-- progress; it is never re-triggered by entering.
-- NOTE: URL is assembled from parts on purpose (keeps the editing pipeline from
-- mangling a contiguous URL literal). Final value resolves to the YouTube watch
-- link below, which xsound streams and loops (PlayUrl loop arg = true).
local mloMusicUrl = 'https://www.youtube.com/' .. 'watch?v=' .. 'ZzfidhdXxhI'
local mloMusicVolume = 0.2
local mloMusicCenter = vector3(-45.0, -1098.0, 26.4)
local mloMusicRadius = 23.0

-- Vanilla/DLC GTA static audio emitters that can play "stock" showroom / garage /
-- shop radio music in or around the PDM. We force these OFF while the player is
-- inside the dealership so ONLY our xsound track is heard, and restore them when
-- the player leaves. Toggling an emitter that does not exist is a harmless no-op,
-- so listing extra safe candidates just widens the net.
--
-- CONFIRMED: the PDM showroom (v_carshowroom interior) radio is the vanilla GTA
-- static emitter  collision_8onfnzt  at (-44.73, -1097.77, 27.0), which plays the
-- RADIO_15_MOTOWN station. That position is dead-center of the PDM, so this is the
-- "stock radio" that was playing on top of our track. It is listed first below and
-- is killed automatically.
local stockEmitters = {
    -- >>> CONFIRMED PDM showroom radio emitter (the one you were hearing) <<<
    'collision_8onfnzt',
    -- Standard / DLC garages and mod shops
    'SE_MP_GARAGE_L_RADIO', 'SE_MP_GARAGE_M_RADIO', 'SE_MP_GARAGE_S_RADIO',
    'DLC_IE_Office_Garage_Radio_01', 'DLC_IE_Office_Garage_Mod_Shop_Radio_01',
    'SE_DLC_GR_MOC_Radio_01', 'SE_DLC_Business_Garage_Radio_01',
    -- Arena War / tuner car meet ambience
    'SE_DLC_AW_Arena_Garage_Radio_01',
    'se_tr_tuner_car_meet_Meet_rm_Music_01', 'se_tr_tuner_car_meet_sandbox_music_01',
    'dlc_tuner_meet_building_engines',
    -- Best-effort Simeon / car-showroom / dealership candidates (safety net)
    'SE_carshowroom', 'LOS_SANTOS_CAR_SHOWROOM', 'SE_CARSHOWROOM_RADIO',
}

-- Fast lookup so /pdmemitter does not add duplicates.
local stockEmittersSet = {}
for _, em in ipairs(stockEmitters) do stockEmittersSet[em] = true end

local function setStockEmitters(enabled)
    for _, em in ipairs(stockEmitters) do
        SetStaticEmitterEnabled(em, enabled)
    end
end

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

-- ============================================================
--  Vehicle performance specs (shown on the vehicle screen)
--  GTA V does not store real horsepower/torque, so we read each
--  car's ACTUAL in-game performance data from its model (top
--  speed, acceleration, braking, traction/grip, seats) and derive
--  an ESTIMATED power/torque figure from those values so the menu
--  can show a familiar spec sheet. Results are cached per model.
-- ============================================================
local statCache = {}

-- Build a 10-segment bar for a 0-100 rating.
local function statBar(p)
    local n = math.floor((p / 10) + 0.5)
    if n < 0 then n = 0 elseif n > 10 then n = 10 end
    return string.rep('\226\150\136', n) .. string.rep('\226\150\145', 10 - n)
end

local function getVehStats(model)
    if statCache[model] then return statCache[model] end
    local hash = GetHashKey(model)
    RequestModel(hash)
    local t = GetGameTimer()
    while not HasModelLoaded(hash) and (GetGameTimer() - t) < 2000 do Wait(0) end
    local s = { ok = false }
    if HasModelLoaded(hash) then
        local sp = GetVehicleModelEstimatedMaxSpeed(hash) + 0.0 -- m/s
        local ac = GetVehicleModelAcceleration(hash) + 0.0
        local br = GetVehicleModelMaxBraking(hash) + 0.0
        local tr = GetVehicleModelMaxTraction(hash) + 0.0
        local seats = GetVehicleModelNumberOfSeats(hash)
        SetModelAsNoLongerNeeded(hash)
        local function clamp100(v)
            if v < 0 then return 0 elseif v > 100 then return 100 end
            return v
        end
        s.mph = math.floor(sp * 2.236936 + 0.5)
        s.kph = math.floor(sp * 3.6 + 0.5)
        s.accel = math.floor(clamp100(ac * 245.0) + 0.5)
        s.brake = math.floor(clamp100(br * 110.0) + 0.5)
        s.grip = math.floor(clamp100(tr * 42.0) + 0.5)
        -- Estimated engine figures derived from in-game speed + acceleration.
        s.hp = math.floor(ac * 1000.0 * (sp / 30.0) + 0.5)
        s.tq = math.floor(s.hp * 1.25 + 0.5)
        s.seats = seats
        s.ok = true
        statCache[model] = s
    end
    return s
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
    local stats = getVehStats(data.model)
    local menu = {
        {
            isMenuHeader = true,
            icon = 'fa-solid fa-circle-info',
            header = (data.brand .. ' ' .. data.name):upper() .. ' - $' .. comma_value(data.price),
        },
    }
    -- Performance spec sheet (read live from the car's in-game data).
    if stats.ok then
        menu[#menu + 1] = {
            isMenuHeader = true,
            icon = 'fa-solid fa-gauge-high',
            header = 'Top Speed',
            txt = '~' .. stats.mph .. ' mph  (' .. stats.kph .. ' km/h)',
        }
        menu[#menu + 1] = {
            isMenuHeader = true,
            icon = 'fa-solid fa-horse',
            header = 'Power ~' .. comma_value(stats.hp) .. ' hp  -  Torque ~' .. comma_value(stats.tq) .. ' lb-ft',
            txt = 'Estimated from this car\'s in-game performance data',
        }
        menu[#menu + 1] = {
            isMenuHeader = true,
            icon = 'fa-solid fa-gauge',
            header = 'Acceleration',
            txt = statBar(stats.accel) .. '  ' .. stats.accel .. '/100',
        }
        menu[#menu + 1] = {
            isMenuHeader = true,
            icon = 'fa-solid fa-car-burst',
            header = 'Braking',
            txt = statBar(stats.brake) .. '  ' .. stats.brake .. '/100',
        }
        menu[#menu + 1] = {
            isMenuHeader = true,
            icon = 'fa-solid fa-arrows-left-right-to-line',
            header = 'Grip / Handling',
            txt = statBar(stats.grip) .. '  ' .. stats.grip .. '/100',
        }
        menu[#menu + 1] = {
            isMenuHeader = true,
            icon = 'fa-solid fa-users',
            header = 'Seats',
            txt = tostring(stats.seats),
        }
    end
    menu[#menu + 1] = {
        header = 'Buy Now',
        txt = 'Pay the full price up front',
        icon = img,
        image = img,
        params = { event = 'rme_pdm:client:confirmBuy', args = data }
    }
    menu[#menu + 1] = {
        header = 'Finance',
        txt = 'Pay a deposit now, the rest in instalments',
        icon = 'fa-solid fa-coins',
        params = { event = 'rme_pdm:client:finance', args = data }
    }
    menu[#menu + 1] = {
        header = 'Back',
        icon = 'fa-solid fa-angle-left',
        params = { event = 'rme_pdm:client:openCategory', args = { category = data.category } }
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
            txt = 'Payments are auto-collected from your bank (then cash). If you cannot pay, the vehicle can be repossessed. No extra interest is charged.',
        },
        {
            header = 'Enter finance details',
            txt = 'Choose your deposit & number of payments',
            icon = 'fa-solid fa-pen-to-square',
            params = { event = 'rme_pdm:client:financeInput', args = data }
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
--  EMITTER FINDER (admin/debug)
--  Stand INSIDE the PDM while the stock music is playing, then in
--  the F8 console (or chat) run:  /pdmemitter <EMITTER_NAME>
--  If the music stops, that name is the culprit -> it is added to
--  the kill list for this session. Paste it into stockEmitters above
--  to make it permanent for everyone. Use /pdmemitteron <NAME> to
--  turn an emitter back on while testing.
-- ============================================================
RegisterCommand('pdmemitter', function(_, args)
    local name = args[1]
    if not name then
        print('^3[rme_pdm]^7 usage: /pdmemitter <EMITTER_NAME>  (disables it so you can hear if the music stops)')
        return
    end
    SetStaticEmitterEnabled(name, false)
    if not stockEmittersSet[name] then
        stockEmitters[#stockEmitters + 1] = name
        stockEmittersSet[name] = true
    end
    print(('^2[rme_pdm]^7 disabled emitter "%s" and added it to the kill list. If the music stopped, that was the one - paste it into stockEmitters to make it permanent.'):format(name))
end, false)

RegisterCommand('pdmemitteron', function(_, args)
    local name = args[1]
    if not name then
        print('^3[rme_pdm]^7 usage: /pdmemitteron <EMITTER_NAME>  (re-enables an emitter while testing)')
        return
    end
    SetStaticEmitterEnabled(name, true)
    print(('^3[rme_pdm]^7 re-enabled emitter "%s".'):format(name))
end, false)

-- ============================================================
--  PDM showroom (MLO) ambient music  -  CONTINUOUS LOOP
--  The playlist is started ONCE (silent) the moment xsound is ready
--  and plays on one unbroken, looping timeline. It is NOT positional
--  and is NOT tied to the player entering - it never starts/stops on
--  entry. We only fade its VOLUME between mloMusicVolume (near the
--  PDM) and 0 (away), so walking in just reveals the song already in
--  progress. We still force-silence the vanilla "stock" GTA showroom/
--  garage radio emitters while near the PDM (re-applied often, because
--  an interior/MLO can re-enable its own emitter when it streams in)
--  and restore them when the player leaves.
-- ============================================================
local function ensurePdmMusic()
    if GetResourceState('xsound') ~= 'started' then return end
    if exports['xsound']:soundExists('rme_pdm_music') then return end
    -- Non-positional, looping, started SILENT. Plays continuously from now on and
    -- never restarts; only the volume changes with distance (handled below).
    exports['xsound']:PlayUrl('rme_pdm_music', mloMusicUrl, 0.0, true)
end

CreateThread(function()
    local muted = false
    while true do
        local sleep = 1000

        -- Keep the continuous loop alive (covers first load + xsound restarts).
        ensurePdmMusic()

        local pos = GetEntityCoords(PlayerPedId())
        local dist = #(pos - mloMusicCenter)
        local near = dist < mloMusicRadius

        -- Volume only - never stop/replay. The loop keeps advancing regardless.
        if GetResourceState('xsound') == 'started' and exports['xsound']:soundExists('rme_pdm_music') then
            exports['xsound']:setVolume('rme_pdm_music', near and mloMusicVolume or 0.0)
        end

        -- Keep the vanilla stock showroom radio muted while near the PDM.
        if near then
            sleep = 800
            setStockEmitters(false)
            muted = true
        elseif muted then
            setStockEmitters(true)
            muted = false
        end

        Wait(sleep)
    end
end)

-- Make sure the music never lingers and the stock emitters are restored if the
-- resource stops/restarts.
AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    setStockEmitters(true)
    if GetResourceState('xsound') == 'started' and exports['xsound']:soundExists('rme_pdm_music') then
        exports['xsound']:Destroy('rme_pdm_music')
    end
end)

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
