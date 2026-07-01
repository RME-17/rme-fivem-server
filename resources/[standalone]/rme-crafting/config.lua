Config = {}

-- Admin command to open the creator panel (server-side gates place/save/delete to admins).
Config.Command = 'rmecraft'

-- Eye interaction
Config.TargetIcon = 'fas fa-hammer'
Config.TargetDistance = 2.0
Config.DefaultCraftTime = 5000 -- ms fallback

-- UI theme (blue + green). Change these hex values to recolor the whole UI.
Config.Theme = {
    primary = '#3B82F6', -- blue
    accent  = '#22C55E', -- green
}

-- Crafting XP / levels. Level = floor(totalXP / perLevel). Recipes can require a
-- minimum level (set per recipe in the creator). This is a single global crafting
-- level per player, stored in QBCore metadata ('craftingxp').
Config.XP = {
    enabled = true,
    perLevel = 100,   -- XP needed per level
    maxLevel = 100,
    defaultGain = 5,  -- default XP per successful craft (recipes can override)
}

-- Skill-check minigame (ox_lib). Set enabled=false to fall back to a plain timer only.
Config.SkillCheck = {
    enabled = true,
    difficulty = { 'easy', 'easy', 'medium' },
    inputs = { 'w', 'a', 's', 'd' },
}

-- Suggested recipe categories (shown in the creator's category dropdown). You can
-- also type a custom category. The craft menu groups recipes by these.
Config.RecipeCategories = { 'General', 'Tools', 'Jewelry', 'Ammo', 'Materials', 'Food', 'Misc' }

-- Bench props selectable in the Basic tab.
Config.Props = {
    'gr_prop_gr_bench_04a',
    'gr_prop_gr_bench_03b',
    'prop_tool_bench02',
    'prop_toolchest_04',
    'prop_toolchest_05',
}

-- Item categories for the recipe item picker. Any item not listed shows under
-- "Other". The picker still shows EVERY server item (with its qb-inventory image).
Config.ItemCategories = {
    ['Ores & Raw'] = { 'copperore','ironore','goldore','silverore','carbon','stone','coal','metalscrap','plastic','aluminum','steel','copper','iron','rubber','glass' },
    ['Ingots & Gems'] = { 'goldingot','silveringot','uncut_emerald','uncut_ruby','uncut_sapphire','uncut_diamond','diamond','emerald','ruby','sapphire' },
    ['Jewelry'] = { 'gold_ring','silver_ring','silverchain','goldearring','silverearring','diamond_necklace' },
    ['Tools'] = { 'goldpan','pickaxe','miningdrill','mininglaser','drillbit','lockpick','advancedlockpick','repairkit','drill','screwdriverset' },
}
