Config = {}

-- Interaction tuning.
Config.MarkerDistance = 8.0  -- how close before the floor marker shows
Config.UseDistance    = 1.4  -- how close before you can press E to use it
Config.TickMs         = 3000 -- grant XP every this many ms while working out
Config.WorkoutSeconds = 60   -- each workout auto-stops after this many seconds; press E to start another set

-- ---------------------------------------------------------------------------
-- Gym membership: players must buy a pass before they can use any station.
-- Bought from the front-desk ped (third-eye / qb-target). Persists on the
-- character (survives relog) and expires after `duration` seconds. While the
-- player is inside the gym a countdown timer shows the time remaining.
-- ---------------------------------------------------------------------------
Config.Membership = {
    price    = 1000,           -- cost of a membership
    duration = 3600,           -- how long it lasts, in seconds (3600 = 1 hour)
    pedModel = 'a_m_y_business_01', -- front-desk attendant model (change if you like)
    -- Default ped spawn point. Reposition live with /gymsetped (admin) - stand
    -- exactly where you want the attendant and run it; the ped plants its feet
    -- on the floor automatically.
    pedCoords = vector4(746.06, -891.81, 25.44, 330.78),
    -- Fine-tune the ped height (metres). Use a +value if it sinks into the
    -- floor, or a -value if it floats above it, on your MLO.
    pedZOffset = 1.0,
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
-- tick (every Config.TickMs), and can train more than one skill at once.
--
-- Trainable skills: running, swimming, shooting, driving, flying, stamina, strength
--
-- LEVELLING PACE (deliberately a slow grind so working out actually feels like
-- effort): rme-playerstats is capped at Lv5 and a skill needs 1000 total XP to
-- fully max (100/200/300/400 per level). XP ticks every 3s, so at 1 XP/tick a
-- skill takes ~50 min of solid working out to max (heavy lifts at 2/tick ~25
-- min); the first level alone is ~5 min. Want it faster/slower? Raise/lower
-- these numbers or lower/raise Config.TickMs.
Config.Stations = {
    treadmill = {
        label = 'Treadmill',
        scenario = 'WORLD_HUMAN_JOG_STANDING',
        train = { running = 1, stamina = 1 },
    },
    freeweights = {
        label = 'Free Weights',
        scenario = 'WORLD_HUMAN_MUSCLE_FREE_WEIGHTS',
        train = { strength = 2 },
    },
    pushups = {
        label = 'Push-ups',
        scenario = 'WORLD_HUMAN_PUSH_UPS',
        train = { strength = 1, stamina = 1 },
    },
    yoga = {
        label = 'Yoga Mat',
        scenario = 'WORLD_HUMAN_YOGA',
        train = { stamina = 1 },
    },
    benchpress = {
        label = 'Bench Press',
        scenario = 'WORLD_HUMAN_MUSCLE_FREE_WEIGHTS',
        train = { strength = 2 },
    },
    situps = {
        label = 'Sit-ups',
        scenario = 'WORLD_HUMAN_SIT_UPS',
        train = { strength = 1, stamina = 1 },
    },
    punchingbag = {
        label = 'Punching Bag',
        scenario = 'WORLD_HUMAN_MUSCLE_FLEX',
        train = { strength = 1, shooting = 1 },
    },
    stationarybike = {
        label = 'Exercise Bike',
        scenario = 'WORLD_HUMAN_JOG_STANDING',
        train = { stamina = 1, running = 1 },
    },
}
