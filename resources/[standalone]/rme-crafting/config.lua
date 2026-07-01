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

-- Bench props selectable in the Basic tab (add any prop model names you like).
Config.Props = {
    'gr_prop_gr_bench_04a',
    'gr_prop_gr_bench_03b',
    'prop_tool_bench02',
    'prop_toolchest_04',
    'prop_toolchest_05',
}

-- Item categories for the recipe item picker. Any item not listed here shows
-- under "Other". Edit these to match YOUR server's items. The picker still shows
-- EVERY server item (with its qb-inventory image) regardless of category.
Config.ItemCategories = {
    ['Ores & Raw'] = { 'copperore','ironore','goldore','silverore','carbon','stone','coal','metalscrap','plastic','aluminum','steel','copper','iron','rubber','glass' },
    ['Ingots & Gems'] = { 'goldingot','silveringot','uncut_emerald','uncut_ruby','uncut_sapphire','uncut_diamond','diamond','emerald','ruby','sapphire' },
    ['Jewelry'] = { 'gold_ring','silver_ring','silverchain','goldearring','silverearring','diamond_necklace' },
    ['Tools'] = { 'goldpan','pickaxe','miningdrill','mininglaser','drillbit','lockpick','advancedlockpick','repairkit','drill','screwdriverset' },
}
