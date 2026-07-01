-- RME Redline: which physical inventory item each cosmetic category consumes.
--
-- A Redline member must carry the matching part in their inventory to apply that
-- cosmetic from the tablet (this also applies when fulfilling a customer order).
-- One item is consumed per successful apply. Turning something OFF, or setting a
-- mod/wheel back to Stock/None, never consumes a part.
--
-- Set RequirePartItems = false to disable this system entirely (free clicking).

Config = Config or {}

Config.RequirePartItems = true

-- keyed by the tablet action 'kind'
Config.PartItems = {
    paint = { item = 'spray_can',      label = 'Spray Can' },
    wheel = { item = 'car_wheel',      label = 'Vehicle Wheel' },
    mod   = { item = 'body_kit',       label = 'Body Part' }, -- exterior + interior mods
    xenon = { item = 'xenon_bulb',     label = 'Xenon Bulb' },
    smoke = { item = 'tyre_smoke_kit', label = 'Tyre Smoke Kit' },
    neon  = { item = 'neon_kit',       label = 'Neon Kit' },
    tint  = { item = 'tint_roll',      label = 'Window Tint Roll' },
    plate = { item = 'plate_kit',      label = 'Plate Kit' },
}

-- Price charged per cosmetic CATEGORY on a customer order. The order builder
-- adds these up into ONE total shown at submit time; the member tablet then
-- shows that same single total on the order (never per-click amounts). A
-- category is only billed once no matter how many tweaks it includes, and is
-- skipped entirely when turned OFF / set back to Stock.
Config.CosmeticPrices = {
    paint = 1500,
    wheel = 5000,
    mod   = 4000,
    xenon = 800,
    neon  = 2500,
    smoke = 1200,
    tint  = 1000,
    plate = 900,
}

-- Shared Redline parts stash. The boss installs crafted spray cans / parts here
-- and members draw from it. Opened from the physical box at the shop and from the
-- Storage tab in the member tablet. maxweight is in grams.
Config.RedlineStorage = {
    stash     = 'redline_storage',
    label     = 'Redline Parts Storage',
    maxweight = 400000,
    slots     = 50,
    coords    = vector3(1161.6, -779.9, 57.6),
}
