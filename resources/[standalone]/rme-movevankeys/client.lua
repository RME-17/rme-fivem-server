-- rme-movevankeys
-- moving_company spawns its van with Config.Vehicle.platePrefix = 'MOVE'. After
-- loading an item the script re-locks the van, which trips the server vehicle-key
-- system ("You don't have keys to this vehicle"). This helper forces any MOVE-plate
-- vehicle to stay unlocked so it is always openable, and best-effort grants keys.

local PLATE_PREFIX = 'MOVE'
local keyed = {}

local function isMoveVehicle(veh)
    if not veh or veh == 0 or not DoesEntityExist(veh) then return false end
    local plate = GetVehicleNumberPlateText(veh)
    if not plate then return false end
    return string.upper(string.sub(plate, 1, #PLATE_PREFIX)) == PLATE_PREFIX
end

local function ensureOpen(veh)
    -- 1 = unlocked. Reassert every tick to override the job's re-lock.
    SetVehicleDoorsLocked(veh, 1)
    SetVehicleDoorsLockedForAllPlayers(veh, false)
    SetVehicleDoorsLockedForPlayer(veh, PlayerId(), false)
    SetVehicleNeedsToBeHotwired(veh, false)

    -- Best-effort: give qb-vehiclekeys ownership once per plate, if it's running.
    if GetResourceState('qb-vehiclekeys') == 'started' then
        local plate = GetVehicleNumberPlateText(veh)
        if plate and not keyed[plate] then
            keyed[plate] = true
            TriggerEvent('vehiclekeys:client:SetOwner', plate)
        end
    end
end

CreateThread(function()
    while true do
        local wait = 1500
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        if isMoveVehicle(veh) then
            ensureOpen(veh)
            wait = 500
        else
            local c = GetEntityCoords(ped)
            local near = GetClosestVehicle(c.x, c.y, c.z, 8.0, 0, 70)
            if isMoveVehicle(near) then
                ensureOpen(near)
                wait = 500
            end
        end

        Wait(wait)
    end
end)
