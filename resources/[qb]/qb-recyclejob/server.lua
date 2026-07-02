local QBCore = exports['qb-core']:GetCoreObject({ 'Functions' })
local sharedItems = exports['qb-core']:GetShared('Items')

-- Materials a Scrap Box can contain when opened with the recycling worker.
local Materials = { 'metalscrap', 'plastic', 'copper', 'rubber', 'iron', 'aluminum', 'steel', 'glass' }

local function distanceTo(src, loc)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return 9999.0 end
    return #(GetEntityCoords(ped) - vector3(loc.x, loc.y, loc.z))
end

-- Player handed in a carried box at the armory crate -> receive 1-5 sealed Scrap Boxes.
RegisterNetEvent('qb-recyclejob:server:getBoxes', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if distanceTo(src, Config.CrateLocation) > 6.0 then return end

    local amount = math.random(Config.BoxesPerDrop.min, Config.BoxesPerDrop.max)
    if Player.Functions.AddItem(Config.BoxItem, amount) then
        TriggerClientEvent('qb-inventory:client:ItemBox', src, sharedItems[Config.BoxItem], 'add', amount)
        TriggerClientEvent('QBCore:Notify', src, ('You packed %dx Scrap Box.'):format(amount), 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'You cannot carry any more boxes.', 'error')
    end
end)

-- Player opens a Scrap Box with the worker -> consume 1 box, get 3-10 random materials.
RegisterNetEvent('qb-recyclejob:server:openBox', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if distanceTo(src, Config.PedLocation) > 6.0 then return end

    local box = Player.Functions.GetItemByName(Config.BoxItem)
    if not box or box.amount < 1 then
        TriggerClientEvent('QBCore:Notify', src, 'You have no Scrap Boxes to open.', 'error')
        return
    end
    if not Player.Functions.RemoveItem(Config.BoxItem, 1) then return end
    TriggerClientEvent('qb-inventory:client:ItemBox', src, sharedItems[Config.BoxItem], 'remove', 1)

    local total = math.random(Config.MaterialsPerBox.min, Config.MaterialsPerBox.max)
    local remaining = total
    while remaining > 0 do
        local mat = Materials[math.random(1, #Materials)]
        local chunk = math.random(1, math.max(1, math.ceil(total / 2)))
        if chunk > remaining then chunk = remaining end
        Player.Functions.AddItem(mat, chunk)
        if sharedItems[mat] then TriggerClientEvent('qb-inventory:client:ItemBox', src, sharedItems[mat], 'add', chunk) end
        remaining = remaining - chunk
    end
    TriggerClientEvent('QBCore:Notify', src, ('Opened a Scrap Box: %d materials.'):format(total), 'success')
end)
