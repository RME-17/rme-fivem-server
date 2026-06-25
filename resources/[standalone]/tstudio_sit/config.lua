-- ============================================
-- TStudio Sit — Configuration
-- ============================================

Config = {}

-- ── Mode ─────────────────────────────────────
-- Determines how interaction + notifications work.
-- One setting — no extra dependencies required for standalone.
--
--   "standalone"  — NUI prompt + NUI toast notifications (zero dependencies)
--   "ox"          — ox_target eye interaction + ox_lib notifications
--   "qb"          — qb-target eye interaction + QBCore notifications
--   "esx"         — NUI prompt interaction + ESX notifications
--
Config.Mode = 'standalone'

-- ── Key Binding ──────────────────────────────
-- Default key for sit/stand toggle (players can rebind in FiveM Settings → Key Bindings)
-- See: https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
Config.DefaultKey = 'E'

-- ── Prompt ───────────────────────────────────
-- NUI prompt text (used in standalone / esx modes)
Config.PromptSitText   = 'Sit Down'
Config.PromptStandText = 'Stand Up'

-- Where to display the NUI prompt on screen
-- "top-left" | "top-center" | "top-right" | "bottom-left" | "bottom-center" | "bottom-right"
Config.PromptPosition = 'bottom-center'

-- ── Target ───────────────────────────────────
-- Target eye icon + label (used in ox / qb modes)
Config.TargetIcon  = 'fas fa-chair'
Config.TargetLabel = 'Sit Down'

-- ── Detection ────────────────────────────────
-- How far (in GTA units) to scan for sittable props.
-- Keep this small — scanning uses GetClosestObjectOfType per model hash;
-- a smaller radius means faster engine-level lookups.
Config.ScanRadius = 5.0

-- Distance at which the interaction prompt appears and sit is allowed
Config.InteractionDistance = 1.5

-- ── Animation ────────────────────────────────
-- Fallback animation when a chair definition has none
Config.DefaultAnimation = {
    scenario = 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER',
}

-- ── Debug ────────────────────────────────────
Config.Debug = false

-- ── Chair Registry ───────────────────────────
-- Populated automatically by client/data_loader.lua
-- DO NOT edit manually — add data files to data/ instead
Config.Chairs = {}

-- ============================================
-- Editor (in-resource authoring tool)
-- Exposed under the global `EditorConfig` table so the editor scripts
-- under editor/ can read it without depending on the runtime `Config`
-- table directly. Everything below only matters if you actually use
-- `/sitedit` to author seats; trim or comment-out as you like.
-- ============================================

EditorConfig = {}

EditorConfig.VERSION = '1.0.0'

-- ── Editor entry-point ───────────────────────
-- The slash command exists only so RegisterKeyMapping has something
-- to bind. Open the editor with the keybind below; there is no
-- in-chat helper anymore. The scan toggle lives in the editor UI.
EditorConfig.UI = {
    command       = 'sitedit',
    keybind       = 'F6',
    keybindLabel  = 'Open TStudio Sit Editor',
    -- Server-side ACE permission required to open the editor.
    -- Grant with:  add_ace group.admin command.tstudio_sit_edit allow
    acePermission = 'command.tstudio_sit_edit',
}

-- ── Scanning ─────────────────────────────────
EditorConfig.SCAN_DEFAULTS = {
    radius        = 50.0,
    minRadius     = 1,
    maxRadius     = 50,
    smartFilter   = true,
    tickInterval  = 500,
    idleInterval  = 1000,
    -- When true, scanning works both inside interiors AND outdoors.
    -- When false, scanning auto-stops on interior exit.
    allowExterior = true,
}

EditorConfig.DUPLICATE_TOLERANCE = 0.5

-- ── Smart-filter prop name patterns ──────────
-- Substrings (case-insensitive) matched against GetEntityArchetypeName.
-- Beds/cots/sofas are folded in because the runtime engine handles
-- them all the same way (a model + seats).
EditorConfig.CHAIR_PATTERNS = {
    'chair', 'seat', 'bench', 'stool', 'couch', 'sofa',
    'barstool', 'lounger', 'pew', 'throne', 'armchair',
    'sit', 'cushion', 'recliner', 'settee', 'divan',
    'beanbag', 'hammock', 'swing_seat',
    'bed', 'mattress', 'stretcher', 'cot', 'bunk',
    'futon', 'sleeping_bag', 'sunbed',
}

EditorConfig.CHAIR_DEFAULTS = {
    pedOffset  = { x = 0.0, y = 0.0, z = 0.0 },
    -- Most GTA chair props have +Y pointing toward the chair's back, so
    -- a sitting ped must face -Y of the prop — i.e., chairHeading + 180°.
    -- The editor stores headings *relative* to the prop, so the default is 180.
    pedHeading = 180.0,
    animIndex  = 1,
}

EditorConfig.MAX_SEATS_PER_CHAIR = 5

-- ── Animation library used by the editor's seat dropdown ──
-- Indexes line up 1:1 with the NUI dropdown. On export each seat
-- resolves to either { scenario = ... } or { dict = ..., clip = ... }.
EditorConfig.CHAIR_ANIMATIONS = {
    { label = 'Chair (MP)',      scenario = 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER' },
    { label = 'Chair',           scenario = 'PROP_HUMAN_SEAT_CHAIR' },
    { label = 'Chair Upright',   scenario = 'PROP_HUMAN_SEAT_CHAIR_UPRIGHT' },
    { label = 'Bench',           scenario = 'PROP_HUMAN_SEAT_BENCH' },
    { label = 'Armchair',        scenario = 'PROP_HUMAN_SEAT_ARMCHAIR' },
    { label = 'Bar Stool',       scenario = 'PROP_HUMAN_SEAT_BAR' },
    { label = 'Deck Chair',      scenario = 'PROP_HUMAN_SEAT_DECKCHAIR' },
    { label = 'Strip Watch',     scenario = 'PROP_HUMAN_SEAT_STRIP_WATCH' },
    { label = 'Sun Lounger',     scenario = 'PROP_HUMAN_SEAT_SUNLOUNGER' },
    { label = 'Bus Stop',        scenario = 'PROP_HUMAN_SEAT_BUS_STOP_WAIT' },
    { label = 'Ledge',           scenario = 'WORLD_HUMAN_SEAT_LEDGE' },
    { label = 'Picnic',          scenario = 'WORLD_HUMAN_PICNIC' },
    { label = 'Sunbathe',        scenario = 'WORLD_HUMAN_SUNBATHE' },
    { label = 'Sunbathe (Back)', scenario = 'WORLD_HUMAN_SUNBATHE_BACK' },
    { label = 'Yoga',            scenario = 'WORLD_HUMAN_YOGA' },
    { label = 'Sit (Phone)',     dict = 'anim@amb@business@bgen@bgen_no_work@', anim = 'sit_phone_phoneputdown_idle_nowork' },
    { label = 'Sunlounger (F)',  dict = 'amb@prop_human_seat_sunlounger@female@idle_a', anim = 'idle_a' },
    { label = 'Sunlounger (M)',  dict = 'amb@prop_human_seat_sunlounger@male@base', anim = 'base' },
}

EditorConfig.GIZMO = {
    pedModel = 'a_m_y_hipster_01',
}

EditorConfig.EXPORT = {
    coordPrecision   = 4,
    headingPrecision = 2,
}