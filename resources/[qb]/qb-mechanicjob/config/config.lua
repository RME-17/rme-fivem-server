Config = {}
Config.RequireJob = true                       -- do you need a mech job to use parts?
Config.FuelResource = 'LegacyFuel'             -- supports any that has a GetFuel() and SetFuel() export

Config.PaintTime = 5                           -- how long it takes to paint a vehicle in seconds
Config.ColorFavorites = false                  -- add your own colors to the favorites menu (see bottom of const.lua)

Config.NitrousBoost = 1.8                      -- how much boost nitrous gives (want this above 1.0)
Config.NitrousUsage = 0.1                      -- how much nitrous is used per frame while holding key

Config.UseDistance = true                      -- enable/disable saving vehicle distance
Config.UseDistanceDamage = true                -- damage vehicle engine health based on vehicle distance
Config.UseWearableParts = true                 -- enable/disable wearable parts
Config.WearablePartsChance = 1                 -- chance of wearable parts being damaged while driving if enabled
Config.WearablePartsDamage = math.random(1, 2) -- how much wearable parts are damaged when damaged if enabled
Config.DamageThreshold = 25                    -- how worn a part needs to be or below to apply an effect if enabled
Config.WarningThreshold = 50                   -- how worn a part needs to be to show a warning color in toolbox if enabled

Config.MinimalMetersForDamage = {              -- unused if Config.UseDistanceDamage is false
    { min = 5000,  max = 10000, damage = 10 },
    { min = 15000, max = 20000, damage = 20 },
    { min = 25000, max = 30000, damage = 30 },
}

Config.WearableParts = { -- unused if Config.UseWearableParts is false (feel free to add/remove parts)
    radiator = { label = Lang:t('menu.radiator_repair'), maxValue = 100, repair = { steel = 2 } },
    axle = { label = Lang:t('menu.axle_repair'), maxValue = 100, repair = { aluminum = 2 } },
    brakes = { label = Lang:t('menu.brakes_repair'), maxValue = 100, repair = { copper = 2 } },
    clutch = { label = Lang:t('menu.clutch_repair'), maxValue = 100, repair = { copper = 2 } },
    fuel = { label = Lang:t('menu.fuel_repair'), maxValue = 100, repair = { plastic = 2 } },
}

Config.Shops = {
    redline = { -- Redline Motorsport @ energy_redlinemlo
        -- Requires the 'redline' job (owner: setjob <id> redline 4). Cosmetics + repair shop.
        -- Three drive-in custom bays, NO separate paint booth, NO vehicle spawner.
        -- Redline has its own external blip resource, so showBlip is false here to avoid a duplicate marker.
        managed = true,
        shopLabel = 'Redline Motorsport',
        showBlip = false,
        duty = vector3(1162.94, -781.14, 57.6),
        stash = vector3(1146.94, -801.38, 57.6),
        -- Drive-in customization pads: park a car on a pad, then press E (in seat or on foot) for the showroom bay (all cosmetics unlocked).
        custombays = {
            vector3(1122.8, -784.44, 57.18),
            vector3(1140.37, -784.84, 57.19),
            vector3(1158.04, -799.26, 57.18),
        },
    },
    mechanic2 = { -- Harmony Location
        managed = true,
        shopLabel = 'LS Customs',
        showBlip = true,
        blipSprite = 72,
        blipColor = 46,
        blipCoords = vector3(1174.93, 2639.45, 37.75),
        duty = vector3(1185.86, 2638.70, 38.93),
        stash = vector3(1175.11, 2635.375, 37.78),
        paint = vector3(1181.29, 2634.69, 37.80),
        vehicles = {
            withdraw = vector3(1185.63, 2646.01, 37.91),
            spawn = vector4(1188.18, 2657.56, 37.79, 316.74),
            list = { 'flatbed', 'towtruck', 'minivan', 'blista' }
        },
    },
    mechanic3 = { -- Airport Location
        managed = true,
        shopLabel = 'LS Customs',
        showBlip = true,
        blipSprite = 72,
        blipColor = 46,
        blipCoords = vector3(-1154.92, -2006.41, 13.18),
        duty = vector3(-1149.17, -1998.27, 13.91),
        stash = vector3(-1146.40, -2002.05, 13.19),
        paint = vector3(-1170.60, -2014.90, 13.23),
        vehicles = {
            withdraw = vector3(-1142.04, -1994.58, 13.26),
            spawn = vector4(-1137.42, -1993.26, 13.14, 226.07),
            list = { 'flatbed', 'towtruck', 'minivan', 'blista' }
        },
    },
    beeker = { -- Paleto Location
        managed = true,
        shopLabel = "Beeker's Garage",
        showBlip = true,
        blipSprite = 72,
        blipColor = 46,
        blipCoords = vector3(109.95, 6627.34, 31.79),
        duty = vector3(101.74, 6620.04, 32.95),
        stash = vector3(107.00, 6629.88, 31.81),
        paint = vector3(102.17, 6626.08, 31.79),
        vehicles = {
            withdraw = vector3(107.08, 6614.90, 31.96),
            spawn = vector4(110.91, 6609.32, 31.81, 315.11),
            list = { 'flatbed', 'towtruck', 'minivan', 'blista' }
        },
    },
}

-- ===========================================================================
-- RME map dressing for shop MLOs (handled by client/decor.lua, no CodeWalker)
-- ===========================================================================

-- Hide existing map/clutter props within a radius of a point.
-- HOW TO FILL: stand on/next to the prop in-game, /coords for x,y,z, and set the
-- prop's model name. Keep radius small (0.5-1.5) so you don't nuke nearby props
-- that share the same model. Each entry runs CreateModelHide() on start.
Config.MapHides = {
    -- { model = 'prop_toolchest_01', coords = vector3(-200.0, -1320.0, 31.0), radius = 1.0 },
    -- { model = 'prop_tool_bench02', coords = vector3(-198.0, -1318.0, 31.0), radius = 1.0 },
}

-- Spawn extra decorative props (e.g. car lifts/ramps to make more bays).
-- coords is vector4 (x, y, z, heading). snapToGround drops it to the floor if true
-- (otherwise the exact z is used); collision defaults to true (set false for decor only).
Config.MapProps = {
    -- { model = 'prop_car_ramp_01', coords = vector4(-195.0, -1310.0, 31.0, 90.0), snapToGround = false, collision = true },
    -- { model = 'prop_carjack', coords = vector4(-193.0, -1312.0, 31.0, 0.0), snapToGround = true, collision = true },
}
