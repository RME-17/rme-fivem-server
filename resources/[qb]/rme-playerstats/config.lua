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
    maxRunBonus  = 0.49, -- +49% sprint speed at max Running level
    maxSwimBonus = 0.49, -- +49% swim speed at max Swimming level
}
