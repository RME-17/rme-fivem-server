-- rme-items: registers custom items that are NOT in qb-core/shared/items.lua
-- Loaded as a shared_script so the items exist on BOTH the server (for
-- giving/crafting) and every client (so menus like qb-crafting can read their
-- label/image without crashing).

-- RME FIX: do NOT call GetCoreObject() at parse time. When this shared_script
-- loaded before qb-core had finished registering its exports, line 6 threw
-- "No such export GetCoreObject in resource qb-core" and crashed rme-items.
-- QBCore is resolved safely inside the thread below once qb-core has started.
local QBCore = nil

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
    gold_earrings = {
        name = 'gold_earrings',
        label = 'Gold Earrings',
        weight = 500,
        type = 'item',
        image = 'gold_earring_128x128_17.png',
        unique = false,
        useable = false,
        shouldClose = true,
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
        description = 'A pair of diamond-studded silver earrings.'
    },
}

CreateThread(function()
    -- Wait until qb-core is fully started and its shared item table exists.
    while GetResourceState('qb-core') ~= 'started' do Wait(100) end
    if not QBCore then QBCore = exports['qb-core']:GetCoreObject() end
    while not (QBCore and QBCore.Shared and QBCore.Shared.Items) do
        Wait(100)
        QBCore = exports['qb-core']:GetCoreObject()
    end

    for name, item in pairs(CustomItems) do
        if IsDuplicityVersion() then
            -- Server: use the official export (registers + broadcasts).
            local ok = pcall(function() exports['qb-core']:AddItem(name, item) end)
            if not ok then QBCore.Shared.Items[name] = item end
        end
        -- Ensure the local shared table has it on BOTH server and client so
        -- qb-crafting (which reads QBCore.Shared.Items directly) always finds it.
        QBCore.Shared.Items[name] = item
    end

    print('[rme-items] Custom items registered (' .. (IsDuplicityVersion() and 'server' or 'client') .. ')')
end)
