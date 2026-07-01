Config = {}

-- Admin command to open the placement / manage menu (server-side gates the actual
-- place/remove to admins, so it is safe to leave open).
Config.Command = 'rmecraft'

-- Eye interaction appearance
Config.TargetIcon = 'fas fa-hammer'
Config.TargetLabel = 'Use %s'   -- %s = bench label
Config.TargetDistance = 2.0

Config.DefaultCraftTime = 5000  -- ms, used when a recipe has no `time`

--[[
    BENCH TYPES
    -----------
    A placed bench references one of these by its key. Recipes live here (NOT in the
    database), so you edit recipes by editing this file and restarting the resource.

    access:
      'public'  -> anyone
      'job'     -> set accessValue = 'jobname' (and optional accessGrade = minGrade)
      'gang'    -> set accessValue = 'gangname'

    recipe:
      output    = item to give
      amount    = how many to give
      time      = craft time in ms (optional)
      materials = { { item = 'x', amount = n }, ... }  -- consumed on craft

    IMPORTANT: the item names below are EXAMPLES using common qb-core items.
    Change them to match YOUR server's items (qb-core shared items + rme-items,
    e.g. your mining outputs like copperore/ironore/goldingot, etc.).
]]
Config.BenchTypes = {
    ['workbench'] = {
        label = 'Workbench',
        prop = 'gr_prop_gr_bench_04a',
        access = 'public',
        recipes = {
            { output = 'lockpick', amount = 1, time = 5000,
              materials = { { item = 'metalscrap', amount = 3 }, { item = 'plastic', amount = 2 } } },
            { output = 'advancedlockpick', amount = 1, time = 8000,
              materials = { { item = 'metalscrap', amount = 6 }, { item = 'aluminum', amount = 3 }, { item = 'plastic', amount = 2 } } },
        },
    },

    ['mechbench'] = {
        label = 'Mechanic Bench',
        prop = 'gr_prop_gr_bench_04a',
        access = 'job',
        accessValue = 'mechanic',
        accessGrade = 0,
        recipes = {
            { output = 'repairkit', amount = 1, time = 10000,
              materials = { { item = 'steel', amount = 5 }, { item = 'aluminum', amount = 5 }, { item = 'plastic', amount = 3 } } },
        },
    },
}
