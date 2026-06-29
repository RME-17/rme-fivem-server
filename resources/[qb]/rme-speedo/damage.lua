-- RME realistic vehicle damage (cars/bikes/boats; aircraft + bicycles skipped).
--
--   1) Vehicles take MORE damage from impacts so they are less 'tanky'.
--   2) A completely wrecked vehicle becomes undriveable until repaired.
--
-- Runs only for the driver so damage isn't applied multiple times by passengers.

local DAMAGE_MULT = 1.8   -- total impact damage multiplier (1.0 = GTA stock). Higher = less tanky.
local KILL_ENGINE = 0.0   -- engine health (0-1000) at/below which the vehicle dies
local KILL_BODY   = 120.0 -- body health   (0-1000) at/below which the vehicle dies

local lastVeh = 0
local lastBody = 1000.0
local lastEngine = 1000.0

local function isAircraft(veh)
    local model = GetEntityModel(veh)
    return IsThisModelAHeli(model) or IsThisModelAPlane(model)
end

CreateThread(function()
    while true do
        local sleep = 500
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        -- Only the driver processes damage, and never for aircraft / bicycles.
        if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped
            and not IsThisModelABicycle(GetEntityModel(veh)) and not isAircraft(veh) then
            sleep = 50
            if veh ~= lastVeh then
                -- New vehicle: snapshot its current health, don't amplify yet.
                lastVeh = veh
                lastBody = GetVehicleBodyHealth(veh)
                lastEngine = GetVehicleEngineHealth(veh)
            else
                local body = GetVehicleBodyHealth(veh)
                local engine = GetVehicleEngineHealth(veh)

                -- Amplify body damage taken since the last check.
                if body < lastBody then
                    local newBody = body - (lastBody - body) * (DAMAGE_MULT - 1.0)
                    if newBody < 0.0 then newBody = 0.0 end
                    SetVehicleBodyHealth(veh, newBody)
                    body = newBody
                end
                -- Amplify engine damage taken since the last check.
                if engine < lastEngine then
                    local newEngine = engine - (lastEngine - engine) * (DAMAGE_MULT - 1.0)
                    if newEngine < 0.0 then newEngine = 0.0 end
                    SetVehicleEngineHealth(veh, newEngine)
                    engine = newEngine
                end

                lastBody = body
                lastEngine = engine

                -- Completely wrecked -> kill the engine so it can no longer drive.
                if engine <= KILL_ENGINE or body <= KILL_BODY then
                    SetVehicleEngineHealth(veh, 0.0)
                    SetVehicleEngineOn(veh, false, true, true)
                    SetVehicleUndriveable(veh, true)
                end
            end
        else
            lastVeh = 0
        end
        Wait(sleep)
    end
end)
