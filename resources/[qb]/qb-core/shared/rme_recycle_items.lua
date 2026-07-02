-- RME: recycling job item. The recycler now hands out sealed "Scrap Boxes";
-- players open them at the recycling worker to get raw materials, or sell the
-- boxes to mechanics/gangs. Loaded by qb-core after shared/items.lua.

QBCore = QBCore or {}
QBCore.Shared = QBCore.Shared or {}
QBCore.Shared.Items = QBCore.Shared.Items or {}

QBCore.Shared.Items['recycle_box'] = {
    name = 'recycle_box',
    label = 'Scrap Box',
    weight = 2000,
    type = 'item',
    image = 'recycle.png',
    unique = false,
    useable = false,
    shouldClose = true,
    description = 'A sealed box of scrap. Open it at the recycling bin for materials, or sell it to a mechanic.'
}
