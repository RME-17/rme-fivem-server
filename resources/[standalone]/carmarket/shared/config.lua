Config = {}

Config.Debug = false
Config.Locale = 'en'

Config.Database = {
    AutoCreateTable = true, -- If true, it will create the table in the database
}

Config.Interaction = 'ox_target' -- 'ox_target' or nil
Config.InventoryMenuSystem = 'ox_lib' -- 'auto' (auto-detect) | 'ox_lib' (optional) | 'esx_menu_default' | 'qb-menu-default' | 'ox_target'
Config.ZoneSpawnRadiusDefault = 50 -- The default radius for the zone spawn
Config.DrawText = { -- Draw text for the zone
    enabled = true, -- If true, it will draw text for the zone (if ox_target is used, it will draw text for the zone)
    key = 38, -- The key to open the menu
    vehicleText = 'Manage chosen vehicle', -- The text to display for the vehicles on zones in market places
}

Config.Zones = {
    {
        id = "zone1",
        coords = vector4(-2187.8787, -409.0271, 13.1511, 231.3093),
        distance = 1.5,
        name = "Mark",
        blip = {
            sprite = 1,
            colour = 1,
            scale = 1.0,
            display = 4
        },
        npc = {
            name = "Mark",
            hash = 0x18CE57D0,
            scenario = "WORLD_HUMAN_CLIPBOARD",
            target = {
                icon = "fas fa-shopping-basket",
                label = "Mark - Car Market",
                distance = 2.0,
                key = 38,
            }
        },
        CarMarketBoxes = {
            { id = 'zone1_slot1', coords = vec3(-2160.43, -402.35, 13.39), size = vec3(3, 5, 3), rotation = 82.9 },
            { id = 'zone1_slot2', coords = vec3(-2159.97, -396.41, 13.39), size = vec3(3, 5, 3), rotation = 82.9 },
            { id = 'zone1_slot3', coords = vec3(-2158.71, -390.22, 13.39), size = vec3(3, 5, 3), rotation = 82.9 },
        },
    },
    {
        id = "zone2",
        coords = vector4(215.0, -810.0, 30.7, 160.0),
        distance = 1.5,
        name = "Legion",
        blip = { sprite = 1, colour = 1, scale = 1.0, display = 4 },
        npc = {
            name = "Legion",
            hash = 0x18CE57D0,
            scenario = "WORLD_HUMAN_CLIPBOARD",
            target = {
                icon = "fas fa-shopping-basket",
                label = "Legion - Car Market",
                distance = 2.0,
                key = 38
            }
        },
        CarMarketBoxes = {
            { id = 'zone2_slot1', coords = vec3(220.0, -808.0, 30.7), size = vec3(3, 5, 3), rotation = 70.0 },
            { id = 'zone2_slot2', coords = vec3(222.44, -801.37, 30.7), size = vec3(3, 5, 3), rotation = 70.0 },
            { id = 'zone2_slot3', coords = vec3(226.59, -791.64, 30.7), size = vec3(3, 5, 3), rotation = 70.0 },
        },
    },
    {
        id = "zone3",
        coords = vector4(1175.0, 2640.0, 37.8, 180.0),
        distance = 1.5,
        name = "Sandy Shores",
        blip = { sprite = 1, colour = 1, scale = 1.0, display = 4 },
        npc = {
            name = "Sandy",
            hash = 0x18CE57D0,
            scenario = "WORLD_HUMAN_CLIPBOARD",
            target = {
                icon = "fas fa-shopping-basket",
                label = "Sandy Shores - Car Market",
                distance = 2.0,
                key = 38
            }
        },
        CarMarketBoxes = {
            { id = 'zone3_slot1', coords = vec3(1180.0, 2642.0, 37.8), size = vec3(3, 5, 3), rotation = 90.0 },
            { id = 'zone3_slot2', coords = vec3(1185.0, 2642.0, 37.8), size = vec3(3, 5, 3), rotation = 90.0 },
            { id = 'zone3_slot3', coords = vec3(1190.0, 2642.0, 37.8), size = vec3(3, 5, 3), rotation = 90.0 },
        },
    },
    {
        id = "zone4",
        coords = vector4(-1037.0, -2734.0, 20.2, 240.0),
        distance = 1.5,
        name = "Airport",
        blip = { sprite = 1, colour = 1, scale = 1.0, display = 4 },
        npc = {
            name = "Airport",
            hash = 0x18CE57D0,
            scenario = "WORLD_HUMAN_CLIPBOARD",
            target = {
                icon = "fas fa-shopping-basket",
                label = "Airport - Car Market",
                distance = 2.0,
                key = 38
            }
        },
        CarMarketBoxes = {
            { id = 'zone4_slot1', coords = vec3(-1032.0, -2730.0, 20.2), size = vec3(3, 5, 3), rotation = 60.0 },
            { id = 'zone4_slot2', coords = vec3(-1028.0, -2726.0, 20.2), size = vec3(3, 5, 3), rotation = 60.0 },
            { id = 'zone4_slot3', coords = vec3(-1024.0, -2722.0, 20.2), size = vec3(3, 5, 3), rotation = 60.0 },
        },
    },
    {
        id = "zone5",
        coords = vector4(120.0, 6600.0, 31.9, 225.0),
        distance = 1.5,
        name = "Paleto",
        blip = { sprite = 1, colour = 1, scale = 1.0, display = 4 },
        npc = {
            name = "Paleto",
            hash = 0x18CE57D0,
            scenario = "WORLD_HUMAN_CLIPBOARD",
            target = {
                icon = "fas fa-shopping-basket",
                label = "Paleto - Car Market",
                distance = 2.0,
                key = 38
            }
        },
        CarMarketBoxes = {
            { id = 'zone5_slot1', coords = vec3(124.0, 6604.0, 31.9), size = vec3(3, 5, 3), rotation = 45.0 },
            { id = 'zone5_slot2', coords = vec3(128.0, 6608.0, 31.9), size = vec3(3, 5, 3), rotation = 45.0 },
            { id = 'zone5_slot3', coords = vec3(132.0, 6612.0, 31.9), size = vec3(3, 5, 3), rotation = 45.0 },
        },
    }
}

Config.Parking = {
    SlotPrice = 10000,
    SlotWeeklyFee = 2000,
    MaxSlotsPerParking = 30,
    SpacesPerPage = 10,
}

Config.Exchange = {
    ZonePurchasePrice = 250000,
    DefaultListingFeePerWeek = 500,
    DefaultCommissionPercent = 5,
    MaxListingsPerZone = 50,
}

Config.Commands = {
    AdminAce = 'group.admin',
    RequireAdminForAddParkingSlot = false,
    RequireAdminForRefreshZone = false,
}

Config.TestDrive = {
    Enabled = true,
    coords = vec3(-1015.0851, -3328.7476, 13.9444),
    heading = 59.8811,
    secondslimit = 20,
    price = 0,
    cancelKey = 73, -- X key [X/G/E] - Available to use in config.lua
}

-- Custom vehicle images.
-- For modded/custom vehicles whose images aren't on docs.fivem.net.
-- 1) Put your image at:  web/build/images/vehicles/<respname>.webp
--    (recommended: 512x256 webp, transparent background)
-- 2) Add the respname (lowercase, exactly as the spawn model) below.
-- Listed respnames load from the local resource; all other vehicles fall back
-- to https://docs.fivem.net/vehicles/<respname>.webp.
Config.CustomVehicleImages = {
    -- 'mymodcar1',
    -- 'mymodcar2',
}
