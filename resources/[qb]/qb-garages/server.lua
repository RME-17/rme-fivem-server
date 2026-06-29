local QBCore = exports['qb-core']:GetCoreObject({ 'Functions' })
local sharedVehicles = exports['qb-core']:GetShared('Vehicles')
local OutsideVehicles = {}

-- Handler

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        -- RME: clear deadlocks from the previous session and confirm the build
        -- that is actually running on the live server.
        print('^2[qb-garages] RME build active: transfer + self-heal + spawn diagnostics^0')
        if Config['AutoRespawn'] then
            MySQL.update('UPDATE player_vehicles SET state = 1 WHERE state = 0', {})
        else
            MySQL.update('UPDATE player_vehicles SET depotprice = 500 WHERE state = 0', {})
        end
    end
end)

-- Functions

local vehicleClasses = {
    compacts = 0,
    sedans = 1,
    suvs = 2,
    coupes = 3,
    muscle = 4,
    sportsclassics = 5,
    sports = 6,
    super = 7,
    motorcycles = 8,
    offroad = 9,
    industrial = 10,
    utility = 11,
    vans = 12,
    cycles = 13,
    boats = 14,
    helicopters = 15,
    planes = 16,
    service = 17,
    emergency = 18,
    military = 19,
    commercial = 20,
    trains = 21,
    openwheel = 22,
}

local function arrayToSet(array)
    local set = {}
    for _, item in ipairs(array) do
        set[item] = true
    end
    return set
end

local function filterVehiclesByCategory(vehicles, category)
    local filtered = {}
    local categorySet = arrayToSet(category)

    for _, vehicle in pairs(vehicles) do
        local vehicleData = sharedVehicles[vehicle.vehicle]
        local vehicleCategoryString = vehicleData and vehicleData.category or 'compacts'
        local vehicleCategoryNumber = vehicleClasses[vehicleCategoryString]

        if vehicleCategoryNumber and categorySet[vehicleCategoryNumber] then
            filtered[#filtered + 1] = vehicle
        end
    end

    return filtered
end

-- Callbacks

QBCore.Functions.CreateCallback('qb-garages:server:getHouseGarage', function(_, cb, house)
    local houseInfo = MySQL.single.await('SELECT * FROM houselocations WHERE name = ?', { house })
    cb(houseInfo)
end)

QBCore.Functions.CreateCallback('qb-garages:server:GetGarageVehicles', function(source, cb, garage, type, category)
    local Player = exports['qb-core']:GetPlayer(source)
    if not Player then return end
    local citizenId = Player.PlayerData.citizenid

    local vehicles

    if type == 'depot' then
        vehicles = MySQL.rawExecute.await('SELECT * FROM player_vehicles WHERE citizenid = ? AND depotprice > 0', { citizenId })
    elseif Config.SharedGarages then
        vehicles = MySQL.rawExecute.await('SELECT * FROM player_vehicles WHERE citizenid = ?', { citizenId })
    elseif type == 'public' then
        -- RME: return ALL of the player's vehicles for public garages so that any
        -- car parked at another garage can be transferred here for a fee. The
        -- client only shows same-garage cars as drivable; cars stored elsewhere
        -- are shown with a "Transfer here" button instead.
        vehicles = MySQL.rawExecute.await('SELECT * FROM player_vehicles WHERE citizenid = ?', { citizenId })
    else
        vehicles = MySQL.rawExecute.await('SELECT * FROM player_vehicles WHERE citizenid = ? AND garage = ?', { citizenId, garage })
    end
    if #vehicles == 0 then
        cb(nil)
        return
    end
    if Config.ClassSystem then
        local filteredVehicles = filterVehiclesByCategory(vehicles, category)
        cb(filteredVehicles)
    else
        cb(vehicles)
    end
end)

-- Backwards Compat
local vehicleTypes = { -- https://docs.fivem.net/natives/?_0xA273060E
    motorcycles = 'bike',
    boats = 'boat',
    helicopters = 'heli',
    planes = 'plane',
    submarines = 'submarine',
    trailer = 'trailer',
    train = 'train'
}

local function GetVehicleTypeByModel(model)
    local vehicleData = sharedVehicles[model]
    if not vehicleData then return 'automobile' end
    local category = vehicleData.category
    local vehicleType = vehicleTypes[category]
    return vehicleType or 'automobile'
end
-- Backwards Compat

-- Spawns a vehicle and returns its network ID and properties.
-- RME: now waits for the entity to actually exist server-side and reports the
-- exact failing model/type both to the console and to the player, so a spawn
-- failure is diagnosable instead of a silent "failed to load".
QBCore.Functions.CreateCallback('qb-garages:server:spawnvehicle', function(source, cb, plate, vehicle, coords)
    if not vehicle then
        print('^1[qb-garages] spawnvehicle: no model supplied for plate ' .. tostring(plate) .. '^0')
        cb(nil)
        return
    end

    local vehType = (sharedVehicles[vehicle] and sharedVehicles[vehicle].type) or GetVehicleTypeByModel(vehicle)
    local hash = (type(vehicle) == 'number') and vehicle or GetHashKey(vehicle)

    -- RME: clear any stale copy of this plate before spawning a fresh one.
    if OutsideVehicles[plate] and OutsideVehicles[plate].entity and DoesEntityExist(OutsideVehicles[plate].entity) then
        DeleteEntity(OutsideVehicles[plate].entity)
    end

    local x = coords.x + 0.0
    local y = coords.y + 0.0
    local z = coords.z + 0.0
    local w = ((coords.w or coords.h) or 0.0) + 0.0

    local veh = CreateVehicleServerSetter(hash, vehType, x, y, z, w)

    -- Wait for the entity to come into existence on the server.
    local tries = 0
    while not DoesEntityExist(veh) and tries < 100 do
        Wait(10)
        tries = tries + 1
    end

    if not DoesEntityExist(veh) then
        print(('^1[qb-garages] SPAWN FAILED -> model="%s" hash=%s type="%s" coords=%.2f,%.2f,%.2f (entity never created -- check the model exists / OneSync is on)^0')
            :format(tostring(vehicle), tostring(hash), tostring(vehType), x, y, z))
        TriggerClientEvent('QBCore:Notify', source,
            ('Spawn failed for model "%s" (type %s). The model may be missing or its resource not started.'):format(tostring(vehicle), tostring(vehType)),
            'error', 9000)
        cb(nil)
        return
    end

    local netId = NetworkGetNetworkIdFromEntity(veh)
    SetVehicleNumberPlateText(veh, plate)
    local vehProps = {}
    local result = MySQL.rawExecute.await('SELECT mods FROM player_vehicles WHERE plate = ?', { plate })
    if result and result[1] and result[1].mods then vehProps = json.decode(result[1].mods) end
    OutsideVehicles[plate] = { netID = netId, entity = veh }
    print(('^2[qb-garages] spawned model="%s" plate=%s netId=%s^0'):format(tostring(vehicle), tostring(plate), tostring(netId)))
    cb(netId, vehProps, plate)
end)

-- Checks if a vehicle can be spawned based on its type and location.
QBCore.Functions.CreateCallback('qb-garages:server:IsSpawnOk', function(_, cb, plate, type)
    -- RME: if a previous copy of this vehicle is still out (or a stale ghost
    -- from a failed spawn) delete it and clear the registry, then always allow
    -- the spawn. This stops players getting stuck on "Your vehicle is not in
    -- depot" forever when an old entity lingers.
    local existing = OutsideVehicles[plate]
    if existing and existing.entity and DoesEntityExist(existing.entity) then
        DeleteEntity(existing.entity)
    end
    OutsideVehicles[plate] = nil
    cb(true)
end)

QBCore.Functions.CreateCallback('qb-garages:server:canDeposit', function(source, cb, plate, type, garage, state)
    local Player = exports['qb-core']:GetPlayer(source)
    local isOwned = MySQL.scalar.await('SELECT citizenid FROM player_vehicles WHERE plate = ? LIMIT 1', { plate })
    if isOwned ~= Player.PlayerData.citizenid then
        cb(false)
        return
    end
    if type == 'house' and not exports['qb-houses']:hasKey(Player.PlayerData.license, Player.PlayerData.citizenid, Config.Garages[garage].houseName) then
        cb(false)
        return
    end
    if state == 1 then
        MySQL.update('UPDATE player_vehicles SET state = ?, garage = ? WHERE plate = ?', { state, garage, plate })
        cb(true)
    else
        cb(false)
    end
end)

-- Events

RegisterNetEvent('qb-garages:server:updateVehicleStats', function(plate, fuel, engine, body)
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    if not Player then return end
    MySQL.update('UPDATE player_vehicles SET fuel = ?, engine = ?, body = ? WHERE plate = ? AND citizenid = ?', { fuel, engine, body, plate, Player.PlayerData.citizenid })
end)

RegisterNetEvent('qb-garages:server:updateVehicleState', function(state, plate)
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    if not Player then return end
    MySQL.update('UPDATE player_vehicles SET state = ?, depotprice = ? WHERE plate = ? AND citizenid = ?', { state, 0, plate, Player.PlayerData.citizenid })
end)

RegisterNetEvent('qb-garages:server:UpdateOutsideVehicle', function(plate, vehicleNetID)
    OutsideVehicles[plate] = {
        netID = vehicleNetID,
        entity = NetworkGetEntityFromNetworkId(vehicleNetID)
    }
end)

RegisterNetEvent('qb-garages:server:trackVehicle', function(plate)
    local src = source
    local vehicleData = OutsideVehicles[plate]
    if vehicleData and DoesEntityExist(vehicleData.entity) then
        TriggerClientEvent('qb-garages:client:trackVehicle', src, GetEntityCoords(vehicleData.entity))
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.vehicle_tracked'), 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.vehicle_not_tracked'), 'error')
    end
end)

RegisterNetEvent('qb-garages:server:PayDepotPrice', function(data)
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    local cashBalance = Player.PlayerData.money['cash']
    local bankBalance = Player.PlayerData.money['bank']
    MySQL.scalar('SELECT depotprice FROM player_vehicles WHERE plate = ?', { data.plate }, function(result)
        if result then
            local depotPrice = result

            if cashBalance >= depotPrice then
                Player.RemoveMoney('cash', depotPrice, 'paid-depot')
                TriggerClientEvent('qb-garages:client:takeOutGarage', src, data)
            elseif bankBalance >= depotPrice then
                Player.RemoveMoney('bank', depotPrice, 'paid-depot')
                TriggerClientEvent('qb-garages:client:takeOutGarage', src, data)
            else
                TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_enough'), 'error')
            end
        end
    end)
end)

-- RME: Transfer a vehicle parked at another garage into the player's current
-- garage for a flat fee. Charges cash first, then bank.
RegisterNetEvent('qb-garages:server:transferVehicle', function(plate, targetGarage)
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    local transferFee = 200 -- RME: fee to move a vehicle to your current garage

    local row = MySQL.single.await('SELECT citizenid, garage, state FROM player_vehicles WHERE plate = ? LIMIT 1', { plate })
    if not row or row.citizenid ~= citizenid then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_owned'), 'error', 3500)
        return
    end
    if row.garage == targetGarage then
        return -- already parked here
    end
    if row.state == 2 then
        TriggerClientEvent('QBCore:Notify', src, 'That vehicle is impounded and must be recovered from the depot.', 'error', 5000)
        return
    end

    local cashBalance = Player.PlayerData.money['cash']
    local bankBalance = Player.PlayerData.money['bank']
    if cashBalance >= transferFee then
        Player.RemoveMoney('cash', transferFee, 'garage-transfer')
    elseif bankBalance >= transferFee then
        Player.RemoveMoney('bank', transferFee, 'garage-transfer')
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_enough'), 'error', 3500)
        return
    end

    MySQL.update('UPDATE player_vehicles SET garage = ?, state = 1, depotprice = 0 WHERE plate = ? AND citizenid = ?', { targetGarage, plate, citizenid })
    TriggerClientEvent('QBCore:Notify', src, ('Vehicle transferred to your current garage for $%s.'):format(transferFee), 'success', 5000)
    TriggerClientEvent('qb-garages:client:transferComplete', src)
end)

-- RME: Transfer FULL OWNERSHIP of a vehicle to another (online) player. The
-- target becomes the new owner -- the car moves to their account and leaves the
-- sender's garage list. Free of charge. The car must be stored in a garage
-- (state 1) so it can't be duplicated while it is out, and impounded cars are
-- blocked. Ownership in qb-garages is keyed off citizenid, so we reassign that.
RegisterNetEvent('qb-garages:server:transferVehicleToPlayer', function(plate, targetId)
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid

    targetId = tonumber(targetId)
    if not targetId then
        TriggerClientEvent('QBCore:Notify', src, 'Enter a valid player ID to transfer to.', 'error', 4000)
        return
    end

    local Target = exports['qb-core']:GetPlayer(targetId)
    if not Target then
        TriggerClientEvent('QBCore:Notify', src, 'That player is not online.', 'error', 4000)
        return
    end

    local targetCid = Target.PlayerData.citizenid
    if targetCid == citizenid then
        TriggerClientEvent('QBCore:Notify', src, 'You already own that vehicle.', 'error', 4000)
        return
    end

    local row = MySQL.single.await('SELECT citizenid, state FROM player_vehicles WHERE plate = ? LIMIT 1', { plate })
    if not row or row.citizenid ~= citizenid then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_owned'), 'error', 3500)
        return
    end
    if row.state == 0 then
        TriggerClientEvent('QBCore:Notify', src, 'Park the vehicle in a garage before transferring it to a player.', 'error', 5000)
        return
    end
    if row.state == 2 then
        TriggerClientEvent('QBCore:Notify', src, 'That vehicle is impounded and cannot be transferred.', 'error', 5000)
        return
    end

    -- Reassign ownership. Keep the car stored (state 1) with no depot fee so the
    -- new owner can pull it straight out of their garage.
    MySQL.update('UPDATE player_vehicles SET citizenid = ?, state = 1, depotprice = 0 WHERE plate = ? AND citizenid = ?', { targetCid, plate, citizenid })

    local senderName = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    TriggerClientEvent('QBCore:Notify', src, ('Vehicle %s transferred to %s (ID %s).'):format(plate, GetPlayerName(targetId), targetId), 'success', 6000)
    TriggerClientEvent('QBCore:Notify', targetId, ('%s transferred a vehicle (%s) to you. It is now in your garage.'):format(senderName, plate), 'success', 8000)
    TriggerClientEvent('qb-garages:client:transferComplete', src)
end)

-- RME: Diagnostics -- list the calling player's vehicles with the exact fields
-- that decide whether a garage button works (state / garage / depotprice).
RegisterCommand('mycars', function(source)
    if source == 0 then return end
    local Player = exports['qb-core']:GetPlayer(source)
    if not Player then return end
    local rows = MySQL.rawExecute.await('SELECT plate, vehicle, state, garage, depotprice, balance FROM player_vehicles WHERE citizenid = ?', { Player.PlayerData.citizenid })
    if not rows or #rows == 0 then
        TriggerClientEvent('chat:addMessage', source, { color = { 255, 180, 0 }, args = { '[Garage]', 'You have no vehicles on record.' } })
        return
    end
    TriggerClientEvent('chat:addMessage', source, { color = { 0, 200, 255 }, args = { '[Garage]', ('You have %s vehicle(s):'):format(#rows) } })
    for _, r in pairs(rows) do
        local line = ('%s | %s | state=%s | garage=%s | depot=%s | owed=%s'):format(
            tostring(r.plate), tostring(r.vehicle), tostring(r.state), tostring(r.garage), tostring(r.depotprice or 0), tostring(r.balance or 0))
        TriggerClientEvent('chat:addMessage', source, { color = { 200, 200, 200 }, args = { '[Garage]', line } })
    end
end, false)

-- RME: Self-repair -- reset the calling player's own vehicles so they can be
-- pulled out again. Clears stale ghost entities, sets non-impounded cars back
-- to "stored" (state 1) with no depot fee. Only ever touches the caller's cars.
RegisterCommand('unstuckmycars', function(source)
    if source == 0 then return end
    local Player = exports['qb-core']:GetPlayer(source)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    local rows = MySQL.rawExecute.await('SELECT plate FROM player_vehicles WHERE citizenid = ?', { citizenid })
    local cleared = 0
    for _, r in pairs(rows or {}) do
        local ov = OutsideVehicles[r.plate]
        if ov and ov.entity and DoesEntityExist(ov.entity) then
            DeleteEntity(ov.entity)
            cleared = cleared + 1
        end
        OutsideVehicles[r.plate] = nil
    end
    MySQL.update('UPDATE player_vehicles SET state = 1, depotprice = 0 WHERE citizenid = ? AND state != 2', { citizenid })
    TriggerClientEvent('QBCore:Notify', source, ('Your vehicles were reset (%s ghost(s) cleared). Open the garage and try again.'):format(cleared), 'success', 6000)
end, false)

-- House Garages

RegisterNetEvent('qb-garages:server:syncGarage', function(updatedGarages)
    Config.Garages = updatedGarages
end)

--Call from qb-phone

QBCore.Functions.CreateCallback('qb-garages:server:GetPlayerVehicles', function(source, cb)
    local Player = exports['qb-core']:GetPlayer(source)
    local Vehicles = {}

    MySQL.rawExecute('SELECT * FROM player_vehicles WHERE citizenid = ?', { Player.PlayerData.citizenid }, function(result)
        if result[1] then
            for _, v in pairs(result) do
                local VehicleData = sharedVehicles[v.vehicle]

                local VehicleGarage = Lang:t('error.no_garage')
                if v.garage ~= nil then
                    if Config.Garages[v.garage] ~= nil then
                        VehicleGarage = Config.Garages[v.garage].label
                    else
                        VehicleGarage = Lang:t('info.house')
                    end
                end

                local stateTranslation
                if v.state == 0 then
                    stateTranslation = Lang:t('status.out')
                elseif v.state == 1 then
                    stateTranslation = Lang:t('status.garaged')
                elseif v.state == 2 then
                    stateTranslation = Lang:t('status.impound')
                end

                local fullname
                if VehicleData and VehicleData['brand'] then
                    fullname = VehicleData['brand'] .. ' ' .. VehicleData['name']
                else
                    fullname = VehicleData and VehicleData['name'] or 'Unknown Vehicle'
                end

                Vehicles[#Vehicles + 1] = {
                    fullname = fullname,
                    brand = VehicleData and VehicleData['brand'] or '',
                    model = VehicleData and VehicleData['name'] or '',
                    plate = v.plate,
                    garage = VehicleGarage,
                    state = stateTranslation,
                    fuel = v.fuel,
                    engine = v.engine,
                    body = v.body
                }
            end
            cb(Vehicles)
        else
            cb(nil)
        end
    end)
end)

local function getAllGarages()
    local garages = {}
    for k, v in pairs(Config.Garages) do
        garages[#garages + 1] = {
            name = k,
            label = v.label,
            type = v.type,
            takeVehicle = v.takeVehicle,
            putVehicle = v.putVehicle,
            spawnPoint = v.spawnPoint,
            showBlip = v.showBlip,
            blipName = v.blipName,
            blipNumber = v.blipNumber,
            blipColor = v.blipColor,
            vehicle = v.vehicle
        }
    end
    return garages
end

exports('getAllGarages', getAllGar