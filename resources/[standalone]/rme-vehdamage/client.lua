-- rme-vehdamage
-- Vehicles take DEFAULT GTA V damage (no amplification).
--
-- Driving rules:
--   * BODY / cosmetic damage NEVER affects driving - the car always drives
--     normally no matter how smashed the bodywork looks (even fully red).
--   * ENGINE condition controls top speed, matching the HUD bar colours:
--       engine  > 60%  (green)  -> normal speed
--       engine 30-60%  (yellow) -> drives slower
--       engine <= 30%  (red)    -> drives much slower
-- Only affects the driver's own vehicle (runs client-side per player).
--
-- ================= TUNING =================
local YELLOW_CAP = 0.70   -- top-speed factor while engine is in the yellow zone
local RED_CAP    = 0.45   -- top-speed factor while engine is in the red zone
local NO_LIMIT   = 200.0  -- m/s (~720 km/h): effectively no cap when healthy
-- ==========================================

local lastVeh = nil

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        -- only govern the vehicle WE are driving
        if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
            local engPct = GetVehicleEngineHealth(veh) / 10.0   -- 0..100
            if engPct > 60.0 then
                -- green: lift any cap, drive normally
                SetVehicleMaxSpeed(veh, NO_LIMIT)
            else
                local baseMax = GetVehicleEstimatedMaxSpeed(veh) -- m/s for this model
                if baseMax <= 0.0 then baseMax = 50.0 end
                local factor = (engPct > 30.0) and YELLOW_CAP or RED_CAP
                SetVehicleMaxSpeed(veh, baseMax * factor)
            end
            lastVeh = veh
            Wait(200)
        else
            -- released the vehicle: remove our speed cap so it drives normally for others
            if lastVeh and DoesEntityExist(lastVeh) then
                SetVehicleMaxSpeed(lastVeh, NO_LIMIT)
            end
            lastVeh = nil
            Wait(500)
        end
    end
end)
