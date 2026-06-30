-- RME Redline Custom Bay
-- Drive a vehicle onto the bay pad, hop out, press E: an orbit "showroom" camera
-- starts and a single menu unlocks every cosmetic (no consumable items needed).
-- Changes are saved to the vehicle (owned vehicles persist) when you finish.

local QBCore = exports['qb-core']:GetCoreObject()

local bayCam = nil
local bayActive = false
local bayVehicle = nil

-- forward declarations so the menu builders can reference each other
local BayMenu, WheelsBay, WheelList, ExteriorBay, ExteriorList, InteriorBay, InteriorList
local NeonBay, XenonBay, TintBay, PlateBay, SmokeBay

local function SaveBayVehicle()
    if bayVehicle and DoesEntityExist(bayVehicle) then
        local props = QBCore.Functions.GetVehicleProperties(bayVehicle)
        if props then TriggerServerEvent('qb-mechanicjob:server:SaveVehicleProps', props) end
    end
end

local function StopCustomBay()
    if not bayActive then return end
    bayActive = false
    SaveBayVehicle()
    RenderScriptCams(false, true, 750, true, true)
    if bayCam then DestroyCam(bayCam, false) bayCam = nil end
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    if bayVehicle and DoesEntityExist(bayVehicle) then FreezeEntityPosition(bayVehicle, false) end
    bayVehicle = nil
end

local function StartBayCamera(vehicle)
    local center = GetEntityCoords(vehicle)
    local radius, height = 5.5, 1.2
    bayCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', center.x + radius, center.y, center.z + height, 0.0, 0.0, 0.0, 55.0, false, 0)
    PointCamAtEntity(bayCam, vehicle, 0.0, 0.0, 0.0, true)
    SetCamActive(bayCam, true)
    RenderScriptCams(true, true, 750, true, true)
    bayActive = true
    CreateThread(function()
        local angle = 0.0
        while bayActive and DoesEntityExist(vehicle) do
            angle = angle + 0.12
            if angle >= 360.0 then angle = angle - 360.0 end
            local rad = angle * math.pi / 180.0
            SetCamCoord(bayCam, center.x + radius * math.cos(rad), center.y + radius * math.sin(rad), center.z + height)
            PointCamAtEntity(bayCam, vehicle, 0.0, 0.0, 0.0, true)
            Wait(0)
        end
    end)
end

local function applyMod(vehicle, modType, modIndex)
    SetVehicleModKit(vehicle, 0)
    SetVehicleMod(vehicle, modType, modIndex, false)
end

-- Wheels --------------------------------------------------------------------
WheelList = function(vehicle, wheelTypeId, label)
    SetVehicleModKit(vehicle, 0)
    SetVehicleWheelType(vehicle, wheelTypeId)
    local menu = {
        { header = label, isMenuHeader = true, icon = 'fas fa-truck-monster' },
        { header = '< Back', icon = 'fas fa-backward', params = { isAction = true, event = function() WheelsBay(vehicle) end, args = {} } },
        { header = 'Stock', params = { isAction = true, event = function() applyMod(vehicle, 23, -1); WheelList(vehicle, wheelTypeId, label) end, args = {} } },
    }
    for i = 0, GetNumVehicleMods(vehicle, 23) - 1 do
        local lbl = GetModTextLabel(vehicle, 23, i)
        menu[#menu + 1] = { header = (lbl and GetLabelText(lbl)) or ('Wheel ' .. i), params = { isAction = true, event = function() applyMod(vehicle, 23, i); WheelList(vehicle, wheelTypeId, label) end, args = {} } }
    end
    exports['qb-menu']:openMenu(menu)
end

WheelsBay = function(vehicle)
    local menu = {
        { header = 'Wheels', isMenuHeader = true, icon = 'fas fa-truck-monster' },
        { header = '< Back to Bay', icon = 'fas fa-backward', params = { isAction = true, event = function() BayMenu(vehicle) end, args = {} } },
    }
    for i = 1, #Config.WheelCategories do
        local cat = Config.WheelCategories[i]
        menu[#menu + 1] = { header = cat.label, params = { isAction = true, event = function() WheelList(vehicle, cat.id, cat.label) end, args = {} } }
    end
    exports['qb-menu']:openMenu(menu)
end

-- Exterior ------------------------------------------------------------------
ExteriorList = function(vehicle, id, label)
    local menu = {
        { header = label, isMenuHeader = true, icon = 'fas fa-car-side' },
        { header = '< Back', icon = 'fas fa-backward', params = { isAction = true, event = function() ExteriorBay(vehicle) end, args = {} } },
        { header = 'Stock', params = { isAction = true, event = function() applyMod(vehicle, id, -1); ExteriorList(vehicle, id, label) end, args = {} } },
    }
    for i = 0, GetNumVehicleMods(vehicle, id) - 1 do
        local lbl = GetModTextLabel(vehicle, id, i)
        menu[#menu + 1] = { header = (lbl and GetLabelText(lbl)) or ('Mod ' .. i), params = { isAction = true, event = function() applyMod(vehicle, id, i); ExteriorList(vehicle, id, label) end, args = {} } }
    end
    exports['qb-menu']:openMenu(menu)
end

ExteriorBay = function(vehicle)
    local menu = {
        { header = 'Exterior', isMenuHeader = true, icon = 'fas fa-car-side' },
        { header = '< Back to Bay', icon = 'fas fa-backward', params = { isAction = true, event = function() BayMenu(vehicle) end, args = {} } },
    }
    for i = 1, #Config.ExteriorCategories do
        local cat = Config.ExteriorCategories[i]
        if GetNumVehicleMods(vehicle, cat.id) > 0 then
            menu[#menu + 1] = { header = cat.label, params = { isAction = true, event = function() ExteriorList(vehicle, cat.id, cat.label) end, args = {} } }
        end
    end
    exports['qb-menu']:openMenu(menu)
end

-- Interior ------------------------------------------------------------------
InteriorList = function(vehicle, id, label)
    local menu = {
        { header = label, isMenuHeader = true, icon = 'fas fa-car' },
        { header = '< Back', icon = 'fas fa-backward', params = { isAction = true, event = function() InteriorBay(vehicle) end, args = {} } },
        { header = 'Stock', params = { isAction = true, event = function() applyMod(vehicle, id, -1); InteriorList(vehicle, id, label) end, args = {} } },
    }
    for i = 0, GetNumVehicleMods(vehicle, id) - 1 do
        local header
        if id == 14 then
            header = (Config.HornLabels and Config.HornLabels[i]) or ('Horn ' .. i)
        else
            local lbl = GetModTextLabel(vehicle, id, i)
            header = (lbl and GetLabelText(lbl)) or ('Mod ' .. i)
        end
        menu[#menu + 1] = { header = header, params = { isAction = true, event = function()
            applyMod(vehicle, id, i)
            if id == 14 then StartVehicleHorn(vehicle, 4000, GetHashKey('HELDDOWN'), false) end
            InteriorList(vehicle, id, label)
        end, args = {} } }
    end
    exports['qb-menu']:openMenu(menu)
end

InteriorBay = function(vehicle)
    local menu = {
        { header = 'Interior', isMenuHeader = true, icon = 'fas fa-car' },
        { header = '< Back to Bay', icon = 'fas fa-backward', params = { isAction = true, event = function() BayMenu(vehicle) end, args = {} } },
    }
    for i = 1, #Config.InteriorCategories do
        local cat = Config.InteriorCategories[i]
        if GetNumVehicleMods(vehicle, cat.id) > 0 then
            menu[#menu + 1] = { header = cat.label, params = { isAction = true, event = function() InteriorList(vehicle, cat.id, cat.label) end, args = {} } }
        end
    end
    exports['qb-menu']:openMenu(menu)
end

-- Neon ----------------------------------------------------------------------
NeonBay = function(vehicle)
    local menu = {
        { header = 'Neon Kits', isMenuHeader = true, icon = 'fas fa-lightbulb' },
        { header = '< Back to Bay', icon = 'fas fa-backward', params = { isAction = true, event = function() BayMenu(vehicle) end, args = {} } },
        { header = 'Neons Off', params = { isAction = true, event = function()
            for n = 0, 3 do SetVehicleNeonLightEnabled(vehicle, n, false) end
            NeonBay(vehicle)
        end, args = {} } },
    }
    for i = 1, #Config.NeonColors do
        local c = Config.NeonColors[i]
        menu[#menu + 1] = { header = c.label, params = { isAction = true, event = function()
            for n = 0, 3 do SetVehicleNeonLightEnabled(vehicle, n, true) end
            SetVehicleNeonLightsColour(vehicle, c.r, c.g, c.b)
            NeonBay(vehicle)
        end, args = {} } }
    end
    exports['qb-menu']:openMenu(menu)
end

-- Headlights (Xenon) --------------------------------------------------------
XenonBay = function(vehicle)
    local menu = {
        { header = 'Headlights', isMenuHeader = true, icon = 'fas fa-car-battery' },
        { header = '< Back to Bay', icon = 'fas fa-backward', params = { isAction = true, event = function() BayMenu(vehicle) end, args = {} } },
        { header = 'Xenon Off', params = { isAction = true, event = function() ToggleVehicleMod(vehicle, 22, false); XenonBay(vehicle) end, args = {} } },
    }
    for i = 1, #Config.Xenon do
        local x = Config.Xenon[i]
        menu[#menu + 1] = { header = x.label, params = { isAction = true, event = function()
            ToggleVehicleMod(vehicle, 22, true)
            SetVehicleXenonLightsColor(vehicle, x.id)
            XenonBay(vehicle)
        end, args = {} } }
    end
    exports['qb-menu']:openMenu(menu)
end

-- Tire Smoke ----------------------------------------------------------------
SmokeBay = function(vehicle)
    local menu = {
        { header = 'Tire Smoke', isMenuHeader = true, icon = 'fas fa-smog' },
        { header = '< Back to Bay', icon = 'fas fa-backward', params = { isAction = true, event = function() BayMenu(vehicle) end, args = {} } },
        { header = 'Smoke Off', params = { isAction = true, event = function() ToggleVehicleMod(vehicle, 20, false); SmokeBay(vehicle) end, args = {} } },
    }
    for i = 1, #Config.TyreSmoke do
        local s = Config.TyreSmoke[i]
        menu[#menu + 1] = { header = s.label, params = { isAction = true, event = function()
            ToggleVehicleMod(vehicle, 20, true)
            SetVehicleTyreSmokeColor(vehicle, s.r, s.g, s.b)
            SmokeBay(vehicle)
        end, args = {} } }
    end
    exports['qb-menu']:openMenu(menu)
end

-- Window Tint ---------------------------------------------------------------
TintBay = function(vehicle)
    local menu = {
        { header = 'Window Tint', isMenuHeader = true, icon = 'fas fa-window-maximize' },
        { header = '< Back to Bay', icon = 'fas fa-backward', params = { isAction = true, event = function() BayMenu(vehicle) end, args = {} } },
    }
    for i = 1, #Config.WindowTints do
        local t = Config.WindowTints[i]
        menu[#menu + 1] = { header = t.label, params = { isAction = true, event = function()
            SetVehicleModKit(vehicle, 0)
            SetVehicleWindowTint(vehicle, t.id)
            TintBay(vehicle)
        end, args = {} } }
    end
    exports['qb-menu']:openMenu(menu)
end

-- Plate Style ---------------------------------------------------------------
PlateBay = function(vehicle)
    local menu = {
        { header = 'Plate Style', isMenuHeader = true, icon = 'fas fa-id-card' },
        { header = '< Back to Bay', icon = 'fas fa-backward', params = { isAction = true, event = function() BayMenu(vehicle) end, args = {} } },
    }
    for i = 1, #Config.PlateIndexes do
        local p = Config.PlateIndexes[i]
        menu[#menu + 1] = { header = p.label, params = { isAction = true, event = function()
            SetVehicleNumberPlateTextIndex(vehicle, p.id)
            PlateBay(vehicle)
        end, args = {} } }
    end
    exports['qb-menu']:openMenu(menu)
end

-- Root bay menu -------------------------------------------------------------
BayMenu = function(vehicle)
    local menu = {
        { header = "Redline Custom Bay", txt = 'All customization unlocked', isMenuHeader = true, icon = 'fas fa-paint-roller' },
        { header = 'Paint', txt = 'Primary, secondary, pearl & wheel colors', icon = 'fas fa-fill-drip', params = { isAction = true, event = function() PaintCategories() end, args = {} } },
        { header = 'Wheels', icon = 'fas fa-truck-monster', params = { isAction = true, event = function() WheelsBay(vehicle) end, args = {} } },
        { header = 'Tire Smoke', icon = 'fas fa-smog', params = { isAction = true, event = function() SmokeBay(vehicle) end, args = {} } },
        { header = 'Exterior', icon = 'fas fa-car-side', params = { isAction = true, event = function() ExteriorBay(vehicle) end, args = {} } },
        { header = 'Interior', icon = 'fas fa-car', params = { isAction = true, event = function() InteriorBay(vehicle) end, args = {} } },
        { header = 'Neon Kits', icon = 'fas fa-lightbulb', params = { isAction = true, event = function() NeonBay(vehicle) end, args = {} } },
        { header = 'Headlights', icon = 'fas fa-car-battery', params = { isAction = true, event = function() XenonBay(vehicle) end, args = {} } },
        { header = 'Window Tint', icon = 'fas fa-window-maximize', params = { isAction = true, event = function() TintBay(vehicle) end, args = {} } },
        { header = 'Plate Style', icon = 'fas fa-id-card', params = { isAction = true, event = function() PlateBay(vehicle) end, args = {} } },
        { header = 'Finish & Exit Bay', icon = 'fas fa-door-open', params = { isAction = true, event = function() StopCustomBay() end, args = {} } },
    }
    exports['qb-menu']:openMenu(menu)
end

-- Entry point (called from the qb-target bay zone in client/main.lua) --------
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
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    FreezeEntityPosition(vehicle, true)
    SetVehicleEngineOn(vehicle, false, true, true)
    StartBayCamera(vehicle)
    BayMenu(vehicle)
    CreateThread(function()
        while bayActive do
            if not bayVehicle or not DoesEntityExist(bayVehicle) then
                StopCustomBay()
                break
            end
            BeginTextCommandDisplayHelp('STRING')
            AddTextComponentSubstringPlayerName('Press ~INPUT_PICKUP~ to open the menu  -  ~INPUT_FRONTEND_CANCEL~ to exit the bay')
            EndTextCommandDisplayHelp(0, false, true, -1)
            if IsControlJustReleased(0, 38) then
                BayMenu(bayVehicle)
            elseif IsControlJustReleased(0, 194) then
                StopCustomBay()
            end
            Wait(0)
        end
    end)
end

-- Safety: restore camera/ped if the resource stops while someone is in the bay
AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if not bayActive then return end
    bayActive = false
    RenderScriptCams(false, false, 0, true, true)
    if bayCam then DestroyCam(bayCam, false) bayCam = nil end
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    if bayVehicle and DoesEntityExist(bayVehicle) then FreezeEntityPosition(bayVehicle, false) end
end)
