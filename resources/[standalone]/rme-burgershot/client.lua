local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local isCooking = false
local createdZones = {}

local function canUse()
    if not Config.RequireJob then return true end
    return PlayerData.job ~= nil and PlayerData.job.name == Config.JobName
end

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    local timeout = 0
    while not HasAnimDictLoaded(dict) and timeout < 1000 do
        Wait(10)
        timeout = timeout + 1
    end
end

local function playCookAnim(station)
    local ped = PlayerPedId()
    local a = Config.Anims[station]
    if not a then return nil end
    loadAnimDict(a.dict)
    TaskPlayAnim(ped, a.dict, a.clip, 6.0, -6.0, -1, 49, 0, false, false, false)
    local obj = nil
    if a.prop then
        RequestModel(a.prop)
        local t = 0
        while not HasModelLoaded(a.prop) and t < 1000 do
            Wait(10)
            t = t + 1
        end
        obj = CreateObject(a.prop, 0.0, 0.0, 0.0, true, true, true)
        AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, a.bone), a.pos.x, a.pos.y, a.pos.z, a.rot.x, a.rot.y, a.rot.z, true, true, false, true, 1, true)
    end
    return obj
end

local function stopCookAnim(obj)
    ClearPedTasks(PlayerPedId())
    if obj and DoesEntityExist(obj) then
        DetachEntity(obj, true, true)
        DeleteEntity(obj)
    end
end

local function cook(recipeId)
    if isCooking then return end
    local recipe = Config.Recipes[recipeId]
    if not recipe then return end
    isCooking = true
    local obj = playCookAnim(recipe.station)
    exports['progressbar']:Progress({
        name = 'bs_cook_' .. recipeId,
        duration = recipe.time,
        label = 'Preparing ' .. recipe.label .. '...',
        useWhileDead = false,
        canCancel = true,
        controlDisables = { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true },
    }, function(cancelled)
        stopCookAnim(obj)
        isCooking = false
        if not cancelled then
            TriggerServerEvent('rme-burgershot:server:cook', recipeId)
        else
            QBCore.Functions.Notify('Cancelled', 'error')
        end
    end)
end

RegisterNetEvent('rme-burgershot:client:cook', function(data)
    cook(data.recipe)
end)

local function ingredientsText(recipe)
    local parts = {}
    for _, ing in ipairs(recipe.ingredients) do
        local itemData = QBCore.Shared.Items[ing.item]
        local lbl = itemData and itemData.label or ing.item
        parts[#parts + 1] = ing.amount .. 'x ' .. lbl
    end
    return table.concat(parts, ', ')
end

local function openStationMenu(station)
    local stationData = Config.Stations[station]
    local menu = {
        { header = stationData.label, isMenuHeader = true },
    }
    for id, recipe in pairs(Config.Recipes) do
        if recipe.station == station then
            menu[#menu + 1] = {
                header = recipe.label,
                txt = 'Needs: ' .. ingredientsText(recipe),
                params = {
                    event = 'rme-burgershot:client:cook',
                    args = { recipe = id },
                },
            }
        end
    end
    exports['qb-menu']:openMenu(menu)
end

local function createZones()
    for station, data in pairs(Config.Stations) do
        local c = data.coords
        local zoneName = 'bs_station_' .. station
        exports['qb-target']:AddBoxZone(zoneName, vector3(c.x, c.y, c.z), data.size.x, data.size.y, {
            name = zoneName,
            heading = c.w,
            debugPoly = false,
            minZ = c.z - 1.0,
            maxZ = c.z + 1.0,
        }, {
            options = {
                {
                    icon = data.icon,
                    label = 'Use ' .. data.label,
                    canInteract = function() return canUse() end,
                    action = function() openStationMenu(station) end,
                },
            },
            distance = 1.8,
        })
        createdZones[#createdZones + 1] = zoneName
    end
end

local function removeZones()
    for _, name in ipairs(createdZones) do
        exports['qb-target']:RemoveZone(name)
    end
    createdZones = {}
end

CreateThread(function()
    Wait(1000)
    createZones()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        removeZones()
        if isCooking then
            ClearPedTasks(PlayerPedId())
        end
    end
end)
