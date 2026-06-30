-- RME Redline Custom Bay (ox_lib edition)
-- Drive a vehicle onto a bay pad, press E: a controllable showroom camera starts
-- and an ox_lib menu unlocks every cosmetic. Camera supports preset angles AND a
-- free-orbit mode (rotate / zoom / raise) so you can view the car from any angle.
-- Changes save to the vehicle when you finish.

local QBCore = exports['qb-core']:GetCoreObject()

local bayActive = false
local orbitMode = false
local bayCam = nil
local bayVehicle = nil
local currentHint = nil

-- camera state (relative to the vehicle): relAngle 0 = front, 90 = right, 180 = rear
local cam = { relAngle = 145.0, radius = 5.5, height = 1.0 }

-- forward declarations
local setHint, SaveBayVehicle, StopCustomBay, StartBayCamera
local applyMod, showList, ModList
local BayMenu, CameraMenu, EnterOrbit
local WheelsBay, WheelList, ExteriorBay, InteriorBay
local NeonBay, XenonBay, SmokeBay, TintBay, PlateBay

setHint = function(text)
    if text == currentHint then return end
    currentHint = text
    if text then
        lib.showTextUI(text, { position = 'bottom-center' })
    else
        lib.hideTextUI()
    end
end

SaveBayVehicle = function()
    if bayVehicle and DoesEntityExist(bayVehicle) then
        local props = QBCore.Functions.GetVehicleProperties(bayVehicle)
        if props then TriggerServerEvent('qb-mechanicjob:server:SaveVehicleProps', props) end
    end
end

StopCustomBay = function()
    if not bayActive then return end
    bayActive = false
    orbitMode = false
    setHint(nil)
    SaveBayVehicle()
    RenderScriptCams(false, true, 750, true, true)
    if bayCam then DestroyCam(bayCam, false) bayCam = nil end
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    if bayVehicle and DoesEntityExist(bayVehicle) then FreezeEntityPosition(bayVehicle, false) end
    bayVehicle = nil
    QBCore.Functions.Notify('Customization saved', 'success')
end

applyMod = function(modType, modIndex)
    SetVehicleModKit(bayVehicle, 0)
    SetVehicleMod(bayVehicle, modType, modIndex, false)
end

showList = function(id, title, options)
    lib.registerContext({ id = id, title = title, options = options })
    lib.showContext(id)
end

-- Generic mod-list submenu (Exterior / Interior categories) ------------------
ModList = function(id, label, modType, parentFn, isHorn)
    SetVehicleModKit(bayVehicle, 0)
    local options = {
        { title = 'Stock / None', icon = 'ban', onSelect = function() applyMod(modType, -1); ModList(id, label, modType, parentFn, isHorn) end },
    }
    for i = 0, GetNumVehicleMods(bayVehicle, modType) - 1 do
        local txt
        if isHorn then
            txt = (Config.HornLabels and Config.HornLabels[i]) or ('Horn ' .. i)
        else
            local l = GetModTextLabel(bayVehicle, modType, i)
            txt = (l and GetLabelText(l)) or (label .. ' ' .. i)
        end
        options[#options + 1] = { title = txt, onSelect = function()
            applyMod(modType, i)
            if isHorn then StartVehicleHorn(bayVehicle, 4000, GetHashKey('HELDDOWN'), false) end
            ModList(id, label, modType, parentFn, isHorn)
        end }
    end
    options[#options + 1] = { title = 'Back', icon = 'arrow-left', onSelect = parentFn }
    showList(id, label, options)
end

-- Wheels --------------------------------------------------------------------
WheelList = function(wheelTypeId, label)
    SetVehicleModKit(bayVehicle, 0)
    SetVehicleWheelType(bayVehicle, wheelTypeId)
    local options = {
        { title = 'Stock', icon = 'ban', onSelect = function() applyMod(23, -1); WheelList(wheelTypeId, label) end },
    }
    for i = 0, GetNumVehicleMods(bayVehicle, 23) - 1 do
        local l = GetModTextLabel(bayVehicle, 23, i)
        options[#options + 1] = { title = (l and GetLabelText(l)) or ('Wheel ' .. i), onSelect = function() applyMod(23, i); WheelList(wheelTypeId, label) end }
    end
    options[#options + 1] = { title = 'Back', icon = 'arrow-left', onSelect = function() WheelsBay() end }
    showList('redline_wheellist', label, options)
end

WheelsBay = function()
    local options = {}
    for i = 1, #Config.WheelCategories do
        local catg = Config.WheelCategories[i]
        options[#options + 1] = { title = catg.label, icon = 'truck-monster', arrow = true, onSelect = function() WheelList(catg.id, catg.label) end }
    end
    options[#options + 1] = { title = 'Back to Bay', icon = 'arrow-left', onSelect = function() BayMenu() end }
    showList('redline_wheels', 'Wheels', options)
end

-- Exterior / Interior -------------------------------------------------------
ExteriorBay = function()
    local options = {}
    for i = 1, #Config.ExteriorCategories do
        local catg = Config.ExteriorCategories[i]
        if GetNumVehicleMods(bayVehicle, catg.id) > 0 then
            options[#options + 1] = { title = catg.label, icon = 'car-side', arrow = true, onSelect = function() ModList('redline_extlist', catg.label, catg.id, ExteriorBay, false) end }
        end
    end
    options[#options + 1] = { title = 'Back to Bay', icon = 'arrow-left', onSelect = function() BayMenu() end }
    showList('redline_exterior', 'Exterior', options)
end

InteriorBay = function()
    local options = {}
    for i = 1, #Config.InteriorCategories do
        local catg = Config.InteriorCategories[i]
        if GetNumVehicleMods(bayVehicle, catg.id) > 0 then
            options[#options + 1] = { title = catg.label, icon = 'car', arrow = true, onSelect = function() ModList('redline_intlist', catg.label, catg.id, InteriorBay, catg.id == 14) end }
        end
    end
    options[#options + 1] = { title = 'Back to Bay', icon = 'arrow-left', onSelect = function() BayMenu() end }
    showList('redline_interior', 'Interior', options)
end

-- Neon ----------------------------------------------------------------------
NeonBay = function()
    local options = {
        { title = 'Neons Off', icon = 'power-off', onSelect = function() for n = 0, 3 do SetVehicleNeonLightEnabled(bayVehicle, n, false) end NeonBay() end },
    }
    for i = 1, #Config.NeonColors do
        local c = Config.NeonColors[i]
        options[#options + 1] = { title = c.label, icon = 'lightbulb', onSelect = function()
            for n = 0, 3 do SetVehicleNeonLightEnabled(bayVehicle, n, true) end
            SetVehicleNeonLightsColour(bayVehicle, c.r, c.g, c.b)
            NeonBay()
        end }
    end
    options[#options + 1] = { title = 'Back to Bay', icon = 'arrow-left', onSelect = function() BayMenu() end }
    showList('redline_neon', 'Neon Kits', options)
end

-- Headlights (Xenon) --------------------------------------------------------
XenonBay = function()
    local options = {
        { title = 'Xenon Off', icon = 'power-off', onSelect = function() ToggleVehicleMod(bayVehicle, 22, false); XenonBay() end },
    }
    for i = 1, #Config.Xenon do
        local x = Config.Xenon[i]
        options[#options + 1] = { title = x.label, icon = 'car-battery', onSelect = function()
            ToggleVehicleMod(bayVehicle, 22, true)
            SetVehicleXenonLightsColor(bayVehicle, x.id)
            XenonBay()
        end }
    end
    options[#options + 1] = { title = 'Back to Bay', icon = 'arrow-left', onSelect = function() BayMenu() end }
    showList('redline_xenon', 'Headlights', options)
end

-- Tire Smoke ----------------------------------------------------------------
SmokeBay = function()
    local options = {
        { title = 'Smoke Off', icon = 'power-off', onSelect = function() ToggleVehicleMod(bayVehicle, 20, false); SmokeBay() end },
    }
    for i = 1, #Config.TyreSmoke do
        local s = Config.TyreSmoke[i]
        options[#options + 1] = { title = s.label, icon = 'smog', onSelect = function()
            ToggleVehicleMod(bayVehicle, 20, true)
            SetVehicleTyreSmokeColor(bayVehicle, s.r, s.g, s.b)
            SmokeBay()
        end }
    end
    options[#options + 1] = { title = 'Back to Bay', icon = 'arrow-left', onSelect = function() BayMenu() end }
    showList('redline_smoke', 'Tire Smoke', options)
end

-- Window Tint ---------------------------------------------------------------
TintBay = function()
    local options = {}
    for i = 1, #Config.WindowTints do
        local t = Config.WindowTints[i]
        options[#options + 1] = { title = t.label, icon = 'window-maximize', onSelect = function()
            SetVehicleModKit(bayVehicle, 0)
            SetVehicleWindowTint(bayVehicle, t.id)
            TintBay()
        end }
    end
    options[#options + 1] = { title = 'Back to Bay', icon = 'arrow-left', onSelect = function() BayMenu() end }
    showList('redline_tint', 'Window Tint', options)
end

-- Plate Style ---------------------------------------------------------------
PlateBay = function()
    local options = {}
    for i = 1, #Config.PlateIndexes do
        local p = Config.PlateIndexes[i]
        options[#options + 1] = { title = p.label, icon = 'id-card', onSelect = function()
            SetVehicleNumberPlateTextIndex(bayVehicle, p.id)
            PlateBay()
        end }
    end
    options[#options + 1] = { title = 'Back to Bay', icon = 'arrow-left', onSelect = function() BayMenu() end }
    showList('redline_plate', 'Plate Style', options)
end

-- Camera --------------------------------------------------------------------
local function applyPreset(relAngle, radius, height)
    cam.relAngle = relAngle % 360.0
    cam.radius = radius
    cam.height = height
end

EnterOrbit = function()
    orbitMode = true
    -- hint + input are handled by the camera render thread
end

CameraMenu = function()
    local options = {
        { title = 'Free Orbit (manual control)', description = 'A/D rotate, W/S zoom, Shift/Ctrl height. Press E to reopen the menu.', icon = 'arrows-up-down-left-right', onSelect = function() EnterOrbit() end },
        { title = 'Front', icon = 'car', onSelect = function() applyPreset(0.0, 5.0, 0.9); CameraMenu() end },
        { title = 'Front 3/4', icon = 'car', onSelect = function() applyPreset(45.0, 5.2, 1.0); CameraMenu() end },
        { title = 'Side', icon = 'car-side', onSelect = function() applyPreset(90.0, 5.0, 0.9); CameraMenu() end },
        { title = 'Rear 3/4', icon = 'car', onSelect = function() applyPreset(135.0, 5.2, 1.0); CameraMenu() end },
        { title = 'Rear', icon = 'car-rear', onSelect = function() applyPreset(180.0, 5.0, 0.9); CameraMenu() end },
        { title = 'Top Down', icon = 'helicopter', onSelect = function() applyPreset(180.0, 3.0, 4.5); CameraMenu() end },
        { title = 'Reset View', icon = 'rotate', onSelect = function() applyPreset(145.0, 5.5, 1.0); CameraMenu() end },
        { title = 'Back to Bay', icon = 'arrow-left', onSelect = function() BayMenu() end },
    }
    showList('redline_camera', 'Camera & View', options)
end

-- Root bay menu -------------------------------------------------------------
BayMenu = function()
    if not bayVehicle or not DoesEntityExist(bayVehicle) then StopCustomBay() return end
    local options = {
        { title = 'Camera & View', description = 'Spin, zoom & pick the perfect angle', icon = 'camera', arrow = true, onSelect = function() CameraMenu() end },
        { title = 'Paint', description = 'Primary, secondary, pearl & wheel colors', icon = 'fill-drip', arrow = true, onSelect = function() if PaintCategories then PaintCategories() else QBCore.Functions.Notify('Paint module unavailable', 'error') end end },
        { title = 'Wheels', icon = 'truck-monster', arrow = true, onSelect = function() WheelsBay() end },
        { title = 'Tire Smoke', icon = 'smog', arrow = true, onSelect = function() SmokeBay() end },
        { title = 'Exterior', icon = 'car-side', arrow = true, onSelect = function() ExteriorBay() end },
        { title = 'Interior', icon = 'car', arrow = true, onSelect = function() InteriorBay() end },
        { title = 'Neon Kits', icon = 'lightbulb', arrow = true, onSelect = function() NeonBay() end },
        { title = 'Headlights', icon = 'car-battery', arrow = true, onSelect = function() XenonBay() end },
        { title = 'Window Tint', icon = 'window-maximize', arrow = true, onSelect = function() TintBay() end },
        { title = 'Plate Style', icon = 'id-card', arrow = true, onSelect = function() PlateBay() end },
        { title = 'Finish & Exit Bay', icon = 'door-open', onSelect = function() StopCustomBay() end },
    }
    lib.registerContext({ id = 'redline_bay', title = 'Redline Custom Bay', options = options })
    lib.showContext('redline_bay')
end

-- Camera render + control thread --------------------------------------------
StartBayCamera = function()
    cam.relAngle, cam.radius, cam.height = 145.0, 5.5, 1.0
    local c = GetEntityCoords(bayVehicle)
    bayCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', c.x, c.y, c.z + 1.0, 0.0, 0.0, 0.0, 50.0, false, 0)
    SetCamActive(bayCam, true)
    RenderScriptCams(true, true, 750, true, true)
    bayActive = true
    CreateThread(function()
        while bayActive do
            if not bayVehicle or not DoesEntityExist(bayVehicle) then StopCustomBay() break end
            local rad = math.rad(cam.relAngle)
            local pos = GetOffsetFromEntityInWorldCoords(bayVehicle, cam.radius * math.sin(rad), cam.radius * math.cos(rad), cam.height)
            SetCamCoord(bayCam, pos.x, pos.y, pos.z)
            PointCamAtEntity(bayCam, bayVehicle, 0.0, 0.0, 0.2, true)
            if orbitMode then
                setHint('[A/D] Rotate   [W/S] Zoom   [Shift/Ctrl] Height   [E] Menu   [Backspace] Exit')
                if IsControlPressed(0, 34) then cam.relAngle = (cam.relAngle - 1.8) % 360.0 end
                if IsControlPressed(0, 35) then cam.relAngle = (cam.relAngle + 1.8) % 360.0 end
                if IsControlPressed(0, 32) then cam.radius = math.max(2.5, cam.radius - 0.06) end
                if IsControlPressed(0, 33) then cam.radius = math.min(13.0, cam.radius + 0.06) end
                if IsControlPressed(0, 241) then cam.radius = math.max(2.5, cam.radius - 0.12) end
                if IsControlPressed(0, 242) then cam.radius = math.min(13.0, cam.radius + 0.12) end
                if IsControlPressed(0, 21) then cam.height = math.min(6.0, cam.height + 0.035) end
                if IsControlPressed(0, 36) then cam.height = math.max(-1.5, cam.height - 0.035) end
                if IsControlJustReleased(0, 38) or IsControlJustReleased(0, 191) then orbitMode = false; BayMenu() end
                if IsControlJustReleased(0, 194) then StopCustomBay() break end
            else
                setHint('[E] Open Menu   [Backspace] Exit Bay')
                if IsControlJustReleased(0, 38) then BayMenu() end
                if IsControlJustReleased(0, 194) then StopCustomBay() break end
            end
            Wait(0)
        end
    end)
end

-- Entry point (called from the passive [E] prompt in client/main.lua) --------
function OpenCustomBay()
    if bayActive then return end
    local vehicle, distance = QBCore.Functions.GetClosestVehicle()
    if not vehicle or vehicle == 0 or distance > 6.0 then
        QBCore.Functions.Notify('Pull a vehicle onto the bay first', 'error')
        return
    end
    if Config.IgnoreClasses and Config.IgnoreClasses[GetVehicleClass(vehicle)] then
        QBCore.Functions.Notify("This vehicle can't be customized here", 'error')
        return
    end
    SetVehicleModKit(vehicle, 0)
    bayVehicle = vehicle
    orbitMode = false
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    FreezeEntityPosition(vehicle, true)
    SetVehicleEngineOn(vehicle, false, true, true)
    StartBayCamera()
    BayMenu()
end

-- Safety: restore camera/ped if the resource stops while someone is in the bay
AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if not bayActive then return end
    bayActive = false
    orbitMode = false
    pcall(function() lib.hideTextUI() end)
    RenderScriptCams(false, false, 0, true, true)
    if bayCam then DestroyCam(bayCam, false) bayCam = nil end
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    if bayVehicle and DoesEntityExist(bayVehicle) then FreezeEntityPosition(bayVehicle, false) end
end)
