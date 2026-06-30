-- rme-vehdamage
-- Makes the car you are driving take damage faster than stock GTA V.
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

local lastVeh, lastBody, lastEngine = nil, nil, nil

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
            lastVeh, lastBody, lastEngine = veh, curBody, curEngine
            Wait(0)
        else
            lastVeh, lastBody, lastEngine = nil, nil, nil
            Wait(500)
        end
    end
end)
