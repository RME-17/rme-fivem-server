
KOJA.Server._rateBuckets = KOJA.Server._rateBuckets or {}
KOJA.Server.rateLimit = function(source, action, cooldownMs)
    cooldownMs = cooldownMs or 500
    local key = tostring(source or 0) .. ':' .. tostring(action or '?')
    local now = GetGameTimer()
    local last = KOJA.Server._rateBuckets[key] or 0
    if now - last < cooldownMs then
        return false
    end
    KOJA.Server._rateBuckets[key] = now
    return true
end
AddEventHandler('playerDropped', function()
    local src = source
    if not src then return end
    local prefix = tostring(src) .. ':'
    for k, _ in pairs(KOJA.Server._rateBuckets) do
        if k:sub(1, #prefix) == prefix then
            KOJA.Server._rateBuckets[k] = nil
        end
    end
end)

KOJA.Server.MAX_PRICE = 100000000
KOJA.Server.MAX_BID = 100000000
KOJA.Server.MAX_INT_ID = 2147483647

KOJA.Server.sanitizeId = function(v)
    local n = tonumber(v)
    if not n then return nil end
    if n < 1 or n > KOJA.Server.MAX_INT_ID then return nil end
    if n ~= math.floor(n) then return nil end
    return n
end

KOJA.Server.clampPrice = function(v)
    local n = tonumber(v)
    if not n then return nil end
    n = math.floor(n)
    if n < 1 or n > KOJA.Server.MAX_PRICE then return nil end
    return n
end

KOJA.Server.clampBid = function(v)
    local n = tonumber(v)
    if not n then return nil end
    n = math.floor(n)
    if n < 1 or n > KOJA.Server.MAX_BID then return nil end
    return n
end

KOJA.Server.sanitizeTags = function(raw)
    if type(raw) ~= 'table' then return {} end
    local MAX_TAGS = 10
    local MAX_TAG_LEN = 30
    local out = {}
    for i = 1, math.min(#raw, MAX_TAGS) do
        local t = raw[i]
        if type(t) == 'string' then
            local trimmed = t:gsub('^%s+', ''):gsub('%s+$', ''):sub(1, MAX_TAG_LEN)
            if trimmed ~= '' then out[#out + 1] = trimmed end
        end
    end
    return out
end

KOJA.Server.sanitizeHeading = function(v)
    local n = tonumber(v)
    if not n then return 0.0 end
    n = n % 360
    if n < 0 then n = n + 360 end
    return n
end

KOJA.Server.computeMinBidIncrement = function(currentMax)
    local n = tonumber(currentMax) or 0
    local pct = math.floor(n * 0.01)
    if pct < 100 then return 100 end
    return pct
end

KOJA.Server.modelHashToDisplayName = function(hash)
    return nil
end

KOJA.Server.modelToRespname = function(v)
    if type(v) ~= "table" then
        return "vehicle error1"
    end
    local rn = v.respname and tostring(v.respname):match("%S+")
    if rn and string.lower(tostring(rn)) ~= "vehicle" and not tostring(rn):match("^-?%d+$") then
        return rn
    end
    local model = v.model
    if type(model) == "string" and model:match("^%-?%d+$") then
        model = tonumber(model)
    end
    if type(model) == "number" then
        return KOJA.Server.modelHashToDisplayName(model) or tostring(model)
    end
    if type(model) == "string" and model:match("%S+") then
        return model
    end
    return "vehicle error2"
end

KOJA.Server.listingDisplayName = function(li, plateOrId)
    if li and li.name and tostring(li.name):match("%S+") then
        local n = tostring(li.name):gsub("%s+", " "):match("^%s*(.-)%s*$") or tostring(li.name)
        if not n:match("^-?%d+") and string.lower(n) ~= "vehicle" and not n:match("^Vehicle%s+") then
            return n
        end
    end
    if
        li and li.respname and tostring(li.respname):match("%S+") and
            not tostring(li.respname):match("^-?%d+$") and
            string.lower(tostring(li.respname)) ~= "vehicle"
     then
        return tostring(li.respname)
    end
    return "Vehicle " .. tostring(plateOrId or "")
end

KOJA.Server.plateTrimmed = function(plate)
    local p = plate and tostring(plate):gsub("^%s+", ""):gsub("%s+$", "") or nil
    if not p or p == "" then return nil end
    return p:sub(1, 32)
end

KOJA.Server.plateNormalized = function(plate)
    local p = KOJA.Server.plateTrimmed(plate)
    return p and p:gsub("%s+", "") or nil
end

KOJA.Server.ownerPlateKey = function(owner, plate)
    return tostring(owner or "") .. "\0" .. tostring(plate or "")
end

KOJA.Server.ownerPlateNormKey = function(owner, plate)
    return tostring(owner or "") .. "\0" .. tostring(KOJA.Server.plateNormalized(plate) or "")
end

KOJA.Server.applyOwnedVehicleSlugsForWire = function(v)
    if type(v) ~= "table" then
        return KOJA.Shared.normalizeVehicleCategorySlug(nil, nil), "gasoline", KOJA.Shared.coalesceDriveType("sedan", nil)
    end
    local cat = KOJA.Shared.normalizeVehicleCategorySlug(v.car_type, v)
    local fuel = KOJA.Shared.wireFuelSlugGasOrElectric(v.fuel_type or v.fuelType)
    local drive = KOJA.Shared.coalesceDriveType(cat, v.drive_type)
    return cat, fuel, drive
end

KOJA.Server.buildListingsIndex = function(listings, includeOwnedIds)
    local listedPlates, listedIds, listingByPlate = {}, {}, {}
    if listings then
        for _, row in ipairs(listings) do
            local plateNorm = KOJA.Server.plateNormalized(row.plate)
            if plateNorm then
                listedPlates[plateNorm] = true
                listingByPlate[plateNorm] = {name = row.name, respname = row.respname}
            end
            if includeOwnedIds and row.owned_vehicle_id and row.owned_vehicle_id > 0 then
                listedIds[row.owned_vehicle_id] = true
            end
        end
    end
    return listedPlates, listedIds, listingByPlate
end

KOJA.Server.buildParkedVehiclePayload = function(listing, vehicleData, plate, garageId)
    local v = type(vehicleData) == "table" and vehicleData or {}
    local respname = KOJA.Server.resolveRespnameForPayload(listing and listing.respname, v)
    local cat, fuel, drive = KOJA.Server.applyOwnedVehicleSlugsForWire(v)
    return {
        id = 0,
        name = KOJA.Server.listingDisplayName({name = listing and listing.name, respname = respname}, plate),
        model = v.model,
        respname = respname,
        plate = plate or "",
        status = "parked",
        garageId = garageId,
        car_type = cat,
        fuel_type = fuel,
        drive_type = drive,
        mileage = tonumber(v.mileage) or 0,
        vehicle_data = v,
    }
end

KOJA.Server.buildMyCarsVehiclePayload = function(row, listing, vehicleData, isParked, garageId)
    local v = type(vehicleData) == "table" and vehicleData or {}
    local respname = KOJA.Server.resolveRespnameForPayload((listing and listing.respname) or row.respname, v)
    local cat, fuel, drive = KOJA.Server.applyOwnedVehicleSlugsForWire(v)
    return {
        id = row.id,
        name = KOJA.Server.listingDisplayName(listing, row.plate or row.id),
        model = v.model,
        respname = respname,
        car_type = cat,
        drive_type = drive,
        fuel_type = fuel,
        mileage = v.mileage or row.mileage or 0,
        plate = row.plate or "",
        status = isParked and "parked" or "unparked",
        garageId = isParked and garageId or nil,
        vehicle_data = v,
    }
end

KOJA.Server.removePlateFromZoneCache = function(zoneId, plate)
    local zid = zoneId and tostring(zoneId):match("%S+") or nil
    local p = KOJA.Server.plateTrimmed(plate)
    if not zid or not p or not KOJA.Server.CarsInZone[zid] then return end
    for existingPlate, _ in pairs(KOJA.Server.CarsInZone[zid] or {}) do
        if KOJA.Server.plateTrimmed(existingPlate) == p then
            KOJA.Server.CarsInZone[zid][existingPlate] = nil
            break
        end
    end
end

KOJA.Server.deleteListingAndNotify = function(vehicleId, identifier, plate, zoneId, cb)
    MySQL.Async.execute(
        "DELETE FROM koja_carmarket_listings WHERE id = @id AND owner = @owner",
        {["@id"] = vehicleId, ["@owner"] = identifier},
        function()
            if plate and plate ~= "" then
                TriggerClientEvent("koja_carmarket:client:vehicleSold", -1, plate)
            end
            cb({success = true, zoneId = zoneId, plate = plate})
        end
    )
end

KOJA.Server.isGenericRespname = function(respname)
    local rn = tostring(respname or ""):gsub("%s+", " "):match("^%s*(.-)%s*$") or ""
    if rn == "" then return true end
    if rn:match("^%-?%d+$") then return true end
    if string.lower(rn) == "vehicle" then return true end
    return false
end

KOJA.Server.resolveRespnameForStore = function(explicitRespname, vehicleData)
    local rn = explicitRespname and tostring(explicitRespname):match("%S+") and tostring(explicitRespname) or nil
    if rn and not tostring(rn):match("^-?%d+$") and string.lower(tostring(rn)) ~= "vehicle" then
        return tostring(rn)
    end
    local fromModel = KOJA.Server.modelToRespname(type(vehicleData) == "table" and vehicleData or {})
    if fromModel and tostring(fromModel):match("%S+") and string.lower(tostring(fromModel)) ~= "vehicle" then
        return tostring(fromModel)
    end
    return "vehicle"
end

KOJA.Server.resolveRespnameForPayload = function(explicitRespname, vehicleData)
    local rn = explicitRespname and tostring(explicitRespname):match("%S+") and tostring(explicitRespname) or nil
    if rn and not KOJA.Server.isGenericRespname(rn) then
        return tostring(rn)
    end
    if type(vehicleData) == "table" then
        local vdResp = vehicleData.respname and tostring(vehicleData.respname):match("%S+") and tostring(vehicleData.respname) or nil
        if vdResp and not KOJA.Server.isGenericRespname(vdResp) then
            return tostring(vdResp)
        end
    end
    return KOJA.Server.resolveRespnameForStore(rn, vehicleData)
end

KOJA.Server.vehicleTable = function()
    return (KOJA.Framework == "qb") and "player_vehicles" or "owned_vehicles"
end

KOJA.Server.getMileageFromOwnedVehicleRow = function(ovRow)
    if not ovRow then
        return nil
    end
    local m = tonumber(ovRow.mileage)
    if m and m >= 0 then
        return m
    end
    local v = KOJA.Shared.decodeJsonStringOrTable(ovRow.vehicle)
    return tonumber(v.mileage or (v.information and v.information.mileage))
end

KOJA.Server.applyEnumSlugsToMarketTags = function(tags, driveSlug, catSlug)
    local function ensureTagList(t)
        if type(t) ~= "table" then
            return {}
        end
        if type(t.list) == "table" then
            return t.list
        end
        if t[1] ~= nil then
            return t
        end
        t.list = {}
        return t.list
    end
    local tagList = ensureTagList(tags)
    local function addUniqueTag(v)
        if v == nil then
            return
        end
        local s = tostring(v)
        if not s:match("%S") then
            return
        end
        for _, existing in ipairs(tagList) do
            if tostring(existing) == s then
                return
            end
        end
        tagList[#tagList + 1] = s
    end
    local enumLabel = (KOJA.Shared and KOJA.Shared.marketEnumDisplayLabel) or nil
    if type(enumLabel) == "function" then
        for i = 1, #tagList do
            local v = tagList[i]
            if v ~= nil and tostring(v):match("%S") then
                tagList[i] = enumLabel(v)
            end
        end
        addUniqueTag(enumLabel(driveSlug))
        addUniqueTag(enumLabel(catSlug))
    else
        addUniqueTag(driveSlug)
        addUniqueTag(catSlug)
    end
end

KOJA.Server.parkingColumn = function()
    return (Config.VehicleParkingColumn and Config.VehicleParkingColumn ~= "") and Config.VehicleParkingColumn or
        "parking"
end

KOJA.Server.isParkedValue = function(val)
    if not val or val == "" then
        return false
    end
    local s = tostring(val):lower()
    if s == "out" or s == "nil" then
        return false
    end
    return true
end

KOJA.Server.formatStoredDateTime = function(raw)
    if raw == nil then
        return ""
    end
    local t = raw
    if type(t) == "number" then
        local s = os.date("%Y-%m-%d %H:%M", t)
        return (s and s ~= "") and s or ""
    end
    if type(t) == "table" then
        local y, mo, d = t.year or t.Year, t.month or t.Month, t.day or t.Day
        local h, mi = t.hour or t.Hour or 0, t.min or t.Minute or t.minute or 0
        if y and mo and d then
            return string.format(
                "%04d-%02d-%02d %02d:%02d",
                tonumber(y) or 0,
                tonumber(mo) or 0,
                tonumber(d) or 0,
                tonumber(h) or 0,
                tonumber(mi) or 0
            )
        end
        return ""
    end
    local s = tostring(t)
    if s:match("^%d+$") then
        local n = tonumber(s)
        if n then
            local out = os.date("%Y-%m-%d %H:%M", n)
            return (out and out ~= "") and out or ""
        end
    end
    return (s:sub(1, 16):gsub("T", " ") or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

KOJA.Server.formatListingDate = KOJA.Server.formatStoredDateTime

KOJA.Server.formatOfferDate = KOJA.Server.formatStoredDateTime

KOJA.Server.findOnlineSourceByIdentifier = function(identifier)
    if not identifier or identifier == "" then
        return nil
    end
    local players = KOJA.Server.GetPlayers and KOJA.Server.GetPlayers() or {}
    for _, pid in ipairs(players) do
        local src = tonumber(pid) or pid
        if KOJA.Server.GetPlayerIdentifier(src) == identifier then
            return src
        end
    end
    return nil
end

KOJA.Server.removeMoneyByIdentifier = function(identifier, amount, reason, cb)
    local value = tonumber(amount) or 0
    if value < 1 then
        cb(true)
        return
    end
    local onlineSource = KOJA.Server.findOnlineSourceByIdentifier(identifier)
    if onlineSource then
        cb(
            (KOJA.Server.getMoney(onlineSource, "bank") or 0) >= value and
                KOJA.Server.removeMoney(onlineSource, value, "bank", reason or "koja_carmarket")
        )
        return
    end
    if Config.Parking and Config.Parking.RemoveMoneyByIdentifier then
        cb(Config.Parking.RemoveMoneyByIdentifier(identifier, value, reason) == true)
        return
    end
    MySQL.Async.execute(
        "UPDATE user_accounts SET money = money - @amount WHERE identifier = @owner AND name = 'bank' AND money >= @amount",
        {
            ["@amount"] = value,
            ["@owner"] = identifier
        },
        function(affectedRows)
            cb((tonumber(affectedRows) or 0) > 0)
        end
    )
end

KOJA.Server.addMoneyByIdentifier = function(identifier, amount, reason)
    local value = tonumber(amount) or 0
    if value < 1 or not identifier or identifier == "" then
        return
    end
    local onlineSource = KOJA.Server.findOnlineSourceByIdentifier(identifier)
    if onlineSource and KOJA.Server.addMoney then
        KOJA.Server.addMoney(onlineSource, value, "bank", reason or "koja_carmarket_income")
        return
    end
    if Config.Parking and Config.Parking.AddMoneyByIdentifier then
        if Config.Parking.AddMoneyByIdentifier(identifier, value, reason) == true then
            return
        end
    end
    MySQL.Async.execute(
        "UPDATE user_accounts SET money = money + @amount WHERE identifier = @owner AND name = 'bank'",
        {
            ["@amount"] = value,
            ["@owner"] = identifier
        },
        function()
        end
    )
end

KOJA.Server.processDueParkingFees = function(identifier, doneCb)
    MySQL.Async.fetchAll(
        "SELECT id, weekly_fee FROM koja_carmarket_parkings WHERE owner_identifier = @oid AND next_payment_at IS NOT NULL AND next_payment_at < NOW()",
        {["@oid"] = identifier},
        function(rows)
            if not rows or #rows == 0 then
                doneCb()
                return
            end
            local idx = 1
            local function nextOne()
                if idx > #rows then
                    doneCb()
                    return
                end
                local row = rows[idx]
                local fee = tonumber(row.weekly_fee) or 0
                local parkingId = row.id
                KOJA.Server.removeMoneyByIdentifier(
                    identifier,
                    fee,
                    "parking_weekly",
                    function(paid)
                        if paid then
                            MySQL.Async.execute(
                                "UPDATE koja_carmarket_parkings SET next_payment_at = DATE_ADD(NOW(), INTERVAL 7 DAY) WHERE id = @id",
                                {["@id"] = parkingId},
                                function()
                                end
                            )
                        elseif fee > 0 then
                            MySQL.Async.execute(
                                "DELETE FROM koja_carmarket_parking_slots WHERE parking_id = @id",
                                {["@id"] = parkingId},
                                function()
                                    MySQL.Async.execute(
                                        "DELETE FROM koja_carmarket_parkings WHERE id = @id",
                                        {["@id"] = parkingId},
                                        function()
                                        end
                                    )
                                end
                            )
                        end
                        idx = idx + 1
                        nextOne()
                    end
                )
            end
            nextOne()
        end
    )
end

KOJA.Server.processDueSlotFees = function(identifier, doneCb)
    MySQL.Async.fetchAll(
        "SELECT slot_id, zone_id, weekly_fee FROM koja_carmarket_slot_owners WHERE owner_identifier = @oid AND next_payment_at IS NOT NULL AND next_payment_at < NOW()",
        {["@oid"] = identifier},
        function(rows)
            if not rows or #rows == 0 then
                doneCb()
                return
            end
            local idx = 1
            local function nextSlot()
                if idx > #rows then
                    doneCb()
                    return
                end
                local row = rows[idx]
                local fee = tonumber(row.weekly_fee) or 0
                local zoneId = row.zone_id
                local slotId = row.slot_id
                MySQL.Async.fetchAll(
                    "SELECT owner_identifier FROM koja_carmarket_exchange WHERE zone_id = @zid LIMIT 1",
                    {["@zid"] = zoneId},
                    function(exRows)
                        local zoneOwner =
                            exRows and exRows[1] and
                            (exRows[1].owner_identifier and tostring(exRows[1].owner_identifier):match("%S+")) or
                            nil
                        KOJA.Server.removeMoneyByIdentifier(
                            identifier,
                            fee,
                            "slot_weekly",
                            function(paid)
                                if paid then
                                    if zoneOwner and zoneOwner ~= "" and fee > 0 then
                                        KOJA.Server.addMoneyByIdentifier(zoneOwner, fee, "zone_slot_weekly")
                                    end
                                    MySQL.Async.execute(
                                        "UPDATE koja_carmarket_slot_owners SET next_payment_at = DATE_ADD(NOW(), INTERVAL 7 DAY) WHERE slot_id = @sid",
                                        {["@sid"] = slotId},
                                        function()
                                        end
                                    )
                                elseif fee > 0 then
                                    MySQL.Async.execute(
                                        "DELETE FROM koja_carmarket_slot_owners WHERE slot_id = @sid",
                                        {["@sid"] = slotId},
                                        function()
                                        end
                                    )
                                end
                                idx = idx + 1
                                nextSlot()
                            end
                        )
                    end
                )
            end
            nextSlot()
        end
    )
end

KOJA.Server.normalizeTags = function(raw)
    if type(raw) == "string" and raw ~= "" then
        local ok, decoded = pcall(json.decode, raw)
        raw = ok and decoded or {}
    end
    if type(raw) ~= "table" then
        return {list = {}, tuning = {visual = {}, mechanical = {}, color = {}}}
    end
    if raw.list or raw.tuning then
        return raw
    end
    return {list = raw, tuning = {visual = {}, mechanical = {}, color = {}}}
end

KOJA.Server.rowToVehicleView = function(row)
    local tags = {}
    if row.tags and row.tags ~= "" then
        tags = json.decode(row.tags) or {}
    end
    local listedAt = row.listedAt or row.listed_at
    if type(listedAt) ~= "string" or listedAt == "" then
        local createdAt = row.created_at or row.createdAt or row.created_at_ts or row.createdAt_ts or row.created
        listedAt = KOJA.Server.formatListingDate(createdAt)
    end
    if listedAt == nil or type(listedAt) ~= "string" then
        listedAt = ""
    end
    local vehicleData = {}
    if row.vehicle_data then
        vehicleData = (type(row.vehicle_data) == "string" and json.decode(row.vehicle_data)) or row.vehicle_data or {}
    end
    local extra_info = KOJA.Shared.buildExtraInfoCoreRowsFromVdata(vehicleData)
    local viewCat = KOJA.Shared.normalizeVehicleCategorySlug(row.car_type, vehicleData)
    local viewRespname = (row.respname and tostring(row.respname):match("%S+") and tostring(row.respname)) or nil
    if not viewRespname or string.lower(tostring(viewRespname)) == "vehicle" then
        viewRespname = KOJA.Server.modelToRespname(vehicleData)
    end
    local viewFuel = KOJA.Shared.wireFuelSlugGasOrElectric(row.fuel_type or vehicleData.fuel_type)
    vehicleData.fuel_type = viewFuel
    local vehicle = {
        id = row.id,
        zone_id = row.zone_id,
        name = (row.name and tostring(row.name):match("%S+") and tostring(row.name)) or "Vehicle",
        respname = viewRespname,
        owner = row.owner,
        car_type = viewCat,
        drive_type = KOJA.Shared.coalesceDriveType(viewCat, row.drive_type),
        fuel_type = viewFuel,
        offert_type = row.offert_type or "buy",
        tags = tags,
        extra_info = extra_info,
        price = row.price,
        information = {mileage = row.mileage or 0},
        description = row.description or "",
        plate = row.plate or "",
        status = "active",
        vehicle_data = vehicleData,
        model = vehicleData.model,
        seller = {
            name = (row.seller_name and row.seller_name ~= "") and row.seller_name or row.owner,
            rank = "Seller",
            issuedDate = (listedAt or ""):sub(1, 10)
        }
    }
    return {
        vehicle = vehicle,
        listedAt = listedAt,
        history = {},
        auction = (row.offert_type == "auction") and
            {
                endsAt = (row.auction_ends_at and tostring(row.auction_ends_at):sub(1, 19):gsub("T", " ")) or "",
                highestBid = row.price,
                highestBidder = {id = "", identifier = "", name = ""},
                isYouHighest = false,
                bids = {}
            } or
            nil
    }
end

KOJA.Server.processDueListingFees = function(identifier, doneCb)
    MySQL.Async.fetchAll(
        "SELECT id, owner, plate, zone_id FROM koja_carmarket_listings WHERE owner = @oid AND listing_fee_paid_until IS NOT NULL AND listing_fee_paid_until < NOW() AND zone_id IS NOT NULL",
        {["@oid"] = identifier},
        function(rows)
            if not rows or #rows == 0 then
                doneCb()
                return
            end
            local idx = 1
            local function nextOne()
                if idx > #rows then
                    doneCb()
                    return
                end
                local row = rows[idx]
                local zoneId = row.zone_id
                local owner = row.owner
                local listingId = row.id
                local plate = row.plate
                MySQL.Async.fetchAll(
                    "SELECT listing_fee_per_week, commission_percent, owner_identifier FROM koja_carmarket_exchange WHERE zone_id = @zid LIMIT 1",
                    {["@zid"] = zoneId},
                    function(exRows)
                        local fee = (Config.Exchange and Config.Exchange.DefaultListingFeePerWeek) or 500
                        local zoneOwner = nil
                        if exRows and #exRows > 0 then
                            fee = tonumber(exRows[1].listing_fee_per_week) or fee
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
                                    idx = idx + 1
                                    nextOne()
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
                                        local commPct =
                                            (Config.Exchange and Config.Exchange.DefaultCommissionPercent) or 5
                                        if exRows and #exRows > 0 then
                                            commPct = tonumber(exRows[1].commission_percent) or commPct
                                        end
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
                                                    TriggerClientEvent("koja_carmarket:client:vehicleSold", -1, plate)
                                                end
                                            )
                                        end
                                    )
                                end
                                idx = idx + 1
                                nextOne()
                            end
                        )
                    end
                )
            end
            nextOne()
        end
    )
end

KOJA.Server.paySellerByIdentifier = function(sellerIdentifier, amount, reason)
    KOJA.Server.addMoneyByIdentifier(sellerIdentifier, tonumber(amount) or 0, reason or "car_sale")
    return true
end

