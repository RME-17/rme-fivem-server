-- rme-movevankeys
-- moving_company spawns its job van with Config.Vehicle.platePrefix = 'MOVE'.
-- The server runs qb-vehiclekeys, which cuts the engine and shows the "Search for
-- Keys" prompt on any vehicle you don't hold keys to -- so unlocking the doors alone
-- is NOT enough to drive. qb-vehiclekeys exempts any vehicle whose statebag has
-- ignoreLocks = true (see its isBlacklistedVehicle check), so we flag the MOVE van
-- that way. We also keep the doors unlocked to counter the job's re-lock after loading.

local PLATE_PREFIX = 'MOVE'
local flagged = {}

local function isMoveVehicle(veh)
    if not veh or veh == 0 or not DoesEntityExist(veh) then return false end
    local plate = GetVehicleNumberPlateText(veh)
    if not plate then return false end
    return string.upper(string.sub(plate, 1, #PLATE_PREFIX)) == PLATE_PREFIX
end

local function exempt(veh)
    local plate = GetVehicleNumberPlateText(veh)
    if plate and not flagged[plate] then
        flagged[plate] = true
        -- Tell qb-vehiclekeys to leave this van alone: no engine cut, no "Search for Keys".
        Entity(veh).state:set('ignoreLocks', true, true)
    end
    -- Counter the job's re-lock after loading so the van can always be opened.
    SetVehicleDoorsLocked(veh, 1)                 -- 1 = unlocked
    SetVehicleDoorsLockedForAllPlayers(veh, false)
    SetVehicleNeedsToBeHotwired(veh, false)
end

CreateThread(function()
    while true do
        local wait = 1500
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        if isMoveVehicle(veh) then
            exempt(veh)
            wait = 500
        else
            local c = GetEntityCoords(ped)
            local near = GetClosestVehicle(c.x, c.y, c.z, 8.0, 0, 70)
            if isMoveVehicle(near) then
                exempt(near)
                wait = 500
            end
        end

        Wait(wait)
    end
end)
