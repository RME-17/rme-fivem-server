-- rme-nopeds-mlo
-- Removes ambient peds (NPCs) while the player is INSIDE any MLO / interior.
-- Ambient peds OUTSIDE in the open world are left completely untouched.
--
-- HOW IT WORKS:
--   GetInteriorFromEntity() returns a non-zero id whenever the player stands
--   inside a defined interior (every proper MLO has one). While that is true we
--   zero out ped + scenario density for that frame and periodically sweep any
--   peds that already wandered inside.
--
-- TUNING:
--   CLEAR_RADIUS      how far around you to delete stray peds while inside (m)
--   SWEEP_INTERVAL    how often (ms) to run the cleanup sweep
--   IGNORE_INTERIORS  interior ids you WANT to keep peds in (default: none)

local CLEAR_RADIUS = 60.0
local SWEEP_INTERVAL = 1000
local IGNORE_INTERIORS = {
    -- [12345] = true,  -- example: keep ambient peds in this interior id
}

CreateThread(function()
    local lastSweep = 0
    while true do
        local sleep = 500
        local ped = PlayerPedId()
        local interior = GetInteriorFromEntity(ped)
        if interior ~= 0 and not IGNORE_INTERIORS[interior] then
            sleep = 0
            -- stop new ambient + scenario peds spawning this frame
            SetPedDensityMultiplierThisFrame(0.0)
            SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
            -- periodically clear any that already spawned inside
            local now = GetGameTimer()
            if now - lastSweep > SWEEP_INTERVAL then
                lastSweep = now
                local c = GetEntityCoords(ped)
                ClearAreaOfPeds(c.x, c.y, c.z, CLEAR_RADIUS, 1)
            end
        end
        Wait(sleep)
    end
end)
