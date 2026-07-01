local QBCore = exports['qb-core']:GetCoreObject()
local Benches = {}   -- id -> { id, benchtype, x, y, z, heading }

local function isAdmin(src)
    if QBCore.Functions.HasPermission(src, 'admin') or QBCore.Functions.HasPermission(src, 'god') then
        return true
    end
    return IsPlayerAceAllowed(src, 'command')
end

local function benchCount()
    local n = 0
    for _ in pairs(Benches) do n = n + 1 end
    return n
end

CreateThread(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `rme_crafting_benches` (
            `id` INT NOT NULL AUTO_INCREMENT,
            `benchtype` VARCHAR(50) NOT NULL,
            `x` FLOAT NOT NULL,
            `y` FLOAT NOT NULL,
            `z` FLOAT NOT NULL,
            `heading` FLOAT NOT NULL DEFAULT 0,
            `placed_by` VARCHAR(64) DEFAULT NULL,
            `created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        )
    ]])
    local rows = MySQL.query.await('SELECT * FROM rme_crafting_benches') or {}
    for _, r in ipairs(rows) do
        Benches[r.id] = { id = r.id, benchtype = r.benchtype, x = r.x, y = r.y, z = r.z, heading = r.heading }
    end
    print(('^2[rme-crafting]^7 Loaded %d bench(es) from the database.'):format(#rows))
end)

RegisterNetEvent('rme-crafting:server:requestBenches', function()
    TriggerClientEvent('rme-crafting:client:syncBenches', source, Benches)
end)

RegisterNetEvent('rme-crafting:server:placeBench', function(benchType, coords)
    local src = source
    if not isAdmin(src) then return end
    if not Config.BenchTypes[benchType] then return end
    if type(coords) ~= 'table' and type(coords) ~= 'vector4' then return end
    local x, y, z, w = coords.x, coords.y, coords.z, coords.w or 0.0
    if not x or not y or not z then return end
    local Player = QBCore.Functions.GetPlayer(src)
    local placedBy = (Player and Player.PlayerData.citizenid) or 'unknown'
    local id = MySQL.insert.await('INSERT INTO rme_crafting_benches (benchtype, x, y, z, heading, placed_by) VALUES (?, ?, ?, ?, ?, ?)', {
        benchType, x, y, z, w, placedBy
    })
    if id then
        Benches[id] = { id = id, benchtype = benchType, x = x, y = y, z = z, heading = w }
        TriggerClientEvent('rme-crafting:client:spawnBench', -1, Benches[id])
        TriggerClientEvent('QBCore:Notify', src, 'Bench placed.', 'success')
    end
end)

RegisterNetEvent('rme-crafting:server:removeBench', function(id)
    local src = source
    if not isAdmin(src) then return end
    id = tonumber(id)
    if not id or not Benches[id] then return end
    MySQL.query.await('DELETE FROM rme_crafting_benches WHERE id = ?', { id })
    Benches[id] = nil
    TriggerClientEvent('rme-crafting:client:removeBench', -1, id)
    TriggerClientEvent('QBCore:Notify', src, 'Bench removed.', 'success')
end)

RegisterNetEvent('rme-crafting:server:craft', function(benchType, index)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local t = Config.BenchTypes[benchType]
    local recipe = t and t.recipes[tonumber(index)]
    if not recipe then return end

    -- access re-check (anti-exploit)
    if t.access == 'job' then
        if Player.PlayerData.job.name ~= t.accessValue or (t.accessGrade and Player.PlayerData.job.grade.level < t.accessGrade) then
            TriggerClientEvent('QBCore:Notify', src, 'You are not allowed to use this bench.', 'error'); return
        end
    elseif t.access == 'gang' then
        if not Player.PlayerData.gang or Player.PlayerData.gang.name ~= t.accessValue then
            TriggerClientEvent('QBCore:Notify', src, 'You are not allowed to use this bench.', 'error'); return
        end
    end

    -- verify materials
    for _, m in ipairs(recipe.materials) do
        local item = Player.Functions.GetItemByName(m.item)
        if not item or item.amount < m.amount then
            TriggerClientEvent('QBCore:Notify', src, 'You do not have the required materials.', 'error'); return
        end
    end

    -- consume materials
    for _, m in ipairs(recipe.materials) do
        Player.Functions.RemoveItem(m.item, m.amount)
        local itemData = QBCore.Shared.Items[m.item]
        if itemData then TriggerClientEvent('qb-inventory:client:ItemBox', src, itemData, 'remove') end
    end

    -- give output
    local added = Player.Functions.AddItem(recipe.output, recipe.amount or 1)
    local outData = QBCore.Shared.Items[recipe.output]
    if added and outData then
        TriggerClientEvent('qb-inventory:client:ItemBox', src, outData, 'add')
        TriggerClientEvent('QBCore:Notify', src, ('Crafted %dx %s.'):format(recipe.amount or 1, outData.label or recipe.output), 'success')
    else
        -- refund materials if the output could not be added (e.g. full inventory)
        for _, m in ipairs(recipe.materials) do
            Player.Functions.AddItem(m.item, m.amount)
        end
        TriggerClientEvent('QBCore:Notify', src, 'Inventory full - craft cancelled.', 'error')
    end
end)
