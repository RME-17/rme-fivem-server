-- rme-vehdamage
-- GLOBAL RULE: crashing NEVER reduces engine health.
--
--   * Vehicles still take full DEFAULT GTA body / cosmetic / deformation damage
--     (dents, smashed panels, broken windows, flat tyres, etc.) - the bodywork
--     looks exactly like stock GTA after a crash.
--   * The ENGINE is protected from collision damage, so cars keep running and
--     driving at FULL speed no matter how smashed the bodywork gets.
--   * Because the engine no longer degrades from crashes, the old engine-based
--     speed slowdown is retired - cars always drive normally.
--
-- Runs client-side: each player protects the vehicle they are in, so the rule
-- applies to every car being driven on the server (a "global" effect).
--
-- HOW IT WORKS: when you get into a vehicle we record its current engine health
-- as the value to protect (so an already-damaged car is preserved, not magically
-- repaired). Every tick we restore engine health back up to that value if a
-- collision knocked it down. Repairs that RAISE engine health are allowed and
-- become the new protected value.

-- How quickly (ms) we restore engine health while driving. Small enough that a
-- hard crash never gets to smoke / catch fire before we top it back up.
local RESTORE_INTERVAL = 50

local function protectEngine(veh, baseline)
    if not DoesEntityExist(veh) then return baseline end
    local current = GetVehicleEngineHealth(veh)
    -- Allow repairs / legitimate increases to raise the protected baseline.
    if current > baseline then
        baseline = current
    -- A crash dropped engine health below the protected value -> restore it.
    elseif current < baseline then
        SetVehicleEngineHealth(veh, baseline)
    end
    return baseline
end

CreateThread(function()
    local lastVeh = nil
    local baseline = nil
    while true do
        local wait = 500
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 then
            if veh ~= lastVeh then
                -- Entered a (different) vehicle: capture its current engine
                -- health as the level we will protect from crash damage.
                baseline = GetVehicleEngineHealth(veh)
                lastVeh = veh
            end
            baseline = protectEngine(veh, baseline)
            wait = RESTORE_INTERVAL
        else
            lastVeh = nil
            baseline = nil
        end
        Wait(wait)
    end
end)
