KOJA.Server.CarsInZone = KOJA.Server.CarsInZone or {}

KOJA.Server.LoadCarsFromDatabase = function()
    MySQL.Async.fetchAll("SELECT * FROM koja_carmarket", {}, function(results)
        if results then
            for _, car in ipairs(results) do
                local coords = json.decode(car.coords)
                local zid = car.zone_id or car.zoneId or car.zoneid
                if not zid then
                    goto continue
                end
                if not KOJA.Server.CarsInZone[zid] then
                    KOJA.Server.CarsInZone[zid] = {}
                end
                local slotId = (car.slot_id and tostring(car.slot_id):match("%S+")) or nil
                KOJA.Server.CarsInZone[zid][car.plate] = {
                    owner = car.owner,
                    vehicle = car.vehicle,
                    plate = car.plate,
                    coords = coords,
                    heading = car.heading,
                    slot_id = slotId
                }
                ::continue::
            end
        end
    end)
end

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:getPlayerName",
    function(source, data, cb)
        local name = KOJA.Server.GetPlayerName(source) or ""
        cb({playerName = name})
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:getPlayerIdentifier",
    function(source, data, cb)
        local identifier = KOJA.Server.GetPlayerIdentifier(source) or ""
        cb({identifier = identifier})
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:buyParking",
    function(source, data, cb)
        if not KOJA.Server.rateLimit(source, "buyParking", 1500) then
            cb({success = false, reason = "rate_limited"})
            return
        end
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false})
            return
        end
        local zoneId = data.zoneId and tostring(data.zoneId):match("%S+") or nil
        if not zoneId then
            cb({success = false})
            return
        end
        local price = (Config.Parking and (Config.Parking.PurchasePrice or Config.Parking.SlotPrice)) or 10000
        if (KOJA.Server.getMoney(source, "bank") or 0) < price then
            cb({success = false})
            return
        end
        MySQL.Async.fetchAll(
            "SELECT id, owner_identifier FROM koja_carmarket_parkings WHERE zone_id = @zid LIMIT 1",
            {["@zid"] = zoneId},
            function(rows)
                if rows and #rows > 0 then
                    if rows[1].owner_identifier == identifier then
                        cb({success = false, reason = "already_owned"})
                    else
                        cb({success = false, reason = "zone_taken"})
                    end
                    return
                end
                if not KOJA.Server.removeMoney(source, price, "bank", "parking_purchase") then
                    cb({success = false})
                    return
                end
                local weeklyFee = (Config.Parking and Config.Parking.DefaultWeeklyFee) or 5000
                local nextPay = os.time() + 7 * 24 * 3600
                MySQL.Async.execute(
                    "INSERT INTO koja_carmarket_parkings (owner_identifier, name, zone_id, weekly_fee, next_payment_at) VALUES (@oid, @name, @zid, @fee, FROM_UNIXTIME(@next))",
                    {
                        ["@oid"] = identifier,
                        ["@name"] = (data.name and tostring(data.name):sub(1, 100)) or ("Parking " .. zoneId),
                        ["@zid"] = zoneId,
                        ["@fee"] = weeklyFee,
                        ["@next"] = nextPay
                    },
                    function()
                        cb({success = true})
                    end
                )
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:buyExchangeZone",
    function(source, data, cb)
        if not KOJA.Server.rateLimit(source, "buyExchangeZone", 2000) then
            cb({success = false, reason = "rate_limited"})
            return
        end
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false, reason = "no_identifier"})
            return
        end
        local zoneId = data.zoneId and tostring(data.zoneId):match("%S+") or nil
        if not zoneId then
            cb({success = false, reason = "no_zone"})
            return
        end
        local price =
            (Config.Exchange and Config.Exchange.ZonePurchasePrice) or
            (Config.Parking and Config.Parking.ZonePurchasePrice) or
            250000
        if (KOJA.Server.getMoney(source, "bank") or 0) < price then
            cb({success = false, reason = "no_money"})
            return
        end

        local function finalizePurchase()
            if not KOJA.Server.removeMoney(source, price, "bank", "exchange_zone_purchase") then
                cb({success = false, reason = "pay_failed"})
                return
            end
            MySQL.Async.execute(
                "UPDATE koja_carmarket_exchange SET owner_identifier = @oid WHERE zone_id = @zid",
                {
                    ["@oid"] = identifier,
                    ["@zid"] = zoneId
                },
                function()
                    cb({success = true})
                end
            )
        end

        MySQL.Async.fetchAll(
            "SELECT owner_identifier FROM koja_carmarket_exchange WHERE zone_id = @zid LIMIT 1",
            {["@zid"] = zoneId},
            function(rows)
                if not rows or #rows == 0 then
                    MySQL.Async.execute(
                        "INSERT IGNORE INTO koja_carmarket_exchange (zone_id, owner_identifier, listing_fee_per_week, max_listings, commission_percent) VALUES (@zid, NULL, @fee, @max, @comm)",
                        {
                            ["@zid"] = zoneId,
                            ["@fee"] = (Config.Exchange and Config.Exchange.DefaultListingFeePerWeek) or 500,
                            ["@max"] = (Config.Exchange and Config.Exchange.MaxListingsPerZone) or 50,
                            ["@comm"] = (Config.Exchange and Config.Exchange.DefaultCommissionPercent) or 5
                        },
                        function()
                            MySQL.Async.fetchAll(
                                "SELECT owner_identifier FROM koja_carmarket_exchange WHERE zone_id = @zid LIMIT 1",
                                {["@zid"] = zoneId},
                                function(r2)
                                    local current = r2 and r2[1] and r2[1].owner_identifier or nil
                                    if current and current ~= "" and current ~= identifier then
                                        cb({success = false, reason = "zone_taken"})
                                        return
                                    end
                                    if current == identifier then
                                        cb({success = false, reason = "already_owned"})
                                        return
                                    end
                                    finalizePurchase()
                                end
                            )
                        end
                    )
                    return
                end

                local current = rows[1].owner_identifier
                if current and current ~= "" and current ~= identifier then
                    cb({success = false, reason = "zone_taken"})
                    return
                end
                if current == identifier then
                    cb({success = false, reason = "already_owned"})
                    return
                end
                finalizePurchase()
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:getMyParkings",
    function(source, data, cb)
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false, parkings = {}})
            return
        end
        KOJA.Server.processDueParkingFees(
            identifier,
            function()
                MySQL.Async.fetchAll(
                    "SELECT id, owner_identifier, name, zone_id, weekly_fee, next_payment_at, created_at FROM koja_carmarket_parkings WHERE owner_identifier = @oid",
                    {["@oid"] = identifier},
                    function(rows)
                        cb({success = true, parkings = rows or {}})
                    end
                )
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:getActiveParkingZones",
    function(source, data, cb)
        MySQL.Async.fetchAll(
            "SELECT p.id, p.zone_id, p.name, p.owner_identifier, s.coords, s.heading FROM koja_carmarket_parkings p LEFT JOIN koja_carmarket_parking_slots s ON s.parking_id = p.id ORDER BY p.id, s.slot_index",
            {},
            function(rows)
                local zones = {}
                if rows then
                    for _, r in ipairs(rows) do
                        if not zones[r.zone_id] then
                            zones[r.zone_id] = {
                                zone_id = r.zone_id,
                                name = r.name or ("Parking " .. r.zone_id),
                                owner = r.owner_identifier,
                                slots = {}
                            }
                        end
                        if r.coords then
                            local sc = r.coords
                            if type(sc) == "string" then
                                sc = json.decode(sc)
                            end
                            if sc and sc.x then
                                zones[r.zone_id].slots[#zones[r.zone_id].slots + 1] = {
                                    x = sc.x,
                                    y = sc.y,
                                    z = sc.z,
                                    heading = tonumber(r.heading) or 0
                                }
                            end
                        end
                    end
                end
                local result = {}
                for _, v in pairs(zones) do
                    result[#result + 1] = v
                end
                cb({success = true, zones = result})
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:buySlot",
    function(source, data, cb)
        if not KOJA.Server.rateLimit(source, "buySlot", 1500) then
            cb({success = false, reason = "rate_limited"})
            return
        end
        KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] buySlot source=" .. tostring(source) .. " data=" .. json.encode(data or {}))
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] buySlot: no_identifier")
            cb({success = false, reason = "no_identifier"})
            return
        end
        local zoneId = data.zoneId and tostring(data.zoneId):match("%S+") or nil
        local slotId = data.slotId and tostring(data.slotId):match("%S+") or nil
        if not slotId and data.slot and zoneId then
            local slotIndex = tonumber(data.slot)
            for _, z in ipairs(Config.Zones or {}) do
                if
                    (z.id and tostring(z.id):match("%S+")) == zoneId and z.CarMarketBoxes and slotIndex and
                        slotIndex >= 1 and
                        slotIndex <= #z.CarMarketBoxes
                 then
                    local box = z.CarMarketBoxes[slotIndex]
                    slotId = box and (box.id and tostring(box.id):match("%S+") or box.id) or nil
                    break
                end
            end
        end
        KOJA.Shared.KojaCarmarketDebug(
            "[koja-carmarket] buySlot: identifier=" ..
                tostring(identifier) .. " slotId=" .. tostring(slotId) .. " zoneId=" .. tostring(zoneId)
        )
        if not slotId or not zoneId then
            KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] buySlot: bad_data")
            cb({success = false, reason = "bad_data"})
            return
        end
        local price = (Config.Parking and Config.Parking.SlotPrice) or 10000
        local weeklyFee = (Config.Parking and Config.Parking.SlotWeeklyFee) or 2000
        KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] buySlot: price=" .. tostring(price) .. " weeklyFee=" .. tostring(weeklyFee))
        MySQL.Async.fetchAll(
            "SELECT owner_identifier FROM koja_carmarket_slot_owners WHERE slot_id = @sid LIMIT 1",
            {["@sid"] = slotId},
            function(rows)
                KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] buySlot: DB query returned " .. tostring(rows and #rows or "nil") .. " rows")
                if rows and #rows > 0 then
                    if rows[1].owner_identifier == identifier then
                        KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] buySlot: already_yours")
                        cb({success = false, reason = "already_yours"})
                        return
                    end
                    KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] buySlot: slot_taken")
                    cb({success = false, reason = "slot_taken"})
                    return
                end
                MySQL.Async.fetchAll(
                    "SELECT owner_identifier FROM koja_carmarket_exchange WHERE zone_id = @zid LIMIT 1",
                    {["@zid"] = zoneId},
                    function(exRows)
                        local zoneOwner =
                            exRows and exRows[1] and
                            (exRows[1].owner_identifier and tostring(exRows[1].owner_identifier):match("%S+")) or
                            nil
                        local money = KOJA.Server.getMoney(source, "bank") or 0
                        KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] buySlot: playerMoney=" .. tostring(money))
                        if money < price then
                            KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] buySlot: no_money")
                            cb({success = false, reason = "no_money"})
                            return
                        end
                        local removed = KOJA.Server.removeMoney(source, price, "bank", "slot_purchase")
                        KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] buySlot: removeMoney=" .. tostring(removed))
                        if not removed then
                            KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] buySlot: pay_failed")
                            cb({success = false, reason = "pay_failed"})
                            return
                        end
                        MySQL.Async.fetchAll(
                            "SELECT owner_identifier FROM koja_carmarket_exchange WHERE zone_id = @zid LIMIT 1",
                            {["@zid"] = zoneId},
                            function(exRows2)
                                local zoneOwner2 =
                                    exRows2 and exRows2[1] and
                                    (exRows2[1].owner_identifier and tostring(exRows2[1].owner_identifier):match("%S+")) or
                                    nil
                                if zoneOwner2 and zoneOwner2 ~= "" and zoneOwner2 ~= identifier then
                                    KOJA.Server.addMoneyByIdentifier(zoneOwner2, price, "zone_slot_income")
                                end
                                MySQL.Async.execute(
                                    "INSERT INTO koja_carmarket_slot_owners (slot_id, zone_id, owner_identifier, weekly_fee, next_payment_at) VALUES (@sid, @zid, @oid, @fee, DATE_ADD(NOW(), INTERVAL 7 DAY))",
                                    {
                                        ["@sid"] = slotId,
                                        ["@zid"] = zoneId,
                                        ["@oid"] = identifier,
                                        ["@fee"] = weeklyFee
                                    },
                                    function()
                                        KOJA.Shared.KojaCarmarketDebug("[koja_carmarket] buySlot: SUCCESS for " .. tostring(slotId))
                                        cb({success = true})
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
    "koja_carmarket:server:getMySlots",
    function(source, data, cb)
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false, slots = {}})
            return
        end
        KOJA.Server.processDueSlotFees(
            identifier,
            function()
                MySQL.Async.fetchAll(
                    "SELECT slot_id, zone_id, weekly_fee, next_payment_at FROM koja_carmarket_slot_owners WHERE owner_identifier = @oid",
                    {["@oid"] = identifier},
                    function(rows)
                        local slots = {}
                        if rows then
                            for _, r in ipairs(rows) do
                                slots[#slots + 1] = {
                                    slot_id = r.slot_id,
                                    zone_id = r.zone_id,
                                    weekly_fee = r.weekly_fee,
                                    next_payment_at = r.next_payment_at
                                }
                            end
                        end
                        cb({success = true, slots = slots})
                    end
                )
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:getAllSlotStatuses",
    function(source, data, cb)
        KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] getAllSlotStatuses called, zoneId=" .. tostring(data and data.zoneId or "nil"))
        local zoneId = data.zoneId and tostring(data.zoneId):match("%S+") or nil
        local q =
            zoneId and "SELECT slot_id, zone_id, owner_identifier FROM koja_carmarket_slot_owners WHERE zone_id = @zid" or
            "SELECT slot_id, zone_id, owner_identifier FROM koja_carmarket_slot_owners"
        local p = zoneId and {["@zid"] = zoneId} or {}
        KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] getAllSlotStatuses query: " .. tostring(q))
        MySQL.Async.fetchAll(
            q,
            p,
            function(rows)
                KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] getAllSlotStatuses rows: " .. tostring(rows and #rows or "nil"))
                local statuses = {}
                if rows then
                    for _, r in ipairs(rows) do
                        statuses[r.slot_id] = {owner = r.owner_identifier, zone_id = r.zone_id}
                    end
                end
                cb({success = true, statuses = statuses})
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:moveCarToSlot",
    function(source, data, cb)
        if not KOJA.Server.rateLimit(source, "moveCarToSlot", 1000) then
            cb({success = false, reason = "rate_limited"})
            return
        end
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false})
            return
        end
        local plate = data.plate and tostring(data.plate):match("%S+") or nil
        local targetSlotId = data.targetSlotId and tostring(data.targetSlotId):match("%S+") or nil
        if not plate or not targetSlotId or #plate > 32 or #targetSlotId > 64 then
            cb({success = false, reason = "bad_data"})
            return
        end
        MySQL.Async.fetchAll(
            "SELECT owner_identifier, zone_id FROM koja_carmarket_slot_owners WHERE slot_id = @sid LIMIT 1",
            {["@sid"] = targetSlotId},
            function(slotRows)
                if not slotRows or #slotRows == 0 or slotRows[1].owner_identifier ~= identifier then
                    cb({success = false, reason = "not_your_slot"})
                    return
                end
                local zoneId = slotRows[1].zone_id
                local configZone = nil
                for _, cz in ipairs(Config.Zones) do
                    if cz.id == zoneId then
                        configZone = cz
                        break
                    end
                end
                if not configZone or not configZone.CarMarketBoxes then
                    cb({success = false, reason = "no_zone"})
                    return
                end
                local targetBox = nil
                for _, box in ipairs(configZone.CarMarketBoxes) do
                    if box.id == targetSlotId then
                        targetBox = box
                        break
                    end
                end
                if not targetBox then
                    cb({success = false, reason = "no_box"})
                    return
                end
                local newCoords = {x = targetBox.coords.x, y = targetBox.coords.y, z = targetBox.coords.z}
                local newHeading = targetBox.rotation or 0.0
                local zd = KOJA.Server.CarsInZone[zoneId]
                if not zd then
                    cb({success = false, reason = "no_car"})
                    return
                end
                local car = zd[plate]
                if not car or car.owner ~= identifier then
                    cb({success = false, reason = "no_car"})
                    return
                end
                for existingPlate, existingCar in pairs(zd) do
                    if existingPlate ~= plate and existingCar.coords then
                        local odx = (tonumber(existingCar.coords.x) or 0) - newCoords.x
                        local ody = (tonumber(existingCar.coords.y) or 0) - newCoords.y
                        if math.sqrt(odx * odx + ody * ody) < 1.5 then
                            cb({success = false, reason = "slot_occupied"})
                            return
                        end
                    end
                end
                car.coords = newCoords
                car.heading = newHeading
                MySQL.Async.execute(
                    "UPDATE koja_carmarket SET coords = @coords, heading = @heading WHERE plate = @plate AND zone_id = @zid",
                    {
                        ["@coords"] = json.encode(newCoords),
                        ["@heading"] = newHeading,
                        ["@plate"] = plate,
                        ["@zid"] = zoneId
                    },
                    function()
                        cb({success = true, zoneId = zoneId})
                    end
                )
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:getParkingLocations",
    function(source, data, cb)
        local identifier = KOJA.Server.GetPlayerIdentifier(source) or ""
        local zones = Config.Zones or {}
        MySQL.Async.fetchAll(
            "SELECT slot_id, zone_id, next_payment_at, owner_identifier FROM koja_carmarket_slot_owners",
            {},
            function(slotOwnerRows)
                local slotOwnersByZone = {}
                if slotOwnerRows then
                    for _, r in ipairs(slotOwnerRows) do
                        local zid = r.zone_id and tostring(r.zone_id):match("%S+") or nil
                        if zid then
                            if not slotOwnersByZone[zid] then
                                slotOwnersByZone[zid] = {}
                            end
                            local sid = r.slot_id and tostring(r.slot_id):match("%S+") or r.slot_id
                            if sid then
                                slotOwnersByZone[zid][sid] = {
                                    next_payment_at = r.next_payment_at,
                                    owner_identifier = r.owner_identifier or ""
                                }
                            end
                        end
                    end
                end
                MySQL.Async.fetchAll(
                    "SELECT zone_id, slot_id, plate, owner, vehicle FROM koja_carmarket",
                    {},
                    function(carRows)
                        local carsByZoneSlot = {}
                        local platesToFetch = {}
                        if carRows then
                            for _, r in ipairs(carRows) do
                                local zid = r.zone_id and tostring(r.zone_id):match("%S+") or nil
                                local sid = r.slot_id and tostring(r.slot_id):match("%S+") or r.slot_id
                                if zid and sid then
                                    if not carsByZoneSlot[zid] then
                                        carsByZoneSlot[zid] = {}
                                    end
                                    carsByZoneSlot[zid][sid] = r
                                    platesToFetch[#platesToFetch + 1] = {owner = r.owner or "", plate = r.plate or ""}
                                end
                            end
                        end
                        local listingByKey = {}
                        local function buildZoneData()
                            local out = {}
                            local spacesPerPage = (Config.Parking and Config.Parking.SpacesPerPage) or 10
                            for _, zone in ipairs(zones) do
                                local zoneId = zone.id and tostring(zone.id):match("%S+") or nil
                                if not zoneId then
                                    goto cont
                                end
                                local boxes = zone.CarMarketBoxes or {}
                                local spaces = {}
                                local ownersInZone = slotOwnersByZone[zoneId] or {}
                                local carsInZone = carsByZoneSlot[zoneId] or {}
                                for slotIndex, box in ipairs(boxes) do
                                    local slotId = box.id and tostring(box.id):match("%S+") or box.id
                                    local owned = slotId and ownersInZone[slotId]
                                    local car = slotId and carsInZone[slotId]
                                    local ownedByMe =
                                        owned and (tostring(owned.owner_identifier or "") == tostring(identifier))
                                    local status
                                    if not owned then
                                        status = "not_purchased"
                                    elseif not ownedByMe then
                                        status = "owned_by_other"
                                    else
                                        status = (car and "occupied" or "free")
                                    end
                                    local expiresAt = nil
                                    if owned and owned.next_payment_at then
                                        local t = owned.next_payment_at
                                        if type(t) == "number" then
                                            expiresAt = os.date("!%Y-%m-%dT%H:%M:%SZ", t)
                                        else
                                            expiresAt = tostring(t):gsub(" ", "T"):gsub("$", "Z")
                                        end
                                    end
                                    local vehicle = nil
                                    if car and car.plate then
                                        local key = KOJA.Server.ownerPlateKey(car.owner, car.plate)
                                        local listing = listingByKey[key]
                                        local v = KOJA.Shared.decodeJsonStringOrTable(car.vehicle)
                                        local displayName = KOJA.Server.listingDisplayName(listing, car.plate)
                                        if displayName == ("Vehicle " .. tostring(car.plate or "")) then
                                            local vName =
                                                v.name and tostring(v.name):match("%S+") and
                                                not tostring(v.name):match("^Vehicle") and
                                                tostring(v.name):gsub("%s+", " "):match("^%s*(.-)%s*$")
                                            local vResp =
                                                v.respname and tostring(v.respname):match("%S+") and
                                                not tostring(v.respname):match("^-?%d+$") and
                                                tostring(v.respname)
                                            local listResp =
                                                listing and listing.respname and tostring(listing.respname):match("%S+") and
                                                not tostring(listing.respname):match("^-?%d+$") and
                                                tostring(listing.respname)
                                            local vdataForModel = v
                                            if listing and listing.vehicle_data then
                                                local vd =
                                                    type(listing.vehicle_data) == "string" and
                                                    json.decode(listing.vehicle_data) or
                                                    listing.vehicle_data
                                                if type(vd) == "table" then
                                                    vdataForModel = vd
                                                end
                                            end
                                            local fromModel = KOJA.Server.modelToRespname(vdataForModel)
                                            if vName then
                                                displayName = vName
                                            elseif vResp then
                                                displayName = vResp
                                            elseif listResp then
                                                displayName = listResp
                                            elseif fromModel and fromModel ~= "vehicle" then
                                                displayName = fromModel
                                            end
                                        end
                                        local finalName = displayName
                                        if listing and listing.name and tostring(listing.name):match("%S+") then
                                            finalName =
                                                tostring(listing.name):gsub("%s+", " "):match("^%s*(.-)%s*$") or
                                                displayName
                                        end
                                        local vdata =
                                            (listing and listing.vehicle_data and
                                            (type(listing.vehicle_data) == "string" and
                                                json.decode(listing.vehicle_data) or
                                                listing.vehicle_data)) or
                                            {}
                                        if type(vdata) ~= "table" then
                                            vdata = {}
                                        end
                                        local parkCat = KOJA.Shared.normalizeVehicleCategorySlug(
                                            (listing and listing.car_type) or v.car_type,
                                            vdata
                                        )
                                        local parkFuel =
                                            KOJA.Shared.wireFuelSlugGasOrElectric(
                                            (listing and listing.fuel_type) or v.fuel_type or vdata.fuel_type)
                                        vehicle = {
                                            id = listing and listing.id or 0,
                                            name = finalName,
                                            respname = (listing and listing.respname) or KOJA.Server.modelToRespname(v),
                                            car_type = parkCat,
                                            drive_type = KOJA.Shared.coalesceDriveType(
                                                parkCat,
                                                (listing and listing.drive_type) or v.drive_type
                                            ),
                                            fuel_type = parkFuel,
                                            mileage = tonumber(listing and listing.mileage or v.mileage) or 0,
                                            plate = car.plate or ""
                                        }
                                    end
                                    spaces[#spaces + 1] = {
                                        slot = slotIndex,
                                        status = status,
                                        ownedByMe = ownedByMe,
                                        expiresAt = expiresAt,
                                        vehicle = vehicle
                                    }
                                end
                                out[zoneId] = {
                                    name = zone.name or zoneId,
                                    spaces = spaces,
                                    totalPages = math.max(1, math.ceil(#spaces / spacesPerPage))
                                }
                                ::cont::
                            end
                            cb(out)
                        end
                        if #platesToFetch == 0 then
                            buildZoneData()
                            return
                        end
                        local placeholders = {}
                        local params = {}
                        for i, p in ipairs(platesToFetch) do
                            placeholders[i] = "(owner = @owner" .. i .. " AND plate = @plate" .. i .. ")"
                            params["@owner" .. i] = p.owner
                            params["@plate" .. i] = p.plate
                        end
                        MySQL.Async.fetchAll(
                            "SELECT id, owner, plate, name, respname, car_type, drive_type, fuel_type, mileage, vehicle_data FROM koja_carmarket_listings WHERE " ..
                                table.concat(placeholders, " OR "),
                            params,
                            function(listingRows)
                                if listingRows then
                                    for _, L in ipairs(listingRows) do
                                        listingByKey[KOJA.Server.ownerPlateKey(L.owner, L.plate)] = L
                                    end
                                end
                                buildZoneData()
                            end
                        )
                    end
                )
            end
        )
    end
)

CreateThread(
    function()
        while true do
            Wait(60000 * 5)
            MySQL.Async.fetchAll(
                "SELECT id, owner, plate, zone_id FROM koja_carmarket_listings WHERE listing_fee_paid_until IS NOT NULL AND listing_fee_paid_until < NOW() AND zone_id IS NOT NULL",
                {},
                function(rows)
                    if not rows then
                        return
                    end
                    for _, row in ipairs(rows) do
                        local zoneId = row.zone_id
                        local owner = row.owner
                        local listingId = row.id
                        local plate = row.plate
                        MySQL.Async.fetchAll(
                            "SELECT listing_fee_per_week, commission_percent, owner_identifier FROM koja_carmarket_exchange WHERE zone_id = @zid LIMIT 1",
                            {["@zid"] = zoneId},
                            function(exRows)
                                local fee = (Config.Exchange and Config.Exchange.DefaultListingFeePerWeek) or 500
                                local commPct = (Config.Exchange and Config.Exchange.DefaultCommissionPercent) or 5
                                local zoneOwner = nil
                                if exRows and #exRows > 0 then
                                    fee = tonumber(exRows[1].listing_fee_per_week) or fee
                                    commPct = tonumber(exRows[1].commission_percent) or commPct
                                    local oi = exRows[1].owner_identifier
                                    if oi and oi ~= "" then
                                        zoneOwner = oi
                                    end
                                end
                                local isZoneOwnerListing =
                                    (zoneOwner and tostring(zoneOwner):match("%S+") == tostring(owner):match("%S+"))
                                if isZoneOwnerListing and fee > 0 then
                                    MySQL.Async.execute(
                                        "UPDATE koja_carmarket_listings SET listing_fee_paid_until = DATE_ADD(NOW(), INTERVAL 7 DAY) WHERE id = @id",
                                        {["@id"] = listingId},
                                        function()
                                        end
                                    )
                                    return
                                end
                                KOJA.Server.removeMoneyByIdentifier(
                                    owner,
                                    fee,
                                    "listing_fee_weekly",
                                    function(paid)
                                        if paid then
                                            MySQL.Async.execute(
                                                "UPDATE koja_carmarket_listings SET listing_fee_paid_until = DATE_ADD(NOW(), INTERVAL 7 DAY) WHERE id = @id",
                                                {["@id"] = listingId},
                                                function()
                                                end
                                            )
                                            if zoneOwner and fee > 0 then
                                                local cut = math.floor(fee * commPct / 100)
                                                if cut > 0 then
                                                    KOJA.Server.addMoneyByIdentifier(zoneOwner, cut, "zone_listing_income")
                                                end
                                            end
                                        elseif fee > 0 then
                                            MySQL.Async.execute(
                                                "DELETE FROM koja_carmarket WHERE zone_id = @zid AND owner = @oid AND plate = @plate",
                                                {["@zid"] = zoneId, ["@oid"] = owner, ["@plate"] = plate},
                                                function()
                                                    MySQL.Async.execute(
                                                        "DELETE FROM koja_carmarket_listings WHERE id = @id",
                                                        {["@id"] = listingId},
                                                        function()
                                                            if KOJA.Server.CarsInZone[zoneId] then
                                                                KOJA.Server.CarsInZone[zoneId][plate] = nil
                                                            end
                                                            TriggerClientEvent(
                                                                "koja_carmarket:client:vehicleSold",
                                                                -1,
                                                                plate
                                                            )
                                                        end
                                                    )
                                                end
                                            )
                                        end
                                    end
                                )
                            end
                        )
                    end
                end
            )
        end
    end
)

local AuctionStartedNotified = {}
CreateThread(function()
    while true do
        Wait(60000)
        MySQL.Async.fetchAll(
            "SELECT id FROM koja_carmarket_listings WHERE offert_type = 'auction' AND auction_starts_at IS NOT NULL AND auction_starts_at <= NOW() AND (auction_ends_at IS NULL OR auction_ends_at > NOW())",
            {},
            function(rows)
                if not rows then return end
                for _, row in ipairs(rows) do
                    local id = row and row.id
                    if id and not AuctionStartedNotified[id] then
                        AuctionStartedNotified[id] = true
                        TriggerClientEvent("koja_carmarket:client:auctionUpdated", -1, {listingId = id, event = "started"})
                    end
                end
            end
        )
    end
end)

CreateThread(
    function()
        while true do
            Wait(60000)
            MySQL.Async.fetchAll(
                "SELECT l.id, l.owner, l.plate, l.zone_id FROM koja_carmarket_listings l WHERE l.offert_type = 'auction' AND l.auction_ends_at IS NOT NULL AND l.auction_ends_at < NOW() AND NOT EXISTS (SELECT 1 FROM koja_carmarket_offers o WHERE o.listing_id = l.id)",
                {},
                function(rows)
                    if not rows then
                        return
                    end
                    for _, row in ipairs(rows) do
                        local zid = row.zone_id and tostring(row.zone_id):match("%S+") or nil
                        local plate = KOJA.Server.plateNormalized(row.plate)
                        local owner = row.owner and tostring(row.owner):match("%S+") or nil
                        if zid and plate and owner then
                            MySQL.Async.execute(
                                "DELETE FROM koja_carmarket WHERE zone_id = @zid AND owner = @oid AND TRIM(plate) = @plate",
                                {["@zid"] = zid, ["@oid"] = owner, ["@plate"] = row.plate or plate},
                                function()
                                    if KOJA.Server.CarsInZone and KOJA.Server.CarsInZone[zid] then
                                        for p, _ in pairs(KOJA.Server.CarsInZone[zid] or {}) do
                                            if KOJA.Server.plateNormalized(p) == plate then
                                                KOJA.Server.CarsInZone[zid][p] = nil
                                                break
                                            end
                                        end
                                    end
                                    MySQL.Async.execute(
                                        "DELETE FROM koja_carmarket_listings WHERE id = @id",
                                        {["@id"] = row.id},
                                        function()
                                            TriggerClientEvent(
                                                "koja_carmarket:client:auctionUpdated",
                                                -1,
                                                {listingId = row.id, event = "ended"}
                                            )
                                            TriggerClientEvent(
                                                "koja_carmarket:client:vehicleSold",
                                                -1,
                                                row.plate or plate
                                            )
                                        end
                                    )
                                end
                            )
                        else
                            MySQL.Async.execute(
                                "DELETE FROM koja_carmarket_listings WHERE id = @id",
                                {["@id"] = row.id},
                                function()
                                    TriggerClientEvent(
                                        "koja_carmarket:client:auctionUpdated",
                                        -1,
                                        {listingId = row.id, event = "ended"}
                                    )
                                end
                            )
                        end
                    end
                end
            )

            MySQL.Async.fetchAll(
                "SELECT l.id, l.owner, l.plate, l.zone_id FROM koja_carmarket_listings l WHERE l.offert_type = 'auction' AND l.auction_ends_at IS NOT NULL AND l.auction_ends_at < NOW()",
                {},
                function(rows2)
                    if not rows2 then return end
                    for _, row in ipairs(rows2) do
                        local zid = row.zone_id and tostring(row.zone_id):match("%S+") or nil
                        local plateNorm = KOJA.Server.plateNormalized(row.plate)
                        local owner = row.owner and tostring(row.owner):match("%S+") or nil

                        local function finalizeDelete()
                            MySQL.Async.execute(
                                "DELETE FROM koja_carmarket_offers WHERE listing_id = @id",
                                {["@id"] = row.id},
                                function()
                                    MySQL.Async.execute(
                                        "DELETE FROM koja_carmarket_listings WHERE id = @id",
                                        {["@id"] = row.id},
                                        function()
                                            TriggerClientEvent("koja_carmarket:client:auctionUpdated", -1, {listingId = row.id, event = "ended"})
                                            if row.plate then
                                                TriggerClientEvent("koja_carmarket:client:vehicleSold", -1, tostring(row.plate):sub(1, 8))
                                            elseif plateNorm then
                                                TriggerClientEvent("koja_carmarket:client:vehicleSold", -1, tostring(plateNorm):sub(1, 8))
                                            end
                                        end
                                    )
                                end
                            )
                        end

                        if zid and plateNorm and owner then
                            MySQL.Async.execute(
                                "DELETE FROM koja_carmarket WHERE zone_id = @zid AND owner = @oid AND REPLACE(TRIM(plate), ' ', '') = @plateNorm",
                                {["@zid"] = zid, ["@oid"] = owner, ["@plateNorm"] = plateNorm},
                                function()
                                    if KOJA.Server.CarsInZone and KOJA.Server.CarsInZone[zid] then
                                        for p, _ in pairs(KOJA.Server.CarsInZone[zid] or {}) do
                                            if KOJA.Server.plateNormalized(p) == plateNorm then
                                                KOJA.Server.CarsInZone[zid][p] = nil
                                                break
                                            end
                                        end
                                    end
                                    finalizeDelete()
                                end
                            )
                        else
                            MySQL.Async.execute(
                                "DELETE FROM koja_carmarket WHERE REPLACE(TRIM(plate), ' ', '') = @plateNorm",
                                {["@plateNorm"] = plateNorm or ""},
                                function()
                                    finalizeDelete()
                                end
                            )
                        end
                    end
                end
            )
        end
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:getCarsInZone",
    function(source, data, cb)
        local zoneId = (data and data.zoneId) and tostring(data.zoneId):match("%S+") or nil
        if not zoneId then
            cb({success = true, data = {}})
            return
        end
        MySQL.Async.fetchAll(
            "SELECT * FROM koja_carmarket",
            {},
            function(results)
                local zoneData = {}
                if not results or #results == 0 then
                    cb({success = true, data = zoneData})
                    return
                end
                local plates = {}
                for _, car in ipairs(results) do
                    local rowZone = tostring(car.zone_id or car.zoneId or car.zoneid or "")
                    if rowZone ~= tostring(zoneId) then
                        goto continue
                    end
                    local plate = car.plate or car.Plate
                    local owner = car.owner or car.Owner
                    local coordsRaw = car.coords or car.Coords
                    local coords = type(coordsRaw) == "string" and json.decode(coordsRaw) or coordsRaw
                    if coords and plate and owner then
                        local slotId = car.slot_id or car.slot_Id or nil
                        zoneData[plate] = {
                            owner = owner,
                            vehicle = car.vehicle or car.Vehicle,
                            plate = plate,
                            coords = coords,
                            heading = tonumber(car.heading or car.Heading) or 0,
                            slot_id = slotId
                        }
                        plates[#plates + 1] = {owner = owner, plate = plate}
                    end
                    ::continue::
                end
                if #plates == 0 then
                    cb({success = true, data = zoneData})
                    return
                end
                local placeholders = {}
                local params = {["@zid"] = zoneId}
                for i, row in ipairs(plates) do
                    placeholders[i] = "(owner = @owner" .. i .. " AND plate = @plate" .. i .. ")"
                    params["@owner" .. i] = row.owner
                    params["@plate" .. i] = row.plate
                end
                local q =
                    "SELECT id, owner, plate, name, respname, car_type, price, description, mileage, fuel_type, drive_type, vehicle_data, DATE_FORMAT(COALESCE(created_at, NOW()), '%Y-%m-%d %H:%i') AS listedAt FROM koja_carmarket_listings WHERE " ..
                        table.concat(placeholders, " OR ")
                MySQL.Async.fetchAll(
                    q,
                    params,
                    function(rows)
                        local byOwnerPlate = {}
                        if not rows or #rows == 0 then
                            if KOJA.Server.CarsInZone[zoneId] then
                                for plate, car in pairs(zoneData) do
                                    KOJA.Server.CarsInZone[zoneId][plate] = car
                                end
                            else
                                KOJA.Server.CarsInZone[zoneId] = zoneData
                            end
                            cb({success = true, data = zoneData})
                            return
                        end
                        local ovConds = {}
                        local ovPar = {}
                        for i, r in ipairs(rows) do
                            ovConds[i] =
                                "(owner = @ovo" ..
                                i .. " AND REPLACE(TRIM(plate), ' ', '') = REPLACE(TRIM(@ovp" .. i .. "), ' ', ''))"
                            ovPar["@ovo" .. i] = r.owner or ""
                            ovPar["@ovp" .. i] = r.plate or ""
                        end
                        MySQL.Async.fetchAll(
                            "SELECT owner, plate, mileage, vehicle FROM " ..
                                KOJA.Server.vehicleTable() .. " WHERE " .. table.concat(ovConds, " OR "),
                            ovPar,
                            function(ovRows)
                                local mileageByKey = {}
                                if ovRows then
                                    for _, r in ipairs(ovRows) do
                                        local k = KOJA.Server.ownerPlateNormKey(r.owner, r.plate)
                                        mileageByKey[k] = KOJA.Server.getMileageFromOwnedVehicleRow(r)
                                    end
                                end
                                for _, r in ipairs(rows) do
                                    local vdata =
                                        (r.vehicle_data and
                                        (type(r.vehicle_data) == "string" and json.decode(r.vehicle_data) or
                                            r.vehicle_data)) or
                                        {}
                                    local extra_info = KOJA.Shared.buildExtraInfoCoreRowsFromVdata(vdata)
                                    local key = KOJA.Server.ownerPlateKey(r.owner, r.plate)
                                    local keyNorm = KOJA.Server.ownerPlateNormKey(r.owner, r.plate)
                                    local mileage = mileageByKey[keyNorm]
                                    if mileage == nil then
                                        mileage = r.mileage
                                    end
                                    mileage = tonumber(mileage) or 0
                                    local fuelRaw = KOJA.Shared.wireFuelSlugGasOrElectric(
                                        (r.fuel_type and tostring(r.fuel_type):match("%S+")) or
                                            (vdata.fuel_type and tostring(vdata.fuel_type):match("%S+")) or
                                            nil
                                    )
                                    local zoneCat = KOJA.Shared.normalizeVehicleCategorySlug(r.car_type, vdata)
                                    local respname = KOJA.Server.resolveRespnameForPayload(r.respname, vdata)
                                    byOwnerPlate[key] = {
                                        listing_id = r.id,
                                        name = r.name,
                                        respname = respname,
                                        car_type = zoneCat,
                                        price = tonumber(r.price) or 0,
                                        description = r.description or "",
                                        listedAt = r.listedAt or "",
                                        mileage = mileage,
                                        fuel_type = fuelRaw,
                                        drive_type = KOJA.Shared.coalesceDriveType(
                                            zoneCat,
                                            (r.drive_type and tostring(r.drive_type):match("%S+")) or
                                                (vdata.drive_type and tostring(vdata.drive_type):match("%S+"))
                                        ),
                                        extra_info = extra_info,
                                        vehicle_data = vdata
                                    }
                                end
                                for plate, car in pairs(zoneData) do
                                    local key = KOJA.Server.ownerPlateKey(car.owner, car.plate)
                                    local listing = byOwnerPlate[key]
                                    if listing then
                                        car.listing_id = listing.listing_id
                                        car.name = KOJA.Server.listingDisplayName(
                                            {name = listing.name, respname = listing.respname},
                                            car.plate
                                        )
                                        car.price = listing.price
                                        car.description = listing.description
                                        car.listedAt = listing.listedAt or ""
                                        car.mileage = listing.mileage
                                        car.fuel_type = listing.fuel_type
                                        car.drive_type = listing.drive_type
                                        car.car_type = listing.car_type
                                        car.respname = KOJA.Server.resolveRespnameForPayload(listing.respname, listing.vehicle_data)
                                        car.extra_info = listing.extra_info or {}
                                        car.vehicle_data = listing.vehicle_data or {}
                                    end
                                end
                                if KOJA.Server.CarsInZone[zoneId] then
                                    for plate, car in pairs(zoneData) do
                                        KOJA.Server.CarsInZone[zoneId][plate] = car
                                    end
                                else
                                    KOJA.Server.CarsInZone[zoneId] = zoneData
                                end
                                cb({success = true, data = zoneData})
                            end
                        )
                    end
                )
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:getPlayerCars",
    function(source, data, cb)
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false})
            return
        end
        MySQL.Async.fetchAll(
            "SELECT * FROM " .. KOJA.Server.vehicleTable() .. " WHERE owner = @owner",
            {
                ["@owner"] = identifier
            },
            function(results)
                if not results or #results == 0 then
                    cb({success = true, data = {}})
                    return
                end
                MySQL.Async.fetchAll(
                    "SELECT plate FROM koja_carmarket_listings WHERE owner = @owner",
                    {["@owner"] = identifier},
                    function(listed)
                        local listedPlates = {}
                        if listed then
                            for _, row in ipairs(listed) do
                                listedPlates[row.plate or ""] = true
                            end
                        end
                        local filtered = {}
                        for _, v in ipairs(results) do
                            if not listedPlates[v.plate or ""] then
                                filtered[#filtered + 1] = v
                            end
                        end
                        cb({success = true, data = filtered})
                    end
                )
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:addToMarket",
    function(source, data, cb)
        if not KOJA.Server.rateLimit(source, "addToMarket", 2000) then
            cb({success = false, reason = "rate_limited"})
            return
        end
        local responded = false
        local function safeCb(result)
            if responded then
                return
            end
            responded = true
            cb(result)
        end
        CreateThread(
            function()
                Wait(15000)
                safeCb({success = false, reason = "timeout"})
            end
        )
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            safeCb({success = false, reason = "no_identifier"})
            return
        end
        local zoneId = data.id and tostring(data.id):match("%S+") or nil
        if not zoneId then
            safeCb({success = false, reason = "no_zone"})
            return
        end
        local plate = KOJA.Server.plateNormalized(data.plate)
        if not plate or plate == "" then
            safeCb({success = false, reason = "no_plate"})
            return
        end
        if not KOJA.Server.CarsInZone[zoneId] then
            KOJA.Server.CarsInZone[zoneId] = {}
        end
        local zoneData = KOJA.Server.CarsInZone[zoneId]
        local currentCount = 0
        for _ in pairs(zoneData) do
            currentCount = currentCount + 1
        end
        MySQL.Async.fetchAll(
            "SELECT max_listings, listing_fee_per_week, owner_identifier FROM koja_carmarket_exchange WHERE zone_id = @zid LIMIT 1",
            {["@zid"] = zoneId},
            function(exRows)
                local maxListings = (Config.Exchange and Config.Exchange.MaxListingsPerZone) or 50
                local listingFee = (Config.Exchange and Config.Exchange.DefaultListingFeePerWeek) or 500
                local zoneOwnerId = nil
                if exRows and #exRows > 0 then
                    maxListings = tonumber(exRows[1].max_listings) or maxListings
                    listingFee = tonumber(exRows[1].listing_fee_per_week) or listingFee
                    local oi = exRows[1].owner_identifier
                    if oi and tostring(oi):match("%S+") then
                        zoneOwnerId = tostring(oi):match("%S+")
                    end
                end
                if currentCount >= maxListings then
                    safeCb({success = false, reason = "max_listings"})
                    return
                end
                local isZoneOwner = (zoneOwnerId and zoneOwnerId == identifier)
                if
                    listingFee > 0 and not isZoneOwner and
                        ((KOJA.Server.getMoney(source, "bank") or 0) < listingFee or
                            not KOJA.Server.removeMoney(source, listingFee, "bank", "listing_fee"))
                 then
                    safeCb({success = false, reason = "fee"})
                    return
                end
                MySQL.Async.fetchAll(
                    "SELECT * FROM " ..
                        KOJA.Server.vehicleTable() .. " WHERE owner = @owner AND REPLACE(TRIM(plate), ' ', '') = @plateNorm LIMIT 1",
                    {["@owner"] = identifier, ["@plateNorm"] = plate},
                    function(vehicleRows)
                        if not vehicleRows or #vehicleRows == 0 then
                            safeCb({success = false, reason = "no_vehicle"})
                            return
                        end
                        local row = vehicleRows[1]
                        local price = KOJA.Server.clampPrice(data.price)
                        if not price then
                            safeCb({success = false, reason = "bad_price"})
                            return
                        end
                        local function doInsertAndUpdate()
                            local slotId = (data.slot_id and tostring(data.slot_id):match("%S+")) or nil
                            MySQL.Async.execute(
                                "INSERT INTO koja_carmarket (zone_id, slot_id, owner, vehicle, plate, coords, heading) VALUES (?, ?, ?, ?, ?, ?, ?)",
                                {
                                    zoneId,
                                    slotId,
                                    identifier,
                                    data.vehicle,
                                    data.plate,
                                    json.encode(data.coords),
                                    data.heading
                                },
                                function()
                                    KOJA.Server.CarsInZone[zoneId][data.plate] = {
                                        owner = identifier,
                                        vehicle = data.vehicle,
                                        plate = data.plate,
                                        coords = data.coords,
                                        heading = data.heading,
                                        slot_id = slotId
                                    }
                                    MySQL.Async.execute(
                                        "UPDATE koja_carmarket_listings SET zone_id = @zid, listing_fee_paid_until = DATE_ADD(NOW(), INTERVAL 7 DAY) WHERE owner = @oid AND plate = @plate",
                                        {
                                            ["@zid"] = zoneId,
                                            ["@oid"] = identifier,
                                            ["@plate"] = data.plate
                                        },
                                        function()
                                        end
                                    )
                                    safeCb({success = true})
                                end
                            )
                        end
                        local function continueListingFlow()
                            MySQL.Async.fetchAll(
                                "SELECT id FROM koja_carmarket_listings WHERE owner = @owner AND plate = @plate LIMIT 1",
                                {["@owner"] = identifier, ["@plate"] = row.plate or data.plate},
                                function(existingListing)
                                    if existingListing and #existingListing > 0 then
                                        doInsertAndUpdate()
                                        return
                                    end
                                    local v =
                                        row.vehicle and
                                        (type(row.vehicle) == "string" and json.decode(row.vehicle) or row.vehicle) or
                                        {}
                                    if type(v) ~= "table" then
                                        v = {}
                                    end
                                    local respname = KOJA.Server.resolveRespnameForStore(data.respname or row.respname or v.respname, v)
                                    v.respname = respname
                                    local vehicleDataJson = json.encode(v)
                                    local ovId = tonumber(row.id) or tonumber(row.vehicle_id) or tonumber(row.owned_vehicle_id)
                                    if not ovId or ovId <= 0 then
                                        ovId = nil
                                    end
                                    local sellerName = KOJA.Server.GetPlayerName(source) or ""
                                    local mileage = tonumber(row.mileage or v.mileage) or 0
                                    local explicitName = (data.name and tostring(data.name):match("%S+") and tostring(data.name):sub(1, 100)) or nil
                                    local listName =
                                        (explicitName and not KOJA.Shared.isGenericVehicleName(explicitName) and explicitName) or
                                        ((respname and respname ~= "vehicle") and respname) or
                                        ("Vehicle " .. (row.plate or data.plate or ""))
                                    local insCat = KOJA.Shared.normalizeVehicleCategorySlug(v.car_type, v)
                                    MySQL.Async.execute(
                                        "INSERT INTO koja_carmarket_listings (name, respname, owner, car_type, drive_type, fuel_type, offert_type, tags, price, mileage, description, plate, vehicle_data, owned_vehicle_id, seller_name) VALUES (@name, @respname, @owner, @ct, @dt, @ft, 'buy', '[]', @price, @mileage, '', @plate, @vdata, @ovid, @sellerName)",
                                        {
                                            ["@name"] = listName,
                                            ["@respname"] = respname,
                                            ["@owner"] = identifier,
                                            ["@ct"] = insCat,
                                            ["@dt"] = KOJA.Shared.coalesceDriveType(insCat, v.drive_type),
                                            ["@ft"] = KOJA.Shared.wireFuelSlugGasOrElectric(v.fuel_type),
                                            ["@price"] = price,
                                            ["@mileage"] = mileage,
                                            ["@plate"] = row.plate or data.plate,
                                            ["@vdata"] = vehicleDataJson,
                                            ["@ovid"] = ovId,
                                            ["@sellerName"] = sellerName
                                        },
                                        function()
                                            doInsertAndUpdate()
                                        end
                                    )
                                end
                            )
                        end

                        MySQL.Async.fetchAll(
                            "SELECT slot_id FROM koja_carmarket_slot_owners WHERE owner_identifier = @oid AND zone_id = @zid",
                            {["@oid"] = identifier, ["@zid"] = zoneId},
                            function(ownedSlots)
                                KOJA.Shared.KojaCarmarketDebug(
                                    "[koja-carmarket] addToMarket: ownedSlots=" ..
                                        tostring(ownedSlots and #ownedSlots or "nil") ..
                                            " for " .. tostring(identifier) .. " in " .. tostring(zoneId)
                                )
                                if not ownedSlots or #ownedSlots == 0 then
                                    safeCb({success = false, reason = "no_slot"})
                                    return
                                end

                                local configZone = nil
                                for _, cz in ipairs(Config.Zones) do
                                    if cz.id == zoneId then
                                        configZone = cz
                                        break
                                    end
                                end
                                local boxById = {}
                                if configZone and configZone.CarMarketBoxes then
                                    for _, box in ipairs(configZone.CarMarketBoxes) do
                                        if box.id then
                                            boxById[box.id] = box
                                        end
                                    end
                                end

                                local ownedBoxes = {}
                                for _, os in ipairs(ownedSlots) do
                                    local box = boxById[os.slot_id]
                                    if box then
                                        ownedBoxes[#ownedBoxes + 1] = box
                                    end
                                end
                                if #ownedBoxes == 0 then
                                    safeCb({success = false, reason = "no_slot"})
                                    return
                                end

                                local occupiedCoords = {}
                                local zd = KOJA.Server.CarsInZone[zoneId] or {}
                                for _, c in pairs(zd) do
                                    if c.coords then
                                        occupiedCoords[#occupiedCoords + 1] = c.coords
                                    end
                                end

                                local cx = tonumber(data.coords and data.coords.x) or 0.0
                                local cy = tonumber(data.coords and data.coords.y) or 0.0
                                local cz = tonumber(data.coords and data.coords.z) or 0.0
                                local bestDist = nil
                                local best = nil
                                for _, box in ipairs(ownedBoxes) do
                                    local sc = box.coords
                                    if sc and sc.x and sc.y and sc.z then
                                        local occupied = false
                                        for _, oc in ipairs(occupiedCoords) do
                                            local odx = (tonumber(oc.x) or 0) - sc.x
                                            local ody = (tonumber(oc.y) or 0) - sc.y
                                            if math.sqrt(odx * odx + ody * ody) < 1.5 then
                                                occupied = true
                                                break
                                            end
                                        end
                                        if not occupied then
                                            local dx, dy, dz = cx - sc.x, cy - sc.y, cz - sc.z
                                            local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
                                            if (not bestDist) or dist < bestDist then
                                                bestDist = dist
                                                best = {
                                                    coords = {x = sc.x, y = sc.y, z = sc.z},
                                                    heading = box.rotation or tonumber(data.heading) or 0.0,
                                                    slot_id = box.id
                                                }
                                            end
                                        end
                                    end
                                end
                                if not best then
                                    safeCb({success = false, reason = "no_slot"})
                                    return
                                end
                                data.coords = best.coords
                                data.heading = best.heading
                                data.slot_id = best.slot_id
                                continueListingFlow()
                            end
                        )
                    end
                )
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:removeFromMarket",
    function(source, data, cb)
        if not KOJA.Server.rateLimit(source, "removeFromMarket", 1000) then
            cb({success = false, reason = "rate_limited"})
            return
        end
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false})
            return
        end
        local plate = KOJA.Server.plateTrimmed((data and data.plate) or nil)
        local plateNorm = KOJA.Server.plateNormalized(plate)
        if not plate or plate == "" then
            cb({success = false})
            return
        end
        local zoneId = (data and data.zoneId) and tostring(data.zoneId):match("%S+") or nil
        if not zoneId then
            cb({success = false})
            return
        end
        MySQL.Async.fetchAll(
            'SELECT owner FROM koja_carmarket WHERE zone_id = @zid AND REPLACE(TRIM(plate), " ", "") = @plateNorm LIMIT 1',
            {["@zid"] = zoneId, ["@plateNorm"] = plateNorm},
            function(rows)
                if not rows or #rows == 0 or rows[1].owner ~= identifier then
                    cb({success = false})
                    return
                end
                MySQL.Async.execute(
                    'DELETE FROM koja_carmarket WHERE zone_id = @zid AND REPLACE(TRIM(plate), " ", "") = @plateNorm AND owner = @oid',
                    {["@zid"] = zoneId, ["@plateNorm"] = plateNorm, ["@oid"] = identifier},
                    function()
                        if KOJA.Server.CarsInZone[zoneId] then
                            KOJA.Server.removePlateFromZoneCache(zoneId, plate)
                        end
                        MySQL.Async.fetchAll(
                            'SELECT id FROM koja_carmarket_listings WHERE owner = @oid AND REPLACE(TRIM(plate), " ", "") = @plateNorm LIMIT 1',
                            {["@oid"] = identifier, ["@plateNorm"] = plateNorm},
                            function(listRows)
                                if listRows and #listRows > 0 then
                                    MySQL.Async.execute(
                                        "DELETE FROM koja_carmarket_listings WHERE id = @id",
                                        {["@id"] = listRows[1].id},
                                        function()
                                        end
                                    )
                                end
                                TriggerClientEvent("koja_carmarket:client:vehicleSold", -1, plate)
                                cb({success = true})
                            end
                        )
                    end
                )
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:updateListing",
    function(source, data, cb)
        if not KOJA.Server.rateLimit(source, "updateListing", 1000) then
            cb({success = false, reason = "rate_limited"})
            return
        end
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false})
            return
        end
        local listingId = KOJA.Server.sanitizeId(data.listingId)
        local price = data.price ~= nil and KOJA.Server.clampPrice(data.price) or nil
        local description = data.description
        if not listingId then
            cb({success = false, reason = "bad_input"})
            return
        end
        MySQL.Async.fetchAll(
            "SELECT id, owner, offert_type, (SELECT COUNT(*) FROM koja_carmarket_offers o WHERE o.listing_id = koja_carmarket_listings.id) AS bid_count FROM koja_carmarket_listings WHERE id = @id LIMIT 1",
            {["@id"] = listingId},
            function(rows)
                if not rows or #rows == 0 or rows[1].owner ~= identifier then
                    cb({success = false})
                    return
                end
                local row = rows[1]
                local isAuctionLocked = (row.offert_type == "auction") and ((tonumber(row.bid_count) or 0) > 0)
                if isAuctionLocked and price ~= nil then
                    cb({success = false, reason = "auction_locked"})
                    return
                end
                if price and price > 0 and not isAuctionLocked then
                    MySQL.Async.execute(
                        "UPDATE koja_carmarket_listings SET price = @price WHERE id = @id",
                        {["@price"] = price, ["@id"] = listingId},
                        function()
                        end
                    )
                end
                if description ~= nil then
                    MySQL.Async.execute(
                        "UPDATE koja_carmarket_listings SET description = @desc WHERE id = @id",
                        {["@desc"] = tostring(description):sub(1, 500), ["@id"] = listingId},
                        function()
                        end
                    )
                end
                cb({success = true})
            end
        )
    end
)

RegisterNetEvent(
    "koja_carmarket:server:contactSeller",
    function(data)
        local source = source
        if not KOJA.Server.rateLimit(source, "contactSeller", 10000) then
            return
        end
        local senderIdentifier = KOJA.Server.GetPlayerIdentifier(source)
        if not senderIdentifier then return end
        local owner = data and data.owner and tostring(data.owner):match("%S+") or nil
        if not owner or #owner > 64 then return end
        local listingId = KOJA.Server.sanitizeId(data and data.listingId)
        if not listingId then return end
        if owner == senderIdentifier then return end
        MySQL.Async.fetchAll(
            "SELECT 1 FROM koja_carmarket_listings WHERE id = @id AND owner = @owner LIMIT 1",
            {["@id"] = listingId, ["@owner"] = owner},
            function(rows)
                if not rows or #rows == 0 then return end
                local players = KOJA.Server.GetPlayers and KOJA.Server.GetPlayers() or {}
                for _, pid in ipairs(players) do
                    if KOJA.Server.GetPlayerIdentifier(pid) == owner then
                        TriggerClientEvent(
                            "koja_carmarket:client:notifyContact",
                            pid,
                            {from = KOJA.Server.GetPlayerName(source) or ""}
                        )
                        break
                    end
                end
            end
        )
    end
)

AddEventHandler(
    "koja_carmarket:databaseReady",
    function()
        _G.runKojaCarmarketAlterSlotId = function()
            MySQL.Async.fetchAll(
                "SELECT COUNT(*) as c FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'koja_carmarket' AND COLUMN_NAME = 'slot_id'",
                {},
                function(has2)
                    if has2 and has2[1] and (tonumber(has2[1].c) or 0) == 0 then
                        MySQL.Async.execute(
                            "ALTER TABLE koja_carmarket ADD COLUMN slot_id VARCHAR(64) DEFAULT NULL",
                            {},
                            function()
                                KOJA.Shared.KojaCarmarketDebug("^2[koja-carmarket]^7 databaseReady - loading cars")
                                KOJA.Server.LoadCarsFromDatabase()
                            end
                        )
                    else
                        KOJA.Shared.KojaCarmarketDebug("^2[koja-carmarket]^7 databaseReady - loading cars")
                        KOJA.Server.LoadCarsFromDatabase()
                    end
                end
            )
        end
        MySQL.Async.fetchAll(
            "SELECT COUNT(*) as c FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'koja_carmarket_history' AND COLUMN_NAME = 'vehicle_info'",
            {},
            function(has)
                if has and has[1] and (tonumber(has[1].c) or 0) == 0 then
                    MySQL.Async.execute(
                        "ALTER TABLE koja_carmarket_history ADD COLUMN vehicle_info JSON DEFAULT NULL",
                        {},
                        function()
                        end
                    )
                end
            end
        )
        MySQL.Async.fetchAll(
            "SELECT COUNT(*) as c FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'koja_carmarket_listings' AND COLUMN_NAME = 'zone_id'",
            {},
            function(has)
                if has and has[1] and (tonumber(has[1].c) or 0) == 0 then
                    MySQL.Async.execute(
                        "ALTER TABLE koja_carmarket_listings ADD COLUMN zone_id VARCHAR(50) DEFAULT NULL",
                        {},
                        function()
                        end
                    )
                end
            end
        )
        MySQL.Async.fetchAll(
            "SELECT COUNT(*) as c FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'koja_carmarket_listings' AND COLUMN_NAME = 'listing_fee_paid_until'",
            {},
            function(has)
                if has and has[1] and (tonumber(has[1].c) or 0) == 0 then
                    MySQL.Async.execute(
                        "ALTER TABLE koja_carmarket_listings ADD COLUMN listing_fee_paid_until TIMESTAMP NULL DEFAULT NULL",
                        {},
                        function()
                        end
                    )
                end
            end
        )
        MySQL.Async.fetchAll(
            "SELECT COUNT(*) as c FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'koja_carmarket_listings' AND COLUMN_NAME = 'auction_ends_at'",
            {},
            function(has)
                if has and has[1] and (tonumber(has[1].c) or 0) == 0 then
                    MySQL.Async.execute(
                        "ALTER TABLE koja_carmarket_listings ADD COLUMN auction_ends_at TIMESTAMP NULL DEFAULT NULL",
                        {},
                        function()
                        end
                    )
                end
            end
        )
        MySQL.Async.fetchAll(
            "SELECT COUNT(*) as c FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'koja_carmarket_listings' AND COLUMN_NAME = 'auction_starts_at'",
            {},
            function(has)
                if has and has[1] and (tonumber(has[1].c) or 0) == 0 then
                    MySQL.Async.execute(
                        "ALTER TABLE koja_carmarket_listings ADD COLUMN auction_starts_at TIMESTAMP NULL DEFAULT NULL",
                        {},
                        function()
                        end
                    )
                end
            end
        )
        MySQL.Async.fetchAll(
            "SELECT COUNT(*) as c FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'koja_carmarket' AND COLUMN_NAME = 'zone_id'",
            {},
            function(has)
                local addZoneId = has and has[1] and (tonumber(has[1].c) or 0) == 0
                local function doSlotIdThenLoad()
                    MySQL.Async.fetchAll(
                        "SELECT COUNT(*) as c FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'koja_carmarket' AND COLUMN_NAME = 'slot_id'",
                        {},
                        function(has2)
                            if has2 and has2[1] and (tonumber(has2[1].c) or 0) == 0 then
                                MySQL.Async.execute(
                                    "ALTER TABLE koja_carmarket ADD COLUMN slot_id VARCHAR(64) DEFAULT NULL",
                                    {},
                                    function()
                                        KOJA.Shared.KojaCarmarketDebug("^2[koja-carmarket]^7 databaseReady - loading cars")
                                        KOJA.Server.LoadCarsFromDatabase()
                                    end
                                )
                            else
                                KOJA.Shared.KojaCarmarketDebug("^2[koja-carmarket]^7 databaseReady - loading cars")
                                KOJA.Server.LoadCarsFromDatabase()
                            end
                        end
                    )
                end
                if addZoneId then
                    MySQL.Async.execute(
                        "ALTER TABLE koja_carmarket ADD COLUMN zone_id VARCHAR(50) NOT NULL DEFAULT 'zone1'",
                        {},
                        function()
                            doSlotIdThenLoad()
                        end
                    )
                else
                    doSlotIdThenLoad()
                end
            end
        )
    end
)

function KOJA.Server.GiveVehicleToPlayer(targetSource, modelName, cb)
    local identifier = KOJA.Server.GetPlayerIdentifier(targetSource)
    if not identifier or not GetPlayerName(targetSource) then
        if cb then
            cb(false, nil)
        end
        return
    end
    local plate = tostring(math.random(4444, 9999)) .. "ABCD"
    local vehicleJson = json.encode({model = GetHashKey(modelName), plate = plate})
    local vtable = KOJA.Server.vehicleTable()
    if KOJA.Framework == "qb" then
        MySQL.Async.execute(
            "INSERT INTO player_vehicles (owner, plate, vehicle, state, garage, type, jobVehicle, jobGarage, tag, impound_data, favorite) VALUES (@owner, @plate, @vehicle, 1, 'OUT', 'vehicle', '', '', NULL, '', 0)",
            {
                ["@owner"] = identifier,
                ["@plate"] = plate,
                ["@vehicle"] = vehicleJson
            },
            function()
                if cb then
                    cb(true, plate)
                end
            end
        )
    else
        MySQL.Async.execute(
            "INSERT INTO " .. vtable .. " (owner, plate, vehicle, `stored`) VALUES (@owner, @plate, @vehicle, 1)",
            {
                ["@owner"] = identifier,
                ["@plate"] = plate,
                ["@vehicle"] = vehicleJson
            },
            function()
                if cb then
                    cb(true, plate)
                end
            end
        )
    end
end

RegisterCommand(
    "savecar",
    function(source, args, rawCommand)
        local ace = (Config.Commands and Config.Commands.AdminAce) or "group.admin"
        if source > 0 and not IsPlayerAceAllowed(source, ace) then
            return
        end
        if #args < 2 then
            print("^1[koja-carmarket]^7 Usage: savecar <model> <playerId>")
            return
        end
        local targetPlayerId = tonumber(args[2])
        if not targetPlayerId or not GetPlayerName(targetPlayerId) then
            print("^1[koja-carmarket]^7 Invalid player ID.")
            return
        end
        KOJA.Server.GiveVehicleToPlayer(
            targetPlayerId,
            args[1],
            function(ok, plate)
                if ok then
                    print(
                        "^2[koja-carmarket]^7 Granted vehicle " ..
                            args[1] ..
                                " to " ..
                                    GetPlayerName(targetPlayerId) .. " (ID: " .. targetPlayerId .. "), plate: " .. plate
                    )
                end
            end
        )
    end,
    false
)

local ITEMS_PER_PAGE = 8

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:getFilteredVehicles",
    function(source, data, cb)
        KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] getFilteredVehicles source=" .. tostring(source))
        KOJA.Shared.KojaCarmarketDebug(
            "[koja-carmarket] getFilteredVehicles payload=" ..
                json.encode(
                    {
                        page = data and data.page or 1,
                        carTypes = data and data.carTypes or {},
                        driveTypes = data and data.driveTypes or {},
                        fuelTypes = data and data.fuelTypes or {},
                        offerTypes = data and data.offerTypes or {},
                        priceRange = data and data.priceRange or nil,
                        distanceRange = data and data.distanceRange or nil
                    }
                )
        )
        local page = tonumber(data.page) or 1
        local offset = (page - 1) * ITEMS_PER_PAGE

        local conditions = {}
        local params = {}
        table.insert(conditions, "(offert_type <> 'auction' OR auction_ends_at IS NULL OR auction_ends_at > NOW())")

        if data.priceRange and data.priceRange[1] and data.priceRange[2] then
            table.insert(conditions, "price >= @priceMin AND price <= @priceMax")
            params["@priceMin"] = data.priceRange[1]
            params["@priceMax"] = data.priceRange[2]
        end

        if data.distanceRange and data.distanceRange[1] and data.distanceRange[2] then
            table.insert(conditions, "mileage >= @distMin AND mileage <= @distMax")
            params["@distMin"] = data.distanceRange[1]
            params["@distMax"] = data.distanceRange[2]
        end

        if data.carTypes and #data.carTypes > 0 then
            local placeholders = {}
            local expanded = {}
            local seen = {}
            local function add(v)
                if v == nil then return end
                local s = tostring(v)
                if s == "" or seen[s] then return end
                seen[s] = true
                expanded[#expanded + 1] = s
            end
            for _, ct in ipairs(data.carTypes) do
                local canonical = KOJA.Shared.normalizeVehicleCategorySlug(ct, nil)
                local k = tostring(canonical or ""):lower()
                add(canonical)
                if k == "suv" then
                    add("suvs")
                elseif k == "offroad" then
                    add("off-road")
                elseif k == "motorbike" then
                    add("motorcycle")
                end
            end
            for i, ct in ipairs(expanded) do
                local key = "@carType" .. i
                table.insert(placeholders, key)
                params[key] = ct
            end
            if #placeholders > 0 then
                table.insert(conditions, "car_type IN (" .. table.concat(placeholders, ",") .. ")")
            end
        end

        if data.driveTypes and #data.driveTypes > 0 then
            local placeholders = {}
            local expanded = {}
            local seen = {}
            local function add(v)
                if v == nil then return end
                local s = tostring(v)
                if s == "" or seen[s] then return end
                seen[s] = true
                expanded[#expanded + 1] = s
            end
            for _, dt in ipairs(data.driveTypes) do
                local k = tostring(dt or ""):lower():gsub("%s+", "_"):gsub("%-", "_")
                if k == "fwd" or k == "front_2x4" then
                    add("FWD")
                    add("front-2x4")
                    add("front_2x4")
                elseif k == "rwd" or k == "rear_2x4" then
                    add("RWD")
                    add("rear-2x4")
                    add("rear_2x4")
                elseif k == "awd" or k == "4x4" or k == "drive_4x4" then
                    add("AWD")
                    add("4x4")
                    add("drive_4x4")
                else
                    add(dt)
                end
            end
            for i, dt in ipairs(expanded) do
                local key = "@driveType" .. i
                table.insert(placeholders, key)
                params[key] = dt
            end
            table.insert(conditions, "drive_type IN (" .. table.concat(placeholders, ",") .. ")")
        end

        if data.fuelTypes and #data.fuelTypes > 0 then
            local placeholders = {}
            local normalizedFuel = {}
            local seenFuel = {}
            for _, ft in ipairs(data.fuelTypes) do
                local fuel = KOJA.Shared.wireFuelSlugGasOrElectric(ft)
                if not seenFuel[fuel] then
                    seenFuel[fuel] = true
                    normalizedFuel[#normalizedFuel + 1] = fuel
                end
            end
            for i, ft in ipairs(normalizedFuel) do
                local key = "@fuelType" .. i
                table.insert(placeholders, key)
                params[key] = ft
            end
            if #placeholders > 0 then
                table.insert(conditions, "fuel_type IN (" .. table.concat(placeholders, ",") .. ")")
            end
        end

        if data.offerTypes and #data.offerTypes > 0 then
            local placeholders = {}
            for i, ot in ipairs(data.offerTypes) do
                local key = "@offerType" .. i
                table.insert(placeholders, key)
                params[key] = ot
            end
            table.insert(conditions, "offert_type IN (" .. table.concat(placeholders, ",") .. ")")
        end

        local whereClause = ""
        if #conditions > 0 then
            whereClause = " WHERE " .. table.concat(conditions, " AND ")
        end
        KOJA.Shared.KojaCarmarketDebug("[koja-carmarket] getFilteredVehicles whereClause=" .. tostring(whereClause))

        local countQuery = "SELECT COUNT(*) as total FROM koja_carmarket_listings" .. whereClause
        local selectQuery =
            "SELECT * FROM koja_carmarket_listings" .. whereClause .. " ORDER BY id DESC LIMIT @limit OFFSET @offset"
        params["@limit"] = ITEMS_PER_PAGE
        params["@offset"] = offset

        MySQL.Async.fetchAll(
            countQuery,
            params,
            function(countResult)
                local total = countResult and countResult[1] and countResult[1].total or 0
                local totalPages = math.ceil(total / ITEMS_PER_PAGE)
                if totalPages < 1 then
                    totalPages = 1
                end

                MySQL.Async.fetchAll(
                    selectQuery,
                    params,
                    function(results)
                        if not results or #results == 0 then
                            cb({success = true, vehicles = {}, totalPages = totalPages})
                            return
                        end
                        local ids = {}
                        for _, r in ipairs(results) do
                            ids[#ids + 1] = r.id
                        end
                        local ph = {}
                        local pparams = {}
                        for i = 1, #ids do
                            ph[i] = "@aid" .. i
                            pparams["@aid" .. i] = ids[i]
                        end
                        MySQL.Async.fetchAll(
                            "SELECT id, (CASE WHEN offert_type = 'auction' AND auction_ends_at IS NOT NULL AND auction_ends_at < NOW() THEN 1 ELSE 0 END) AS auction_ended, (CASE WHEN offert_type = 'auction' AND auction_starts_at IS NOT NULL AND NOW() < auction_starts_at THEN 1 ELSE 0 END) AS auction_not_started, (SELECT COUNT(*) FROM koja_carmarket_offers o WHERE o.listing_id = koja_carmarket_listings.id) AS offer_count FROM koja_carmarket_listings WHERE id IN (" ..
                                table.concat(ph, ",") .. ")",
                            pparams,
                            function(statusRows)
                                local statusById = {}
                                if statusRows then
                                    for _, r in ipairs(statusRows) do
                                        statusById[r.id] = {
                                            ended = (r.auction_ended == 1),
                                            notStarted = (r.auction_not_started == 1),
                                            count = tonumber(r.offer_count) or 0
                                        }
                                    end
                                end
                                local ovConditions = {}
                                local ovParams = {}
                                for i, row in ipairs(results) do
                                    ovConditions[i] =
                                        "(owner = @ovOwner" ..
                                        i ..
                                            " AND REPLACE(TRIM(plate), ' ', '') = REPLACE(TRIM(@ovPlate" ..
                                                i .. "), ' ', ''))"
                                    ovParams["@ovOwner" .. i] = row.owner or ""
                                    ovParams["@ovPlate" .. i] = row.plate or ""
                                end
                                MySQL.Async.fetchAll(
                                    "SELECT owner, plate, mileage, vehicle FROM " ..
                                        KOJA.Server.vehicleTable() .. " WHERE " .. table.concat(ovConditions, " OR "),
                                    ovParams,
                                    function(ovRows)
                                        local mileageByKey = {}
                                        if ovRows then
                                            for _, r in ipairs(ovRows) do
                                                local k = KOJA.Server.ownerPlateNormKey(r.owner, r.plate)
                                                mileageByKey[k] = KOJA.Server.getMileageFromOwnedVehicleRow(r)
                                            end
                                        end
                                        local vehicles = {}
                                        for _, row in ipairs(results) do
                                            local okRow, errRow = pcall(function()
                                                local key = KOJA.Server.ownerPlateNormKey(row.owner, row.plate)
                                                local mileage = mileageByKey[key]
                                                if mileage == nil then
                                                    mileage = row.mileage
                                                end
                                                mileage = tonumber(mileage) or 0
                                                local tags = KOJA.Server.normalizeTags(row.tags)
                                                local vehicleData = {}
                                                if row.vehicle_data then
                                                    if type(row.vehicle_data) == "string" then
                                                        local okVd, decodedVd = pcall(json.decode, row.vehicle_data)
                                                        vehicleData = (okVd and type(decodedVd) == "table") and decodedVd or {}
                                                    else
                                                        vehicleData = type(row.vehicle_data) == "table" and row.vehicle_data or {}
                                                    end
                                                end
                                                local extra_info = KOJA.Shared.buildExtraInfoCoreRowsFromVdata(vehicleData)
                                                local respname =
                                                    (row.respname and tostring(row.respname):match("%S+")) and
                                                    tostring(row.respname) or
                                                    nil
                                                if
                                                    (not respname or string.lower(tostring(respname)) == "vehicle") and
                                                        row.vehicle_data
                                                 then
                                                    local vd =
                                                        type(row.vehicle_data) == "string" and (
                                                            (function()
                                                                local okTmp, decodedTmp = pcall(json.decode, row.vehicle_data)
                                                                return okTmp and decodedTmp or nil
                                                            end)()
                                                        ) or
                                                        row.vehicle_data
                                                    if type(vd) == "table" and (vd.model or vd.respname) then
                                                        respname = KOJA.Server.modelToRespname(vd)
                                                    end
                                                end
                                                local displayName =
                                                    (row.name and tostring(row.name):match("%S+") and tostring(row.name)) or
                                                    "Vehicle"
                                                local listStatus = "active"
                                                if (row.offert_type or "") == "auction" then
                                                    local st = statusById[row.id]
                                                    if st then
                                                        if st.ended then
                                                            listStatus = "ended"
                                                        elseif st.notStarted then
                                                            listStatus = "waiting"
                                                        else
                                                            listStatus = "started"
                                                        end
                                                    end
                                                end
                                                local listCat = KOJA.Shared.normalizeVehicleCategorySlug(row.car_type, vehicleData)
                                                local listDrive = KOJA.Shared.coalesceDriveType(listCat, row.drive_type)
                                                KOJA.Server.applyEnumSlugsToMarketTags(tags, listDrive, listCat)
                                                table.insert(
                                                    vehicles,
                                                    {
                                                        id = row.id,
                                                        name = displayName,
                                                        respname = respname or "vehicle",
                                                        owner = row.owner,
                                                        car_type = listCat,
                                                        drive_type = listDrive,
                                                        fuel_type = row.fuel_type or "gasoline",
                                                        offert_type = row.offert_type or "buy",
                                                        tags = tags,
                                                        price = row.price,
                                                        mileage = mileage,
                                                        information = {mileage = mileage},
                                                        status = listStatus,
                                                        extra_info = extra_info,
                                                        vehicle_data = vehicleData,
                                                        model = vehicleData.model
                                                    }
                                                )
                                            end)
                                            if not okRow then
                                                KOJA.Shared.KojaCarmarketDebug(
                                                    "^1[koja-carmarket]^7 getFilteredVehicles skipped row id=" ..
                                                        tostring(row and row.id or "?") .. " err=" .. tostring(errRow)
                                                )
                                                local fallbackVd = {}
                                                if type(row) == "table" and row.vehicle_data and type(row.vehicle_data) == "string" then
                                                    local okFallback, decodedFallback = pcall(json.decode, row.vehicle_data)
                                                    if okFallback and type(decodedFallback) == "table" then
                                                        fallbackVd = decodedFallback
                                                    end
                                                elseif type(row) == "table" and type(row.vehicle_data) == "table" then
                                                    fallbackVd = row.vehicle_data
                                                end
                                                local fallbackCat = KOJA.Shared.normalizeVehicleCategorySlug(row and row.car_type, fallbackVd)
                                                local fallbackDrive = KOJA.Shared.coalesceDriveType(fallbackCat, row and row.drive_type)
                                                local fallbackFuel = KOJA.Shared.wireFuelSlugGasOrElectric(row and row.fuel_type)
                                                local fallbackMileage = tonumber((row and row.mileage) or 0) or 0
                                                table.insert(
                                                    vehicles,
                                                    {
                                                        id = row and row.id or 0,
                                                        name = (row and row.name and tostring(row.name):match("%S+") and tostring(row.name)) or "Vehicle",
                                                        respname = (row and row.respname and tostring(row.respname):match("%S+") and tostring(row.respname)) or "vehicle",
                                                        owner = row and row.owner or "",
                                                        car_type = fallbackCat,
                                                        drive_type = fallbackDrive,
                                                        fuel_type = fallbackFuel,
                                                        offert_type = (row and row.offert_type) or "buy",
                                                        tags = {list = {}, tuning = {visual = {}, mechanical = {}, color = {}}},
                                                        price = tonumber((row and row.price) or 0) or 0,
                                                        mileage = fallbackMileage,
                                                        information = {mileage = fallbackMileage},
                                                        status = "active",
                                                        extra_info = {},
                                                        vehicle_data = fallbackVd,
                                                        model = fallbackVd and fallbackVd.model
                                                    }
                                                )
                                            end
                                        end
                                        KOJA.Shared.KojaCarmarketDebug(
                                            '[market][server] source=' ..
                                                tostring(source) ..
                                                    ' page=' ..
                                                        tostring(page) ..
                                                            ' totalPages=' ..
                                                                tostring(totalPages) .. ' count=' .. tostring(#vehicles)
                                        )
                                        for i, veh in ipairs(vehicles) do
                                            KOJA.Shared.KojaCarmarketDebug(
                                                '[market][server][' ..
                                                    tostring(i) ..
                                                    '] id=' ..
                                                    tostring(veh.id) ..
                                                    ' plate=' ..
                                                    tostring(veh.plate) ..
                                                    ' cat=' ..
                                                    tostring(veh.car_type) ..
                                                    ' drive=' ..
                                                    tostring(veh.drive_type) ..
                                                    ' fuel=' ..
                                                    tostring(veh.fuel_type) ..
                                                    ' price=' ..
                                                    tostring(veh.price)
                                            )
                                        end
                                        cb({success = true, vehicles = vehicles, totalPages = totalPages})
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
    "koja_carmarket:server:getVehicleViewData",
    function(source, data, cb)
        local vehicleId = tonumber(data.vehicleId)
        if not vehicleId then
            cb({success = false})
            return
        end
        local currentPlayerIdentifier = KOJA.Server.GetPlayerIdentifier(source)
        MySQL.Async.fetchAll(
            "SELECT *, DATE_FORMAT(COALESCE(created_at, NOW()), '%Y-%m-%d %H:%i') AS listedAt, (CASE WHEN offert_type = 'auction' AND auction_ends_at IS NOT NULL AND auction_ends_at < NOW() THEN 1 ELSE 0 END) as auction_ended, (CASE WHEN offert_type = 'auction' AND auction_starts_at IS NOT NULL AND NOW() < auction_starts_at THEN 1 ELSE 0 END) as auction_not_started FROM koja_carmarket_listings WHERE id = @id LIMIT 1",
            {["@id"] = vehicleId},
            function(rows)
                if not rows or #rows == 0 then
                    cb({success = false})
                    return
                end
                local row = rows[1]
                MySQL.Async.fetchAll(
                    "SELECT mileage, vehicle FROM " ..
                        KOJA.Server.vehicleTable() ..
                            " WHERE owner = @owner AND REPLACE(TRIM(plate), ' ', '') = REPLACE(TRIM(@plate), ' ', '') LIMIT 1",
                    {["@owner"] = row.owner or "", ["@plate"] = row.plate or ""},
                    function(ovRows)
                        local view = KOJA.Server.rowToVehicleView(row)
                        if ovRows and ovRows[1] then
                            local m = KOJA.Server.getMileageFromOwnedVehicleRow(ovRows[1])
                            if m ~= nil then
                                view.vehicle.information.mileage = tonumber(m) or 0
                            end
                            local ovV = ovRows[1].vehicle
                            if ovV then
                                local ovVeh = KOJA.Shared.decodeJsonStringOrTable(ovV)
                                if type(ovVeh) == "table" then
                                    local merged = {}
                                    local vd = view.vehicle.vehicle_data or {}
                                    for k, v in pairs(vd) do
                                        merged[k] = v
                                    end
                                    for k, v in pairs(ovVeh) do
                                        merged[k] = v
                                    end
                                    view.vehicle.vehicle_data = merged
                                end
                            end
                        end
                        view.success = true
                        view.currentPlayerIdentifier = currentPlayerIdentifier
                        if view.auction and row.auction_ends_at then
                            view.auction.endsAt = tostring(row.auction_ends_at):sub(1, 19):gsub("T", " ")
                        end
                        if view.auction then
                            view.auction.ended = (row.auction_ended == 1)
                        end
                        local function doHistory()
                            MySQL.Async.fetchAll(
                                "SELECT id, type, price, seller_identifier, seller_name, buyer_identifier, buyer_name, created_at, vehicle_info FROM koja_carmarket_history WHERE listing_id = @id ORDER BY created_at DESC",
                                {["@id"] = vehicleId},
                                function(histRows)
                                    view.history = {}
                                    if histRows then
                                        for _, h in ipairs(histRows) do
                                            local dateStr = ""
                                            if h.created_at then
                                                if type(h.created_at) == "number" then
                                                    dateStr = os.date("%Y-%m-%d", h.created_at)
                                                else
                                                    dateStr = tostring(h.created_at):sub(1, 10)
                                                end
                                            end
                                            local vinfo = h.vehicle_info
                                            if type(vinfo) == "string" then
                                                vinfo = json.decode(vinfo)
                                            end
                                            view.history[#view.history + 1] = {
                                                id = h.id,
                                                type = h.type or "listing",
                                                date = dateStr,
                                                price = tonumber(h.price) or 0,
                                                seller = (h.seller_name and h.seller_name ~= "") and h.seller_name or
                                                    nil,
                                                buyer = (h.buyer_name and h.buyer_name ~= "") and h.buyer_name or nil,
                                                vehicle_info = vinfo
                                            }
                                        end
                                    end
                                    cb(view)
                                end
                            )
                        end
                        if view.auction then
                            MySQL.Async.fetchAll(
                                "SELECT id, buyer_identifier, buyer_name, amount, created_at, UNIX_TIMESTAMP(created_at) AS created_ts, DATE_FORMAT(COALESCE(created_at, NOW()), '%Y-%m-%d %H:%i') AS bid_date FROM koja_carmarket_offers WHERE listing_id = @id ORDER BY amount DESC",
                                {["@id"] = vehicleId},
                                function(offRows)
                                    view.auction.bids = {}
                                    if offRows and #offRows > 0 then
                                        view.auction.highestBid = tonumber(offRows[1].amount) or view.auction.highestBid
                                        view.auction.highestBidder = {
                                            id = "",
                                            identifier = offRows[1].buyer_identifier or "",
                                            name = offRows[1].buyer_name or ""
                                        }
                                        view.auction.isYouHighest =
                                            (currentPlayerIdentifier and
                                            offRows[1].buyer_identifier == currentPlayerIdentifier)
                                        for _, o in ipairs(offRows) do
                                            local bd = o.bid_date or o.Bid_date or o.BID_DATE
                                            local odate =
                                                (bd and tostring(bd):match("%S")) and
                                                tostring(bd):gsub("^%s+", ""):gsub("%s+$", "") or
                                                ""
                                            if odate == "" then
                                                local ts =
                                                    o.created_ts or o.Created_ts or o.CREATED_TS or o.created_ts_ts
                                                if
                                                    ts ~= nil and
                                                        (type(ts) == "number" or
                                                            (type(ts) == "string" and ts:match("^%d+$")))
                                                 then
                                                    local n = tonumber(ts)
                                                    if n and n > 0 then
                                                        odate = os.date("%Y-%m-%d %H:%M", n) or ""
                                                    end
                                                end
                                                if odate == "" then
                                                    local raw = o.created_at or o.Created_At or o.createdAt
                                                    if raw ~= nil then
                                                        local t = raw
                                                        if type(t) == "number" then
                                                            odate = os.date("%Y-%m-%d %H:%M", t) or ""
                                                        elseif
                                                            type(t) == "table" and (t.year or t.Year) and
                                                                (t.month or t.Month) and
                                                                (t.day or t.Day)
                                                         then
                                                            local y, mo, d =
                                                                tonumber(t.year or t.Year) or 0,
                                                                tonumber(t.month or t.Month) or 0,
                                                                tonumber(t.day or t.Day) or 0
                                                            local h, mi =
                                                                tonumber(t.hour or t.Hour) or 0,
                                                                tonumber(t.min or t.minute or t.Minute) or 0
                                                            odate =
                                                                string.format(
                                                                "%04d-%02d-%02d %02d:%02d",
                                                                y,
                                                                mo,
                                                                d,
                                                                h,
                                                                mi
                                                            )
                                                        else
                                                            local s = tostring(t)
                                                            if s:match("^%d+$") then
                                                                local n = tonumber(s)
                                                                if n then
                                                                    odate = os.date("%Y-%m-%d %H:%M", n) or ""
                                                                end
                                                            else
                                                                odate =
                                                                    s:sub(1, 19):gsub("T", " "):gsub("^%s+", ""):gsub(
                                                                    "%s+$",
                                                                    ""
                                                                )
                                                            end
                                                        end
                                                    end
                                                end
                                                if odate == "" and type(o) == "table" then
                                                    for k, v in pairs(o) do
                                                        if type(v) == "string" and v:match("%d%d%d%d%-%d%d") then
                                                            odate =
                                                                v:sub(1, 19):gsub("T", " "):gsub("^%s+", ""):gsub(
                                                                "%s+$",
                                                                ""
                                                            )
                                                            break
                                                        elseif type(v) == "number" and v > 0 and v < 5000000000 then
                                                            odate = os.date("%Y-%m-%d %H:%M", v) or ""
                                                            break
                                                        end
                                                    end
                                                end
                                            end
                                            view.auction.bids[#view.auction.bids + 1] = {
                                                id = o.id,
                                                amount = tonumber(o.amount) or 0,
                                                buyer = o.buyer_name or "",
                                                date = odate,
                                                isYou = (currentPlayerIdentifier and
                                                    o.buyer_identifier == currentPlayerIdentifier)
                                            }
                                        end
                                    end
                                    if view.auction.ended then
                                        view.auction.status = "ended"
                                    elseif row.auction_not_started == 1 then
                                        view.auction.status = "waiting"
                                    else
                                        view.auction.status = "started"
                                    end
                                    view.vehicle.status = view.auction.status
                                    doHistory()
                                end
                            )
                        else
                            doHistory()
                        end
                    end
                )
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:getMyOffers",
    function(source, data, cb)
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false})
            return
        end
        KOJA.Server.processDueListingFees(
            identifier,
            function()
                MySQL.Async.fetchAll(
                    "SELECT l.*, (CASE WHEN l.offert_type = 'auction' AND l.auction_ends_at IS NOT NULL AND l.auction_ends_at < NOW() THEN 1 ELSE 0 END) AS auction_ended, (CASE WHEN l.offert_type = 'auction' AND l.auction_starts_at IS NOT NULL AND NOW() < l.auction_starts_at THEN 1 ELSE 0 END) AS auction_not_started, (SELECT COUNT(*) FROM koja_carmarket_offers o WHERE o.listing_id = l.id) AS offer_count FROM koja_carmarket_listings l WHERE l.owner = @owner ORDER BY l.id DESC",
                    {["@owner"] = identifier},
                    function(rows)
                        if not rows or #rows == 0 then
                            cb({success = true, vehicles = {}, totalPages = 1})
                            return
                        end
                        local ovConds = {}
                        local ovPar = {["@owner"] = identifier}
                        for i, row in ipairs(rows) do
                            ovConds[i] = "REPLACE(TRIM(plate), ' ', '') = REPLACE(TRIM(@plate" .. i .. "), ' ', '')"
                            ovPar["@plate" .. i] = row.plate or ""
                        end
                        MySQL.Async.fetchAll(
                            "SELECT owner, plate, mileage, vehicle FROM " ..
                                KOJA.Server.vehicleTable() .. " WHERE owner = @owner AND (" .. table.concat(ovConds, " OR ") .. ")",
                            ovPar,
                            function(ovRows)
                                local mileageByPlateNorm = {}
                                if ovRows then
                                    for _, r in ipairs(ovRows) do
                                        local pn = KOJA.Server.plateNormalized(r.plate) or ""
                                        mileageByPlateNorm[pn] = KOJA.Server.getMileageFromOwnedVehicleRow(r)
                                    end
                                end
                                local vehicles = {}
                                for _, row in ipairs(rows) do
                                    local plateNorm = KOJA.Server.plateNormalized(row.plate) or ""
                                    local mileage = mileageByPlateNorm[plateNorm]
                                    if mileage == nil then
                                        mileage = row.mileage
                                    end
                                    mileage = tonumber(mileage) or 0
                                    local tags = KOJA.Server.normalizeTags(row.tags)
                                    local listedAt = ""
                                    if row.created_at then
                                        if type(row.created_at) == "number" then
                                            listedAt = os.date("%Y-%m-%d %H:%M", row.created_at)
                                        else
                                            listedAt = tostring(row.created_at):sub(1, 16):gsub("T", " ")
                                        end
                                    end
                                    local respname =
                                        (row.respname and tostring(row.respname):match("%S+")) and
                                        tostring(row.respname) or
                                        nil
                                    if not respname and row.vehicle_data then
                                        local vd =
                                            type(row.vehicle_data) == "string" and json.decode(row.vehicle_data) or
                                            row.vehicle_data
                                        if type(vd) == "table" and (vd.model or vd.respname) then
                                            respname = KOJA.Server.modelToRespname(vd)
                                        end
                                    end
                                    local displayName =
                                        (row.name and tostring(row.name):match("%S+") and tostring(row.name)) or "Vehicle"
                                    local myStatus = "active"
                                    if (row.offert_type or "") == "auction" then
                                        if row.auction_ended == 1 then
                                            myStatus = "ended"
                                        elseif row.auction_not_started == 1 then
                                            myStatus = "waiting"
                                        else
                                            myStatus = "started"
                                        end
                                    end
                                    local myOfferVd = {}
                                    if row.vehicle_data then
                                        myOfferVd =
                                            (type(row.vehicle_data) == "string" and json.decode(row.vehicle_data)) or
                                            row.vehicle_data or
                                            {}
                                    end
                                    local myOfferCat = KOJA.Shared.normalizeVehicleCategorySlug(row.car_type, myOfferVd)
                                    local myOfferDrive = KOJA.Shared.coalesceDriveType(myOfferCat, row.drive_type)
                                    local myOfferFuel = KOJA.Shared.wireFuelSlugGasOrElectric(row.fuel_type or myOfferVd.fuel_type)
                                    KOJA.Server.applyEnumSlugsToMarketTags(tags, myOfferDrive, myOfferCat)
                                    table.insert(
                                        vehicles,
                                        {
                                            id = row.id,
                                            name = displayName,
                                            respname = respname or "vehicle",
                                            owner = row.owner,
                                            car_type = myOfferCat,
                                            drive_type = myOfferDrive,
                                            fuel_type = myOfferFuel,
                                            offert_type = row.offert_type or "buy",
                                            tags = tags,
                                            price = row.price,
                                            mileage = mileage,
                                            information = {mileage = mileage},
                                            listedAt = listedAt,
                                            status = myStatus
                                        }
                                    )
                                end
                                cb({success = true, vehicles = vehicles, totalPages = 1})
                            end
                        )
                    end
                )
            end
        )
    end
)

KOJA.Shared.KojaCarmarketDebug("^3[koja-carmarket]^7 server.lua loaded")

local function resolveOwnedVehicleIdFromRow(row)
    if type(row) ~= "table" then
        return nil
    end
    local id = tonumber(row.id) or tonumber(row.vehicle_id) or tonumber(row.owned_vehicle_id)
    if id and id > 0 then
        return id
    end
    return nil
end

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:createOffer",
    function(source, data, cb)
        if not KOJA.Server.rateLimit(source, "createOffer", 2000) then
            cb({success = false, reason = "rate_limited"})
            return
        end
        KOJA.Shared.KojaCarmarketDebug(
            "^3[koja-carmarket]^7 createOffer source=" ..
                tostring(source) .. " plate=" .. tostring(data.plate) .. " vehicleId=" .. tostring(data.vehicleId)
        )
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            KOJA.Shared.KojaCarmarketDebug("^1[koja-carmarket]^7 createOffer: no player")
            cb({success = false})
            return
        end
        if KOJA.Server.clampPrice(data.price) == nil then
            cb({success = false, reason = "bad_price"})
            return
        end
        local plate = KOJA.Server.plateNormalized(data.plate)
        local vehicleId = KOJA.Server.sanitizeId(data.vehicleId)
        if not plate or plate == "" then
            if not vehicleId then
                cb({success = false})
                return
            end
        end
        local function doInsert(row)
            MySQL.Async.fetchAll(
                "SELECT 1 FROM koja_carmarket_listings WHERE owner = @owner AND (plate = @plate OR (@ovid IS NOT NULL AND owned_vehicle_id = @ovid)) LIMIT 1",
                {
                    ["@owner"] = identifier,
                    ["@plate"] = row.plate or "",
                    ["@ovid"] = resolveOwnedVehicleIdFromRow(row)
                },
                function(existing)
                    if existing and #existing > 0 then
                        cb({success = false})
                        return
                    end
                    local v = row.vehicle and json.decode(row.vehicle) or {}
                    local explicitName = (data.name and tostring(data.name):match("%S+") and tostring(data.name):sub(1, 100)) or nil
                    local respname = KOJA.Server.resolveRespnameForStore(data.respname, v)
                    local name =
                        (explicitName and not KOJA.Shared.isGenericVehicleName(explicitName) and explicitName) or
                        ((respname and respname ~= "vehicle") and respname) or
                        ("Vehicle " .. (row.plate or ""))
                    local price = KOJA.Server.clampPrice(data.price) or 0
                    if price < 1 then
                        cb({success = false, reason = "bad_price"})
                        return
                    end
                    local tags = json.encode(KOJA.Server.sanitizeTags(data.tags))
                    local offertType = (data.offerType == "auction") and "auction" or "buy"
                    local offerCat = KOJA.Shared.normalizeVehicleCategorySlug(data.car_type or v.car_type, v)
                    if not KOJA.Shared.isMarketAllowedCategorySlug(offerCat) then
                        cb({success = false, reason = "invalid_vehicle_type"})
                        return
                    end
                    local driveType = KOJA.Shared.coalesceDriveType(offerCat, data.drive_type or v.drive_type)
                    local fuelType = KOJA.Shared.wireFuelSlugGasOrElectric(data.fuel_type or v.fuel_type)
                    local mileage = tonumber(data.mileage or v.mileage or row.mileage) or 0
                    v.respname = respname
                    v.car_type = offerCat
                    v.drive_type = driveType
                    v.fuel_type = fuelType
                    v.mileage = mileage
                    local vehicleDataJson = json.encode(v)
                    local ovId = resolveOwnedVehicleIdFromRow(row)
                    local sellerName = KOJA.Server.GetPlayerName(source) or ""
                    local auctionStartsAt = nil
                    local auctionEndsAt = nil
                    local startRaw = data.auctionStart or data.auction_start
                    if offertType == "auction" and startRaw and tostring(startRaw):match("%S") then
                        local s = tostring(startRaw):gsub("T", " "):sub(1, 19)
                        if #s >= 16 then
                            auctionStartsAt = s:match("%d%d:%d%d:%d%d$") and s or (s .. ":00")
                        end
                    end
                    local endRaw = data.auctionEnd or data.auction_end
                    if offertType == "auction" and endRaw and tostring(endRaw):match("%S") then
                        local s = tostring(endRaw):gsub("T", " "):sub(1, 19)
                        if #s >= 16 then
                            auctionEndsAt = s:match("%d%d:%d%d:%d%d$") and s or (s .. ":00")
                        end
                    end
                    MySQL.Async.execute(
                        "INSERT INTO koja_carmarket_listings (name, respname, owner, car_type, drive_type, fuel_type, offert_type, tags, price, mileage, description, plate, vehicle_data, owned_vehicle_id, seller_name, auction_starts_at, auction_ends_at) VALUES (@name, @respname, @owner, @ct, @dt, @ft, @ot, @tags, @price, @mileage, @desc, @plate, @vdata, @ovid, @sellerName, @astarts, @aends)",
                        {
                            ["@name"] = name,
                            ["@respname"] = respname,
                            ["@owner"] = identifier,
                            ["@ct"] = offerCat,
                            ["@dt"] = driveType,
                            ["@ft"] = fuelType,
                            ["@ot"] = offertType,
                            ["@tags"] = tags,
                            ["@price"] = price,
                            ["@mileage"] = mileage,
                            ["@desc"] = tostring(data.description or ""):sub(1, 500),
                            ["@plate"] = row.plate or "",
                            ["@vdata"] = vehicleDataJson,
                            ["@ovid"] = ovId,
                            ["@sellerName"] = sellerName,
                            ["@astarts"] = auctionStartsAt,
                            ["@aends"] = auctionEndsAt
                        },
                        function()
                            MySQL.Async.fetchAll(
                                "SELECT LAST_INSERT_ID() as id",
                                {},
                                function(res)
                                    if res and res[1] then
                                        local lid = res[1].id
                                        local listingVehicleInfo =
                                            json.encode(
                                            {
                                                vehicleName = (name and tostring(name):match("%S+") and tostring(name)) or
                                                    "Vehicle",
                                                respname = respname or "vehicle",
                                                plate = row.plate or "",
                                                mileage = mileage,
                                                fuel_type = fuelType,
                                                drive_type = driveType,
                                                car_type = offerCat
                                            }
                                        )
                                        MySQL.Async.execute(
                                            "INSERT INTO koja_carmarket_history (listing_id, type, price, seller_identifier, seller_name, vehicle_info) VALUES (@lid, 'listing', @price, @owner, @sellerName, @vinfo)",
                                            {
                                                ["@lid"] = lid,
                                                ["@price"] = price,
                                                ["@owner"] = identifier,
                                                ["@sellerName"] = sellerName,
                                                ["@vinfo"] = listingVehicleInfo
                                            },
                                            function()
                                                if lid then
                                                    TriggerClientEvent("koja_carmarket:client:auctionUpdated", -1, {listingId = lid, event = "started"})
                                                end
                                                cb({success = true})
                                            end
                                        )
                                    else
                                        cb({success = true})
                                    end
                                end
                            )
                        end
                    )
                end
            )
        end
        if vehicleId and vehicleId > 0 then
            MySQL.Async.fetchAll(
                "SELECT * FROM " .. KOJA.Server.vehicleTable() .. " WHERE id = @id AND owner = @owner LIMIT 1",
                {["@id"] = vehicleId, ["@owner"] = identifier},
                function(rows)
                    if not rows or #rows == 0 then
                        KOJA.Shared.KojaCarmarketDebug("^3[koja-carmarket]^7 createOffer: vehicle not found by id, trying owner+plate fallback")
                        if plate and plate ~= "" then
                            MySQL.Async.fetchAll(
                                "SELECT * FROM " ..
                                    KOJA.Server.vehicleTable() .. " WHERE owner = @owner AND REPLACE(TRIM(plate), ' ', '') = @plateNorm LIMIT 1",
                                {["@owner"] = identifier, ["@plateNorm"] = plate},
                                function(fallbackRows)
                                    if not fallbackRows or #fallbackRows == 0 then
                                        KOJA.Shared.KojaCarmarketDebug(
                                            "^1[koja-carmarket]^7 createOffer: vehicle not found (id and owner+plate) vehicleId=" ..
                                                tostring(vehicleId) .. " plate=" .. tostring(plate)
                                        )
                                        cb({success = false})
                                        return
                                    end
                                    doInsert(fallbackRows[1])
                                end
                            )
                            return
                        end
                        KOJA.Shared.KojaCarmarketDebug(
                            "^1[koja-carmarket]^7 createOffer: vehicle not found (id) vehicleId=" .. tostring(vehicleId)
                        )
                        cb({success = false})
                        return
                    end
                    doInsert(rows[1])
                end
            )
        elseif plate and plate ~= "" then
            MySQL.Async.fetchAll(
                "SELECT * FROM " ..
                    KOJA.Server.vehicleTable() .. " WHERE owner = @owner AND REPLACE(TRIM(plate), ' ', '') = @plateNorm LIMIT 1",
                {["@owner"] = identifier, ["@plateNorm"] = plate},
                function(rows)
                    if not rows or #rows == 0 then
                        KOJA.Shared.KojaCarmarketDebug(
                            "^1[koja-carmarket]^7 createOffer: vehicle not found (owner+plate) plate=" ..
                                tostring(plate)
                        )
                        cb({success = false})
                        return
                    end
                    doInsert(rows[1])
                end
            )
        else
            cb({success = false})
        end
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:buyVehicle",
    function(source, data, cb)
        if not KOJA.Server.rateLimit(source, "buyVehicle", 1500) then
            cb({success = false, reason = "rate_limited"})
            return
        end
        local buyer = KOJA.Server.GetPlayerBySource(source)
        if not buyer then
            KOJA.Shared.KojaCarmarketDebug("^1[koja-carmarket]^7 buyVehicle: no buyer")
            cb({success = false, reason = "no_buyer"})
            return
        end
        local buyerIdentifier = KOJA.Server.GetPlayerIdentifier(source)
        if not buyerIdentifier then
            KOJA.Shared.KojaCarmarketDebug("^1[koja-carmarket]^7 buyVehicle: no buyer identifier")
            cb({success = false, reason = "no_buyer_identifier"})
            return
        end
        local listingId = KOJA.Server.sanitizeId(data.listingId)
        if not listingId then
            KOJA.Shared.KojaCarmarketDebug("^1[koja-carmarket]^7 buyVehicle: no listing id")
            cb({success = false, reason = "no_listing_id"})
            return
        end
        local bank = KOJA.Server.getMoney and KOJA.Server.getMoney(source, "bank") or 0
        MySQL.Async.fetchAll(
            "SELECT * FROM koja_carmarket_listings WHERE id = @id LIMIT 1",
            {["@id"] = listingId},
            function(rows)
                if not rows or #rows == 0 then
                    KOJA.Shared.KojaCarmarketDebug("^1[koja-carmarket]^7 buyVehicle: no rows")
                    cb({success = false, reason = "no_rows"})
                    return
                end
                local row = rows[1]
                if row.owner == buyerIdentifier then
                    KOJA.Shared.KojaCarmarketDebug("^1[koja-carmarket]^7 buyVehicle: seller is the buyer")
                    cb({success = false, reason = "seller_is_the_buyer"})
                    return
                end
                local zoneId = row.zone_id or nil
                local doFinalizePurchase
                local function doCompletePurchase(priceVal)
                    local price = tonumber(priceVal) or 0
                    if price < 1 or bank < price then
                        cb({success = false, reason = "not_enough_money"})
                        return
                    end
                    local sellerId = row.owner and tostring(row.owner):match("%S+") or nil
                    local plateNorm = KOJA.Server.plateNormalized(row.plate)
                    if not sellerId or not plateNorm or plateNorm == "" then
                        cb({success = false, reason = "no_seller_id_or_plate"})
                        return
                    end
                    local vtable = KOJA.Server.vehicleTable()
                    MySQL.Async.execute(
                        "UPDATE " ..
                            vtable ..
                                " SET `owner` = @newOwner WHERE `owner` = @seller AND REPLACE(TRIM(`plate`), ' ', '') = @plateNorm",
                        {["@newOwner"] = buyerIdentifier, ["@seller"] = sellerId, ["@plateNorm"] = plateNorm},
                        function(affected)
                            if (tonumber(affected) or 0) == 0 then
                                cb({success = false, reason = "vehicle_transfer_failed"})
                                return
                            end
                            if not KOJA.Server.removeMoney or not KOJA.Server.removeMoney(source, price, "bank", "car_purchase") then
                                MySQL.Async.execute(
                                    "UPDATE " ..
                                        vtable ..
                                            " SET `owner` = @seller WHERE `owner` = @newOwner AND REPLACE(TRIM(`plate`), ' ', '') = @plateNorm",
                                    {["@seller"] = sellerId, ["@newOwner"] = buyerIdentifier, ["@plateNorm"] = plateNorm},
                                    function() end
                                )
                                cb({success = false, reason = "remove_money_failed"})
                                return
                            end
                            doFinalizePurchase(sellerId, plateNorm, price)
                        end
                    )
                end
                doFinalizePurchase = function(sellerId, plateNorm, price)
                    local soldPlate = row.plate and tostring(row.plate):sub(1, 8) or nil
                    local zid = (zoneId and tostring(zoneId):match("%S+")) or nil
                    if zid and zid ~= "" then
                        MySQL.Async.fetchAll(
                            "SELECT commission_percent, owner_identifier FROM koja_carmarket_exchange WHERE zone_id = @zid LIMIT 1",
                            {["@zid"] = zid},
                            function(exRows)
                                local commPct = (Config.Exchange and Config.Exchange.DefaultCommissionPercent) or 5
                                local zoneOwner = nil
                                if exRows and #exRows > 0 then
                                    commPct = tonumber(exRows[1].commission_percent) or commPct
                                    local oi = exRows[1].owner_identifier
                                    if oi and oi ~= "" then
                                        zoneOwner = oi
                                    end
                                end
                                local commission = math.floor(price * commPct / 100)
                                local sellerAmount = price - commission
                                KOJA.Server.paySellerByIdentifier(row.owner, sellerAmount, "car_sale")
                                if zoneOwner and commission > 0 then
                                    KOJA.Server.addMoneyByIdentifier(zoneOwner, commission, "zone_sale_commission")
                                end
                            end
                        )
                    else
                        KOJA.Server.paySellerByIdentifier(row.owner, price, "car_sale")
                    end
                    local buyerName = KOJA.Server.GetPlayerName(source) or ""
                    local rowVd =
                        row.vehicle_data and
                        (type(row.vehicle_data) == "string" and json.decode(row.vehicle_data) or row.vehicle_data) or
                        nil
                    if type(rowVd) ~= "table" then rowVd = {} end
                    local histCat = KOJA.Shared.normalizeVehicleCategorySlug(rowVd.car_type or row.car_type, rowVd)
                    local histDrive = KOJA.Shared.coalesceDriveType(histCat, rowVd.drive_type or row.drive_type)
                    local histFuel = KOJA.Shared.wireFuelSlugGasOrElectric(rowVd.fuel_type or row.fuel_type)
                    local vehicleInfoJson = json.encode({
                        vehicleName = (row.name and tostring(row.name):match("%S+") and tostring(row.name)) or "Vehicle",
                        respname = row.respname or "vehicle",
                        plate = row.plate or "",
                        mileage = tonumber(rowVd.mileage or row.mileage) or 0,
                        fuel_type = histFuel,
                        drive_type = histDrive,
                        car_type = histCat,
                        model = rowVd.model,
                    })
                    MySQL.Async.execute(
                        "INSERT INTO koja_carmarket_history (listing_id, type, price, seller_identifier, seller_name, buyer_identifier, buyer_name, vehicle_info) VALUES (@lid, 'purchase', @price, @sellerId, @sellerName, @buyerId, @buyerName, @vinfo)",
                        {
                            ["@lid"] = listingId,
                            ["@price"] = price,
                            ["@sellerId"] = row.owner or "",
                            ["@sellerName"] = (row.seller_name and row.seller_name ~= "") and row.seller_name or row.owner or "",
                            ["@buyerId"] = buyerIdentifier or "",
                            ["@buyerName"] = buyerName,
                            ["@vinfo"] = vehicleInfoJson,
                        },
                        function() end
                    )
                    local function deleteListingThenDone()
                        MySQL.Async.execute(
                            "DELETE FROM koja_carmarket_listings WHERE id = @id",
                            {["@id"] = listingId},
                            function()
                                TriggerClientEvent("koja_carmarket:client:auctionUpdated", -1, {listingId = listingId, event = "ended"})
                                if soldPlate then
                                    TriggerClientEvent("koja_carmarket:client:vehicleSold", -1, soldPlate)
                                end
                                cb({success = true, reason = "vehicle_sold"})
                            end
                        )
                    end
                    if zid then
                        MySQL.Async.execute(
                            "DELETE FROM koja_carmarket WHERE zone_id = @zid AND owner = @oid AND TRIM(plate) = @plate",
                            {["@zid"] = zid, ["@oid"] = sellerId, ["@plate"] = row.plate or plateNorm},
                            function()
                                if KOJA.Server.CarsInZone and KOJA.Server.CarsInZone[zid] then
                                    for p, _ in pairs(KOJA.Server.CarsInZone[zid] or {}) do
                                        if p and (p:gsub("^%s+", ""):gsub("%s+$", "")) == plateNorm then
                                            KOJA.Server.CarsInZone[zid][p] = nil
                                            break
                                        end
                                    end
                                end
                                deleteListingThenDone()
                            end
                        )
                    else
                        deleteListingThenDone()
                    end
                end
                if (row.offert_type or "buy") == "auction" then
                    if not row.auction_ends_at then
                        cb({success = false, reason = "auction_not_ended"})
                        return
                    end
                    MySQL.Async.fetchAll(
                        "SELECT NOW() as now_ts",
                        {},
                        function(nowRows)
                            if not nowRows or not nowRows[1] then
                                cb({success = false, reason = "auction_not_ended"})
                                return
                            end
                            if tostring(row.auction_ends_at) > tostring(nowRows[1].now_ts) then
                                cb({success = false, reason = "auction_not_ended"})
                                return
                            end
                            MySQL.Async.fetchAll(
                                "SELECT buyer_identifier, amount FROM koja_carmarket_offers WHERE listing_id = @id ORDER BY amount DESC LIMIT 1",
                                {["@id"] = listingId},
                                function(winRows)
                                    if not winRows or not winRows[1] then
                                        cb({success = false, reason = "no_winner"})
                                        return
                                    end
                                    if winRows[1].buyer_identifier ~= buyerIdentifier then
                                        cb({success = false, reason = "not_auction_winner"})
                                        return
                                    end
                                    doCompletePurchase(winRows[1].amount)
                                end
                            )
                        end
                    )
                    return
                end
                if (row.offert_type or "buy") ~= "buy" then
                    cb({success = false, reason = "not_a_buy_offer"})
                    return
                end
                doCompletePurchase(row.price)
            end
        )
    end
)

