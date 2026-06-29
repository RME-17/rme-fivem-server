Config = {}

-- How often (seconds) stats are auto-saved to the database while playing.
Config.SaveInterval = 120

-- Skill level curve. Each level L needs (PerLevelBase * L) XP to reach L+1, so
-- higher levels take progressively longer. Capped at MaxLevel.
Config.MaxLevel = 100
Config.PerLevelBase = 100

-- How raw activity converts into skill XP (tweak freely).
Config.Xp = {
    sprintPerMeter = 0.10, -- Running skill, while sprinting
    joggPerMeter   = 0.03, -- Running skill, normal on-foot movement
    swimPerMeter   = 0.20, -- Swimming skill
    drivePerMeter  = 0.02, -- Driving skill
    flyPerMeter    = 0.015, -- Flying skill
    hit            = 3,    -- Shooting skill, per shot that lands on a ped
    kill           = 12,   -- Strength skill, per takedown
    staminaSprint  = 0.05, -- Stamina skill, per metre sprinted
    staminaSwim    = 0.08, -- Stamina skill, per metre swum
}

-- Gameplay perks granted by skill level. Engine caps the run/swim multipliers
-- at ~1.49, so these are the bonus on top of 1.0 at max level.
Config.Perks = {
    maxRunBonus    = 0.49, -- +49% sprint speed at max Running level
    maxSwimBonus   = 0.49, -- +49% swim speed at max Swimming level
    staminaRestore = 0.60, -- max stamina restored per tick at max Stamina level
                           -- (uses a squared curve, so low levels barely help)
}

-- Inactivity decay: skill stats slowly regress the longer a player is away.
-- Applied when they next load in, based on real time since their last save, so
-- daily players (within graceDays) lose nothing but someone gone for a week
-- comes back weaker.
Config.Decay = {
    perDay    = 0.04, -- ~4% lost per day of inactivity (a week away ~= -22%)
    graceDays = 1.0,  -- no decay for the first day away
    floor     = 0.10, -- never drop below 10% of accumulated progress
    keys = {          -- which counters regress (skill-driving stats)
        'run_distance', 'sprint_distance', 'swim_distance',
        'drive_distance', 'fly_distance',
        'shots_fired', 'shots_hit', 'kills',
    },
}
