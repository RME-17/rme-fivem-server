local QBCore = exports['qb-core']:GetCoreObject()
local spawned = {}      -- id -> entity
local benchCache = {}   -- id -> bench data
local placing = false
local currentCraftBench = nil

-- ============================================================
-- Data builders for the NUI
-- ============================================================
local function buildItemList()
    local items = {}
    for name, v in pairs(QBCore.Shared.Items) do
        items[#items + 1] = {
            name = name,
            label = v.label or name,
            image = ('nui://qb-inventory/html/images/%s'):format(v.image or (name .. '.png')),
        }
    end
    table.sort(items, function(a, b) return a.label < b.label end)
    return items
end

local function buildJobs()
    local jobs = {}
    for name, j in pairs(QBCore.Shared.Jobs or {}) do
        local grades = {}
        for g, gd in pairs(j.grades or {}) do grades[#grades + 1] = { grade = tonumber(g) or 0, name = gd.name } end
        table.sort(grades, function(a, b) return a.grade < b.grade end)
        jobs[#jobs + 1] = { name = name, label = j.label or name, grades = grades }
    end
    table.sort(jobs, function(a, b) return a.label < b.label end)
    return jobs
end

local function buildGangs()
    local gangs = {}
    for name, g in pairs(QBCore.Shared.Gangs or {}) do
        gangs[#gangs + 1] = { name = name, label = g.label or name }
    end
    table.sort(gangs, function(a, b) return a.label < b.label end)
    return gangs
end

local function buildInvCounts()
    local counts = {}
    local pd = QBCore.Functions.GetPlayerData()
    local items = (pd and pd.items) or {}
    for _, it in pairs(items) do
        if it and it.name then
            counts[it.name] = (counts[it.name] or 0) + (it.amount or it.count or 1)
        end
    end
    return counts
end

local function getXPInfo()
    local pd = QBCore.Functions.GetPlayerData()
    local xp = (pd and pd.metadata and pd.metadata.craftingxp) or 0
    local per = (Config.XP and Config.XP.perLevel) or 100
    return { xp = xp, level = math.floor(xp / per), perLevel = per, into = xp % per, enabled = (Config.XP and Config.XP.enabled) or false }
end

local function hasAccess(b)
    if not b or b.access == nil or b.access == 'public' then return true end
    local pd = QBCore.Functions.GetPlayerData()
    if not pd then return false end
    if b.access == 'job' then
        return pd.job and pd.job.name == b.accessValue and (not b.accessGrade or (pd.job.grade and pd.job.grade.level >= b.accessGrade))
    elseif b.access == 'gang' then
        return pd.gang and pd.gang.name == b.accessValue
    end
    return true
end

-- ============================================================
-- Craft NUI
-- ============================================================
local function openCraft(b)
    if not b then return end
    if not hasAccess(b) then QBCore.Functions.Notify('You cannot use this bench.', 'error') return end
    currentCraftBench = b.id
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openCraft',
        bench = b,
        items = buildItemList(),
        theme = Config.Theme,
        inventory = buildInvCounts(),
        xp = getXPInfo(),
    })
end

local function reopenCraft(id)
    local b = benchCache[id]
    if b then openCraft(b) end
end

-- ============================================================
-- Target
-- ============================================================
local function addBenchTarget(b, entity)
    exports['qb-target']:AddTargetEntity(entity, {
        options = {
            {
                icon = Config.TargetIcon,
                label = ('Use %s'):format(b.label or 'Bench'),
                action = function() openCraft(benchCache[b.id] or b) end,
            },
        },
        distance = Config.TargetDistance,
    })
end

-- ============================================================
-- Spawn / remove benches
-- ============================================================
local function spawnBench(b)
    benchCache[b.id] = b
    if spawned[b.id] then
        exports['qb-target']:RemoveTargetEntity(spawned[b.id])
        if DoesEntityExist(spawned[b.id]) then DeleteEntity(spawned[b.id]) end
        spawned[b.id] = nil
    end
    local model = joaat(b.prop or 'gr_prop_gr_bench_04a')
    RequestModel(model)
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 200 do Wait(10); timeout = timeout + 1 end
    if not HasModelLoaded(model) then return end
    local obj = CreateObject(model, b.x + 0.0, b.y + 0.0, b.z + 0.0, false, false, false)
    SetEntityHeading(obj, (b.heading or 0.0) + 0.0)
    PlaceObjectOnGroundProperly(obj)
    FreezeEntityPosition(obj, true)
    SetModelAsNoLongerNeeded(model)
    spawned[b.id] = obj
    addBenchTarget(b, obj)
end

local function removeBench(id)
    benchCache[id] = nil
    local ent = spawned[id]
    if ent then
        exports['qb-target']:RemoveTargetEntity(ent)
        if DoesEntityExist(ent) then DeleteEntity(ent) end
        spawned[id] = nil
    end
end

RegisterNetEvent('rme-crafting:client:syncBenches', function(list)
    for _, b in ipairs(list) do spawnBench(b) end
end)
RegisterNetEvent('rme-crafting:client:spawnBench', function(b) spawnBench(b) end)
RegisterNetEvent('rme-crafting:client:updateBench', function(b) spawnBench(b) end)
RegisterNetEvent('rme-crafting:client:removeBench', function(id) removeBench(id) end)

CreateThread(function()
    while not LocalPlayer.state.isLoggedIn do Wait(250) end
    Wait(1000)
    TriggerServerEvent('rme-crafting:server:requestBenches')
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for id in pairs(spawned) do removeBench(id) end
    SetNuiFocus(false, false)
end)

-- ============================================================
-- Placement (admin)
-- ============================================================
local function rotToDir(rot)
    local radZ = math.rad(rot.z)
    local radX = math.rad(rot.x)
    local cosX = math.abs(math.cos(radX))
    return vector3(-math.sin(radZ) * cosX, math.cos(radZ) * cosX, math.sin(radX))
end

local function getAimGround()
    local cam = GetGameplayCamCoord()
    local dir = rotToDir(GetGameplayCamRot(2))
    local dest = cam + dir * 8.0
    local ray = StartExpensiveSynchronousShapeTestLosProbe(cam.x, cam.y, cam.z, dest.x, dest.y, dest.z, 1 + 16, PlayerPedId(), 0)
    local _, hit, endCoords = GetShapeTestResult(ray)
    if hit == 1 then return endCoords end
    return dest
end

local function drawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

local function startPlacement(prop, onConfirm)
    if placing then return end
    placing = true
    local model = joaat(prop or 'gr_prop_gr_bench_04a')
    RequestModel(model)
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 200 do Wait(10); timeout = timeout + 1 end
    if not HasModelLoaded(model) then placing = false; return end
    local obj = CreateObject(model, GetEntityCoords(PlayerPedId()), false, false, false)
    SetEntityAlpha(obj, 160, false)
    SetEntityCollision(obj, false, false)
    FreezeEntityPosition(obj, true)
    local heading = GetEntityHeading(PlayerPedId())
    CreateThread(function()
        while placing do
            Wait(0)
            local g = getAimGround()
            SetEntityCoords(obj, g.x, g.y, g.z)
            SetEntityHeading(obj, heading)
            PlaceObjectOnGroundProperly(obj)
            if IsControlPressed(0, 174) then heading = (heading + 2.0) % 360.0 end
            if IsControlPressed(0, 175) then heading = (heading - 2.0) % 360.0 end
            drawText3D(g.x, g.y, g.z + 1.0, '[Enter] Place    [Left/Right Arrow] Rotate    [Backspace] Cancel')
            if IsControlJustPressed(0, 191) or IsControlJustPressed(0, 201) then
                local c = GetEntityCoords(obj)
                placing = false
                if DoesEntityExist(obj) then DeleteEntity(obj) end
                onConfirm({ x = c.x, y = c.y, z = c.z, w = heading })
            elseif IsControlJustPressed(0, 177) then
                placing = false
                if DoesEntityExist(obj) then DeleteEntity(obj) end
                QBCore.Functions.Notify('Placement cancelled.', 'error')
            end
        end
        SetModelAsNoLongerNeeded(model)
    end)
end

-- ============================================================
-- Creator NUI
-- ============================================================
local function openCreator()
    local list = {}
    for _, b in pairs(benchCache) do list[#list + 1] = b end
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openCreator',
        benches = list,
        items = buildItemList(),
        categories = Config.ItemCategories,
        recipeCategories = Config.RecipeCategories,
        jobs = buildJobs(),
        gangs = buildGangs(),
        props = Config.Props,
        theme = Config.Theme,
    })
end

RegisterCommand(Config.Command, function() openCreator() end, false)

-- ============================================================
-- NUI callbacks
-- ============================================================
RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('saveBench', function(data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent('rme-crafting:server:saveBench', data)
    cb('ok')
end)

RegisterNUICallback('placeBench', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
    startPlacement(data.prop, function(coords)
        data.id = nil
        data.x, data.y, data.z, data.heading = coords.x, coords.y, coords.z, coords.w
        TriggerServerEvent('rme-crafting:server:saveBench', data)
    end)
end)

RegisterNUICallback('moveBench', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
    startPlacement(data.prop, function(coords)
        data.x, data.y, data.z, data.heading = coords.x, coords.y, coords.z, coords.w
        TriggerServerEvent('rme-crafting:server:saveBench', data)
    end)
end)

RegisterNUICallback('deleteBench', function(data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent('rme-crafting:server:deleteBench', data.id)
    cb('ok')
end)

RegisterNUICallback('craft', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
    local benchId = currentCraftBench
    local b = benchCache[benchId]
    local recipe = b and b.recipes and b.recipes[data.index]
    if not recipe then return end
    local qty = math.max(1, math.min(tonumber(data.qty) or 1, 20))
    local ped = PlayerPedId()
    CreateThread(function()
        if Config.SkillCheck and Config.SkillCheck.enabled and lib and lib.skillCheck then
            local ok = lib.skillCheck(Config.SkillCheck.difficulty, Config.SkillCheck.inputs)
            if not ok then
                QBCore.Functions.Notify('Craft failed (skill check).', 'error')
                Wait(200); reopenCraft(benchId); return
            end
        end
        local time = recipe.time or Config.DefaultCraftTime
        QBCore.Functions.Progressbar('rme_craft', 'Crafting...', time, false, true, {
            disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true,
        }, { animDict = 'mini@repair', anim = 'fixing_a_player', flags = 16 }, {}, {}, function()
            StopAnimTask(ped, 'mini@repair', 'fixing_a_player', 1.0)
            TriggerServerEvent('rme-crafting:server:craft', benchId, data.index, qty)
            Wait(600); reopenCraft(benchId)
        end, function()
            StopAnimTask(ped, 'mini@repair', 'fixing_a_player', 1.0)
            QBCore.Functions.Notify('Cancelled.', 'error')
            Wait(200); reopenCraft(benchId)
        end)
    end)
end)
