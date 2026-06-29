Config = {}

-- How often (seconds) stats are auto-saved to the database while playing.
Config.SaveInterval = 120

-- Skill level curve. Levels run from 1 to MaxLevel. Each level L needs
-- (PerLevelBase * L) XP to reach L+1, so higher levels take progressively
-- longer. With MaxLevel = 5 and PerLevelBase = 100 the totals are:
--   Lv1->2: 100 | Lv2->3: 200 | Lv3->4: 300 | Lv4->5: 400  (1000 XP to max)
Config.MaxLevel = 5
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
-- at ~1.49, so those are the bonus on top of 1.0 at max level (Lv5). Perks
-- scale linearly with level: Lv1 = no bonus, Lv5 = the full bonus below.
Config.Perks = {
    maxRunBonus    = 0.49, -- +49% sprint speed at Lv5 Running
    maxSwimBonus   = 0.49, -- +49% swim speed at Lv5 Swimming
    maxMeleeBonus  = 1.00, -- +100% melee damage at Lv5 Strength
}

-- Stamina perk: how long your (boosted) run/swim speed lasts before you tire.
-- While sprinting or swimming we restore a little stamina every 0.4s, scaled by
-- your Stamina LEVEL:
--   * Level 1 (untrained): restores nothing - you tire at the normal rate.
--   * It ramps up linearly with level, so each level holds the speed longer.
--   * At `fullLevel` (and above) the top-up matches the drain, so sprint is
--     effectively endless.
-- Quick tuning:
--   * Want endless sprint to arrive sooner -> lower fullLevel (e.g. 4)
--   * Even max stamina still runs out too soon -> raise maxRestore (e.g. 0.09)
--   * Sprint feels infinite too early          -> lower maxRestore (e.g. 0.05)
Config.Stamina = {
    fullLevel  = 5,    -- Stamina level at which sprint becomes effectively endless (= MaxLevel)
    maxRestore = 0.07, -- stamina restored per 0.4s tick at fullLevel and above
}

-- Inactivity decay: skill stats slowly regress the longer a player is away.
-- Applied when they next load in, based on real time since their last save, so
-- daily players (within graceDays) lose nothing but someone gone for a week
-- comes back weaker.
Config.Decay = {
    perDay    = 0.04, -- ~4% lost per day of inactivity (a week away ~= -22%)
    graceDays = 1.0,  -- no decay for the first day away
    floor     = 0.10, -- never drop below 10% of accumulated progress
    keys = {          -- which counters regress (skill-driving stats + training)
        'run_distance', 'sprint_distance', 'swim_distance',
        'drive_distance', 'fly_distance',
        'shots_fired', 'shots_hit', 'kills',
        'bonus_running', 'bonus_swimming', 'bonus_shooting',
        'bonus_driving', 'bonus_flying', 'bonus_stamina', 'bonus_strength',
    },
}
