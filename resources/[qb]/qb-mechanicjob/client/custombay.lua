-- RME Redline Custom Bay - customer order builder + orbit drag camera
-- Any player can pull a vehicle onto a bay pad and press E to open the Redline
-- order builder. A frosted-glass NUI previews visual cosmetics live on the car
-- (paint, wheels, neon, tire smoke, window tint, plate, and now exterior /
-- interior / performance upgrades). Nothing is applied for real: on Submit the
-- car reverts to stock and the chosen options are sent to the Redline members
-- as an order to fulfil from their tablet, one item at a time, while the car is
-- present.

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
-- The order panel is docked to the RIGHT of the screen, so aim the camera a bit
-- to the right of the car. That pushes the vehicle into the open left area and
-- removes the empty dark space next to the panel.
local lateralShift = 1.3

-- smooth orbit: the joystick feeds an analog input (inputX/inputY) that nudges a
-- TARGET orbit angle; the live camera angles then EASE toward the target every
-- frame, so motion is slow and buttery instead of big jumpy steps.
local targetZ = 145.0
local targetY = 22.0
local targetRadius = 5.5
local inputX = 0.0    -- -1..1 horizontal stick (already inverted + deadzoned)
local inputY = 0.0    -- -1..1 vertical stick (already inverted + deadzoned)
local DEADZONE = 0.12
local ROT_SPEED = 50.0    -- deg/sec horizontal at full stick (slow & controlled)
local TILT_SPEED = 30.0   -- deg/sec vertical at full stick
local EASE = 6.0          -- how quickly the live camera chases the target

local function cosd(d) return math.cos(math.rad(d)) end
local function sind(d) return math.sin(math.rad(d)) end

-- shortest signed angular distance a->b (handles the 360/0 wrap smoothly)
local function angDiff(a, b)
    return (b - a + 180.0) % 360.0 - 180.0
end

local function updateCam()
    if not cam or not bayVehicle or not DoesEntityExist(bayVehicle) then return end
    local c = GetEntityCoords(bayVehicle)
    local horiz = radius * cosd(angleY)
    local px = c.x + horiz * sind(angleZ)
    local py = c.y + horiz * cosd(angleZ)
    local pz = c.z + radius * sind(angleY) + 0.3
    -- collidable camera: cast a ray from the car out to the desired camera spot.
    -- if a wall / object / other vehicle is in the way, pull the camera in to
    -- just before the hit so it never clips through walls. (flags 1+2+16 =
    -- world + vehicles + objects; the bay car itself is ignored.)
    local pivotZ = c.z + 0.3
    local ray = StartShapeTestRay(c.x, c.y, pivotZ, px, py, pz, 19, bayVehicle, 4)
    local _, hit, endCoords = GetShapeTestResult(ray)
    if hit == 1 or hit == true then
        local dx, dy, dz = endCoords.x - c.x, endCoords.y - c.y, endCoords.z - pivotZ
        local hitDist = math.sqrt(dx * dx + dy * dy + dz * dz)
        local wx, wy, wz = px - c.x, py - c.y, pz - pivotZ
        local want = math.sqrt(wx * wx + wy * wy + wz * wz)
        local pull = math.max(0.6, hitDist - 0.35)
        if want > 0.0 and pull < want then
            local f = pull / want
            px = c.x + wx * f
            py = c.y + wy * f
            pz = pivotZ + wz * f
        end
    end
    SetCamCoord(cam, px, py, pz)
    -- camera right vector (horizontal) for the current orbit angle
    local rx = -cosd(angleZ)
    local ry = sind(angleZ)
    local tx = c.x + rx * lateralShift
    local ty = c.y + ry * lateralShift
    PointCamAtCoord(cam, tx, ty, c.z + 0.3)
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

-- performance upgrade categories (indexed mods). Turbo is added separately as a
-- simple on/off toggle since it is not an indexed mod.
local PERFORMANCE_CATEGORIES = {
    { label = 'Engine',       id = 11 },
    { label = 'Brakes',       id = 12 },
    { label = 'Transmission', id = 13 },
    { label = 'Suspension',   id = 15 },
    { label = 'Armor',        id = 16 },
}

-- Build the option list for an indexed vehicle mod category (Stock + each style).
local function buildModList(veh, modType, isHorn)
    local list = { { label = 'Stock / None', index = -1 } }
    for i = 0, GetNumVehicleMods(veh, modType) - 1 do
        local txt
        if isHorn then
            txt = (Config.HornLabels and Config.HornLabels[i]) or ('Horn ' .. i)
        else
            local l = GetModTextLabel(veh, modType, i)
            txt = (l and GetLabelText(l)) or (tostring(modType) .. ' #' .. i)
            if txt == 'NULL' or txt == '' then txt = 'Style ' .. i end
        end
        list[#list + 1] = { label = txt, index = i }
    end
    return list
end

local function buildOrderCatalog(veh)
    SetVehicleModKit(veh, 0)
    local cat = {}
    cat.name = vehName(veh)
    cat.plate = QBCore.Functions.GetPlate(veh)
    cat.prices = Config.CosmeticPrices or {}
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
    -- NOTE: keep this as cat.plateStyles -- cat.plate stays the plate STRING
    -- above so the order header shows the plate, not [object Object].
    cat.plateStyles = {}
    for i = 1, #Config.PlateIndexes do
        cat.plateStyles[#cat.plateStyles + 1] = { label = Config.PlateIndexes[i].label, id = Config.PlateIndexes[i].id }
    end
    -- exterior body mods (only categories the vehicle actually supports)
    cat.exterior = {}
    for i = 1, #Config.ExteriorCategories do
        local ec = Config.ExteriorCategories[i]
        if GetNumVehicleMods(veh, ec.id) > 0 then
            cat.exterior[#cat.exterior + 1] = { label = ec.label, modType = ec.id, options = buildModList(veh, ec.id, false) }
        end
    end
    -- interior mods (horns handled with their friendly labels)
    cat.interior = {}
    for i = 1, #Config.InteriorCategories do
        local ic = Config.InteriorCategories[i]
        if GetNumVehicleMods(veh, ic.id) > 0 then
            cat.interior[#cat.interior + 1] = { label = ic.label, modType = ic.id, horn = (ic.id == 14), options = buildModList(veh, ic.id, ic.id == 14) }
        end
    end
    -- performance upgrades (indexed) + a turbo on/off toggle
    cat.performance = {}
    for i = 1, #PERFORMANCE_CATEGORIES do
        local pc = PERFORMANCE_CATEGORIES[i]
        if GetNumVehicleMods(veh, pc.id) > 0 then
            cat.performance[#cat.performance + 1] = { label = pc.label, modType = pc.id, options = buildModList(veh, pc.id, false) }
        end
    end
    cat.performance[#cat.performance + 1] = { label = 'Turbo', modType = 18, toggle = true, options = { { label = 'Off', off = true }, { label = 'On', on = true } } }
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
    inputX, inputY = 0.0, 0.0
    -- bring the speedo + top-right info card (and any other HUD) back
    TriggerEvent('rme:hud:setVisible', true)
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
    targetZ, targetY, targetRadius = 145.0, 22.0, 5.5
    inputX, inputY = 0.0, 0.0
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamActive(cam, true)
    updateCam()
    RenderScriptCams(true, true, 600, true, true)
    bayActive = true
    camRun = true
    -- hide the speedo + top-right info card (and other HUD) so they don't bleed
    -- through the order builder; restored in closeBay().
    TriggerEvent('rme:hud:setVisible', false)
    CreateThread(function()
        while camRun do
            if not bayVehicle or not DoesEntityExist(bayVehicle) then closeBay() break end
            local dt = GetFrameTime()
            if dt <= 0.0 then dt = 0.016 end
            -- advance the TARGET orbit from the analog joystick input
            if inputX ~= 0.0 then targetZ = (targetZ + inputX * ROT_SPEED * dt) % 360.0 end
            if inputY ~= 0.0 then targetY = math.max(2.0, math.min(80.0, targetY + inputY * TILT_SPEED * dt)) end
            -- ease the live camera toward the target (frame-rate independent)
            local k = EASE * dt
            if k > 1.0 then k = 1.0 end
            angleZ = (angleZ + angDiff(angleZ, targetZ) * k) % 360.0
            angleY = angleY + (targetY - angleY) * k
            radius = radius + (targetRadius - radius) * k
            updateCam()
            Wait(0)
        end
    end)
    local catalog = buildOrderCatalog(vehicle)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'openRedlineOrder', data = catalog })
end

-- NUI callbacks -------------------------------------------------------------

-- analog joystick from the order UI. x/y are -1..1. Controls are INVERTED per
-- request: drag right orbits left, and drag down tilts down (both axes
-- inverted). The smoothing loop above turns this into slow, eased motion.
RegisterNUICallback('rmoCamAnalog', function(data, cb)
    local x = tonumber(data and data.x) or 0.0
    local y = tonumber(data and data.y) or 0.0
    if math.abs(x) < DEADZONE then x = 0.0 end
    if math.abs(y) < DEADZONE then y = 0.0 end
    inputX = -x   -- inverted horizontal
    inputY = -y   -- inverted vertical (drag down -> camera tilts down)
    cb('ok')
end)

-- discrete nudges (zoom buttons, and any legacy left/right/up/down). These now
-- move the TARGET so they ease smoothly too.
RegisterNUICallback('rmoCam', function(data, cb)
    local dir = data and data.dir
    if dir == 'left' then targetZ = (targetZ - 8.0) % 360.0
    elseif dir == 'right' then targetZ = (targetZ + 8.0) % 360.0
    elseif dir == 'up' then targetY = math.min(80.0, targetY + 6.0)
    elseif dir == 'down' then targetY = math.max(2.0, targetY - 6.0)
    elseif dir == 'in' then targetRadius = math.max(radiusMin, targetRadius - 0.6)
    elseif dir == 'out' then targetRadius = math.min(radiusMax, targetRadius + 0.6)
    end
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
    elseif kind == 'mod' then
        if payload.toggle then
            ToggleVehicleMod(veh, payload.modType, payload.on == true)
            recordSelection('mod_' .. payload.modType, { kind = 'mod', modType = payload.modType, toggle = true, on = payload.on == true, label = payload.label })
        else
            SetVehicleMod(veh, payload.modType, payload.index, false)
            recordSelection('mod_' .. payload.modType, { kind = 'mod', modType = payload.modType, index = payload.index, horn = payload.horn == true, label = payload.label })
        end
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
    TriggerEvent('rme:hud:setVisible', true)
    SetNuiFocus(false, false)
    RenderScriptCams(false, false, 0, true, true)
    if cam then DestroyCam(cam, false) cam = nil end
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    if bayVehicle and DoesEntityExist(bayVehicle) then FreezeEntityPosition(bayVehicle, false) end
end)
