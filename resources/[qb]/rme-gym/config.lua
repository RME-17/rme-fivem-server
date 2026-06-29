Config = {}

-- Interaction tuning.
Config.MarkerDistance = 8.0  -- how close before the floor marker shows
Config.UseDistance    = 1.4  -- how close before you can press E to use it
Config.TickMs         = 2000 -- grant XP every this many ms while working out

-- ---------------------------------------------------------------------------
-- Gym membership: players must buy a pass before they can use any station.
-- Bought from the front-desk ped (third-eye / qb-target). Persists on the
-- character (survives relog) and expires after `duration` seconds.
-- ---------------------------------------------------------------------------
Config.Membership = {
    price    = 1000,           -- cost of a membership
    duration = 3600,           -- how long it lasts, in seconds (3600 = 1 hour)
    pedModel = 'a_m_y_business_01', -- front-desk attendant model (change if you like)
    -- Default ped spawn point. Reposition live with /gymsetped (admin) - that
    -- captures your exact position so the ped stands correctly.
    pedCoords = vector4(746.06, -891.81, 25.44, 330.78),
}

-- Prop models the free-weights / bench scenarios spawn in the player's hands.
-- When a workout ends these are swept up near the player so nothing is left
-- lying on the floor.
Config.WeightProps = {
    'prop_curl_bar_01', 'prop_dumbbell_01', 'prop_dumbell_01',
    'prop_v_bbell_01', 'prop_weight_set', 'prop_gym_bench_01',
    'prop_barbell_01', 'prop_barbell_02',
}

-- Workout station types. Each placed station references one of these by key.
-- `scenario` is the GTA ambient animation played while working out (purely
-- cosmetic - the XP is granted regardless). `train` is the skill XP granted per
-- tick, and can train more than one skill at once.
--
-- Trainable skills: running, swimming, shooting, driving, flying, stamina, strength
--
-- To place a station: stand at the equipment and type /gymadd <key>
Config.Stations = {
    treadmill = {
        label = 'Treadmill',
        scenario = 'WORLD_HUMAN_JOG_STANDING',
        train = { running = 8, stamina = 6 },
    },
    freeweights = {
        label = 'Free Weights',
        scenario = 'WORLD_HUMAN_MUSCLE_FREE_WEIGHTS',
        train = { strength = 12 },
    },
    pushups = {
        label = 'Push-ups',
        scenario = 'WORLD_HUMAN_PUSH_UPS',
        train = { strength = 8, stamina = 4 },
    },
    yoga = {
        label = 'Yoga Mat',
        scenario = 'WORLD_HUMAN_YOGA',
        train = { stamina = 10 },
    },
    benchpress = {
        label = 'Bench Press',
        scenario = 'WORLD_HUMAN_MUSCLE_FREE_WEIGHTS',
        train = { strength = 14 },
    },
    situps = {
        label = 'Sit-ups',
        scenario = 'WORLD_HUMAN_SIT_UPS',
        train = { strength = 6, stamina = 6 },
    },
    punchingbag = {
        label = 'Punching Bag',
        scenario = 'WORLD_HUMAN_MUSCLE_FLEX',
        train = { strength = 8, shooting = 2 },
    },
    stationarybike = {
        label = 'Exercise Bike',
        scenario = 'WORLD_HUMAN_JOG_STANDING',
        train = { stamina = 10, running = 4 },
    },
}
