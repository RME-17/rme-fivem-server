-- rme-items: registers custom items that are NOT in qb-core/shared/items.lua
-- Loaded as a shared_script so the item exists on BOTH the server (for
-- giving/crafting) and every client (so menus like qb-crafting can read its
-- label/image without crashing).

local QBCore = exports['qb-core']:GetCoreObject()

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
