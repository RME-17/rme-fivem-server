-- RME Redline Custom Bay - customer order builder + orbit drag camera
-- Any player can pull a vehicle onto a bay pad and press E to open the Redline
-- order builder. A frosted-glass NUI previews visual cosmetics live on the car
-- (paint, wheels, neon, tire smoke, window tint, plate). Nothing is applied for
-- real: on Submit the car reverts to stock and the chosen options are sent to
-- the Redline members as an order to fulfil from their tablet, one item at a
-- time, while the car is present.

local QBCore = exports['qb-core']:GetCoreObject()

local bayActive = false
local bayVehicle = nil
local originalProps = nil
local selections = {}
local selectionKeys = {}

-- orbit drag camera ---------------------------------------------------------
local cam = nil
local camRun = false
local angleZ = 145.0
local angleY = 22.0
local radius = 5.5
local radiusMin, radiusMax = 3.0, 9.0

local function cosd(d) return math.cos(math.rad(d)) end
local function sind(d) return math.sin(math.rad(d)) end

local function updateCam()
    if not cam or not bayVehicle or not DoesEntityExist(bayVehicle) then return end
    local c = GetEntityCoords(bayVehicle)
    local horiz = radius * cosd(angleY)
    local px = c.x + horiz * sind(angleZ)
    local py = c.y + horiz * cosd(angleZ)
    local pz = c.z + radius * sind(angleY) + 0.3
    SetCamCoord(cam, px, py, pz)
    PointCamAtCoord(cam, c.x, c.y, c.z + 0.3)
end

local function vehName(veh)
    local model = GetEntityModel(veh)
    local label = GetLabelText(GetDisplayNameFromVehicleModel(model))
    if not label or label == 'NULL' or label == '' then
        label = GetDisplayNameFromVehicleModel(model)
    end
    local make = GetMakeNameFromVehicleModel(model)
    if make and make ~= '' and make ~= 'NULL' then
        local mk = GetLabelText(make)
        if mk and mk ~= 'NULL' and mk ~= '' then label = mk .. ' ' .. label end
    end
    return label
end

local PAINT_GROUPS = { 'Metallic', 'Matte', 'Util', 'Worn', 'Misc', 'Chameleon' }

local function buildOrderCatalog(veh)
    SetVehicleModKit(veh, 0)
    local cat = {}
    cat.name = vehName(veh)
    cat.plate = QBCore.Functions.GetPlate(veh)
    cat.paint = {}
    for _, gname in ipairs(PAINT_GROUPS) do
        local grp = Config.Paints[gname]
        if grp then
            local colors = {}
            for i = 1, #grp do
                colors[#colors + 1] = { label = grp[i].label, id = grp[i].id, hex = grp[i].hex }
            end
            cat.paint[#cat.paint + 1] = { name = gname, colors = colors }
        end
    end
    cat.wheelCats = {}
    for i = 1, #Config.WheelCategories do
        cat.wheelCats[#cat.wheelCats + 1] = { label = Config.WheelCategories[i].label, id = Config.WheelCategories[i].id }
    end
    cat.neon = {}
    for i = 1, #Config.NeonColors do
        local c = Config.NeonColors[i]
        cat.neon[#cat.neon + 1] = { label = c.label, r = c.r, g = c.g, b = c.b }
    end
    cat.smoke = {}
    for i = 1, #Config.TyreSmoke do
        local s = Config.TyreSmoke[i]
        cat.smoke[#cat.smoke + 1] = { label = s.label, r = s.r, g = s.g, b = s.b }
    end
    cat.tint = {}
    for i = 1, #Config.WindowTints do
        cat.tint[#cat.tint + 1] = { label = Config.WindowTints[i].label, id = Config.WindowTints[i].id }
    end
    cat.plate = {}
    for i = 1, #Config.PlateIndexes do
        cat.plate[#cat.plate + 1] = { label = Config.PlateIndexes[i].label, id = Config.PlateIndexes[i].id }
    end
    return cat
end

local function recordSelection(key, item)
    if selectionKeys[key] then
        selections[selectionKeys[key]] = item
    else
        selections[#selections + 1] = item
        selectionKeys[key] = #selections
    end
end

local function closeBay()
    bayActive = false
    camRun = false
    SetNuiFocus(false, false)
    RenderScriptCams(false, true, 500, true, true)
    if cam then DestroyCam(cam, false) cam = nil end
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    if bayVehicle and DoesEntityExist(bayVehicle) then FreezeEntityPosition(bayVehicle, false) end
    bayVehicle = nil
    originalProps = nil
    selections = {}
    selectionKeys = {}
end

-- entry point (called from the [E] prompt in client/main.lua) ----------------
function OpenCustomBay()
    if bayActive then return end
    local vehicle, distance = QBCore.Functions.GetClosestVehicle()
    if not vehicle or vehicle == 0 or distance > 6.0 then
        QBCore.Functions.Notify('Pull a vehicle onto the bay first', 'error')
        return
    end
    if Config.IgnoreClasses and Config.IgnoreClasses[GetVehicleClass(vehicle)] then
        QBCore.Functions.Notify('This vehicle cannot be customized here', 'error')
        return
    end
    SetVehicleModKit(vehicle, 0)
    bayVehicle = vehicle
    originalProps = QBCore.Functions.GetVehicleProperties(vehicle)
    selections = {}
    selectionKeys = {}
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    FreezeEntityPosition(vehicle, true)
    SetVehicleEngineOn(vehicle, false, true, true)
    angleZ, angleY, radius = 145.0, 22.0, 5.5
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamActive(cam, true)
    updateCam()
    RenderScriptCams(true, true, 600, true, true)
    bayActive = true
    camRun = true
    CreateThread(function()
        while camRun do
            if not bayVehicle or not DoesEntityExist(bayVehicle) then closeBay() break end
            updateCam()
            Wait(200)
        end
    end)
    local catalog = buildOrderCatalog(vehicle)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'openRedlineOrder', data = catalog })
end

-- NUI callbacks -------------------------------------------------------------

RegisterNUICallback('rmoCam', function(data, cb)
    local dir = data and data.dir
    if dir == 'left' then angleZ = (angleZ - 12.0) % 360.0
    elseif dir == 'right' then angleZ = (angleZ + 12.0) % 360.0
    elseif dir == 'up' then angleY = math.min(80.0, angleY + 8.0)
    elseif dir == 'down' then angleY = math.max(2.0, angleY - 8.0)
    elseif dir == 'in' then radius = math.max(radiusMin, radius - 0.6)
    elseif dir == 'out' then radius = math.min(radiusMax, radius + 0.6)
    end
    updateCam()
    cb('ok')
end)

RegisterNUICallback('rmoPreview', function(payload, cb)
    local veh = bayVehicle
    if not veh or not DoesEntityExist(veh) then cb('novehicle') return end
    SetVehicleModKit(veh, 0)
    local kind = payload.kind
    if kind == 'paint' then
        local p, s = GetVehicleColours(veh)
        if payload.section == 'secondary' then
            SetVehicleColours(veh, p, payload.colorId)
        else
            SetVehicleColours(veh, payload.colorId, s)
        end
        recordSelection('paint_' .. payload.section, { kind = 'paint', section = payload.section, colorId = payload.colorId, label = payload.label })
    elseif kind == 'wheel' then
        SetVehicleWheelType(veh, payload.wheelType)
        SetVehicleMod(veh, 23, payload.index, false)
        recordSelection('wheel', { kind = 'wheel', wheelType = payload.wheelType, index = payload.index, label = payload.label })
    elseif kind == 'neon' then
        if payload.off then
            for n = 0, 3 do SetVehicleNeonLightEnabled(veh, n, false) end
            recordSelection('neon', { kind = 'neon', off = true, label = 'Neons Off' })
        else
            for n = 0, 3 do SetVehicleNeonLightEnabled(veh, n, true) end
            SetVehicleNeonLightsColour(veh, payload.r, payload.g, payload.b)
            recordSelection('neon', { kind = 'neon', r = payload.r, g = payload.g, b = payload.b, label = payload.label })
        end
    elseif kind == 'smoke' then
        if payload.off then
            ToggleVehicleMod(veh, 20, false)
            recordSelection('smoke', { kind = 'smoke', off = true, label = 'Smoke Off' })
        else
            ToggleVehicleMod(veh, 20, true)
            SetVehicleTyreSmokeColor(veh, payload.r, payload.g, payload.b)
            recordSelection('smoke', { kind = 'smoke', r = payload.r, g = payload.g, b = payload.b, label = payload.label })
        end
    elseif kind == 'tint' then
        SetVehicleWindowTint(veh, payload.id)
        recordSelection('tint', { kind = 'tint', id = payload.id, label = payload.label })
    elseif kind == 'plate' then
        SetVehicleNumberPlateTextIndex(veh, payload.id)
        recordSelection('plate', { kind = 'plate', id = payload.id, label = payload.label })
    end
    cb('ok')
end)

RegisterNUICallback('rmoWheelList', function(payload, cb)
    local veh = bayVehicle
    if not veh or not DoesEntityExist(veh) then cb({}) return end
    SetVehicleModKit(veh, 0)
    SetVehicleWheelType(veh, payload.id)
    local list = { { label = 'Stock', index = -1 } }
    for i = 0, GetNumVehicleMods(veh, 23) - 1 do
        local l = GetModTextLabel(veh, 23, i)
        local txt = (l and GetLabelText(l)) or ('Wheel ' .. i)
        if txt == 'NULL' or txt == '' then txt = 'Wheel ' .. i end
        list[#list + 1] = { label = txt, index = i }
    end
    cb(list)
end)

RegisterNUICallback('rmoSubmit', function(_, cb)
    local veh = bayVehicle
    if not veh or not DoesEntityExist(veh) then cb('novehicle') return end
    if #selections == 0 then
        QBCore.Functions.Notify('Choose at least one option first', 'error')
        cb('empty') return
    end
    local plate = QBCore.Functions.GetPlate(veh)
    local name = vehName(veh)
    if originalProps then QBCore.Functions.SetVehicleProperties(veh, originalProps) end
    TriggerServerEvent('qb-mechanicjob:server:submitOrder', plate, name, selections)
    closeBay()
    cb('ok')
end)

RegisterNUICallback('rmoClose', function(_, cb)
    if bayVehicle and DoesEntityExist(bayVehicle) and originalProps then
        QBCore.Functions.SetVehicleProperties(bayVehicle, originalProps)
    end
    closeBay()
    cb('ok')
end)

-- safety -------------------------------------------------------------------
AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if not bayActive then return end
    bayActive = false
    camRun = false
    SetNuiFocus(false, false)
    RenderScriptCams(false, false, 0, true, true)
    if cam then DestroyCam(cam, false) cam = nil end
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    if bayVehicle and DoesEntityExist(bayVehicle) then FreezeEntityPosition(bayVehicle, false) end
end)
