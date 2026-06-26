KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:getParkingSlots",
    function(source, data, cb)
        local parkingId = tonumber(data.parkingId)
        if not parkingId then
            cb({success = false, slots = {}})
            return
        end
        MySQL.Async.fetchAll(
            "SELECT parking_id, slot_index, coords, heading FROM koja_carmarket_parking_slots WHERE parking_id = @pid ORDER BY slot_index",
            {["@pid"] = parkingId},
            function(rows)
                cb({success = true, slots = rows or {}})
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:addParkingSlot",
    function(source, data, cb)
        if Config.Commands and Config.Commands.RequireAdminForAddParkingSlot then
            local ace = Config.Commands.AdminAce or "group.admin"
            if not IsPlayerAceAllowed(source, ace) then
                cb({success = false})
                return
            end
        end
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false})
            return
        end
        local parkingId = tonumber(data.parkingId)
        if not parkingId then
            cb({success = false})
            return
        end
        MySQL.Async.fetchAll(
            "SELECT id, owner_identifier FROM koja_carmarket_parkings WHERE id = @pid LIMIT 1",
            {["@pid"] = parkingId},
            function(rows)
                if not rows or #rows == 0 or rows[1].owner_identifier ~= identifier then
                    cb({success = false})
                    return
                end
                local maxSlots = (Config.Parking and Config.Parking.MaxSlotsPerParking) or 30
                MySQL.Async.fetchAll(
                    "SELECT MAX(slot_index) as mx FROM koja_carmarket_parking_slots WHERE parking_id = @pid",
                    {["@pid"] = parkingId},
                    function(slotRows)
                        local nextSlot = 1
                        if slotRows and slotRows[1] and slotRows[1].mx then
                            nextSlot = (tonumber(slotRows[1].mx) or 0) + 1
                        end
                        if nextSlot > maxSlots then
                            cb({success = false})
                            return
                        end
                        local coords = data.coords or {}
                        local heading = tonumber(data.heading) or 0
                        MySQL.Async.execute(
                            "INSERT INTO koja_carmarket_parking_slots (parking_id, slot_index, coords, heading) VALUES (@pid, @idx, @coords, @heading)",
                            {
                                ["@pid"] = parkingId,
                                ["@idx"] = nextSlot,
                                ["@coords"] = json.encode(coords),
                                ["@heading"] = heading
                            },
                            function()
                                cb({success = true, slotIndex = nextSlot})
                            end
                        )
                    end
                )
            end
        )
    end
)

KOJA.Server.RegisterServerCallback(
    "koja_carmarket:server:updateParkingSlot",
    function(source, data, cb)
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false})
            return
        end
        local parkingId = tonumber(data.parkingId)
        local slotIndex = tonumber(data.slotIndex)
        if not parkingId or not slotIndex then
            cb({success = false})
            return
        end
        MySQL.Async.fetchAll(
            "SELECT id, owner_identifier FROM koja_carmarket_parkings WHERE id = @pid LIMIT 1",
            {["@pid"] = parkingId},
            function(rows)
                if not rows or #rows == 0 or rows[1].owner_identifier ~= identifier then
                    cb({success = false})
                    return
                end
                local coords = data.coords or {}
                local heading = tonumber(data.heading) or 0
                MySQL.Async.execute(
                    "UPDATE koja_carmarket_parking_slots SET coords = @coords, heading = @heading WHERE parking_id = @pid AND slot_index = @idx",
                    {
                        ["@coords"] = json.encode(coords),
                        ["@heading"] = heading,
                        ["@pid"] = parkingId,
                        ["@idx"] = slotIndex
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
    "koja_carmarket:server:removeParkingSlot",
    function(source, data, cb)
        local identifier = KOJA.Server.GetPlayerIdentifier(source)
        if not identifier then
            cb({success = false})
            return
        end
        local parkingId = tonumber(data.parkingId)
        local slotIndex = tonumber(data.slotIndex)
        if not parkingId or not slotIndex then
            cb({success = false})
            return
        end
        MySQL.Async.fetchAll(
            "SELECT id, owner_identifier FROM koja_carmarket_parkings WHERE id = @pid LIMIT 1",
            {["@pid"] = parkingId},
            function(rows)
                if not rows or #rows == 0 or rows[1].owner_identifier ~= identifier then
                    cb({success = false})
                    return
                end
                MySQL.Async.execute(
                    "DELETE FROM koja_carmarket_parking_slots WHERE parking_id = @pid AND slot_index = @idx",
                    {
                        ["@pid"] = parkingId,
                        ["@idx"] = slotIndex
                    },
                    function()
                        cb({success = true})
                    end
                )
            end
        )
    end
)
