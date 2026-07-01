local QBCore = exports['qb-core']:GetCoreObject()
local Benches = {}

local function isAdmin(src)
    if QBCore.Functions.HasPermission(src, 'admin') or QBCore.Functions.HasPermission(src, 'god') then
        return true
    end
    return IsPlayerAceAllowed(src, 'command')
end

local function decodeRecipes(str)
    if not str or str == '' then return {} end
    local ok, decoded = pcall(json.decode, str)
    if ok and type(decoded) == 'table' then return decoded end
    return {}
end

local function benchPayload(b)
    return {
        id = b.id, prop = b.prop, label = b.label,
        x = b.x, y = b.y, z = b.z, heading = b.heading,
        access = b.access, accessValue = b.accessValue, accessGrade = b.accessGrade,
        recipes = b.recipes or {},
    }
end

CreateThread(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `rme_crafting_benches` (
            `id` INT NOT NULL AUTO_INCREMENT,
            `prop` VARCHAR(64) NOT NULL DEFAULT 'gr_prop_gr_bench_04a',
            `label` VARCHAR(64) NOT NULL DEFAULT 'Workbench',
            `x` FLOAT NOT NULL, `y` FLOAT NOT NULL, `z` FLOAT NOT NULL,
            `heading` FLOAT NOT NULL DEFAULT 0,
            `access` VARCHAR(16) NOT NULL DEFAULT 'public',
            `access_value` VARCHAR(64) DEFAULT NULL,
            `access_grade` INT NOT NULL DEFAULT 0,
            `recipes` LONGTEXT DEFAULT NULL,
            `placed_by` VARCHAR(64) DEFAULT NULL,
            `created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        )
    ]])
    -- Upgrade a v1 table if it exists (MariaDB supports IF NOT EXISTS on columns).
    for _, clause in ipairs({
        "ADD COLUMN IF NOT EXISTS `prop` VARCHAR(64) NOT NULL DEFAULT 'gr_prop_gr_bench_04a'",
        "ADD COLUMN IF NOT EXISTS `label` VARCHAR(64) NOT NULL DEFAULT 'Workbench'",
        "ADD COLUMN IF NOT EXISTS `access` VARCHAR(16) NOT NULL DEFAULT 'public'",
        "ADD COLUMN IF NOT EXISTS `access_value` VARCHAR(64) DEFAULT NULL",
        "ADD COLUMN IF NOT EXISTS `access_grade` INT NOT NULL DEFAULT 0",
        "ADD COLUMN IF NOT EXISTS `recipes` LONGTEXT DEFAULT NULL",
    }) do
        pcall(function() MySQL.query.await('ALTER TABLE `rme_crafting_benches` ' .. clause) end)
    end

    local rows = MySQL.query.await('SELECT * FROM rme_crafting_benches') or {}
    for _, r in ipairs(rows) do
        Benches[r.id] = {
            id = r.id, prop = r.prop, label = r.label,
            x = r.x, y = r.y, z = r.z, heading = r.heading,
            access = r.access, accessValue = r.access_value, accessGrade = r.access_grade,
            recipes = decodeRecipes(r.recipes),
        }
    end
    print(('^2[rme-crafting]^7 Loaded %d bench(es).'):format(#rows))
end)

RegisterNetEvent('rme-crafting:server:requestBenches', function()
    local list = {}
    for _, b in pairs(Benches) do list[#list + 1] = benchPayload(b) end
    TriggerClientEvent('rme-crafting:client:syncBenches', source, list)
end)

-- data: { id?, prop, label, access, accessValue, accessGrade, recipes, x?, y?, z?, heading? }
RegisterNetEvent('rme-crafting:server:saveBench', function(data)
    local src = source
    if not isAdmin(src) then return end
    if type(data) ~= 'table' then return end
    local recipesJson = json.encode(data.recipes or {})

    if data.id and Benches[data.id] then
        local b = Benches[data.id]
        b.prop = data.prop or b.prop
        b.label = data.label or b.label
        b.access = data.access or 'public'
        b.accessValue = data.accessValue
        b.accessGrade = tonumber(data.accessGrade) or 0
        b.recipes = data.recipes or {}
        MySQL.update.await('UPDATE rme_crafting_benches SET prop=?, label=?, access=?, access_value=?, access_grade=?, recipes=? WHERE id=?', {
            b.prop, b.label, b.access, b.accessValue, b.accessGrade, recipesJson, b.id
        })
        TriggerClientEvent('rme-crafting:client:updateBench', -1, benchPayload(b))
        TriggerClientEvent('QBCore:Notify', src, 'Bench saved.', 'success')
    else
        if not data.x or not data.y or not data.z then return end
        local Player = QBCore.Functions.GetPlayer(src)
        local id = MySQL.insert.await('INSERT INTO rme_crafting_benches (prop,label,x,y,z,heading,access,access_value,access_grade,recipes,placed_by) VALUES (?,?,?,?,?,?,?,?,?,?,?)', {
            data.prop or 'gr_prop_gr_bench_04a', data.label or 'Workbench', data.x, data.y, data.z, data.heading or 0.0,
            data.access or 'public', data.accessValue, tonumber(data.accessGrade) or 0, recipesJson,
            (Player and Player.PlayerData.citizenid) or 'unknown'
        })
        if id then
            Benches[id] = {
                id = id, prop = data.prop or 'gr_prop_gr_bench_04a', label = data.label or 'Workbench',
                x = data.x, y = data.y, z = data.z, heading = data.heading or 0.0,
                access = data.access or 'public', accessValue = data.accessValue, accessGrade = tonumber(data.accessGrade) or 0,
                recipes = data.recipes or {},
            }
            TriggerClientEvent('rme-crafting:client:spawnBench', -1, benchPayload(Benches[id]))
            TriggerClientEvent('QBCore:Notify', src, 'Bench placed.', 'success')
        end
    end
end)

RegisterNetEvent('rme-crafting:server:deleteBench', function(id)
    local src = source
    if not isAdmin(src) then return end
    id = tonumber(id)
    if not id or not Benches[id] then return end
    MySQL.query.await('DELETE FROM rme_crafting_benches WHERE id=?', { id })
    Benches[id] = nil
    TriggerClientEvent('rme-crafting:client:removeBench', -1, id)
    TriggerClientEvent('QBCore:Notify', src, 'Bench removed.', 'success')
end)

RegisterNetEvent('rme-crafting:server:craft', function(benchId, recipeIndex)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local b = Benches[tonumber(benchId)]
    if not b then return end
    local recipe = b.recipes[tonumber(recipeIndex)]
    if not recipe then return end

    if b.access == 'job' then
        if Player.PlayerData.job.name ~= b.accessValue or (b.accessGrade and Player.PlayerData.job.grade.level < b.accessGrade) then
            TriggerClientEvent('QBCore:Notify', src, 'You cannot use this bench.', 'error'); return
        end
    elseif b.access == 'gang' then
        if not Player.PlayerData.gang or Player.PlayerData.gang.name ~= b.accessValue then
            TriggerClientEvent('QBCore:Notify', src, 'You cannot use this bench.', 'error'); return
        end
    end

    for _, m in ipairs(recipe.materials or {}) do
        local item = Player.Functions.GetItemByName(m.item)
        if not item or item.amount < (m.amount or 1) then
            TriggerClientEvent('QBCore:Notify', src, 'You do not have the required materials.', 'error'); return
        end
    end
    for _, m in ipairs(recipe.materials or {}) do
        Player.Functions.RemoveItem(m.item, m.amount or 1)
        local d = QBCore.Shared.Items[m.item]
        if d then TriggerClientEvent('qb-inventory:client:ItemBox', src, d, 'remove') end
    end

    local added = Player.Functions.AddItem(recipe.output, recipe.amount or 1)
    local outData = QBCore.Shared.Items[recipe.output]
    if added and outData then
        TriggerClientEvent('qb-inventory:client:ItemBox', src, outData, 'add')
        TriggerClientEvent('QBCore:Notify', src, ('Crafted %dx %s.'):format(recipe.amount or 1, outData.label or recipe.output), 'success')
    else
        for _, m in ipairs(recipe.materials or {}) do Player.Functions.AddItem(m.item, m.amount or 1) end
        TriggerClientEvent('QBCore:Notify', src, 'Inventory full - craft cancelled.', 'error')
    end
end)
