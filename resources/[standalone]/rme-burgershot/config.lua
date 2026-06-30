Config = {}

-- Require the Burger Shot job to use the cooking stations?
-- Locked to Burger Shot staff only (everything in BS is members-only).
Config.RequireJob = true
Config.JobName    = 'burgershot'

-- Account ingredients are paid from ('cash' or 'bank')
Config.PayAccount = 'cash'

-- Show supply-ped blips on the map? (Only burgershot members ever see them.)
Config.ShowSupplyBlips = true

-- ============================================================
-- COOKING STATIONS (coords captured in-game)
-- Adjust coords/size here if a station marker is off.
-- ============================================================
Config.Stations = {
    grill = {
        coords = vector4(-580.79, -892.77, 26.0, 272.59),
        label  = 'Grill',
        icon   = 'fas fa-fire-burner',
        size   = vector3(1.2, 1.2, 1.0),
    },
    fryer = {
        coords = vector4(-580.66, -891.5, 26.0, 270.93),
        label  = 'Fryer',
        icon   = 'fas fa-bowl-food',
        size   = vector3(1.2, 1.2, 1.0),
    },
    prep = {
        coords = vector4(-580.72, -886.49, 26.0, 262.87),
        label  = 'Prep Counter',
        icon   = 'fas fa-utensils',
        size   = vector3(1.2, 1.2, 1.0),
    },
    drinks = {
        coords = vector4(-582.73, -887.58, 26.0, 96.68),
        label  = 'Drinks Machine',
        icon   = 'fas fa-cup-straw',
        size   = vector3(1.2, 1.2, 1.0),
    },
}

-- ============================================================
-- COOKING ANIMATIONS PER STATION
-- The grill reuses the hot-dog spatula animation
-- (BBQ idle + prop_fish_slice_01 attached to the right hand).
-- ============================================================
Config.Anims = {
    grill = {
        dict = 'amb@prop_human_bbq@male@idle_a',
        clip = 'idle_b',
        prop = `prop_fish_slice_01`,
        bone = 57005,
        pos  = vector3(0.08, 0.0, -0.02),
        rot  = vector3(0.0, -25.0, 130.0),
    },
    fryer = {
        dict = 'amb@prop_human_bbq@male@idle_a',
        clip = 'idle_b',
        prop = nil,
    },
    prep = {
        dict = 'amb@prop_human_bbq@male@idle_a',
        clip = 'idle_b',
        prop = nil,
    },
    drinks = {
        dict = 'amb@prop_human_bbq@male@idle_a',
        clip = 'idle_b',
        prop = nil,
    },
}

-- ============================================================
-- RECIPES (each belongs to a station)
-- ingredients = items consumed, output = item produced.
-- ============================================================
Config.Recipes = {
    -- GRILL: cook raw patties
    cook_patty = {
        label = 'Cook Beef Patty',
        station = 'grill',
        time = 6000,
        ingredients = { { item = 'burgershot_frozenmeat', amount = 1 } },
        output = { item = 'burgershot_meat', amount = 1 },
    },

    -- FRYER: fry frozen sides
    fry_nuggets = {
        label = 'Fry Shot Nuggets',
        station = 'fryer',
        time = 6000,
        ingredients = { { item = 'burgershot_frozennuggets', amount = 1 } },
        output = { item = 'burgershot_shotnuggets', amount = 1 },
    },
    fry_rings = {
        label = 'Fry Onion Rings',
        station = 'fryer',
        time = 6000,
        ingredients = { { item = 'burgershot_frozenrings', amount = 1 } },
        output = { item = 'burgershot_shotrings', amount = 1 },
    },
    fry_largefries = {
        label = 'Fry Large Fries',
        station = 'fryer',
        time = 6000,
        ingredients = { { item = 'burgershot_bigfrozenpotato', amount = 1 } },
        output = { item = 'burgershot_patatob', amount = 1 },
    },
    fry_smallfries = {
        label = 'Fry Small Fries',
        station = 'fryer',
        time = 5000,
        ingredients = { { item = 'burgershot_smallfrozenpotato', amount = 1 } },
        output = { item = 'burgershot_patatos', amount = 1 },
    },

    -- PREP: assemble final products
    make_bleeder = {
        label = 'Bleeder Burger',
        station = 'prep',
        time = 4000,
        ingredients = {
            { item = 'burgershot_meat', amount = 1 },
            { item = 'burgershot_bread', amount = 1 },
            { item = 'burgershot_sauce', amount = 1 },
        },
        output = { item = 'burgershot_bleeder', amount = 1 },
    },
    make_bigking = {
        label = 'Big King Burger',
        station = 'prep',
        time = 5000,
        ingredients = {
            { item = 'burgershot_meat', amount = 2 },
            { item = 'burgershot_bread', amount = 1 },
            { item = 'burgershot_cheddar', amount = 1 },
            { item = 'burgershot_tomato', amount = 1 },
            { item = 'burgershot_sauce', amount = 1 },
        },
        output = { item = 'burgershot_bigking', amount = 1 },
    },
    make_goatwrap = {
        label = 'Goat Wrap',
        station = 'prep',
        time = 4000,
        ingredients = {
            { item = 'burgershot_meat', amount = 1 },
            { item = 'burgershot_tomato', amount = 1 },
            { item = 'burgershot_sauce', amount = 1 },
        },
        output = { item = 'burgershot_goatwrap', amount = 1 },
    },
    make_lavash = {
        label = 'Lavash Wrap',
        station = 'prep',
        time = 4000,
        ingredients = {
            { item = 'burgershot_meat', amount = 1 },
            { item = 'burgershot_cheddar', amount = 1 },
            { item = 'burgershot_sauce', amount = 1 },
        },
        output = { item = 'burgershot_lavash', amount = 1 },
    },

    -- DRINKS MACHINE: fill cups with soda / coffee (each needs an empty cup)
    make_smallcola = {
        label = 'Small Cola',
        station = 'drinks',
        time = 3000,
        ingredients = { { item = 'burgershot_smallemptyglass', amount = 1 } },
        output = { item = 'burgershot_colas', amount = 1 },
    },
    make_largecola = {
        label = 'Large Cola',
        station = 'drinks',
        time = 3500,
        ingredients = { { item = 'burgershot_bigemptyglass', amount = 1 } },
        output = { item = 'burgershot_colab', amount = 1 },
    },
    make_goatcola = {
        label = 'Goat Cola',
        station = 'drinks',
        time = 4000,
        ingredients = { { item = 'burgershot_bigemptyglass', amount = 1 } },
        output = { item = 'burgershot_colagoat', amount = 1 },
    },
    make_coffee = {
        label = 'Coffee',
        station = 'drinks',
        time = 3000,
        ingredients = { { item = 'burgershot_coffeeemptyglass', amount = 1 } },
        output = { item = 'burgershot_coffee', amount = 1 },
    },
}

-- ============================================================
-- INGREDIENT SUPPLY PEDS (paid, locked to the burgershot job)
-- Staff buy raw ingredients here. price = cost per single item.
-- blip is only drawn for burgershot members (handled in client.lua).
-- Both peds also sell the empty cups used by the drinks machine.
-- ============================================================
Config.BuyAmounts = { 1, 5, 10 }   -- quantity options offered per item

Config.SupplyPeds = {
    frozen = {
        label  = 'Frozen Supplies',
        model  = 'mp_m_shopkeep_01',
        coords = vector4(966.15, -1651.91, 29.42, 106.56),
        blip   = { sprite = 52, color = 3, scale = 0.6 },
        items  = {
            { item = 'burgershot_frozenmeat', price = 5 },
            { item = 'burgershot_frozennuggets', price = 5 },
            { item = 'burgershot_frozenrings', price = 5 },
            { item = 'burgershot_bigfrozenpotato', price = 5 },
            { item = 'burgershot_smallfrozenpotato', price = 5 },
            { item = 'burgershot_smallemptyglass', price = 2 },
            { item = 'burgershot_bigemptyglass', price = 2 },
            { item = 'burgershot_coffeeemptyglass', price = 2 },
        },
    },
    fresh = {
        label  = 'Fresh Supplies',
        model  = 'mp_m_shopkeep_01',
        coords = vector4(556.37, -1621.77, 28.38, 129.5),
        blip   = { sprite = 52, color = 2, scale = 0.6 },
        items  = {
            { item = 'burgershot_bread', price = 5 },
            { item = 'burgershot_cheddar', price = 5 },
            { item = 'burgershot_tomato', price = 5 },
            { item = 'burgershot_sauce', price = 5 },
            { item = 'burgershot_smallemptyglass', price = 2 },
            { item = 'burgershot_bigemptyglass', price = 2 },
            { item = 'burgershot_coffeeemptyglass', price = 2 },
        },
    },
}

-- ============================================================
-- STORAGES (job-locked qb-inventory stashes, members only)
-- Persistent + shared among all Burger Shot staff.
-- cold = frozen/chilled stock, normal = dry goods.
-- ============================================================
Config.Storages = {
    cold = {
        label     = 'Burger Shot Cold Storage',
        stashId   = 'burgershot_coldstorage',
        coords    = vector4(-580.57, -883.78, 26.0, 269.4),
        icon      = 'fas fa-snowflake',
        size      = vector3(1.4, 1.4, 1.0),
        maxweight = 1000000,
        slots     = 50,
    },
    normal = {
        label     = 'Burger Shot Storage',
        stashId   = 'burgershot_normalstorage',
        coords    = vector4(-580.87, -895.36, 26.0, 202.08),
        icon      = 'fas fa-box-open',
        size      = vector3(1.4, 1.4, 1.0),
        maxweight = 1000000,
        slots     = 50,
    },
}

-- ============================================================
-- BOSS MENU (qb-management)
-- Opens qb-bossmenu:client:OpenMenu. Only graded bosses
-- (Owner, isboss = true) can open it: hire/fire, promote/
-- demote, society storage & society funds.
-- ============================================================
Config.BossMenu = {
    coords = vector4(-582.67, -880.99, 26.0, 86.45),
    label  = 'Boss Menu',
    icon   = 'fas fa-user-tie',
    size   = vector3(1.0, 1.0, 1.0),
}
