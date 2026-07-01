-- RME: Redline mechanic part items.
--
-- These are the physical parts a Redline member must carry in their inventory to
-- apply a cosmetic from the mechanic tablet. One matching part is consumed each
-- time an item is applied (see qb-mechanicjob/config/rme_parts.lua for the
-- category -> item mapping, and server/tablet.lua for the consume logic).
--
-- Registered here inside qb-core so the items exist in QBCore.Shared.Items
-- before qb-inventory builds its item list.
--
-- NOTE: drop matching PNG icons into qb-inventory/html/images/ using the same
-- file names below (e.g. spray_can.png) or the item will show a broken image.
-- The system works fine without the icons.

QBCore = QBCore or {}
QBCore.Shared = QBCore.Shared or {}
QBCore.Shared.Items = QBCore.Shared.Items or {}

local RedlineParts = {
    spray_can      = { name = 'spray_can',      label = 'Spray Can',        weight = 800,  type = 'item', image = 'spray_can.png',      unique = false, useable = false, shouldClose = false, combinable = nil, description = 'A can of automotive spray paint. Used by Redline to repaint a vehicle.' },
    car_wheel      = { name = 'car_wheel',      label = 'Vehicle Wheel',    weight = 4000, type = 'item', image = 'car_wheel.png',      unique = false, useable = false, shouldClose = false, combinable = nil, description = 'A replacement or upgrade wheel. Used by Redline to fit new rims.' },
    body_kit       = { name = 'body_kit',       label = 'Body Part',        weight = 3000, type = 'item', image = 'body_kit.png',       unique = false, useable = false, shouldClose = false, combinable = nil, description = 'A bodywork, exterior or interior part. Used by Redline for body and interior mods.' },
    xenon_bulb     = { name = 'xenon_bulb',     label = 'Xenon Bulb',       weight = 300,  type = 'item', image = 'xenon_bulb.png',     unique = false, useable = false, shouldClose = false, combinable = nil, description = 'A xenon headlight bulb kit. Used by Redline to fit headlights.' },
    tyre_smoke_kit = { name = 'tyre_smoke_kit', label = 'Tyre Smoke Kit',   weight = 500,  type = 'item', image = 'tyre_smoke_kit.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = 'A coloured tyre smoke kit. Used by Redline to fit tyre smoke.' },
    neon_kit       = { name = 'neon_kit',       label = 'Neon Kit',         weight = 1200, type = 'item', image = 'neon_kit.png',       unique = false, useable = false, shouldClose = false, combinable = nil, description = 'An underglow neon kit. Used by Redline to fit neons.' },
    tint_roll      = { name = 'tint_roll',      label = 'Window Tint Roll', weight = 600,  type = 'item', image = 'tint_roll.png',      unique = false, useable = false, shouldClose = false, combinable = nil, description = 'A roll of window tint film. Used by Redline to tint windows.' },
    plate_kit      = { name = 'plate_kit',      label = 'Plate Kit',        weight = 400,  type = 'item', image = 'plate_kit.png',      unique = false, useable = false, shouldClose = false, combinable = nil, description = 'A number plate style kit. Used by Redline to change plate style.' },
}

for name, item in pairs(RedlineParts) do
    QBCore.Shared.Items[name] = item
end
