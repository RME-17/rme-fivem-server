-- rme-vehdamage
-- 1) Makes the car you are driving take damage faster than stock GTA V.
-- 2) Body crashes also wear the ENGINE, so repeatedly bashing the car will
--    eventually fully wreck it (engine 0%) even from cosmetic hits.
-- 3) When the engine hits 0%, one axle's wheels fall off and the car becomes
--    undriveable until a mechanic repairs it.
-- Only affects the driver's own vehicle (runs client-side per player).
--
-- ================= TUNING =================
-- Body and engine are SEPARATE health pools (0..1000). Higher multiplier = faster damage.
--   1.0  = stock GTA (toughest, no change)
--   2.0  = current (twice the damage per hit)
--   3.0+ = very fragile
local BODY_MULT      = 2.0   -- body/collision damage multiplier
local ENGINE_MULT    = 2.0   -- engine damage multiplier
-- How much of the body damage also bleeds into the engine (0 = none, 1 = all).
-- This is what makes ordinary crashes progress the car toward a full wreck.
local BODY_TO_ENGINE = 0.4
-- Engine health at/below which the car is considered fully wrecked.
local DEAD_AT = 0.0
-- ==========================================

local lastVeh, lastBody, lastEngine = nil, nil, nil
local wrecked = {}   -- vehicles already wrecked this life (reset on repair)

-- Drop one axle's wheels (random front or rear) and lock the car down so it
-- cannot be driven again until repaired.
local function wreckVehicle(veh)
    SetVehicleUndriveable(veh, true)
    SetVehicleEngineOn(veh, false, true, true)
    SetVehicleWheelsCanBreak(veh, true)
    -- wheel indices: 0 = front-left, 1 = front-right, 4 = rear-left, 5 = rear-right
    if math.random(2) == 1 then
        BreakOffVehicleWheel(veh, 4, false, true, true, false) -- rear axle
        BreakOffVehicleWheel(veh, 5, false, true, true, false)
    else
        BreakOffVehicleWheel(veh, 0, false, true, true, false) -- front axle
        BreakOffVehicleWheel(veh, 1, false, true, true, false)
    end
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        -- only amplify damage when WE are the driver
        if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
            local curBody = GetVehicleBodyHealth(veh)
            local curEngine = GetVehicleEngineHealth(veh)
            if veh == lastVeh and lastBody and lastEngine then
                -- ENGINE: amplify the engine's own damage (use raw values first)
                if curEngine < lastEngine then
                    local extra = (lastEngine - curEngine) * (ENGINE_MULT - 1.0)
                    curEngine = math.max(0.0, curEngine - extra)
                end
                -- BODY: amplify body damage, then bleed part of it into the engine
                if curBody < lastBody then
                    local delta = lastBody - curBody
                    local extra = delta * (BODY_MULT - 1.0)
                    curBody = math.max(0.0, curBody - extra)
                    local bleed = (delta + extra) * BODY_TO_ENGINE
                    curEngine = math.max(0.0, curEngine - bleed)
                end
                SetVehicleBodyHealth(veh, curBody)
                SetVehicleEngineHealth(veh, curEngine)
            end

            -- fully wrecked -> drop wheels + lock down (once per life)
            if curEngine <= DEAD_AT and not wrecked[veh] then
                wrecked[veh] = true
                wreckVehicle(veh)
            elseif curEngine > 100.0 and wrecked[veh] then
                wrecked[veh] = nil   -- repaired, allow it to be wrecked again later
            end

            lastVeh, lastBody, lastEngine = veh, curBody, curEngine
            Wait(0)
        else
            lastVeh, lastBody, lastEngine = nil, nil, nil
            Wait(500)
        end
    end
end)
