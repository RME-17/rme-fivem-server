-- RME Redline: one-shot admin restock for the shared Redline parts storage.
--
-- Run  /fillredline  in-game as an admin to completely stock the Redline Parts
-- Storage with every physical cosmetic part the tablet / order builder can
-- consume. It is safe to run repeatedly -- it RESETS the stash to a full, known
-- stock and writes it straight to the qb-inventory `inventories` table so the
-- stock survives a server restart (qb-inventory otherwise only auto-saves a
-- stash when it is closed or on shutdown).

local QBCore = exports['qb-core']:GetCoreObject()

-- item -> how many to stock. Covers every 'kind' in Config.PartItems:
--   paint  -> spray_can       wheel -> car_wheel
--   mod    -> body_kit  (exterior + interior + performance mods)
--   xenon  -> xenon_bulb      smoke -> tyre_smoke_kit
--   neon   -> neon_kit        tint  -> tint_roll        plate -> plate_kit
local RESTOCK = {
    { item = 'spray_can',      amount = 100 },
    { item = 'car_wheel',      amount = 100 },
    { item = 'body_kit',       amount = 100 },
    { item = 'xenon_bulb',     amount = 100 },
    { item = 'tyre_smoke_kit', amount = 100 },
    { item = 'neon_kit',       amount = 100 },
    { item = 'tint_roll',      amount = 100 },
    { item = 'plate_kit',      amount = 100 },
}

local function stockRedlineStorage()
    local cfg = Config.RedlineStorage
    if not cfg or not cfg.stash then return false, 'Config.RedlineStorage missing' end

    -- Ensure the stash exists in memory. A stash loaded from the DB on start only
    -- has { items, isOpen } set, so we (re)apply label/maxweight/slots every time
    -- -- otherwise AddItem's weight check reads a nil maxweight and errors.
    local inv = exports['qb-inventory']:GetInventory(cfg.stash)
    if not inv then
        exports['qb-inventory']:CreateInventory(cfg.stash, {
            label = cfg.label, maxweight = cfg.maxweight, slots = cfg.slots,
        })
        inv = exports['qb-inventory']:GetInventory(cfg.stash)
    end
    if not inv then return false, 'could not create stash' end
    inv.label = cfg.label
    inv.maxweight = cfg.maxweight
    inv.slots = cfg.slots

    -- Reset to a clean, known-full stock so repeated runs don't pile up / drift.
    inv.items = {}

    local slot = 1
    for _, entry in ipairs(RESTOCK) do
        if QBCore.Shared.Items[entry.item] then
            exports['qb-inventory']:AddItem(cfg.stash, entry.item, entry.amount, slot, {}, 'redline restock')
            slot = slot + 1
        else
            print(('[redline] restock skipped unknown item: %s'):format(entry.item))
        end
    end

    -- Persist immediately (same upsert qb-inventory uses on close/shutdown).
    MySQL.prepare('INSERT INTO inventories (identifier, items) VALUES (?, ?) ON DUPLICATE KEY UPDATE items = ?',
        { cfg.stash, json.encode(inv.items), json.encode(inv.items) })

    return true
end

QBCore.Commands.Add('fillredline', 'Fully stock the Redline parts storage (Admin Only)', {}, false, function(source)
    local ok, err = stockRedlineStorage()
    if ok then
        TriggerClientEvent('QBCore:Notify', source, 'Redline Parts Storage fully stocked', 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Could not stock Redline storage: ' .. tostring(err), 'error')
    end
end, 'admin')
