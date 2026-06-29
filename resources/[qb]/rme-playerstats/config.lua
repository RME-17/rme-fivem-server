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
    hit            = 3,    -- Shooting skill, per FIREARM shot that lands on a ped
    kill           = 12,   -- Strength skill, per takedown
    staminaSprint  = 0.05, -- Stamina skill, per metre sprinted
    staminaSwim    = 0.08, -- Stamina skill, per metre swum
}

-- Gameplay perks granted by skill level. Perks scale LINEARLY with level so
-- Lv1 is the normal (vanilla) speed - no bonus at all - and the full bonus
-- below is only reached at Lv5. Steps for run/swim at +0.15:
--   Lv1 +0%  |  Lv2 +3.75%  |  Lv3 +7.5%  |  Lv4 +11.25%  |  Lv5 +15%
-- Engine caps the run/swim multipliers at ~1.49 (so keep these well under 0.49).
Config.Perks = {
    maxRunBonus    = 0.15, -- +15% sprint speed at Lv5 Running (Lv1 = normal speed)
    maxSwimBonus   = 0.15, -- +15% swim speed at Lv5 Swimming (Lv1 = normal speed)
    maxMeleeBonus  = 1.00, -- +100% melee damage at Lv5 Strength (does not affect movement)
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

-- 'Use it or lose it' decay, tied to ACTIVE time in the city - NOT real-world
-- time away. Stats only bleed down while the player is connected and spawned in
-- (Stats are loaded). Being offline, on another server, or otherwise away from
-- the city never reduces anything. While actively playing, every skill-driving
-- counter slowly trickles down, so players must keep training to hold a level.
Config.Decay = {
    enabled         = true,
    perActiveHour   = 0.06, -- fraction of progress lost per HOUR actively in the city (~6%/hr)
    intervalSeconds = 60,   -- apply a slice of the decay this often while active
    keys = {                -- which counters regress (skill-driving stats + training)
        'run_distance', 'sprint_distance', 'swim_distance',
        'drive_distance', 'fly_distance',
        'shots_fired', 'shots_hit', 'kills',
        'bonus_running', 'bonus_swimming', 'bonus_shooting',
        'bonus_driving', 'bonus_flying', 'bonus_stamina', 'bonus_strength',
    },
}
