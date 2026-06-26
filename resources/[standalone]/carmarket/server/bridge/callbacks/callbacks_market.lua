KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:deleteMyOffer",
    function(source, data, cb)
        if not KOJA.Server.rateLimit(source, "deleteMyOffer", 1000) then
            cb({success = false, reason = "rate_limited"})
            return
        end
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false})
            return
        end
        local vehicleId = KOJA.Server.sanitizeId(data.vehicleId)
        if not vehicleId then
            cb({success = false, reason = "bad_input"})
            return
        end
        MySQL.Async.fetchAll(
            [[
        SELECT l.id, l.plate, l.zone_id, l.offert_type,
            (CASE WHEN l.offert_type = 'auction' AND l.auction_ends_at IS NOT NULL AND l.auction_ends_at < NOW() THEN 1 ELSE 0 END) AS auction_ended,
            (CASE WHEN l.offert_type = 'auction' AND l.auction_starts_at IS NOT NULL AND NOW() < l.auction_starts_at THEN 1 ELSE 0 END) AS auction_not_started
        FROM koja_carmarket_listings l WHERE l.id = @id AND l.owner = @owner LIMIT 1
    ]],
            {["@id"] = vehicleId, ["@owner"] = identifier},
            function(rows)
                if not rows or #rows == 0 then
                    cb({success = false})
                    return
                end
                local row = rows[1]
                if row.offert_type == "auction" then
                    local ended = (row.auction_ended == 1)
                    local notStarted = (row.auction_not_started == 1)
                    local status = ended and "ended" or (notStarted and "waiting" or "started")
                    if status == "started" or status == "ended" then
                        cb({success = false, reason = "auction_cannot_remove"})
                        return
                    end
                end
                local plate = KOJA.Server.plateTrimmed(row.plate)
                local plateNorm = KOJA.Server.plateNormalized(plate)
                local zoneId = row.zone_id and tostring(row.zone_id):match("%S+") or nil
                if not plate or plate == "" then
                    KOJA.Server.deleteListingAndNotify(vehicleId, identifier, plate, zoneId, cb)
                    return
                end
                if zoneId then
                    MySQL.Async.execute(
                        'DELETE FROM koja_carmarket WHERE zone_id = @zid AND REPLACE(TRIM(plate), " ", "") = @plateNorm AND owner = @oid',
                        {["@zid"] = zoneId, ["@plateNorm"] = plateNorm, ["@oid"] = identifier},
                        function()
                            KOJA.Server.removePlateFromZoneCache(zoneId, plate)
                            KOJA.Server.deleteListingAndNotify(vehicleId, identifier, plate, zoneId, cb)
                        end
                    )
                else
                    MySQL.Async.fetchAll(
                        'SELECT zone_id FROM koja_carmarket WHERE owner = @oid AND REPLACE(TRIM(plate), " ", "") = @plateNorm LIMIT 1',
                        {["@oid"] = identifier, ["@plateNorm"] = plateNorm},
                        function(zRows)
                            local zid =
                                (zRows and zRows[1] and zRows[1].zone_id) and tostring(zRows[1].zone_id):match("%S+") or
                                nil
                            MySQL.Async.execute(
                                'DELETE FROM koja_carmarket WHERE owner = @oid AND REPLACE(TRIM(plate), " ", "") = @plateNorm',
                                {["@oid"] = identifier, ["@plateNorm"] = plateNorm},
                                function()
                                    KOJA.Server.removePlateFromZoneCache(zid, plate)
                                    KOJA.Server.deleteListingAndNotify(vehicleId, identifier, plate, zoneId, cb)
                                end
                            )
                        end
                    )
                end
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:editMyOffer",
    function(source, data, cb)
        if not KOJA.Server.rateLimit(source, "editMyOffer", 800) then
            cb({success = false, reason = "rate_limited"})
            return
        end
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false})
            return
        end
        local vehicleId = KOJA.Server.sanitizeId(data.vehicleId)
        local price = KOJA.Server.clampPrice(data.price)
        local tags = json.encode(KOJA.Server.sanitizeTags(data.tags))
        if not vehicleId then
            cb({success = false, reason = "bad_input"})
            return
        end
        if not price then
            cb({success = false, reason = "bad_price"})
            return
        end
        MySQL.Async.fetchAll(
            "SELECT id, owner, offert_type, (SELECT COUNT(*) FROM koja_carmarket_offers o WHERE o.listing_id = koja_carmarket_listings.id) AS bid_count FROM koja_carmarket_listings WHERE id = @id LIMIT 1",
            {["@id"] = vehicleId},
            function(rows)
                if not rows or #rows == 0 or rows[1].owner ~= identifier then
                    cb({success = false})
                    return
                end
                if rows[1].offert_type == "auction" and (tonumber(rows[1].bid_count) or 0) > 0 then
                    cb({success = false, reason = "auction_locked"})
                    return
                end
                MySQL.Async.execute(
                    "UPDATE koja_carmarket_listings SET price = @price, tags = @tags WHERE id = @id AND owner = @owner",
                    {["@price"] = price, ["@tags"] = tags, ["@id"] = vehicleId, ["@owner"] = identifier},
                    function()
                        cb({success = true})
                    end
                )
            end
        )
    end
)

local GARAGE_PAGE = 5
KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:getGarageVehicles",
    function(source, data, cb)
        KOJA.Shared.KojaCarmarketDebug(json.encode(data))
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false})
            KOJA.Shared.KojaCarmarketDebug("^1[koja-carmarket]^7 getGarageVehicles: no identifier")
            return
        end
        local page = tonumber(data.page) or 1
        MySQL.Async.fetchAll(
            "SELECT plate, owned_vehicle_id, name, respname FROM koja_carmarket_listings WHERE owner = @owner",
            {["@owner"] = identifier},
            function(listings)
                local listedPlates, listedIds = KOJA.Server.buildListingsIndex(listings, true)
                MySQL.Async.fetchAll(
                    "SELECT * FROM " .. KOJA.Server.vehicleTable() .. " WHERE owner = @owner",
                    {["@owner"] = identifier},
                    function(all)
                        local list = {}
                        for _, row in ipairs(all or {}) do
                            local plateNorm = KOJA.Server.plateNormalized(row.plate) or ""
                            if not listedPlates[plateNorm] and not listedIds[row.id] then
                                local v = row.vehicle and json.decode(row.vehicle) or {}
                                if type(v) ~= "table" then
                                    v = {}
                                end
                                local garCat = KOJA.Shared.normalizeVehicleCategorySlug(v.car_type, v)
                                if KOJA.Shared.isMarketAllowedCategorySlug(garCat) then
                                    list[#list + 1] = row
                                end
                            end
                        end
                        local totalPages = math.max(1, math.ceil(#list / GARAGE_PAGE))
                        page = math.max(1, math.min(page, totalPages))
                        local offset = (page - 1) * GARAGE_PAGE
                        local vehicles = {}
                        for i = offset + 1, math.min(offset + GARAGE_PAGE, #list) do
                            local row = list[i]
                            local v = row.vehicle and json.decode(row.vehicle) or {}
                            if type(v) ~= "table" then
                                v = {}
                            end
                            local respname = KOJA.Server.modelToRespname(v)
                            local name = KOJA.Server.listingDisplayName({name = v.name, respname = respname}, row.plate)
                            local garCat, fuelN, garDrive = KOJA.Server.applyOwnedVehicleSlugsForWire(v)
                            vehicles[#vehicles + 1] = {
                                id = tonumber(row.id) or tonumber(row.vehicle_id) or tonumber(row.owned_vehicle_id) or row.id,
                                name = name,
                                model = v.model,
                                respname = respname,
                                car_type = garCat,
                                drive_type = garDrive,
                                fuel_type = fuelN,
                                mileage = v.mileage or row.mileage or 0,
                                plate = row.plate or "",
                                status = "available",
                                vehicle_data = v
                            }
                        end
                        KOJA.Shared.KojaCarmarketDebug(json.encode(vehicles))
                        cb({success = true, vehicles = vehicles, totalPages = totalPages})
                    end
                )
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:payTestDriveFee",
    function(source, data, cb)
        if not KOJA.Server.rateLimit(source, "payTestDriveFee", 2000) then
            cb({success = false, reason = "rate_limited"})
            return
        end
        local zoneId = data and data.zoneId and tostring(data.zoneId):match("%S+")
        if not zoneId then
            cb({ success = false, reason = "bad_zone" })
            return
        end
        local cfg = KOJA.Shared.resolveTestDriveSettings(zoneId)
        if not cfg then
            cb({ success = false, reason = "disabled" })
            return
        end
        local price = cfg.price or 0
        if price <= 0 then
            cb({ success = true, paid = 0 })
            return
        end
        if not KOJA.Server.getMoney or not KOJA.Server.removeMoney then
            cb({ success = false, reason = "framework" })
            return
        end
        if (KOJA.Server.getMoney(source, "bank") or 0) < price then
            cb({ success = false, reason = "no_money", price = price })
            return
        end
        if not KOJA.Server.removeMoney(source, price, "bank", "test_drive_fee") then
            cb({ success = false, reason = "pay_failed" })
            return
        end
        cb({ success = true, paid = price })
    end
)

