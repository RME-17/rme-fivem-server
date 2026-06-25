-- RME dedicated speedometer (bottom-right). Cars + aircraft.
local UseMPH = true -- set false for KM/H (also change the unit shown)
local speedMult = UseMPH and 2.23694 or 3.6
local speedUnit = UseMPH and 'MPH' or 'KM/H'
local FuelScript = 'LegacyFuel'

local function getFuel(veh)
    local ok, fuel = pcall(function()
        return exports[FuelScript]:GetFuel(veh)
    end)
    if ok and fuel then
        return math.floor(fuel + 0.5)
    end
    return math.floor(GetVehicleFuelLevel(veh) + 0.5)
end

local shown = false

CreateThread(function()
    while true do
        local sleep = 350
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            if veh ~= 0 and not IsThisModelABicycle(GetEntityModel(veh)) then
                sleep = 90
                local isAir = IsPedInAnyHeli(ped) or IsPedInAnyPlane(ped)
                local speed = math.floor(GetEntitySpeed(veh) * speedMult + 0.5)
                local rpm = GetVehicleCurrentRpm(veh)
                local gear = GetVehicleCurrentGear(veh)
                local fuel = getFuel(veh)
                local alt = math.floor(GetEntityCoords(ped).z + 0.5)
                if not shown then
                    shown = true
                    SendNUIMessage({ action = 'speedo', show = true })
                end
                SendNUIMessage({
                    action = 'update',
                    speed = speed,
                    unit = speedUnit,
                    rpm = rpm,
                    gear = gear,
                    fuel = fuel,
                    altitude = alt,
                    isAir = isAir,
                })
            elseif shown then
                shown = false
                SendNUIMessage({ action = 'speedo', show = false })
            end
        elseif shown then
            shown = false
            SendNUIMessage({ action = 'speedo', show = false })
        end
        Wait(sleep)
    end
end)
