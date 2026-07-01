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
