Config = {}

Config.Command = 'mapper'
Config.Permission = 'admin'
Config.SpawnDistance = 3.0
Config.RaycastDistance = 30.0
Config.DefaultModel = 'prop_barrel_01a'
Config.HideRadius = 2.0

-- Searchable quick-pick list shown in the Spawn menu.
-- Add your own lines anytime: { label = 'What you see', model = 'prop_model_name' }
-- Invalid models are rejected automatically with a notification, so feel free to experiment.
Config.PropList = {
    -- Mechanic / Benny's
    { label = 'Toolbox (red chest 1)', model = 'prop_toolchest_01' },
    { label = 'Toolbox (red chest 2)', model = 'prop_toolchest_02' },
    { label = 'Toolbox (red chest 3)', model = 'prop_toolchest_03' },
    { label = 'Toolbox (red chest 4)', model = 'prop_toolchest_04' },
    { label = 'Toolbox (small, interior)', model = 'v_ind_cftoolbox' },
    { label = 'Workbench', model = 'prop_tool_bench02' },
    { label = 'Tool trolley', model = 'prop_tool_bench02b' },
    { label = 'Oil drum', model = 'prop_oltank_01' },
    { label = 'Jerry / gas can', model = 'prop_gascan_01a' },
    { label = 'Engine block', model = 'prop_engine_01' },
    { label = 'Car battery', model = 'prop_car_battery_01' },
    { label = 'Paint can', model = 'prop_paints_can01' },
    { label = 'Air compressor', model = 'prop_air_compressor_01' },
    { label = 'Fire extinguisher', model = 'prop_fire_exting_1a' },

    -- Tyres & wheels
    { label = 'Tyre (single)', model = 'prop_tyre_03' },
    { label = 'Tyre stack', model = 'prop_tyres_stack_03' },
    { label = 'Wheel rim', model = 'prop_wheel_01' },

    -- Barrels, boxes, pallets
    { label = 'Barrel (metal)', model = 'prop_barrel_01a' },
    { label = 'Barrel (oil)', model = 'prop_barrel_02a' },
    { label = 'Wooden crate', model = 'prop_box_wood02a_pu' },
    { label = 'Crate pile', model = 'prop_boxpile_07d' },
    { label = 'Pallet', model = 'prop_pallet_02a' },
    { label = 'Cardboard box', model = 'prop_cardbordbox_05a' },

    -- Cones, signs, barriers
    { label = 'Traffic cone', model = 'prop_roadcone02a' },
    { label = 'Traffic cone (small)', model = 'prop_roadcone01a' },
    { label = 'Barrier (metal)', model = 'prop_barrier_work05' },
    { label = 'Road sign', model = 'prop_sign_road_01a' },

    -- Furniture / decor
    { label = 'Bench', model = 'prop_bench_01a' },
    { label = 'Office chair', model = 'prop_cs_office_chair' },
    { label = 'Chair (plastic)', model = 'prop_chair_01a' },
    { label = 'Table', model = 'prop_table_03' },
    { label = 'Soda vending machine', model = 'prop_vend_soda_01' },
    { label = 'Flatscreen TV', model = 'prop_tv_flat_01' },
    { label = 'Plant (potted)', model = 'prop_plant_int_01a' },
    { label = 'Ladder', model = 'prop_ladder_01a' },
    { label = 'Street light', model = 'prop_streetlight_01' },
}
