Config = {}

-- Interaction tuning.
Config.MarkerDistance = 8.0  -- how close before the floor marker shows
Config.UseDistance    = 1.4  -- how close before you can press E to use it
Config.TickMs         = 2000 -- grant XP every this many ms while working out

-- Workout station types. Each placed station references one of these by key.
-- `scenario` is the GTA ambient animation played while working out (purely
-- cosmetic - the XP is granted regardless). `train` is the skill XP granted per
-- tick, and can train more than one skill at once.
--
-- Trainable skills: running, swimming, shooting, driving, flying, stamina, strength
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
}
