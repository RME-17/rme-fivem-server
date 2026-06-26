Config = {}

-- 'auto' uses each player's GTA/FiveM language. Use a locale code to force one language.
Config.Locale = 'auto' -- auto, en, fr, es, de, it, pt
Config.FallbackLocale = 'en'

-- auto detects QBCore first, then ESX. Use 'standalone' if you do not want framework payments.
Config.Framework = 'auto' -- auto, qb, esx, standalone
Config.MoneyAccount = 'cash' -- QBCore: cash/bank, ESX: money/bank/black_money

Config.UI = {
    useOxLib = true,
    fallbackStartsSolo = true
}

Config.Notifications = {
    system = 'auto', -- auto, ox_lib, okokNotify, brutal_notify, wasabi_notify, mythic_notify, qb, esx, gta, custom
    duration = 5000,
    titleKey = 'blip.company',
    playSound = true,

    -- Auto uses the first started resource in this list, then falls back to the GTA feed.
    autoPriority = {
        'okokNotify',
        'brutal_notify',
        'wasabi_notify',
        'mythic_notify',
        'ox_lib',
        'qb',
        'esx'
    },

    -- Used only when system = 'custom', or when 'custom' is added to autoPriority.
    -- Return false to let the script use its normal fallback notification.
    custom = function(message, notifyType, duration, title)
        -- Example:
        -- exports['your_notify']:Notify(title, message, duration, notifyType)
        return false
    end
}

Config.Target = {
    enabled = true,
    system = 'auto', -- auto, ox_target, qb-target, none
    distance = 2.3,
    fallbackPressE = false,
    startIcon = 'fas fa-truck-moving',
    finishIcon = 'fas fa-dollar-sign',
    cancelIcon = 'fas fa-ban'
}

Config.Crew = {
    enabled = true,
    maxMembers = 4,
    codeLength = 4,
    inviteRadius = 10.0,
    inviteExpireMs = 60000,
    splitPayout = true
}

Config.Security = {
    bossInteractRadius = 3.0,
    depotInteractRadius = 3.5,
    vehicleInteractRadius = 7.5,
    deliveryInteractRadius = 4.0,
    finishInteractRadius = 4.0,
    eventCooldownMs = 900,
    invalidEventWarnings = true
}

Config.Progress = {
    enabled = true,
    position = 'bottom',
    pickupMs = 1600,
    placeTruckMs = 1750,
    takeTruckMs = 1500,
    placeCustomerMs = 1700
}

Config.Animations = {
    pickup = {
        dict = 'pickup_object',
        clip = 'pickup_low',
        flag = 0
    }
}

Config.Sound = {
    enabled = true,
    load = { name = 'PICK_UP', set = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    unload = { name = 'CHECKPOINT_PERFECT', set = 'HUD_MINI_GAME_SOUNDSET' },
    complete = { name = 'BASE_JUMP_PASSED', set = 'HUD_AWARDS' }
}

Config.Integrations = {
    vehicleKeys = 'auto', -- auto, qb, qs, none
    fuel = 'auto', -- auto, lc_fuel, Renewed-Fuel, LegacyFuel, ps-fuel, lj-fuel, cdn-fuel, x-fuel, ox_fuel, native, custom, none
    startFuel = 100.0,

    -- Optional LC Fuel type: electric, regular, midgrade, premium, or diesel.
    -- Leave nil to keep the type selected by LC Fuel for the vehicle model.
    fuelType = nil,

    fuelAutoPriority = {
        'lc_fuel',
        'Renewed-Fuel',
        'LegacyFuel',
        'ps-fuel',
        'lj-fuel',
        'cdn-fuel',
        'x-fuel',
        'ox_fuel'
    },

    -- Used only when fuel = 'custom', or when 'custom' is added to fuelAutoPriority.
    -- Return false to keep only the native GTA fuel level fallback.
    customFuel = function(vehicle, amount, fuelType)
        -- Example:
        -- exports['your_fuel']:SetFuel(vehicle, amount)
        return false
    end
}

-- The high-visibility vest is a matched arms/undershirt/top combination.
-- Component IDs: 3 arms, 4 pants, 6 shoes, 8 undershirt, 9 armor, 11 top.
-- Prop IDs: 0 hat, 1 glasses, 2 ears. Set a prop drawable to -1 to remove it.
Config.Outfit = {
    enabled = true,
    restoreAfterJob = true,
    male = {
        components = {
            [3] = { drawable = 41, texture = 0 },
            [4] = { drawable = 36, texture = 0 },
            [6] = { drawable = 12, texture = 0 },
            [8] = { drawable = 59, texture = 1 },
            [9] = { drawable = 0, texture = 0 },
            [11] = { drawable = 56, texture = 0 }
        },
        props = {
            [0] = { drawable = -1, texture = 0 }
        }
    },
    female = {
        components = {
            [3] = { drawable = 44, texture = 0 },
            [4] = { drawable = 35, texture = 0 },
            [6] = { drawable = 27, texture = 0 },
            [8] = { drawable = 36, texture = 1 },
            [9] = { drawable = 0, texture = 0 },
            [11] = { drawable = 48, texture = 0 }
        },
        props = {
            [0] = { drawable = -1, texture = 0 }
        }
    }
}

Config.Keys = {
    Interact = 38 -- E
}

Config.JobPed = {
    model = 's_m_m_dockwork_01',
    coords = vector4(1010.16, -2528.88, 28.30, 88.00),
    scenario = 'WORLD_HUMAN_CLIPBOARD'
}

Config.Blip = {
    enabled = true,
    sprite = 479,
    color = 5,
    scale = 0.78,
    labelKey = 'blip.company'
}

Config.Vehicle = {
    model = 'boxville2',
    spawn = vector4(1002.42, -2522.62, 28.30, 88.00),
    spawns = {
        vector4(1002.42, -2522.62, 28.30, 88.00),
        vector4(1002.18, -2527.95, 28.30, 88.00),
        vector4(1002.68, -2517.35, 28.30, 88.00),
        vector4(995.34, -2522.50, 28.30, 88.00)
    },
    spawnClearRadius = 7.5,
    spawnHeightOffset = 0.35,
    maxGroundLift = 1.0,
    rearOffset = vector3(0.0, -3.85, 0.35),
    rearInteractRadius = 2.1,
    platePrefix = 'MOVE',
    cargoSlots = {
        vector3(-0.28, -1.65, 0.12),
        vector3(0.00, -1.65, 0.12),
        vector3(0.28, -1.65, 0.12),
        vector3(-0.28, -2.25, 0.12),
        vector3(0.00, -2.25, 0.12),
        vector3(0.28, -2.25, 0.12),
        vector3(0.00, -2.85, 0.12)
    },
    benchSlots = {
        { offset = vector3(-0.62, -1.45, 0.58), rotation = vector3(0.0, 0.0, 90.0) },
        { offset = vector3(0.62, -1.45, 0.58), rotation = vector3(0.0, 0.0, -90.0) },
        { offset = vector3(-0.62, -2.05, 0.58), rotation = vector3(0.0, 0.0, 90.0) },
        { offset = vector3(0.62, -2.05, 0.58), rotation = vector3(0.0, 0.0, -90.0) },
        { offset = vector3(-0.62, -2.65, 0.58), rotation = vector3(0.0, 0.0, 90.0) },
        { offset = vector3(0.62, -2.65, 0.58), rotation = vector3(0.0, 0.0, -90.0) },
        { offset = vector3(-0.62, -3.10, 0.58), rotation = vector3(0.0, 0.0, 90.0) }
    }
}

Config.Depot = {
    pickupPoint = vector3(1013.28, -2521.57, 28.30),
    loadPoint = vector3(1013.28, -2521.57, 28.30),
    vanCheckRadius = 22.0
}

Config.Job = {
    minItems = 4,
    maxItems = 7,
    payPerItemMin = 95,
    payPerItemMax = 160,
    bonusMin = 275,
    bonusMax = 475,
    deliveryCooldownMs = 1250,
    requireMovingVanNearDropoff = true,
    vanDropoffRadius = 32.0,
    contractsPerRequest = 3
}

Config.Props = {
    { labelKey = 'item.moving_box', model = 'prop_cs_cardbox_01', anim = 'box', cargoType = 'bench' },
    { labelKey = 'item.small_box', model = 'prop_cardbordbox_02a', anim = 'box', cargoType = 'bench' },
    { labelKey = 'item.office_chair', model = 'prop_off_chair_04', anim = 'furniture' },
    { labelKey = 'item.dining_chair', model = 'prop_chair_04a', anim = 'furniture' },
    { labelKey = 'item.bedside_table', model = 'prop_table_04', anim = 'heavy', cargoCenter = true, cargoZ = -0.08, cargoRotation = vector3(0.0, 0.0, 90.0) },
    { labelKey = 'item.tv_box', model = 'prop_tv_flat_03', anim = 'fragile', cargoType = 'bench', cargoZ = 0.64 }
}

Config.Customers = {
    'Marlene Carter',
    'DeShawn Price',
    'Ari Morgan',
    'Noah Brooks',
    'Rosa Delgado',
    'Marcus Reed',
    'Kelly Stone',
    'Andre Wilson'
}

-- Doorstep spots are calculated from each door toward its exterior arrival point.
-- forward moves away from the door; side spreads items left and right.
Config.DeliveryPlacement = {
    spots = {
        { forward = 0.90, side = 0.00 },
        { forward = 1.00, side = 0.65 },
        { forward = 1.00, side = -0.65 },
        { forward = 1.60, side = 0.00 },
        { forward = 1.65, side = 0.65 },
        { forward = 1.65, side = -0.65 },
        { forward = 2.25, side = 0.00 }
    }
}

Config.Destinations = {
    {
        labelKey = 'destination.mirror_park_house',
        door = vector3(1229.68, -725.52, 60.80),
        arrival = vector3(1228.70, -724.25, 60.58)
    },
    {
        labelKey = 'destination.vespucci_apartment',
        door = vector3(-1118.30, -938.63, 2.15),
        arrival = vector3(-1120.92, -940.95, 2.15)
    },
    {
        labelKey = 'destination.del_perro_condo',
        door = vector3(-1452.92, -653.19, 29.58),
        arrival = vector3(-1454.18, -655.04, 29.58)
    },
    {
        labelKey = 'destination.vinewood_hills_home',
        door = vector3(340.94, 437.06, 149.39),
        arrival = vector3(338.88, 436.02, 149.14)
    },
    {
        labelKey = 'destination.alta_street_loft',
        door = vector3(299.72, -902.88, 29.29),
        arrival = vector3(297.12, -902.78, 29.18)
    }
}
