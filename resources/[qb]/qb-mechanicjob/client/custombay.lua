-- RME Benny's Custom Bay
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
        local lbl = GetModTextLabel(veh