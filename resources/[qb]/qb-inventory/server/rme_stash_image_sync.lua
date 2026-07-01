-- RME: qb-inventory stored-image self-heal.
--
-- qb-inventory snapshots an item's `image` (plus label/weight/etc.) into the saved
-- stash JSON at the moment the item is added, and it never re-resolves those fields
-- from QBCore.Shared.Items when a stash is opened (see server/main.lua loading the
-- `inventories` table straight into the Inventories cache, and functions.lua
-- OpenInventory sending inventory.items as-is). Any item placed into a stash before
-- its image field existed -- e.g. the Redline mechanic parts (spray_can, car_wheel,
-- body_kit, xenon_bulb, tyre_smoke_kit, neon_kit, tint_roll, plate_kit) -- therefore
-- keeps a stale/empty image and renders as a blank icon forever.
--
-- On resource start we walk every cached stash, refresh each item's static display
-- fields from the current item definition, and persist the result so the fix
-- survives future restarts. Player inventories and shops already re-resolve fresh,
-- so only stashes need this.

CreateThread(function()
    -- Wait until the shared item list is populated.
    while not QBCore or not QBCore.Shared or not QBCore.Shared.Items or not next(QBCore.Shared.Items) do
        Wait(250)
    end

    -- Give server/main.lua's initial 'SELECT * FROM inventories' query time to
    -- populate the in-memory Inventories cache.
    Wait(2500)

    if not Inventories then return end

    local refreshed = 0
    for identifier, inventory in pairs(Inventories) do
        if inventory and inventory.items and next(inventory.items) then
            local changed = false
            for _, item in pairs(inventory.items) do
                if item and item.name then
                    local itemInfo = QBCore.Shared.Items[tostring(item.name):lower()]
                    if itemInfo then
                        item.image = itemInfo.image
                        item.label = itemInfo.label
                        item.description = itemInfo.description or ''
                        item.weight = itemInfo.weight
                        item.type = itemInfo.type
                        item.unique = itemInfo.unique
                        item.useable = itemInfo.useable
                        item.shouldClose = itemInfo.shouldClose
                        item.combinable = itemInfo.combinable
                        changed = true
                    end
                end
            end
            if changed then
                refreshed = refreshed + 1
                MySQL.prepare(
                    'INSERT INTO inventories (identifier, items) VALUES (?, ?) ON DUPLICATE KEY UPDATE items = ?',
                    { identifier, json.encode(inventory.items), json.encode(inventory.items) }
                )
            end
        end
    end

    print(('[rme] qb-inventory stash image sync complete -- %d stash(es) refreshed'):format(refreshed))
end)
