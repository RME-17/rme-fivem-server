KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:getExchange",
    function(source, data, cb)
        local zoneId = data.zoneId and tostring(data.zoneId):match("%S+") or nil
        if not zoneId then
            cb({success = false})
            return
        end
        MySQL.Async.fetchAll(
            "SELECT zone_id, owner_identifier, listing_fee_per_week, max_listings, commission_percent FROM koja_carmarket_exchange WHERE zone_id = @zid LIMIT 1",
            {["@zid"] = zoneId},
            function(rows)
                if rows and #rows > 0 then
                    cb({success = true, exchange = rows[1]})
                else
                    MySQL.Async.execute(
                        "INSERT IGNORE INTO koja_carmarket_exchange (zone_id, listing_fee_per_week, max_listings, commission_percent) VALUES (@zid, @fee, @max, @comm)",
                        {
                            ["@zid"] = zoneId,
                            ["@fee"] = (Config.Exchange and Config.Exchange.DefaultListingFeePerWeek) or 500,
                            ["@max"] = (Config.Exchange and Config.Exchange.MaxListingsPerZone) or 50,
                            ["@comm"] = (Config.Exchange and Config.Exchange.DefaultCommissionPercent) or 5
                        },
                        function()
                            MySQL.Async.fetchAll(
                                "SELECT zone_id, owner_identifier, listing_fee_per_week, max_listings, commission_percent FROM koja_carmarket_exchange WHERE zone_id = @zid LIMIT 1",
                                {["@zid"] = zoneId},
                                function(r2)
                                    cb({success = true, exchange = (r2 and r2[1]) or {}})
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
    "koja_carmarket:server:updateExchange",
    function(source, data, cb)
        if not KOJA.Server.rateLimit(source, "updateExchange", 1000) then
            cb({success = false, reason = "rate_limited"})
            return
        end
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false})
            return
        end
        local zoneId = data.zoneId and tostring(data.zoneId):match("%S+") or nil
        if not zoneId or #zoneId > 50 then
            cb({success = false})
            return
        end
        MySQL.Async.fetchAll(
            "SELECT owner_identifier FROM koja_carmarket_exchange WHERE zone_id = @zid LIMIT 1",
            {["@zid"] = zoneId},
            function(rows)
                if not rows or #rows == 0 then
                    cb({success = false})
                    return
                end
                local current = rows[1].owner_identifier
                if current and current ~= "" and current ~= identifier then
                    cb({success = false})
                    return
                end
                local rawFee = tonumber(data.listing_fee_per_week)
                local rawMaxL = tonumber(data.max_listings)
                local rawComm = tonumber(data.commission_percent)
                local fee = rawFee and math.max(0, math.min(KOJA.Server.MAX_PRICE, math.floor(rawFee))) or nil
                local maxL = rawMaxL and math.max(1, math.min(500, math.floor(rawMaxL))) or nil
                local comm = rawComm and math.max(0, math.min(50, math.floor(rawComm))) or nil
                MySQL.Async.execute(
                    "UPDATE koja_carmarket_exchange SET owner_identifier = @oid, listing_fee_per_week = COALESCE(@fee, listing_fee_per_week), max_listings = COALESCE(@max, max_listings), commission_percent = COALESCE(@comm, commission_percent) WHERE zone_id = @zid",
                    {
                        ["@oid"] = current or identifier,
                        ["@fee"] = fee,
                        ["@max"] = maxL,
                        ["@comm"] = comm,
                        ["@zid"] = zoneId
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
    "koja_carmarket:server:submitOffer",
    function(source, data, cb)
        if not KOJA.Server.rateLimit(source, "submitOffer", 800) then
            cb({success = false, reason = "rate_limited"})
            return
        end
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false})
            return
        end
        local listingId = KOJA.Server.sanitizeId(data.listingId)
        local amount = KOJA.Server.clampBid(data.amount)
        if not listingId or not amount then
            cb({success = false, reason = "bad_input"})
            return
        end
        MySQL.Async.fetchAll(
            "SELECT id, owner, offert_type, price, auction_ends_at FROM koja_carmarket_listings WHERE id = @lid",
            {["@lid"] = listingId},
            function(rows)
                if not rows or not rows[1] then
                    cb({success = false})
                    return
                end
                local row = rows[1]
                if (row.offert_type or "") ~= "auction" then
                    cb({success = false})
                    return
                end
                if row.owner == identifier then
                    cb({success = false, reason = "own_listing"})
                    return
                end
                local function doInsertOffer()
                    MySQL.Async.fetchAll(
                        "SELECT COALESCE(MAX(amount), 0) as mx FROM koja_carmarket_offers WHERE listing_id = @lid",
                        {["@lid"] = listingId},
                        function(maxRows)
                            local currentMax =
                                (maxRows and maxRows[1] and tonumber(maxRows[1].mx)) or tonumber(row.price) or 0
                            local minPrice = tonumber(row.price) or 0
                            local minIncrement = KOJA.Server.computeMinBidIncrement(currentMax)
                            local floor = math.max(minPrice, currentMax + minIncrement)
                            if amount < floor then
                                cb({success = false, reason = "bid_too_low", minimum = floor})
                                return
                            end
                            local bank = (KOJA.Server.getMoney and KOJA.Server.getMoney(source, "bank")) or 0
                            if bank < amount then
                                cb({success = false, reason = "no_money"})
                                return
                            end
                            local buyerName = KOJA.Server.GetPlayerName(source) or ""
                            MySQL.Async.execute(
                                [[INSERT INTO koja_carmarket_offers (listing_id, buyer_identifier, buyer_name, amount, status, created_at)
                                  SELECT @lid, @bid, @bname, @amt, 'pending', NOW()
                                  WHERE NOT EXISTS (
                                      SELECT 1 FROM koja_carmarket_offers
                                      WHERE listing_id = @lid AND amount >= @amt
                                  )]],
                                {
                                    ["@lid"] = listingId,
                                    ["@bid"] = identifier,
                                    ["@bname"] = buyerName,
                                    ["@amt"] = amount
                                },
                                function(affected)
                                    if (tonumber(affected) or 0) == 0 then
                                        cb({success = false, reason = "outbid"})
                                        return
                                    end
                                    MySQL.Async.execute(
                                        "UPDATE koja_carmarket_listings SET price = @amt, auction_ends_at = CASE WHEN auction_ends_at IS NOT NULL AND TIMESTAMPDIFF(SECOND, NOW(), auction_ends_at) < 60 THEN DATE_ADD(NOW(), INTERVAL 60 SECOND) ELSE auction_ends_at END WHERE id = @lid",
                                        {["@amt"] = amount, ["@lid"] = listingId},
                                        function()
                                            TriggerClientEvent(
                                                "koja_carmarket:client:auctionUpdated",
                                                -1,
                                                {listingId = listingId, event = "bid_placed"}
                                            )
                                            cb({success = true})
                                        end
                                    )
                                end
                            )
                        end
                    )
                end
                if row.auction_ends_at then
                    MySQL.Async.fetchAll(
                        "SELECT NOW() as now_ts",
                        {},
                        function(nowRows)
                            if
                                nowRows and nowRows[1] and row.auction_ends_at and
                                    tostring(row.auction_ends_at) <= tostring(nowRows[1].now_ts)
                             then
                                cb({success = false, reason = "auction_ended"})
                                return
                            end
                            doInsertOffer()
                        end
                    )
                else
                    doInsertOffer()
                end
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:getExchangeOwnerPanel",
    function(source, data, cb)
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({identifier = "", zones = {}, exchanges = {}})
            return
        end
        local zones = {}
        for _, z in ipairs(Config.Zones or {}) do
            zones[#zones + 1] = {id = z.id, name = z.name or z.id}
        end
        if #zones == 0 then
            cb({identifier = identifier, zones = {}, exchanges = {}})
            return
        end
        local placeholders = {}
        for i = 1, #zones do
            placeholders[i] = "@z" .. i
        end
        local params = {}
        for i, z in ipairs(zones) do
            params["@z" .. i] = z.id
        end
        MySQL.Async.fetchAll(
            "SELECT zone_id, owner_identifier, listing_fee_per_week, max_listings, commission_percent FROM koja_carmarket_exchange WHERE zone_id IN (" ..
                table.concat(placeholders, ",") .. ")",
            params,
            function(rows)
                local exchanges = {}
                if rows then
                    for _, r in ipairs(rows) do
                        exchanges[r.zone_id] = r
                    end
                end
                cb({identifier = identifier, zones = zones, exchanges = exchanges})
            end
        )
    end
)
