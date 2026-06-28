-- Registers custom items at runtime so we don't have to edit qb-core/shared/items.lua directly.
-- Waits for qb-core to be started, then adds each item via the AddItem export.

local CustomItems = {
    diamond_chain = {
        name = 'diamond_chain',
        label = 'Diamond Chain',
        weight = 2000,
        type = 'item',
        image = 'diamond_chain.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'An ice-cold diamond-encrusted chain. Pure flex.'
    },
}

CreateThread(function()
    while GetResourceState('qb-core') ~= 'started' do
        Wait(200)
    end
    Wait(500)
    for name, item in pairs(CustomItems) do
        local ok, reason = exports['qb-core']:AddItem(name, item)
        if ok then
            print(('[rme-items] Registered custom item: %s'):format(name))
        elseif reason == 'item_exists' then
            print(('[rme-items] Item already exists, skipping: %s'):format(name))
        else
            print(('[rme-items] Failed to register %s (%s)'):format(name, tostring(reason)))
        end
    end
end)
