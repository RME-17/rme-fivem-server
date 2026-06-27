local SPACES_PER_PAGE = 10
local MYCARS_PAGE = 10

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:getMyCarsData",
    function(source, data, cb)
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false})
            return
        end
        local zones = Config.Zones or {}
        local zoneId = (data and data.zoneId and tostring(data.zoneId):match("%S+")) or (zones[1] and zones[1].id)
        local selectedZone = nil
        for _, z in ipairs(zones) do
            if z.id == zoneId then
                selectedZone = z
                break
            end
        end
        if not selectedZone then
            selectedZone = zones[1] or {id = "zone1", name = "Mark"}
            zoneId = selectedZone.id
        end
        local garages = {}
        for _, z in ipairs(zones) do
            garages[#garages + 1] = {
                id = z.id,
                name = z.name or z.id,
                description = "",
                location = z.name or z.id,
                totalSpaces = 0,
                usedSpaces = 0
            }
        end
        local parkingPage = tonumber(data.parkingPage) or 1
        local vehiclesPage = tonumber(data.vehiclesPage) or 1
        MySQL.Async.fetchAll(
            "SELECT slot_id FROM koja_carmarket_slot_owners WHERE owner_identifier = @oid AND zone_id = @zid ORDER BY slot_id",
            {["@oid"] = identifier, ["@zid"] = zoneId},
            function(slotRows)
                local mySlots = {}
                if slotRows then
                    for _, row in ipairs(slotRows) do
                        mySlots[#mySlots + 1] = row.slot_id
                    end
                end
                MySQL.Async.fetchAll(
                    "SELECT plate, slot_id, vehicle FROM koja_carmarket WHERE owner = @oid AND zone_id = @zid",
                    {["@oid"] = identifier, ["@zid"] = zoneId},
                    function(carsInZoneRows)
                        local carsBySlot = {}
                        local platesInZone = {}
                        if carsInZoneRows then
                            for _, row in ipairs(carsInZoneRows) do
                                local sid = row.slot_id and tostring(row.slot_id):match("%S+")
                                if sid then
                                    carsBySlot[sid] = row
                                end
                                platesInZone[row.plate or ""] = true
                            end
                        end
                        local totalSlots = #mySlots
                        local usedSpaces = carsInZoneRows and #carsInZoneRows or 0
                        local selectedGarage = {
                            id = zoneId,
                            name = selectedZone.name or zoneId,
                            description = "",
                            location = selectedZone.name or zoneId,
                            totalSpaces = totalSlots,
                            usedSpaces = usedSpaces
                        }
                        MySQL.Async.fetchAll(
                            "SELECT plate, owned_vehicle_id, name, respname FROM koja_carmarket_listings WHERE owner = @owner",
                            {["@owner"] = identifier},
                            function(listings)
                                local listedPlates, listedIds, listingByPlate = KOJA.Server.buildListingsIndex(listings, true)
                                MySQL.Async.fetchAll(
                                    "SELECT * FROM " .. KOJA.Server.vehicleTable() .. " WHERE owner = @owner",
                                    {["@owner"] = identifier},
                                    function(ovRows)
                                        local ovFiltered = {}
                                        if ovRows then
                                            for _, r in ipairs(ovRows) do
                                                local plateNorm = KOJA.Server.plateNormalized(r.plate) or ""
                                                if listedPlates[plateNorm] or listedIds[r.id] then
                                                    ovFiltered[#ovFiltered + 1] = r
                                                end
                                            end
                                        end
                                        ovRows = ovFiltered
                                        for i, sid in ipairs(mySlots) do
                                            mySlots[i] = (sid and tostring(sid):match("%S+")) or sid
                                        end
                                        local parkingTotalPages = math.max(1, math.ceil(totalSlots / SPACES_PER_PAGE))
                                        local startSlot = (parkingPage - 1) * SPACES_PER_PAGE
                                        local parkingSpaces = {}
                                        for i = 1, SPACES_PER_PAGE do
                                            local slotIdx = startSlot + i
                                            if slotIdx > totalSlots then
                                                break
                                            end
                                            local sid = mySlots[slotIdx]
                                            local ps = {slot = slotIdx, vehicle = nil}
                                            local row = sid and carsBySlot[sid]
                                            if row and row.plate then
                                                local plateNorm = KOJA.Server.plateNormalized(row.plate) or ""
                                                local li = listingByPlate[plateNorm]
                                                local v = KOJA.Shared.decodeJsonStringOrTable(row.vehicle)
                                                ps.vehicle = KOJA.Server.buildParkedVehiclePayload(li, v, row.plate, zoneId)
                                            end
                                            parkingSpaces[#parkingSpaces + 1] = ps
                                        end
                                        local allVehicles = {}
                                        if ovRows then
                                            for _, r in ipairs(ovRows) do
                                                local v = KOJA.Shared.decodeJsonStringOrTable(r.vehicle)
                                                local plateNorm = KOJA.Server.plateNormalized(r.plate) or ""
                                                local li = listingByPlate[plateNorm]
                                                local parkedHere = platesInZone[plateNorm]
                                                allVehicles[#allVehicles + 1] = KOJA.Server.buildMyCarsVehiclePayload(
                                                    r,
                                                    li,
                                                    v,
                                                    parkedHere == true,
                                                    zoneId
                                                )
                                            end
                                        end
                                        local vehiclesTotalPages = math.max(1, math.ceil(#allVehicles / MYCARS_PAGE))
                                        local vStart = (vehiclesPage - 1) * MYCARS_PAGE
                                        local vehicles = {}
                                        for i = vStart + 1, math.min(vStart + MYCARS_PAGE, #allVehicles) do
                                            vehicles[#vehicles + 1] = allVehicles[i]
                                        end
                                        cb(
                                            {
                                                success = true,
                                                garages = garages,
                                                selectedGarage = selectedGarage,
                                                parkingSpaces = parkingSpaces,
                                                parkingTotalPages = parkingTotalPages,
                                                vehicles = vehicles,
                                                vehiclesTotalPages = vehiclesTotalPages
                                            }
                                        )
                                    end
                                )
                            end
                        )
                    end
                )
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:getMyCarsParking",
    function(source, data, cb)
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false})
            return
        end
        local zones = Config.Zones or {}
        local zoneId = (data and data.zoneId and tostring(data.zoneId):match("%S+")) or (zones[1] and zones[1].id)
        local page = tonumber(data.page) or 1
        MySQL.Async.fetchAll(
            "SELECT slot_id FROM koja_carmarket_slot_owners WHERE owner_identifier = @oid AND zone_id = @zid ORDER BY slot_id",
            {["@oid"] = identifier, ["@zid"] = zoneId},
            function(slotRows)
                local mySlots = {}
                if slotRows then
                    for _, row in ipairs(slotRows) do
                        mySlots[#mySlots + 1] = (row.slot_id and tostring(row.slot_id):match("%S+")) or row.slot_id
                    end
                end
                MySQL.Async.fetchAll(
                    "SELECT plate, slot_id, vehicle FROM koja_carmarket WHERE owner = @oid AND zone_id = @zid",
                    {["@oid"] = identifier, ["@zid"] = zoneId},
                    function(carsInZoneRows)
                        local carsBySlot = {}
                        if carsInZoneRows then
                            for _, row in ipairs(carsInZoneRows) do
                                local sid = row.slot_id and tostring(row.slot_id):match("%S+")
                                if sid then
                                    carsBySlot[sid] = row
                                end
                            end
                        end
                        MySQL.Async.fetchAll(
                            "SELECT plate, name, respname FROM koja_carmarket_listings WHERE owner = @owner",
                            {["@owner"] = identifier},
                            function(listings)
                                local _, _, listingByPlate = KOJA.Server.buildListingsIndex(listings, false)
                                local totalSlots = #mySlots
                                local totalPages = math.max(1, math.ceil(totalSlots / SPACES_PER_PAGE))
                                local startSlot = (page - 1) * SPACES_PER_PAGE
                                local spaces = {}
                                for i = 1, SPACES_PER_PAGE do
                                    local slotIdx = startSlot + i
                                    if slotIdx > totalSlots then
                                        break
                                    end
                                    local sid = mySlots[slotIdx]
                                    local ps = {slot = slotIdx, vehicle = nil}
                                    local row = sid and carsBySlot[sid]
                                    if row and row.plate then
                                        local plateNorm = KOJA.Server.plateNormalized(row.plate) or ""
                                        local li = listingByPlate[plateNorm]
                                        local v = KOJA.Shared.decodeJsonStringOrTable(row.vehicle)
                                        ps.vehicle = KOJA.Server.buildParkedVehiclePayload(li, v, row.plate, zoneId)
                                    end
                                    spaces[#spaces + 1] = ps
                                end
                                cb({success = true, spaces = spaces, totalPages = totalPages})
                            end
                        )
                    end
                )
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:getMyCarsVehicles",
    function(source, data, cb)
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false})
            return
        end
        local page = tonumber(data.page) or 1
        local pcol = KOJA.Server.parkingColumn()
        MySQL.Async.fetchAll(
            "SELECT plate, owned_vehicle_id, name, respname FROM koja_carmarket_listings WHERE owner = @owner",
            {["@owner"] = identifier},
            function(listings)
                local listedPlates, listedIds, listingByPlate = KOJA.Server.buildListingsIndex(listings, true)
                MySQL.Async.fetchAll(
                    "SELECT * FROM " .. KOJA.Server.vehicleTable() .. " WHERE owner = @owner",
                    {["@owner"] = identifier},
                    function(rows)
                        local filtered = {}
                        if rows then
                            for _, r in ipairs(rows) do
                                local pn = KOJA.Server.plateNormalized(r.plate) or ""
                                if listedPlates[pn] or listedIds[r.id] then
                                    filtered[#filtered + 1] = r
                                end
                            end
                        end
                        rows = filtered
                        local list = rows or {}
                        local totalPages = math.max(1, math.ceil(#list / MYCARS_PAGE))
                        local start = (page - 1) * MYCARS_PAGE
                        local vehicles = {}
                        for i = start + 1, math.min(start + MYCARS_PAGE, #list) do
                            local r = list[i]
                            local v = KOJA.Shared.decodeJsonStringOrTable(r.vehicle)
                            local pval = r[pcol]
                            local parked = KOJA.Server.isParkedValue(pval)
                            local pn = KOJA.Server.plateNormalized(r.plate) or ""
                            local li = listingByPlate[pn]
                            vehicles[#vehicles + 1] = KOJA.Server.buildMyCarsVehiclePayload(
                                r,
                                li,
                                v,
                                parked == true,
                                pval
                            )
                        end
                        cb({success = true, vehicles = vehicles, totalPages = totalPages})
                    end
                )
            end
        )
    end
)

KOJA.Server.RegisterServerCallback( "koja_carmarket:server:assignVehicleToSlot", function(source, data, cb)
    if not KOJA.Server.rateLimit(source, "assignVehicleToSlot", 1000) then
        cb({success = false, reason = "rate_limited"})
        return
    end
    KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] assignVehicleToSlot source=" .. tostring(source) .. " data=" .. json.encode(data or {}))
    local identifier = KOJA.Server.GetPlayerIdentifier(source)
    if not identifier then
        KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] assignVehicleToSlot: no identifier")
        cb({success = false})
        return
    end
    local zoneId = data.zoneId and tostring(data.zoneId):match("%S+") or nil
    local plateInput = KOJA.Server.plateNormalized(data.plate) or ""
    local slotIndex = tonumber(data.slot)
    if not zoneId or plateInput == "" or not slotIndex or slotIndex < 1 then
        KOJA.Shared.KojaCarmarketDebug(
            "[koja-carmarket] assignVehicleToSlot: bad params zoneId=" ..
                tostring(zoneId) .. " plate=" .. tostring(data.plate) .. " slotIndex=" .. tostring(slotIndex)
        )
        cb({success = false})
        return
    end
    local configZone = nil
    for _, z in ipairs(Config.Zones or {}) do
        if z.id == zoneId then
            configZone = z
            break
        end
    end
    if not configZone or not configZone.CarMarketBoxes then
        KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] assignVehicleToSlot: no config zone or CarMarketBoxes")
        cb({success = false})
        return
    end
    local boxes = configZone.CarMarketBoxes
    if slotIndex > #boxes then
        KOJA.Shared.KojaCarmarketDebug(
            "[koja-carmarket] assignVehicleToSlot: slotIndex out of range (boxes) slotIndex=" ..
                tostring(slotIndex) .. " #boxes=" .. tostring(#boxes)
        )
        cb({success = false})
        return
    end
    local targetBox = boxes[slotIndex]
    local slotId = (targetBox and targetBox.id and tostring(targetBox.id):match("%S+")) or (targetBox and targetBox.id)
    if not slotId then
        KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] assignVehicleToSlot: no slotId from box")
        cb({success = false})
        return
    end
    MySQL.Async.fetchAll("SELECT 1 FROM koja_carmarket_slot_owners WHERE owner_identifier = @oid AND zone_id = @zid AND slot_id = @sid LIMIT 1",{["@oid"] = identifier, ["@zid"] = zoneId, ["@sid"] = slotId},function(ownerRows)
        if not ownerRows or #ownerRows == 0 then
            KOJA.Shared.KojaCarmarketDebug(
                "[koja-carmarket] assignVehicleToSlot: player does not own this slot slotId=" ..
                    tostring(slotId)
            )
            cb({success = false})
            return
        end
        KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] assignVehicleToSlot: slotId=" .. tostring(slotId))
        MySQL.Async.fetchAll(
            "SELECT * FROM " .. KOJA.Server.vehicleTable() .. " WHERE owner = @owner",
            {["@owner"] = identifier},
            function(vehRows)
                local row = nil
                if vehRows then
                    for _, r in ipairs(vehRows) do
                        local p = KOJA.Server.plateNormalized(r.plate) or ""
                        if p == plateInput then
                            row = r
                            break
                        end
                    end
                end
                if not row then
                    KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] assignVehicleToSlot: vehicle not found for plate")
                    cb({success = false})
                    return
                end
                local vehicleId = row.id
                local plate = KOJA.Server.plateTrimmed(row.plate)
                if not plate or plate == "" then
                    KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] assignVehicleToSlot: no plate")
                    cb({success = false})
                    return
                end
                KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] assignVehicleToSlot: plate=" .. tostring(plate))
                local plateNorm = KOJA.Server.plateNormalized(plate) or ""
                MySQL.Async.fetchAll(
                    'SELECT 1 FROM koja_carmarket_listings WHERE owner = @owner AND (plate = @plate OR TRIM(REPLACE(plate, " ", "")) = @plateNorm OR (owned_vehicle_id IS NOT NULL AND owned_vehicle_id = @vid)) LIMIT 1',
                    {
                        ["@owner"] = identifier,
                        ["@plate"] = plate,
                        ["@plateNorm"] = plateNorm,
                        ["@vid"] = vehicleId
                    },
                    function(listingRows)
                        if not listingRows or #listingRows == 0 then
                            KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] assignVehicleToSlot: no listing for plate/vehicle")
                            cb({success = false})
                            return
                        end
                        local coords = {x = targetBox.coords.x, y = targetBox.coords.y, z = targetBox.coords.z}
                        local heading = targetBox.rotation or 0.0
                        local vehicleJson =
                            type(row.vehicle) == "string" and row.vehicle or json.encode(row.vehicle or {})
                        MySQL.Async.fetchAll(
                            'SELECT 1 FROM koja_carmarket WHERE zone_id = @zid AND slot_id = @sid AND owner = @oid AND (plate = @plate OR REPLACE(TRIM(plate), " ", "") = @plateNorm) LIMIT 1',
                            {
                                ["@zid"] = zoneId,
                                ["@sid"] = slotId,
                                ["@oid"] = identifier,
                                ["@plate"] = plate,
                                ["@plateNorm"] = plateNorm
                            },
                            function(sameSlotRows)
                                if sameSlotRows and #sameSlotRows > 0 then
                                    cb({success = true, zoneId = zoneId})
                                    return
                                end
                                MySQL.Async.execute(
                                    "DELETE FROM koja_carmarket WHERE zone_id = @zid AND slot_id = @sid",
                                    {["@zid"] = zoneId, ["@sid"] = slotId},
                                    function()
                                        MySQL.Async.fetchAll(
                                            'SELECT 1 FROM koja_carmarket WHERE owner = @oid AND (plate = @plate OR REPLACE(TRIM(plate), " ", "") = @plateNorm) LIMIT 1',
                                            {
                                                ["@oid"] = identifier,
                                                ["@plate"] = plate,
                                                ["@plateNorm"] = plateNorm
                                            },
                                            function(existing)
                                                local doInsert = not existing or #existing == 0
                                                local function afterWrite()
                                                    if not KOJA.Server.CarsInZone[zoneId] then
                                                        KOJA.Server.CarsInZone[zoneId] = {}
                                                    end
                                                    KOJA.Server.CarsInZone[zoneId][plate] = {
                                                        owner = identifier,
                                                        vehicle = vehicleJson,
                                                        plate = plate,
                                                        coords = coords,
                                                        heading = heading,
                                                        slot_id = slotId
                                                    }
                                                    MySQL.Async.execute(
                                                        "UPDATE koja_carmarket_listings SET zone_id = @zid, listing_fee_paid_until = DATE_ADD(NOW(), INTERVAL 7 DAY) WHERE owner = @oid AND (plate = @plate OR owned_vehicle_id = @vid)",
                                                        {
                                                            ["@zid"] = zoneId,
                                                            ["@oid"] = identifier,
                                                            ["@plate"] = plate,
                                                            ["@vid"] = vehicleId
                                                        },
                                                        function()
                                                            KOJA.Shared.KojaCarmarketDebug(
                                                                "[koja-carmarket] assignVehicleToSlot: success zone_id updated for listing plate =" ..
                                                                    tostring(plate)
                                                            )
                                                            cb({success = true, zoneId = zoneId})
                                                        end
                                                    )
                                                end
                                                if doInsert then
                                                    MySQL.Async.execute(
                                                        "INSERT INTO koja_carmarket (zone_id, slot_id, owner, vehicle, plate, coords, heading) VALUES (@zid, @sid, @owner, @vehicle, @plate, @coords, @heading)",
                                                        {
                                                            ["@zid"] = zoneId,
                                                            ["@sid"] = slotId,
                                                            ["@owner"] = identifier,
                                                            ["@vehicle"] = vehicleJson,
                                                            ["@plate"] = plate,
                                                            ["@coords"] = json.encode(coords),
                                                            ["@heading"] = heading
                                                        },
                                                        afterWrite
                                                    )
                                                else
                                                    MySQL.Async.execute(
                                                        'UPDATE koja_carmarket SET zone_id = @zid, slot_id = @sid, vehicle = @vehicle, coords = @coords, heading = @heading WHERE owner = @oid AND REPLACE(TRIM(plate), " ", "") = @plateNorm',
                                                        {
                                                            ["@zid"] = zoneId,
                                                            ["@sid"] = slotId,
                                                            ["@vehicle"] = vehicleJson,
                                                            ["@coords"] = json.encode(coords),
                                                            ["@heading"] = heading,
                                                            ["@oid"] = identifier,
                                                            ["@plateNorm"] = plateNorm
                                                        },
                                                        afterWrite)
                                                end
                                            end)
                                    end)
                            end)
                    end)
            end)
    end)
end)

KOJA.Server.RegisterServerCallback("koja_carmarket:server:unassignVehicleFromSlot", function(source, data, cb)
    if not KOJA.Server.rateLimit(source, "unassignVehicleFromSlot", 1000) then
        cb({success = false, reason = "rate_limited"})
        return
    end
    local identifier = KOJA.Server.GetPlayerIdentifier(source)
    if not identifier then
        cb({success = false})
        return
    end
    local zoneId = data.zoneId and tostring(data.zoneId):match("%S+") or nil
    local slotIndex = tonumber(data.slot)
    if not zoneId or not slotIndex or slotIndex < 1 then
        cb({success = false})
        return
    end
    local configZone = nil
    for _, z in ipairs(Config.Zones or {}) do
        if z.id == zoneId then
            configZone = z
            break
        end
    end
    if not configZone or not configZone.CarMarketBoxes or slotIndex > #configZone.CarMarketBoxes then
        cb({success = false})
        return
    end
    local targetBox = configZone.CarMarketBoxes[slotIndex]
    local slotId =
        (targetBox and targetBox.id and tostring(targetBox.id):match("%S+")) or (targetBox and targetBox.id)
    if not slotId then
        cb({success = false})
        return
    end
    MySQL.Async.fetchAll(
        "SELECT 1 FROM koja_carmarket_slot_owners WHERE owner_identifier = @oid AND zone_id = @zid AND slot_id = @sid LIMIT 1",
        {["@oid"] = identifier, ["@zid"] = zoneId, ["@sid"] = slotId},
        function(ownerRows)
            if not ownerRows or #ownerRows == 0 then
                cb({success = false})
                return
            end
            MySQL.Async.fetchAll(
                "SELECT plate FROM koja_carmarket WHERE zone_id = @zid AND slot_id = @sid AND owner = @owner LIMIT 1",
                {["@zid"] = zoneId, ["@sid"] = slotId, ["@owner"] = identifier},
                function(carRows)
                    if not carRows or #carRows == 0 then
                        cb({success = true})
                        return
                    end
                    local plate = carRows[1].plate
                    MySQL.Async.execute(
                        "DELETE FROM koja_carmarket WHERE zone_id = @zid AND slot_id = @sid AND owner = @owner",
                        {["@zid"] = zoneId, ["@sid"] = slotId, ["@owner"] = identifier},
                        function()
                            if KOJA.Server.CarsInZone[zoneId] then
                                KOJA.Server.CarsInZone[zoneId][plate] = nil
                            end
                            TriggerClientEvent("koja_carmarket:client:vehicleSold", -1, plate)
                            cb({success = true, zoneId = zoneId})
                        end)
                end)
        end)
end)

KOJA.Server.RegisterServerCallback("koja_carmarket:server:getStatisticsData",function(source, data, cb)
    local identifier = KOJA.Server.GetPlayerIdentifier(source)
    if not identifier then
        cb({logs = {}, totalPages = 1})
        return
    end
    local limit = tonumber(data.limit) or 5
    if limit < 1 or limit > 100 then
        limit = 5
    end
    local page = tonumber(data.page) or 1
    if page < 1 then
        page = 1
    end
    local offset = (page - 1) * limit
    MySQL.Async.fetchAll(
        "SELECT COUNT(*) as total FROM koja_carmarket_history WHERE seller_identifier = @id OR buyer_identifier = @id",
        {["@id"] = identifier},
        function(countRows)
            local total = (countRows and countRows[1] and tonumber(countRows[1].total)) or 0
            local totalPages = math.max(1, math.ceil(total / limit))
            MySQL.Async.fetchAll(
                "SELECT id, type AS history_type, price, seller_identifier, seller_name, buyer_identifier, buyer_name, created_at, vehicle_info FROM koja_carmarket_history WHERE seller_identifier = @id OR buyer_identifier = @id ORDER BY created_at DESC LIMIT @limit OFFSET @offset",
                {["@id"] = identifier, ["@limit"] = limit, ["@offset"] = offset},
                function(rows)
                    local logs = {}
                    if rows then
                        for _, r in ipairs(rows) do
                            local isSeller = (r.seller_identifier or "") == identifier
                            local dbType = tostring(r.history_type or r.type or "purchase"):lower()
                            local logType =
                                (dbType == "listing") and "listing" or (isSeller and "sold" or "purchased")
                            local vinfo = r.vehicle_info
                            if type(vinfo) == "string" then
                                vinfo = json.decode(vinfo)
                            end
                            if type(vinfo) ~= "table" then
                                vinfo = {}
                            end
                            local respnamee =
                                (vinfo.respname and tostring(vinfo.respname):match("%S+")) and
                                tostring(vinfo.respname) or
                                KOJA.Server.modelToRespname(vinfo)
                            if respnamee and tostring(respnamee):match("^-?%d+$") then
                                respnamee = "vehicle"
                            end
                            local dateStr = ""
                            if r.created_at then
                                if type(r.created_at) == "number" then
                                    dateStr = os.date("!%Y-%m-%dT%H:%M:%SZ", r.created_at)
                                else
                                    dateStr = tostring(r.created_at):gsub(" ", "T"):gsub("$", "Z")
                                end
                            end
                            local statCat = KOJA.Shared.normalizeVehicleCategorySlug(vinfo.car_type, nil)
                            if type(vinfo.model) == "number" and vinfo.model ~= 0 and KOJA.Shared.resolveVehicleCategorySlugFromModel then
                                local mh = KOJA.Shared.resolveVehicleCategorySlugFromModel(vinfo.model)
                                if type(mh) == "string" and mh:match("%S+") then
                                    statCat = KOJA.Shared.normalizeVehicleCategorySlug(mh, nil)
                                end
                            end
                            local statFuel = KOJA.Shared.wireFuelSlugGasOrElectric(vinfo.fuel_type or vinfo.fuelType)
                            logs[#logs + 1] = {
                                id = r.id,
                                type = logType,
                                vehicleName = (vinfo.vehicleName and tostring(vinfo.vehicleName):match("%S+") and
                                    tostring(vinfo.vehicleName)) or
                                    "Vehicle",
                                respname = respnamee or "vehicle",
                                plate = vinfo.plate or "",
                                price = tonumber(r.price) or 0,
                                date = dateStr,
                                fuel_type = statFuel,
                                mileage = tonumber(vinfo.mileage) or 0,
                                drive_type = KOJA.Shared.coalesceDriveType(statCat, vinfo.drive_type),
                                car_type = statCat
                            }
                        end
                    end
                    cb({logs = logs, totalPages = totalPages})
                end)
        end)
end)

