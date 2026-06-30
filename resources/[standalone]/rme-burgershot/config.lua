Config = {}

-- Require the Burger Shot job to use the cooking stations?
-- Keep false while testing so anyone can cook. Set true once the job is set up.
Config.RequireJob = false
Config.JobName    = 'burgershot'

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
}
