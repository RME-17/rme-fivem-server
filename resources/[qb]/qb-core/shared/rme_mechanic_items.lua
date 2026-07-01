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
-- NOTE: the image fields below point at existing vehicle-mod icons already in
-- qb-inventory/html/images/ (veh_exterior.png, veh_wheels.png, etc.) as close
-- matches, so the parts show a sensible icon instead of a broken image. Swap in
-- dedicated art later if desired using the same file-name pattern.

QBCore = QBCore or {}
QBCore.Shared = QBCore.Shared or {}
QBCore.Shared.Items = QBCore.Shared.Items or {}

local RedlineParts = {
    spray_can      = { name = 'spray_can',      label = 'Spray Can',        weight = 800,  type = 'item', image = 'veh_exterior.png',   unique = false, useable = false, shouldClose = false, combinable = nil, description = 'A can of automotive spray paint. Used by Redline to repaint a vehicle.' },
    car_wheel      = { name = 'car_wheel',      label = 'Vehicle Wheel',    weight = 4000, type = 'item', image = 'veh_wheels.png',     unique = false, useable = false, shouldClose = false, combinable = nil, description = 'A replacement or upgrade wheel. Used by Redline to fit new rims.' },
    body_kit       = { name = 'body_kit',       label = 'Body Part',        weight = 3000, type = 'item', image = 'veh_exterior.png',   unique = false, useable = false, shouldClose = false, combinable = nil, description = 'A bodywork, exterior or interior part. Used by Redline for body and interior mods.' },
    xenon_bulb     = { name = 'xenon_bulb',     label = 'Xenon Bulb',       weight = 300,  type = 'item', image = 'veh_xenons.png',     unique = false, useable = false, shouldClose = false, combinable = nil, description = 'A xenon headlight bulb kit. Used by Redline to fit headlights.' },
    tyre_smoke_kit = { name = 'tyre_smoke_kit', label = 'Tyre Smoke Kit',   weight = 500,  type = 'item', image = 'veh_wheels.png',     unique = false, useable = false, shouldClose = false, combinable = nil, description = 'A coloured tyre smoke kit. Used by Redline to fit tyre smoke.' },
    neon_kit       = { name = 'neon_kit',       label = 'Neon Kit',         weight = 1200, type = 'item', image = 'veh_neons.png',      unique = false, useable = false, shouldClose = false, combinable = nil, description = 'An underglow neon kit. Used by Redline to fit neons.' },
    tint_roll      = { name = 'tint_roll',      label = 'Window Tint Roll', weight = 600,  type = 'item', image = 'veh_tint.png',       unique = false, useable = false, shouldClose = false, combinable = nil, description = 'A roll of window tint film. Used by Redline to tint windows.' },
    plate_kit      = { name = 'plate_kit',      label = 'Plate Kit',        weight = 400,  type = 'item', image = 'veh_plates.png',     unique = false, useable = false, shouldClose = false, combinable = nil, description = 'A number plate style kit. Used by Redline to change plate style.' },
}

for name, item in pairs(RedlineParts) do
    QBCore.Shared.Items[name] = item
end
