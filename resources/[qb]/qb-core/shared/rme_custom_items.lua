-- RME custom items, merged natively into QBCore.Shared.Items.
-- Loaded right AFTER shared/items.lua in the qb-core fxmanifest so these run in
-- qb-core's own runtime and are guaranteed present for every other resource
-- (qb-crafting, qb-pawnshop, qb-inventory, etc.) without needing a separate
-- resource to be started or to propagate across the resource boundary.

QBCore = QBCore or {}
QBCore.Shared = QBCore.Shared or {}
QBCore.Shared.Items = QBCore.Shared.Items or {}

local RMECustomItems = {
    diamond_chain = {
        name = 'diamond_chain',
        label = 'Diamond Chain',
        weight = 2000,
        type = 'item',
        image = 'diamond_chain.png',
        unique = false,
        useable = false,
        shouldClose = true,
        combinable = nil,
        description = 'An ice-cold diamond-encrusted chain. Pure flex.'
    },
    gold_earrings = {
        name = 'gold_earrings',
        label = 'Gold Earrings',
        weight = 500,
        type = 'item',
        image = 'gold_earring_128x128_17.png',
        unique = false,
        useable = false,
        shouldClose = true,
        combinable = nil,
        description = 'A glistening pair of solid gold earrings.'
    },
    diamond_earrings = {
        name = 'diamond_earrings',
        label = 'Diamond Earrings',
        weight = 500,
        type = 'item',
        image = 'diamond_earring_silver_128x128_15.png',
        unique = false,
        useable = false,
        shouldClose = true,
        combinable = nil,
        description = 'A pair of diamond-studded silver earrings.'
    },
}

for name, item in pairs(RMECustomItems) do
    QBCore.Shared.Items[name] = item
end
