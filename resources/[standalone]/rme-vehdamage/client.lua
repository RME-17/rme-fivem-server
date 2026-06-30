-- rme-vehdamage
-- Makes the car you are driving take damage faster than stock GTA V.
-- Only affects the driver's own vehicle (runs client-side per player).
--
-- TUNE HERE:
--   1.0 = stock GTA damage (no change)
--   2.0 = twice as much damage per hit
--   2.5 = current setting (cars break noticeably faster)
--   4.0+ = very fragile
local BODY_MULT   = 2.5   -- body/collision damage multiplier
local ENGINE_MULT = 2.5   -- engine damage multiplier

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
