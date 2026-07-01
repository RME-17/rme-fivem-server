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

local function getLevel(xp)
    return math.floor((xp or 0) / (Config.XP.perLevel or 100))
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
        local moved = false
        if data.x and data.y and data.z then
            b.x, b.y, b.z, b.heading = data.x, data.y, data.z, data.heading or b.heading
            moved = true
        end
        if moved then
            MySQL.update.await('UPDATE rme_crafting_benches SET prop=?, label=?, access=?, access_value=?, access_grade=?, recipes=?, x=?, y=?, z=?, heading=? WHERE id=?', {
                b.prop, b.label, b.access, b.accessValue, b.accessGrade, recipesJson, b.x, b.y, b.z, b.heading, b.id
            })
        else
            MySQL.update.await('UPDATE rme_crafting_benches SET prop=?, label=?, access=?, access_value=?, access_grade=?, recipes=? WHERE id=?', {
                b.prop, b.label, b.access, b.accessValue, b.accessGrade, recipesJson, b.id
            })
        end
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

local function canAccess(Player, access, accessValue, accessGrade)
    if not access or access == 'public' then return true end
    if access == 'job' then
        return Player.PlayerData.job.name == accessValue and (not accessGrade or Player.PlayerData.job.grade.level >= accessGrade)
    elseif access == 'gang' then
        return Player.PlayerData.gang and Player.PlayerData.gang.name == accessValue
    end
    return true
end

RegisterNetEvent('rme-crafting:server:craft', function(benchId, index, qty)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local b = Benches[tonumber(benchId)]
    if not b then return end
    local recipe = b.recipes[tonumber(index)]
    if not recipe then return end
    qty = math.max(1, math.min(tonumber(qty) or 1, 20))

    -- access (per-recipe overrides bench; 'inherit'/nil = use bench)
    local access, accessValue, accessGrade = recipe.access, recipe.accessValue, recipe.accessGrade
    if not access or access == 'inherit' then
        access, accessValue, accessGrade = b.access, b.accessValue, b.accessGrade
    end
    if not canAccess(Player, access, accessValue, accessGrade) then
        TriggerClientEvent('QBCore:Notify', src, 'You cannot craft this.', 'error'); return
    end

    -- level
    local xp = (Player.PlayerData.metadata and Player.PlayerData.metadata.craftingxp) or 0
    if Config.XP.enabled and recipe.requiredLevel and recipe.requiredLevel > 0 and getLevel(xp) < recipe.requiredLevel then
        TriggerClientEvent('QBCore:Notify', src, ('Requires crafting level %d.'):format(recipe.requiredLevel), 'error'); return
    end

    local made, failed, gained = 0, 0, 0
    for _ = 1, qty do
        local haveAll = true
        for _, m in ipairs(recipe.materials or {}) do
            local item = Player.Functions.GetItemByName(m.item)
            if not item or item.amount < (m.amount or 1) then haveAll = false; break end
        end
        if not haveAll then break end
        for _, m in ipairs(recipe.materials or {}) do
            Player.Functions.RemoveItem(m.item, m.amount or 1)
            local d = QBCore.Shared.Items[m.item]; if d then TriggerClientEvent('qb-inventory:client:ItemBox', src, d, 'remove') end
        end
        local fail = recipe.failChance and recipe.failChance > 0 and (math.random(100) <= recipe.failChance)
        if fail then
            failed = failed + 1
        else
            local added = Player.Functions.AddItem(recipe.output, recipe.amount or 1)
            if added then
                local d = QBCore.Shared.Items[recipe.output]; if d then TriggerClientEvent('qb-inventory:client:ItemBox', src, d, 'add') end
                made = made + 1
                gained = gained + (recipe.xp or Config.XP.defaultGain or 5)
            else
                for _, m in ipairs(recipe.materials or {}) do Player.Functions.AddItem(m.item, m.amount or 1) end
                break
            end
        end
    end

    if Config.XP.enabled and gained > 0 then
        local cap = (Config.XP.maxLevel or 100) * (Config.XP.perLevel or 100)
        Player.Functions.SetMetaData('craftingxp', math.min(xp + gained, cap))
    end

    if made > 0 then
        local d = QBCore.Shared.Items[recipe.output]
        local msg = ('Crafted %dx %s'):format(made * (recipe.amount or 1), (d and d.label) or recipe.output)
        if failed > 0 then msg = msg .. (' (%d failed)'):format(failed) end
        TriggerClientEvent('QBCore:Notify', src, msg, 'success')
    elseif failed > 0 then
        TriggerClientEvent('QBCore:Notify', src, 'Craft failed - materials lost.', 'error')
    else
        TriggerClientEvent('QBCore:Notify', src, 'You do not have the required materials.', 'error')
    end
end)
