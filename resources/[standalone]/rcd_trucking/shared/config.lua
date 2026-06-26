Config = {}

-- General
Config.Debug = false              -- true prints extra debug logs to the console; keep false in production
Config.MenuCommand = 'trucking'   -- the chat command players type to open the menu (/trucking)
Config.AllowRemoteMenu = true     -- true: players can open the menu anywhere; false: only at the depot ped
Config.CurrencySymbol = '$'       -- shown in all money displays/logs

Config.Locale = 'en'              -- default language: en, fr, de, es, pt, pl (must match a file in locales/)
Config.NotifySystem = 'auto'      -- 'auto' detects your framework's notify; or force 'qb' / 'esx' / 'ox'

-- Storage: where company data is saved
Config.Storage = {
    type = 'sql',                         -- 'sql' = oxmysql database | 'local' = JSON file below (no database needed)
    fileName = 'data/companies.json',     -- path to the save file, relative to this resource
    saveInterval = 60,                    -- how often (seconds) data is flushed to disk
}

-- Bank transaction ledger
Config.Transactions = {
    maxStored = 100,      -- how many transactions are kept on each company record
    historyShown = 40,    -- how many of those are shown in the bank tab UI
}

-- Top-companies leaderboard
Config.Leaderboard = {
    cacheSeconds = 60,    -- how long (seconds) the leaderboard is cached before it recalculates
    topCount = 10,        -- how many companies to list
}

-- Depot
Config.Depot = {
    blip = { sprite = 477, color = 17, scale = 0.85, label = 'Trucking Depot' },
    coords = vector3(1208.8, -3115.61, 5.54),
    ped = {
        model = 's_m_m_trucker_01',
        coords = vector4(1208.8, -3115.61, 5.54, 100.0),
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        targetIcon = 'fa-solid fa-truck',
        targetLabel = 'Trucking Company',
    },
    spawnPoints = {
        vector4(1246.19, -3166.77, 4.63, 266.29),
        vector4(1245.67, -3157.05, 4.59, 267.23),
        vector4(1245.12, -3149.06, 4.55, 271.85),
        vector4(1245.0, -3142.18, 4.55, 273.06),
        vector4(1244.57, -3135.1, 4.53, 263.94),
    },
    trailerSpawnPoints = {
        vector4(1268.84, -3187.25, 4.9, 84.77),
        vector4(1268.93, -3193.56, 4.9, 88.82),
        vector4(1268.84, -3200.39, 4.9, 83.78),
        vector4(1269.31, -3208.74, 4.9, 94.45),
    },
    spawnClearRadius = 4.0,
    interactDistance = 2.5,
}

-- Company
Config.CompanyCreationCost = 10000    -- price a player pays to found a company
Config.CompanyRenameCost = 2500       -- price to rename an existing company
Config.MaxCompanyNameLength = 28      -- max characters allowed in a company name
Config.StarterTruck = false           -- true: new companies get a free truck to begin with

Config.Ranks = {
    { level = 0,  label = 'Rookie Hauler' },
    { level = 3,  label = 'Local Courier' },
    { level = 5,  label = 'Regional Carrier' },
    { level = 10, label = 'Interstate Operator' },
    { level = 15, label = 'Heavy Freight Specialist' },
    { level = 20, label = 'Logistics Magnate' },
    { level = 30, label = 'Freight Tycoon' },
}

-- XP required to reach the NEXT level. Raise the 400 or the 1.35 exponent to
-- make levelling slower (each level costs more XP than the last).
Config.XPForLevel = function(level)
    return math.floor(400 * (level + 1) ^ 1.35)
end

-- Level tiers: as a company levels up it unlocks farther regions, more cargo
-- types, and longer routes. regions reference shared/locations.lua.
-- maxDistance is in map units; oversized=true unlocks oversize-load freight.
Config.Tiers = {
    { level = 0,  label = 'Local',             regions = { 'city' },                              cargo = { 'basic' },                                                   maxDistance = 2.0 },
    { level = 5,  label = 'Regional',          regions = { 'city', 'county' },                    cargo = { 'basic', 'fragile' },             maxDistance = 6.0 },
    { level = 10, label = 'Long Distance',     regions = { 'city', 'county', 'state' },           cargo = { 'basic', 'fragile', 'valuable' }, maxDistance = 14.0 },
    { level = 15, label = 'Hazardous',         regions = { 'city', 'county', 'state' },           cargo = { 'basic', 'fragile', 'valuable' }, maxDistance = 20.0 },
    { level = 20, label = 'Premium Long-Haul', regions = { 'city', 'county', 'state', 'premium' },cargo = { 'basic', 'fragile', 'valuable' }, maxDistance = 999.0, oversized = true },
}

-- Contracts / player jobs: the available-jobs board and how each haul is paid out
Config.Contracts = {
    basePoolSize = 20,              -- how many contracts sit on the job board at once
    refreshInterval = 900,         -- seconds between automatic board refreshes (900 = 15 min)
    manualRefreshCooldown = 60,    -- seconds a player must wait before manually refreshing the board

    -- Pay shares (fraction of a contract's headline value)
    basicShare = 0.30,             -- cut a hired driver / non-owner keeps when using a company truck
    ownerOpShare = 0.35,           -- cut kept when the player uses their OWN (owned) truck
    ownerOpBonusPct = 0.15,        -- extra bonus on top for owner-operators
    loanerCondition = 75,          -- condition % a free loaner truck spawns with

    minRouteMiles = 0.3,           -- contracts shorter than this (map miles) are filtered out

    -- Optional delivery timer (off by default)
    timeLimitEnabled = false,      -- true turns on a countdown the player must beat
    minutesPerMile = 2.2,          -- time budget granted per mile of the route
    timeLimitBuffer = 5,           -- extra minutes added on top of the budget

    unloadTime = 6000,             -- ms the unload animation/wait takes at the dropoff

    -- Performance bonuses added to the payout
    speedBonusThreshold = 0.70,    -- finish within this fraction of the time limit to earn the speed bonus
    speedBonusPct = 0.15,          -- size of that speed bonus (+15%)
    noDamageThreshold = 0.02,      -- max trailer damage (2%) still counted as a clean delivery
    noDamagePct = 0.10,            -- bonus for a clean, no-damage delivery (+10%)

    -- Penalties subtracted from the payout
    latePenaltyPct = 0.25,         -- penalty for finishing past the time limit (-25%)
    damagePenaltyMult = 0.5,       -- how hard cargo damage is punished (multiplier on damage %)
    damagePenaltyCap = 0.4,        -- max total damage penalty (capped at -40%)
    cancelPenaltyPct = 0.15,       -- penalty for cancelling an accepted job (-15%)
    cancelGraceSeconds = 30,       -- grace window after accepting where cancelling is free

    completionRadius = 60.0,       -- distance (units) from the dropoff that counts as "arrived"
    returnRadius = 60.0,           -- distance from the depot that counts as the truck "returned"
    maxAverageSpeed = 120,         -- anti-cheat: deliveries averaging above this speed are flagged

    -- Back-in parking check: makes the player reverse the trailer onto the pad
    backIn = {
        enabled = true,                -- false lets players just drive near the pad instead of backing in
        radius = 4.5,                  -- trailer-centre distance to turn the pad green; ~half the
                                       -- dropoff pad length. Too small and a parked trailer never
                                       -- registers (its centre sits ~7m from the dock).
        noseOut = true,                -- require the truck cab to point away (true reverse-in parking)
        maxSpeed = 1.0,                -- trailer must be nearly stopped (below this speed) to register
        requireHeading = true,         -- also require the trailer to be aligned with the pad
        headingTolerance = 35.0,       -- how many degrees off-square is still accepted
        flipHeading = false,           -- flip the accepted direction if your pad faces the other way
    },

    -- Express (time-sensitive) deliveries: a tighter deadline than the normal timer
    -- above, plus a pay bonus. These only appear once a company buys the Express
    -- Dispatch upgrade (Config.Upgrades.express) - none exist at upgrade level 0.
    -- The deadline is enforced at delivery; there is no on-screen countdown.
    express = {
        minutesPerMile = 1.4,          -- time budget per mile (lower = stricter than the normal 2.2)
        timeLimitBuffer = 3,           -- flat minutes added on top of the budget
        latePenaltyPct = 0.40,         -- penalty for a late express delivery (harsher than the normal 0.25)
    },

    -- Fragile cargo damage rules: punished far harder than normal freight, so it
    -- has to be driven smoothly. Applies to any load in the 'fragile' cargo category.
    fragile = {
        noDamageThreshold = 0.005,     -- max damage (0.5%) still counted as a clean run (normal is 0.02)
        noDamagePct = 0.20,            -- clean-run bonus (+20%, vs the normal +10%)
        damagePenaltyMult = 1.2,       -- damage hurts ~2.4x harder than normal freight (normal is 0.5)
        damagePenaltyCap = 0.7,        -- max total damage penalty (-70%, vs the normal -40%)
    },
}

-- Special rotating contracts that pay/award more than normal hauls
Config.DailyContract  = { rewardMult = 2.5, xpMult = 2.0 }                 -- daily job: 2.5x pay, 2x XP
Config.WeeklyContract = { rewardMult = 5.0, xpMult = 3.5, minLevel = 10 }  -- weekly job: 5x pay, 3.5x XP, needs level 10

-- Illegal/smuggling cargo: high pay, but can trigger a police alert
Config.IllegalCargo = {
    enabled = true,            -- false removes illegal cargo from the board entirely
    requiresUpgrade = 'illegal', -- smuggling only appears once the Smuggling Contacts upgrade is bought (Config.Upgrades.illegal)
    minLevel = 0,              -- company level required before illegal jobs appear
    poolShare = 0.15,          -- fraction of the job board that can be illegal contracts (15%)
    rewardMult = 2.5,          -- pay multiplier vs a normal haul
    xpMult = 1.5,              -- XP multiplier vs a normal haul
    alertChancePct = 35,       -- chance (%) a delivery pings police dispatch
    alertBlipRadius = 120.0,   -- how wide (units) the search-area blip is for police
    alertBlipDuration = 90,    -- how long (seconds) that police blip stays on the map
}

-- Which jobs count as police, and how they search trailers for illegal cargo
Config.Police = {
    jobs = { 'police', 'sheriff', 'bcso', 'sast' },                       -- framework job names treated as police
    useTarget = true,                                                     -- true uses ox/qb-target; false uses a key/command
    searchTime = 5000,                                                    -- ms a trailer search takes
    trailerModels = { 'docktrailer', 'trflat', 'trailers3', 'tr4', 'armytanker' }, -- trailer models that are searchable
}

-- Where the illegal-cargo police alert is sent
Config.Dispatch = {
    system = 'auto', -- 'auto' uses the built-in alert; 'PS-Dispatch' routes it through ps-dispatch
    psDispatch = {   -- only used when system = 'PS-Dispatch'
        codeName = 'trucking_smuggling',
        code = '10-90',
        icon = 'fas fa-truck-ramp-box',
        priority = 2,
    },
}

--if using ps-mdt add this to the config of ps-mdt
--['trucking_smuggling'] = {
--    radius = 0,
--    sprite = 477,
--    color = 1,
--    scale = 1.2,
--    length = 3,
--    sound = 'Lose_1st',
--    sound2 = 'GTAO_FM_Events_Soundset',
--    offset = false,
--    flash = false
--},


-- Random truck breakdowns mid-route
Config.Breakdown = {
    enabled = true,                  -- false disables breakdowns entirely
    baseChancePerMinute = 0.8,       -- % chance per minute of driving that the truck breaks down
    repairTime = 20000,              -- ms the roadside repair takes
    repairCost = 350,                -- money charged for the repair
    brokenEngineHealth = 50.0,       -- engine health the truck drops to when it breaks down
    repairedEngineHealth = 650.0,    -- engine health restored after repairing
}

-- Plates and fuel for spawned job/company trucks
Config.JobTruck = {
    fuelLevel = 100,         -- fuel % a job truck spawns with
    fleetPlate = 'TRK',      -- plate prefix for company-owned trucks (e.g. TRK12345)
    loanerPlate = 'RNT',     -- plate prefix for free loaner trucks
}

-- Storing/retrieving owned trucks
Config.Garage = {
    enabled = true,          -- false disables the trucking garage
    takeOutPerm = 'drive',   -- crew permission required to take a truck out (see Config.Crew perms)
    storeRadius = 6.0,       -- how close (units) to the depot you must be to store a truck
}

-- Register purchased trucks in the framework's owned-vehicles table (needs oxmysql)
Config.OwnedVehicles = {
    enabled = true,          -- true makes bought trucks show up for police plate lookups / persistent garages
    garage = 'trucking',     -- garage name the truck is filed under
    state = 1,               -- stored state (1 = in garage) written to the DB row
}

-- Job markers: purely cosmetic. The on-ground markers for dropoff, direction,
-- truck return and trailer pickup (colour/size/draw distance). Safe to leave as-is.
Config.Markers = {
    dropoff = {
        type = 30,
        size = vector3(4.5, 2.0, 14.0),
        color = { r = 245, g = 130, b = 32, a = 170 },
        colorBlocked = { r = 224, g = 70, b = 70, a = 170 },
        colorReady = { r = 76, g = 200, b = 120, a = 190 },
        levelRotation = vector3(90.0, 0.0, 0.0),
        zOffset = 0.05,
        headingOffset = 0.0,
        bob = false, spin = false, faceCamera = false,
        drawDistance = 45.0,
    },
    direction = {
        type = 20,
        size = vector3(3.0, 3.0, 3.0),
        color = { r = 245, g = 130, b = 32, a = 200 },
        levelRotation = vector3(90.0, 0.0, 0.0),
        zOffset = 0.15,
        headingOffset = 0.0,
        bob = false, spin = false, faceCamera = false,
        drawDistance = 45.0,
    },
    returnPoint = {
        type = 39,
        size = vector3(2.4, 2.4, 2.4),
        color = { r = 245, g = 130, b = 32, a = 210 },
        rotation = vector3(0.0, 0.0, 0.0),
        zOffset = 2.5,
        bob = true, spin = false, faceCamera = true,
        drawDistance = 40.0,
    },
    trailer = {
        type = 20,
        size = vector3(2.0, 2.0, 2.0),
        color = { r = 245, g = 130, b = 32, a = 210 },
        rotation = vector3(180.0, 0.0, 0.0),
        zOffset = 4.0,
        bob = true, spin = false, faceCamera = false,
        drawDistance = 150.0,
    },
}

Config.AdminPlacement = {
    rotateSpeed = 1.5,
    heightStep = 0.02,
}

-- Crew (multiplayer): let players share one company
Config.Crew = {
    maxMembers = 5,              -- max players in a single company (including the owner)
    defaultPerms = {            -- permissions a newly-invited member starts with (owner can change them)
        drive    = true,         -- take trucks out and run jobs
        bank     = false,        -- withdraw company money
        drivers  = false,        -- hire/fire AI drivers
        fleet    = false,        -- buy/sell company trucks
        upgrades = false,        -- purchase company upgrades
    },
}

-- AI drivers: hired NPCs that run jobs automatically and earn the company money
Config.Drivers = {
    tickInterval = 30,            -- seconds between AI driver job-progress checks
    offlineProgress = true,       -- true: AI drivers keep working/earning while the owner is offline
    autoDispatch = true,          -- true: idle AI drivers automatically pick up new jobs
    jobDuration = 20,             -- baseline minutes an AI job takes
    minJobMinutes = 5,            -- shortest an AI job can take regardless of route
    cutPct = 0.20,                -- fraction of each AI payout the driver takes as wages (company keeps the rest)
    maxLevel = 10,                -- highest level an AI driver can train up to
    premiumMinLevel = 5,          -- company level before premium-freight AI jobs unlock
    companyXPShare = 0.5,         -- fraction of an AI job's XP that goes to the company
    driverXPShare = 0.6,          -- fraction of XP the driver earns on a successful job
    driverXPShareFailed = 0.1,    -- reduced driver XP share when the job fails
    xpForLevel = function(level) return math.floor(120 * level ^ 1.5) end,  -- XP needed for an AI driver to level up
    tiers = {                     -- hireable driver tiers; better tiers cost more but perform better
                                  -- skill/reliability are random ranges {min,max}; costMult scales hire cost
        { label = 'Rookie',      minCompanyLevel = 0,  minDriverLevel = 1,  skill = { 25, 50 }, reliability = { 30, 55 }, costMult = 1.0 },
        { label = 'Experienced', minCompanyLevel = 5,  minDriverLevel = 4,  skill = { 45, 70 }, reliability = { 50, 75 }, costMult = 1.6 },
        { label = 'Veteran',     minCompanyLevel = 10, minDriverLevel = 7,  skill = { 60, 85 }, reliability = { 65, 88 }, costMult = 2.4 },
        { label = 'Elite',       minCompanyLevel = 18, minDriverLevel = 10, skill = { 80, 98 }, reliability = { 82, 98 }, costMult = 3.5 },
    },
    candidates = {                -- the pool of drivers available to hire
        count = 4,                                                                    -- how many candidates are offered at once
        refreshInterval = 1800,                                                       -- seconds before the candidate list refreshes (30 min)
        hireCost = function(skill, reliability) return 2500 + skill * 60 + reliability * 40 end,  -- one-time hiring fee formula
    },
    -- Base chance (%) of each bad outcome before driver skill/reliability reduce it
    failBasePct = 14,             -- job failed outright
    lateBasePct = 16,             -- job delivered late
    damageBasePct = 18,           -- cargo damaged in transit
    outcomes = {                  -- payout effects of each bad outcome
        late    = { payMult = 0.60 },                              -- late: 60% pay
        damaged = { payMult = 0.85, penaltyPct = 0.10, extraWear = 10 },  -- damaged: 85% pay, 10% penalty, +10 truck wear
        failed  = { payMult = 0.0,  penaltyPct = 0.10 },           -- failed: no pay, 10% penalty
    },
    resignOnFailPct = 10,         -- chance (%) a driver quits after failing a job
    resignLowReliabilityPct = 1,  -- chance (%) per tick a low-reliability driver quits
    resignReliabilityBelow = 40,  -- reliability under this is considered "low" for the rule above
    fuelCostPerMile = 9,          -- operating fuel cost charged per mile of an AI job
    names = {                     -- random first/last name pools for generated drivers
        first = { 'Marcus', 'Elena', 'Dwayne', 'Rosa', 'Pete', 'Tanya', 'Carl', 'Misha', 'Hank', 'Lucia',
            'Omar', 'Brenda', 'Felix', 'Dana', 'Vince', 'Carmen', 'Earl', 'Nadia', 'Ray', 'Sofia' },
        last = { 'Holloway', 'Vargas', 'Kowalski', 'Brooks', 'Okafor', 'Reyes', 'Larsen', 'Webb', 'Donovan',
            'Petrov', 'Sanders', 'Macklin', 'Ferreira', 'Boone', 'Castillo', 'Hargrove', 'Nilsen', 'Drummond' },
    },
}

-- Performance formulas: how a driver's stats translate into results.
-- Higher skill/level = more revenue and speed; higher skill/reliability = fewer mishaps.
Config.Drivers.revenueMult = function(driver)
    return 0.8 + driver.skill / 250 + driver.level * 0.04
end
Config.Drivers.speedMult = function(driver)
    return 1 + (driver.level - 1) * 0.06
end
Config.Drivers.failChance = function(driver)
    return math.max(2, Config.Drivers.failBasePct - driver.skill * 0.05 - driver.level - driver.reliability * 0.05)
end
Config.Drivers.lateChance = function(driver)
    return math.max(3, Config.Drivers.lateBasePct - driver.level * 1.2 - driver.skill * 0.05)
end
Config.Drivers.damageChance = function(driver, truckReliability)
    return math.max(3, Config.Drivers.damageBasePct - driver.skill * 0.1 - truckReliability * 0.05)
end

-- Company upgrades players buy to improve the business.
-- baseCost is the level-1 price; the per-level functions return that upgrade's
-- effect at a given level. Actual price scales via Config.UpgradeCost below.
Config.Upgrades = {
    garage = {
        label = 'Garage', icon = 'warehouse', baseCost = 20000, maxLevel = 5,
        description = 'Expands fleet size and driver capacity.',
        fleetSize = function(lvl) return 2 + lvl * 2 end,
        driverCap = function(lvl) return 1 + lvl end,
    },
    dispatch = {
        label = 'Dispatch Center', icon = 'headset', baseCost = 15000, maxLevel = 5,
        description = 'More available contracts and better odds of premium freight.',
        poolBonus = function(lvl) return lvl * 2 end,
        premiumChancePct = function(lvl) return 5 + lvl * 6 end,
    },
    training = {
        label = 'Driver Training', icon = 'school', baseCost = 12000, maxLevel = 5,
        description = 'Drivers earn more XP and finish jobs faster.',
        xpMult = function(lvl) return 1 + lvl * 0.15 end,
        speedMult = function(lvl) return 1 - lvl * 0.04 end,
    },
    insurance = {
        label = 'Insurance', icon = 'shield', baseCost = 18000, maxLevel = 5,
        description = 'Reduces damage penalties and failed contract losses.',
        penaltyMult = function(lvl) return 1 - lvl * 0.12 end,
    },
    fuel = {
        label = 'Fuel Contracts', icon = 'gas', baseCost = 10000, maxLevel = 5,
        description = 'Cuts fuel and operating costs across the fleet.',
        costMult = function(lvl) return 1 - lvl * 0.08 end,
    },
    express = {
        label = 'Time-Sensitive Dispatch', icon = 'bolt', baseCost = 16000, maxLevel = 5,
        description = 'Unlocks time-sensitive loads. They pay a bonus but must be delivered before the deadline.',
        poolShare = function(lvl) return lvl > 0 and (0.05 + lvl * 0.04) or 0 end,  -- 0 at lvl 0; ~9% of the board at lvl 1 up to ~25% at lvl 5
        rewardBonus = function(lvl) return 0.20 + lvl * 0.06 end,                    -- express pay bonus: +26% at lvl 1 up to +50% at lvl 5
    },
    -- One-time licenses (maxLevel 1) that unlock a cargo category. The matching
    -- category in shared/cargo.lua carries requiresUpgrade = 'fragile' / 'valuable',
    -- so those loads only appear on the board once the license is bought.
    fragile = {
        label = 'Fragile Freight License', icon = 'wine-glass', baseCost = 14000, maxLevel = 1,
        description = 'Unlocks fragile cargo contracts (glassware, ceramics, fine art). Damage is punished hard, so drive smoothly.',
    },
    valuable = {
        label = 'Valuable Freight License', icon = 'gem', baseCost = 22000, maxLevel = 1,
        description = 'Unlocks high-value cargo contracts (jewelry, gold, banknotes) for big payouts.',
    },
    illegal = {
        label = 'Smuggling Contacts', icon = 'mask', baseCost = 25000, maxLevel = 1,
        description = 'Unlocks illegal smuggling contracts. Big payouts, but deliveries can ping the police.',
    },
}
-- Price of the NEXT upgrade level. Raise the 1.6 exponent to make upgrades scale more steeply.
Config.UpgradeCost = function(baseCost, currentLevel)
    return math.floor(baseCost * (currentLevel + 1) ^ 1.6)
end

-- Company level required to purchase a given upgrade rank
Config.UpgradeLevelRequired = function(rank)
    return (rank - 1) * 4
end

Config.SkillPointsPerLevel = 1    -- skill points a company earns each level
Config.UpgradePointCost = 1       -- skill points each upgrade level costs

-- Truck wear & condition
Config.Maintenance = {
    wearPerJobMin = 2,             -- minimum condition % a truck loses per completed job
    wearPerJobMax = 6,             -- maximum condition % lost per job
    damageWearMult = 15,           -- extra wear multiplier applied from in-transit damage
    minConditionToDispatch = 20,   -- a truck below this condition % can't be sent on jobs
    sellbackPct = 0.55,            -- fraction of purchase price refunded when selling a truck
}

-- Integration hooks
-- KeySystem: auto | renewed | qbx | qb | none
Config.KeySystem = 'auto'

local function keySystem()
    if Config.KeySystem ~= 'auto' then return Config.KeySystem end
    if GetResourceState('Renewed-Vehiclekeys'):find('start') then return 'renewed' end
    if GetResourceState('qbx_vehiclekeys'):find('start') then return 'qbx' end
    if GetResourceState('qb-vehiclekeys'):find('start') then return 'qb' end
    return 'none'
end

Config.GiveKeys = function(vehicle, plate)
    local sys = keySystem()
    if sys == 'renewed' then
        exports['Renewed-Vehiclekeys']:addKey(plate)
    elseif sys == 'qbx' then
        TriggerServerEvent('trucking:server:vehicleKeys', 'give', VehToNet(vehicle), plate)
    elseif sys == 'qb' then
        TriggerEvent('vehiclekeys:client:SetOwner', plate)
    end
end

Config.RemoveKeys = function(vehicle, plate)
    local sys = keySystem()
    local validVeh = vehicle and vehicle ~= 0 and DoesEntityExist(vehicle)
    if sys == 'renewed' then
        exports['Renewed-Vehiclekeys']:removeKey(plate)
    elseif sys == 'qbx' then
        TriggerServerEvent('trucking:server:vehicleKeys', 'remove', validVeh and VehToNet(vehicle) or 0, plate)
    elseif sys == 'qb' then
        TriggerEvent('qb-vehiclekeys:client:RemoveKeys', plate)
        TriggerServerEvent('qb-vehiclekeys:server:RemoveKey', plate)
        pcall(function() exports['qb-vehiclekeys']:RemoveKeys(plate) end)
    end
end

Config.SetFuel = function(vehicle, level)
    SetVehicleFuelLevel(vehicle, level + 0.0)
end

-- Discord logging (empty webhook disables it)
Config.Discord = {
    webhook = '',                  -- paste your Discord webhook URL here to enable logging
    name = 'Trucking Logs',        -- username the webhook posts under
    color = 15105570,              -- embed colour (decimal RGB)
    logLevel = {                   -- which event categories get logged
        company = true,            -- company created/renamed/deleted
        money = true,              -- deposits/withdrawals (only above moneyThreshold)
        moneyThreshold = 10000,    -- only log money moves at or above this amount
        admin = true,              -- admin command actions
        drivers = false,           -- AI driver hires/results (noisy; off by default)
    },
}
