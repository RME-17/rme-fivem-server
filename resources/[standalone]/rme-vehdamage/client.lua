-- rme-vehdamage
-- 1) Makes the car you are driving take damage faster than stock GTA V.
-- 2) When the ENGINE is fully destroyed (0%), one axle's wheels fall off and
--    the car becomes undriveable until a mechanic repairs it.
-- Only affects the driver's own vehicle (runs client-side per player).
--
-- Body and engine are SEPARATE health pools and can be tuned independently:
--   1.0 = stock GTA damage (no change / toughest)
--   1.2 = engine current (only a little less tanky than stock)
--   1.5 = body current (noticeably less tanky)
--   2.0 = twice as much damage per hit
--   2.5+ = very fragile
local BODY_MULT   = 1.5   -- body/collision (cosmetic crumpling) damage multiplier
local ENGINE_MULT = 1.2   -- engine damage multiplier (lower = engine stays stronger)

-- Engine health (0..1000) at/below which the car is considered fully wrecked.
local DEAD_AT = 0.0

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
        -- rear axle
        BreakOffVehicleWheel(veh, 4, false, true, true, false)
        BreakOffVehicleWheel(veh, 5, false, true, true, false)
    else
        -- front axle
        BreakOffVehicleWheel(veh, 0, false, true, true, false)
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
                -- body took a hit this frame -> apply extra damage
                if curBody < lastBody then
                    local extra = (lastBody - curBody) * (BODY_MULT - 1.0)
                    curBody = math.max(0.0, curBody - extra)
                    SetVehicleBodyHealth(veh, curBody)
                end
                -- engine took a hit this frame -> apply extra damage
                if curEngine < lastEngine then
                    local extra = (lastEngine - curEngine) * (ENGINE_MULT - 1.0)
                    curEngine = math.max(0.0, curEngine - extra)
                    SetVehicleEngineHealth(veh, curEngine)
                end
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
