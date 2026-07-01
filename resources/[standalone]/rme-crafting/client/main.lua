local QBCore = exports['qb-core']:GetCoreObject()
local spawned = {}   -- benchId -> entity
local placing = false

-- ============================================================
-- Access check (client-side, for hiding the menu; server re-checks)
-- ============================================================
local function hasAccess(t)
    if not t or t.access == nil or t.access == 'public' then return true end
    local pd = QBCore.Functions.GetPlayerData()
    if not pd or not pd.job then return false end
    if t.access == 'job' then
        return pd.job.name == t.accessValue and (not t.accessGrade or (pd.job.grade and pd.job.grade.level >= t.accessGrade))
    elseif t.access == 'gang' then
        return pd.gang and pd.gang.name == t.accessValue
    end
    return true
end

-- ============================================================
-- Crafting menu (qb-menu)
-- ============================================================
local function openCraftingMenu(benchType)
    local t = Config.BenchTypes[benchType]
    if not t then return end
    if not hasAccess(t) then
        QBCore.Functions.Notify('You are not allowed to use this bench.', 'error')
        return
    end

    local menu = { { header = t.label, isMenuHeader = true } }
    for i, recipe in ipairs(t.recipes) do
        local outItem = QBCore.Shared.Items[recipe.output]
        local outLabel = (outItem and outItem.label) or recipe.output
        local parts = {}
        for _, m in ipairs(recipe.materials) do
            local mItem = QBCore.Shared.Items[m.item]
            parts[#parts + 1] = m.amount .. 'x ' .. ((mItem and mItem.label) or m.item)
        end
        menu[#menu + 1] = {
            header = ('%dx %s'):format(recipe.amount or 1, outLabel),
            txt = 'Requires: ' .. table.concat(parts, ', '),
            params = { isServer = false, event = 'rme-crafting:client:craft', args = { benchType = benchType, index = i } },
        }
    end
    menu[#menu + 1] = { header = 'Close', params = { event = 'qb-menu:closeMenu' } }
    exports['qb-menu']:openMenu(menu)
end

RegisterNetEvent('rme-crafting:client:craft', function(data)
    local t = Config.BenchTypes[data.benchType]
    local recipe = t and t.recipes[data.index]
    if not recipe then return end
    local ped = PlayerPedId()
    QBCore.Functions.Progressbar('rme_craft', 'Crafting ' .. (recipe.amount or 1) .. 'x...', recipe.time or Config.DefaultCraftTime, false, true, {
        disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true,
    }, {
        animDict = 'mini@repair', anim = 'fixing_a_player', flags = 16,
    }, {}, {}, function() -- done
        StopAnimTask(ped, 'mini@repair', 'fixing_a_player', 1.0)
        TriggerServerEvent('rme-crafting:server:craft', data.benchType, data.index)
    end, function() -- cancel
        StopAnimTask(ped, 'mini@repair', 'fixing_a_player', 1.0)
        QBCore.Functions.Notify('Cancelled.', 'error')
    end)
end)

-- ============================================================
-- qb-target on each placed bench (WE own the action -> it fires)
-- ============================================================
local function addBenchTarget(benchType, entity)
    local t = Config.BenchTypes[benchType]
    if not t then return end
    exports['qb-target']:AddTargetEntity(entity, {
        options = {
            {
                icon = Config.TargetIcon,
                label = Config.TargetLabel:format(t.label),
                action = function()
                    openCraftingMenu(benchType)
                end,
            },
        },
        distance = Config.TargetDistance,
    })
end

-- ============================================================
-- Spawn / remove bench props
-- ============================================================
local function spawnBench(b)
    if spawned[b.id] then return end
    local t = Config.BenchTypes[b.benchtype]
    if not t then return end
    local model = joaat(t.prop)
    RequestModel(model)
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 200 do Wait(10); timeout = timeout + 1 end
    if not HasModelLoaded(model) then return end
    local obj = CreateObject(model, b.x + 0.0, b.y + 0.0, b.z + 0.0, false, false, false)
    SetEntityHeading(obj, b.heading + 0.0)
    PlaceObjectOnGroundProperly(obj)
    FreezeEntityPosition(obj, true)
    SetModelAsNoLongerNeeded(model)
    spawned[b.id] = obj
    addBenchTarget(b.benchtype, obj)
end

local function removeBench(id)
    local ent = spawned[id]
    if ent then
        exports['qb-target']:RemoveTargetEntity(ent)
        if DoesEntityExist(ent) then DeleteEntity(ent) end
        spawned[id] = nil
    end
end

RegisterNetEvent('rme-crafting:client:syncBenches', function(benches)
    for _, b in pairs(benches) do spawnBench(b) end
end)
RegisterNetEvent('rme-crafting:client:spawnBench', function(b) spawnBench(b) end)
RegisterNetEvent('rme-crafting:client:removeBench', function(id) removeBench(id) end)

CreateThread(function()
    while not LocalPlayer.state.isLoggedIn do Wait(250) end
    Wait(1000)
    TriggerServerEvent('rme-crafting:server:requestBenches')
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for id in pairs(spawned) do removeBench(id) end
end)

-- ============================================================
-- Placement (admin) - raycast ghost prop + rotate + confirm
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

RegisterNetEvent('rme-crafting:client:startPlacement', function(data)
    if placing then return end
    local t = Config.BenchTypes[data.benchType]
    if not t then return end
    placing = true
    local model = joaat(t.prop)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end
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
            if IsControlPressed(0, 174) then heading = (heading + 2.0) % 360.0 end -- left arrow
            if IsControlPressed(0, 175) then heading = (heading - 2.0) % 360.0 end -- right arrow
            drawText3D(g.x, g.y, g.z + 1.0, '[Enter] Place    [Left/Right Arrow] Rotate    [Backspace] Cancel')
            if IsControlJustPressed(0, 191) or IsControlJustPressed(0, 201) then -- Enter
                local c = GetEntityCoords(obj)
                placing = false
                if DoesEntityExist(obj) then DeleteEntity(obj) end
                TriggerServerEvent('rme-crafting:server:placeBench', data.benchType, { x = c.x, y = c.y, z = c.z, w = heading })
            elseif IsControlJustPressed(0, 177) then -- Backspace
                placing = false
                if DoesEntityExist(obj) then DeleteEntity(obj) end
                QBCore.Functions.Notify('Placement cancelled.', 'error')
            end
        end
        SetModelAsNoLongerNeeded(model)
    end)
end)

RegisterNetEvent('rme-crafting:client:removeNearest', function()
    local pc = GetEntityCoords(PlayerPedId())
    local nearestId, nearestDist
    for id, ent in pairs(spawned) do
        if DoesEntityExist(ent) then
            local d = #(pc - GetEntityCoords(ent))
            if not nearestDist or d < nearestDist then nearestDist = d; nearestId = id end
        end
    end
    if nearestId and nearestDist <= 5.0 then
        TriggerServerEvent('rme-crafting:server:removeBench', nearestId)
    else
        QBCore.Functions.Notify('No bench within 5m.', 'error')
    end
end)

RegisterCommand(Config.Command, function()
    local menu = { { header = 'RME Crafting - Admin', isMenuHeader = true } }
    for key, t in pairs(Config.BenchTypes) do
        menu[#menu + 1] = {
            header = 'Place: ' .. t.label,
            txt = 'Prop: ' .. t.prop,
            params = { event = 'rme-crafting:client:startPlacement', args = { benchType = key } },
        }
    end
    menu[#menu + 1] = { header = 'Remove nearest bench', txt = 'Deletes the closest placed bench (within 5m)', params = { event = 'rme-crafting:client:removeNearest' } }
    menu[#menu + 1] = { header = 'Close', params = { event = 'qb-menu:closeMenu' } }
    exports['qb-menu']:openMenu(menu)
end, false)
