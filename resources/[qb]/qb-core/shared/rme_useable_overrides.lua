-- RME: force-enable the inventory 'Use' option on items that other resources
-- register a useable handler for (e.g. the Redline mechanic tablet).
--
-- qb-inventory only shows/fires 'Use' when the item's useable flag is truthy,
-- and it reads that flag from QBCore.Shared.Items. This file runs INSIDE qb-core
-- right after shared/items.lua + rme_custom_items.lua, so the flag is already
-- true before qb-inventory (or any other resource) ever builds its item list.
-- Doing the flip here (instead of in qb-mechanicjob, which starts later) makes
-- the 'Use' option reliable regardless of resource start order.

QBCore = QBCore or {}
QBCore.Shared = QBCore.Shared or {}
QBCore.Shared.Items = QBCore.Shared.Items or {}

local ForceUseable = {
    'tablet',
}

for _, name in ipairs(ForceUseable) do
    if QBCore.Shared.Items[name] then
        QBCore.Shared.Items[name].useable = true
        QBCore.Shared.Items[name].shouldClose = true
    end
end
