Config = {}

Config.Command = 'mapper'
Config.Permission = 'admin'
Config.SpawnDistance = 3.0
Config.RaycastDistance = 30.0
Config.DefaultModel = 'prop_barrel_01a'
Config.HideRadius = 2.0

-- Steps used by the "Precise nudge / rotate" tool.
Config.NudgeStep = 0.25
Config.RotateStep = 15.0

-- Catalog shown in the Spawn menu, grouped by category.
-- Add your own anytime: { label = 'What you see', model = 'prop_model_name' }
-- The Spawn menu also has a "model name" box and a search box, so you can place
-- ANY prop without editing this file. Invalid models are rejected automatically.
Config.Catalog = {
    {
        category = "Benny's parts (needs the Bennys resource running)",
        items = {
            { label = 'Car lift (Benny 1)', model = 'lr_supermod_carlift' },
            { label = 'Car lift (Benny 2)', model = 'lr_supermod_carlift2' },
            { label = 'Engine hoist', model = 'lr_smod_engine_hoist_001' },
            { label = 'Car creeper', model = 'lr_smod_carcreeper_001' },
            { label = 'Weld machine', model = 'lr_smodd_cm_weldmachine_001' },
            { label = 'Heat lamp', model = 'lr_smodd_cm_heatlamp_001' },
            { label = 'Standing panel', model = 'lr_smodd_cm_panelstd_001' },
            { label = 'Compressor 1', model = 'lr_smod_compressor_01_001' },
            { label = 'Compressor 2', model = 'lr_smod_compressor_02_001' },
            { label = 'Compressor 3', model = 'lr_smod_compressor_03' },
            { label = 'Toolchest 02', model = 'lr_smod_toolchest_02_001' },
            { label = 'Toolchest 05', model = 'lr_smod_toolchest_05_001' },
            { label = 'Toolchest 05b', model = 'lr_smod_toolchest_05_002' },
            { label = 'Toolchest 9', model = 'lr_smod_toolchest9' },
            { label = 'Toolbox 2', model = 'lr_smod_cs_toolbox2_001' },
            { label = 'Tool tray', model = 'lr_smod_cs_tray02_001' },
            { label = 'Drill', model = 'lr_smod_cs_drill_001' },
            { label = 'Jerry can', model = 'lr_smod_cs_jerrycan01_001' },
            { label = 'Oil can', model = 'lr_smod_oilcan_01a_001' },
            { label = 'Barrel', model = 'lr_smod_barrel_01a_001' },
            { label = 'Car seat', model = 'lr_smod_car_seat_001' },
            { label = 'Sack truck', model = 'lr_smod_sacktruck_02a_001' },
            { label = 'Coiled hose', model = 'lr_smod_cor_hose_001' },
            { label = 'Socket set', model = 'lr_smodr_2socket_001' },
            { label = 'Banner 1', model = 'lr_supermod_banners1' },
            { label = 'Banner 2', model = 'lr_supermod_banners2' },
            { label = 'Banner 3', model = 'lr_supermod_banners3' },
            { label = 'Banner 4', model = 'lr_supermod_banners004' },
            { label = 'Roof beams 1', model = 'lr_supermod_beams1' },
            { label = 'Roof beams 2', model = 'lr_supermod_beams2' },
            { label = 'Display Banshee', model = 'lr_supermod_banshee' },
            { label = 'Display Cheetah', model = 'lr_supermod_cheetah' },
        },
    },
    {
        category = 'Walls & structure',
        items = {
            { label = 'Wall panel - clean (4m)', model = 'prop_test_boundary_4m' },
            { label = 'Wall panel - clean (1m)', model = 'prop_test_boundary_1m' },
            { label = 'Construction hoarding 1', model = 'prop_fnc_construct_01a' },
            { label = 'Construction hoarding 2', model = 'prop_fnc_construct_02a' },
            { label = 'Wooden hoarding wall', model = 'prop_fncwood_16e' },
            { label = 'Concrete wall section', model = 'prop_conc_sectionb_01a' },
            { label = 'Jersey barrier (concrete)', model = 'prop_mp_conc_block' },
            { label = 'Security barrier', model = 'prop_sec_barier_02a' },
            { label = 'Metal barrier (heavy)', model = 'prop_barrier_work06a' },
            { label = 'Metal barrier', model = 'prop_barrier_work05' },
            { label = 'Chain-link fence (straight)', model = 'prop_fnclink_03e' },
            { label = 'Chain-link fence (corner)', model = 'prop_fnclink_03crnr1' },
            { label = 'Shipping container (room shell)', model = 'prop_container_01a' },
            { label = 'Scaffold pole', model = 'prop_scaffold_pole_2b' },
        },
    },
    {
        category = 'Doors & gates',
        items = {
            { label = 'Sliding gate (metal)', model = 'prop_facgate_03b' },
            { label = 'Prison sliding gate', model = 'prop_gate_prison_01' },
        },
    },
    {
        category = 'Lighting',
        items = {
            { label = 'Work light (tripod)', model = 'prop_worklight_01a' },
            { label = 'Site flood lights', model = 'prop_air_lights_02a' },
            { label = 'Wall light', model = 'prop_wall_light_10a' },
            { label = 'Street light', model = 'prop_streetlight_01' },
        },
    },
    {
        category = 'Mechanic equipment',
        items = {
            { label = 'Toolbox (red chest 1)', model = 'prop_toolchest_01' },
            { label = 'Toolbox (red chest 2)', model = 'prop_toolchest_02' },
            { label = 'Toolbox (red chest 3)', model = 'prop_toolchest_03' },
            { label = 'Toolbox (red chest 4)', model = 'prop_toolchest_04' },
            { label = 'Toolbox (small)', model = 'v_ind_cftoolbox' },
            { label = 'Workbench', model = 'prop_tool_bench02' },
            { label = 'Tool trolley', model = 'prop_tool_bench02b' },
            { label = 'Oil drum', model = 'prop_oltank_01' },
            { label = 'Jerry / gas can', model = 'prop_gascan_01a' },
            { label = 'Engine block', model = 'prop_engine_01' },
            { label = 'Car battery', model = 'prop_car_battery_01' },
            { label = 'Paint can', model = 'prop_paints_can01' },
            { label = 'Air compressor', model = 'prop_air_compressor_01' },
            { label = 'Fire extinguisher', model = 'prop_fire_exting_1a' },
        },
    },
    {
        category = 'Tyres & wheels',
        items = {
            { label = 'Tyre (single)', model = 'prop_tyre_03' },
            { label = 'Tyre stack', model = 'prop_tyres_stack_03' },
            { label = 'Wheel rim', model = 'prop_wheel_01' },
        },
    },
    {
        category = 'Barrels, boxes & pallets',
        items = {
            { label = 'Barrel (metal)', model = 'prop_barrel_01a' },
            { label = 'Barrel (oil)', model = 'prop_barrel_02a' },
            { label = 'Wooden crate', model = 'prop_box_wood02a_pu' },
            { label = 'Crate pile', model = 'prop_boxpile_07d' },
            { label = 'Pallet', model = 'prop_pallet_02a' },
            { label = 'Cardboard box', model = 'prop_cardbordbox_05a' },
        },
    },
    {
        category = 'Furniture & decor',
        items = {
            { label = 'Bench', model = 'prop_bench_01a' },
            { label = 'Office chair', model = 'prop_cs_office_chair' },
            { label = 'Chair (plastic)', model = 'prop_chair_01a' },
            { label = 'Table', model = 'prop_table_03' },
            { label = 'Soda vending machine', model = 'prop_vend_soda_01' },
            { label = 'Flatscreen TV', model = 'prop_tv_flat_01' },
            { label = 'Plant (potted)', model = 'prop_plant_int_01a' },
            { label = 'Ladder', model = 'prop_ladder_01a' },
        },
    },
    {
        category = 'Signs, cones & barriers',
        items = {
            { label = 'Traffic cone', model = 'prop_roadcone02a' },
            { label = 'Traffic cone (small)', model = 'prop_roadcone01a' },
            { label = 'Road sign', model = 'prop_sign_road_01a' },
        },
    },
}
