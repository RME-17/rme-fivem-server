local QBCore = exports['qb-core']:GetCoreObject({ 'Functions' })
local sharedItems = exports['qb-core']:GetShared('Items')
local carryPackage = nil
local packageIndex = nil
local onDuty = false
local isBusy = false
local props = {}
local crateObj, workerPed = nil, nil

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for _, v in pairs(props) do if v and DoesEntityExist(v) then DeleteObject(v) end end
    if carryPackage and DoesEntityExist(carryPackage) then DeleteObject(carryPackage) end
    if crateObj and DoesEntityExist(crateObj) then DeleteObject(crateObj) end
    if workerPed and DoesEntityExist(workerPed) then DeletePed(workerPed) end
end)

local function outline(ent, on, r, g, b)
    if ent and DoesEntityExist(ent) then
        SetEntityDrawOutline(ent, on)
        if on then SetEntityDrawOutlineColor(ent, r or 15, g or 20, b or 60) end
    end
end

-- Grounds a prop reliably: waits until the player is close (so collision is
-- streamed in) then snaps it to the floor and freezes it.
local function groundProp(obj, loc)
    CreateThread(function()
        local tries = 0
        while obj and DoesEntityExist(obj) and tries < 900 do
            if #(GetEntityCoords(PlayerPedId()) - vector3(loc.x, loc.y, loc.z)) < 25.0 then
                RequestCollisionAtCoord(loc.x, loc.y, loc.z)
                FreezeEntityPosition(obj, false)
                Wait(400)
                PlaceObjectOnGroundProperly(obj)
                Wait(50)
                FreezeEntityPosition(obj, true)
                return
            end
            tries = tries + 1
            Wait(1000)
        end
    end)
end

local function SetLocationBlip()
    local blip = AddBlipForCoord(Config.OutsideLocation.x, Config.OutsideLocation.y, Config.OutsideLocation.z)
    SetBlipSprite(blip, 365)
    SetBlipColour(blip, 2)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Recycle Center')
    EndTextCommandSetBlipName(blip)
end
SetLocationBlip()

local function GetRandomPackage()
    if packageIndex then outline(props[packageIndex], false) end
    packageIndex = math.random(1, #Config.PickupLocations)
    if Config.DrawPackageLocationBlip then outline(props[packageIndex], true, 15, 20, 60) end
end

local function PickupPackage()
    local pos = GetEntityCoords(PlayerPedId(), true)
    RequestAnimDict('anim@heists@box_carry@')
    while not HasAnimDictLoaded('anim@heists@box_carry@') do Wait(7) end
    TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 5.0, -1, -1, 50, 0, false, false, false)
    RequestModel(Config.PickupBoxModel)
    while not HasModelLoaded(Config.PickupBoxModel) do Wait(0) end
    local object = CreateObject(Config.PickupBoxModel, pos.x, pos.y, pos.z, true, true, true)
    AttachEntityToEntity(object, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.05, 0.1, -0.3, 300.0, 250.0, 20.0, true, true, false, true, 1, true)
    carryPackage = object
end

local function DropPackage()
    ClearPedTasks(PlayerPedId())
    if carryPackage then
        DetachEntity(carryPackage, true, true)
        DeleteObject(carryPackage)
        carryPackage = nil
    end
end

local function EnterLocation()
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(10) end
    SetEntityCoords(PlayerPedId(), Config.InsideLocation.x, Config.InsideLocation.y, Config.InsideLocation.z)
    DoScreenFadeIn(500)
end

local function ExitLocation()
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(10) end
    SetEntityCoords(PlayerPedId(), Config.OutsideLocation.x, Config.OutsideLocation.y, Config.OutsideLocation.z + 1)
    DoScreenFadeIn(500)
    onDuty = false
    if packageIndex then outline(props[packageIndex], false); packageIndex = nil end
    outline(crateObj, false)
    if carryPackage then DropPackage() end
end

local function toggleDuty()
    if onDuty then
        onDuty = false
        QBCore.Functions.Notify(Lang:t('text.clock_out'), 'success')
        if packageIndex then outline(props[packageIndex], false); packageIndex = nil end
        outline(crateObj, false)
        if carryPackage then DropPackage() end
    else
        onDuty = true
        QBCore.Functions.Notify(Lang:t('text.clock_in'), 'success')
        GetRandomPackage()
    end
end

local function pickUp()
    if isBusy or not onDuty or carryPackage then return end
    isBusy = true
    QBCore.Functions.Progressbar('pickup_recycle_package', Lang:t('text.picking_up_the_package'), Config.PickupActionDuration, false, true, {
        disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true
    }, { animDict = 'mp_car_bomb', anim = 'car_bomb_mechanic', flags = 16 }, {}, {}, function()
        isBusy = false
        if packageIndex then outline(props[packageIndex], false); packageIndex = nil end
        PickupPackage()
        outline(crateObj, true, 34, 197, 94) -- green: carry it to the armory crate
        QBCore.Functions.Notify('Carry the box to the armory crate.', 'primary')
    end, function()
        isBusy = false
    end)
end

local function dropAtCrate()
    if not carryPackage then return end
    DropPackage()
    outline(crateObj, false)
    QBCore.Functions.Progressbar('drop_recycle_box', 'Packing the box...', Config.DeliveryActionDuration, false, true, {
        disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true
    }, { animDict = 'mp_car_bomb', anim = 'car_bomb_mechanic', flags = 16 }, {}, {}, function()
        TriggerServerEvent('qb-recyclejob:server:getBoxes')
        if onDuty then GetRandomPackage() end
    end)
end

local function openBox()
    if isBusy then return end
    if not QBCore.Functions.HasItem(Config.BoxItem) then
        QBCore.Functions.Notify('You have no Scrap Boxes to open.', 'error')
        return
    end
    isBusy = true
    QBCore.Functions.Progressbar('open_recycle_box', 'Opening a Scrap Box...', Config.ExchangeActionDuration, false, true, {
        disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true
    }, { animDict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', anim = 'machinic_loop_mechandplayer', flags = 16 }, {}, {}, function()
        isBusy = false
        TriggerServerEvent('qb-recyclejob:server:openBox')
    end, function()
        isBusy = false
    end)
end

CreateThread(function()
    Wait(500)

    -- Armory crate (drop-off) - grounded once the player is near
    RequestModel(Config.CrateModel)
    local t = 0
    while not HasModelLoaded(Config.CrateModel) and t < 100 do Wait(10); t = t + 1 end
    if HasModelLoaded(Config.CrateModel) then
        crateObj = CreateObject(Config.CrateModel, Config.CrateLocation.x, Config.CrateLocation.y, Config.CrateLocation.z, false, false, false)
        SetEntityHeading(crateObj, Config.CrateLocation.w)
        FreezeEntityPosition(crateObj, true)
        SetModelAsNoLongerNeeded(Config.CrateModel)
        groundProp(crateObj, Config.CrateLocation)
        exports['qb-target']:AddTargetEntity(crateObj, {
            options = { {
                icon = 'fas fa-box-open',
                label = 'Drop off box',
                action = function() dropAtCrate() end,
                canInteract = function() return carryPackage ~= nil end,
            } },
            distance = 2.5
        })
    end

    -- Recycling worker (ped) - open Scrap Boxes for materials
    local pedHash = GetHashKey(Config.PedModel)
    RequestModel(pedHash)
    t = 0
    while not HasModelLoaded(pedHash) and t < 100 do Wait(10); t = t + 1 end
    if HasModelLoaded(pedHash) then
        local p = Config.PedLocation
        workerPed = CreatePed(4, pedHash, p.x, p.y, p.z, p.w, false, false)
        SetEntityHeading(workerPed, p.w)
        FreezeEntityPosition(workerPed, true)
        SetEntityInvincible(workerPed, true)
        SetBlockingOfNonTemporaryEvents(workerPed, true)
        SetModelAsNoLongerNeeded(pedHash)
        exports['qb-target']:AddTargetEntity(workerPed, {
            options = { {
                icon = 'fas fa-recycle',
                label = 'Open boxes',
                action = function() openBox() end,
                canInteract = function() return QBCore.Functions.HasItem(Config.BoxItem) end,
            } },
            distance = 2.5
        })
    end

    -- Enter / Exit / Duty
    exports['qb-target']:AddBoxZone('recycle_enter', vector3(Config.OutsideLocation.x, Config.OutsideLocation.y, Config.OutsideLocation.z), 3.0, 2.0, {
        name = 'recycle_enter', heading = Config.OutsideLocation.w, minZ = Config.OutsideLocation.z - 1.5, maxZ = Config.OutsideLocation.z + 1.5, debugPoly = false
    }, {
        options = { { icon = 'fas fa-door-open', label = 'Enter Recycling Center', action = function() EnterLocation() end } },
        distance = 2.0
    })
    exports['qb-target']:AddBoxZone('recycle_exit', vector3(Config.InsideLocation.x, Config.InsideLocation.y, Config.InsideLocation.z), 3.0, 2.0, {
        name = 'recycle_exit', heading = Config.InsideLocation.w, minZ = Config.InsideLocation.z - 1.5, maxZ = Config.InsideLocation.z + 1.5, debugPoly = false
    }, {
        options = { { icon = 'fas fa-door-closed', label = 'Leave Recycling Center', action = function() ExitLocation() end } },
        distance = 2.0
    })
    exports['qb-target']:AddBoxZone('recycle_duty', vector3(Config.DutyLocation.x, Config.DutyLocation.y, Config.DutyLocation.z), 2.0, 2.0, {
        name = 'recycle_duty', heading = Config.DutyLocation.w, minZ = Config.DutyLocation.z - 1.5, maxZ = Config.DutyLocation.z + 1.5, debugPoly = false
    }, {
        options = { { icon = 'fas fa-clipboard-check', label = 'Toggle Duty', action = function() toggleDuty() end } },
        distance = 2.0
    })

    -- Pickup piles
    for k, v in pairs(Config.PickupLocations) do
        RequestModel(Config.WarehouseObjects[v.model])
        while not HasModelLoaded(Config.WarehouseObjects[v.model]) do Wait(0) end
        props[k] = CreateObject(Config.WarehouseObjects[v.model], v.loc.x, v.loc.y, v.loc.z, false, true, true)
        PlaceObjectOnGroundProperly(props[k])
        FreezeEntityPosition(props[k], true)
        exports['qb-target']:AddTargetEntity(props[k], {
            options = { {
                icon = 'fas fa-box',
                label = 'Grab box',
                action = function() pickUp() end,
                canInteract = function() return onDuty and packageIndex == k and not isBusy and not carryPackage end,
            } },
            distance = 2.0
        })
    end
end)
