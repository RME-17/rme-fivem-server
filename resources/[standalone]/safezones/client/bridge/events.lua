RegisterNetEvent('koja_carmarket:client:auctionUpdated', function(payload)
    if not payload or type(payload) ~= 'table' then return end
    KOJA.Shared.KojaCarmarketDebug(json.encode(payload))
    if KOJA.Client.SendReactMessage then
        KOJA.Client.SendReactMessage('koja_carmarket:nui:auctionUpdated', payload)
    else
        SendNUIMessage({ action = 'koja_carmarket:nui:auctionUpdated', data = payload })
    end
end)

RegisterNetEvent('koja_carmarket:client:vehicleSold', function(plate)
    if not plate or plate == '' then return end
    local normalize = function(s) return string.lower(string.gsub(tostring(s), '%s', '')) end
    local want = normalize(plate)
    for zoneId, list in pairs(spawnedVehicles) do
        if type(list) == 'table' then
            for idx, entry in ipairs(list) do
                if entry.carData and want == normalize(entry.carData.plate or '') then
                    if entry.listingKey then KojaCarmarketMenus.CleanupVehicleListing(zoneId, entry.listingKey) end
                    if DoesEntityExist(entry.vehicle) then DeleteEntity(entry.vehicle) end
                    table.remove(list, idx)
                    return
                end
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if KOJA.Client.abortMarketTestDriveOnStop then KOJA.Client.abortMarketTestDriveOnStop() end
        KojaCarmarketMenus.CleanupAllBindings()
        for j = 1, #(Config.Zones or {}) do
            local point = KOJA.Client.points and KOJA.Client.points[j]
            if point and type(point.remove) == 'function' then
                point:remove()
            end
            if KOJA.Client.points then KOJA.Client.points[j] = nil end
        end
        for _, list in pairs(spawnedVehicles) do
            if type(list) == 'table' then
                for _, entry in ipairs(list) do
                    if DoesEntityExist(entry.vehicle) then DeleteEntity(entry.vehicle) end
                end
            end
        end
        spawnedVehicles = {}
        KOJA.Client.clearParkingBlips()
    end
end)

RegisterNetEvent('koja_carmarket:client:notifyContact', function(data)
    if data and data.from then
        KOJA.Client.SendNotify({
            type = 'info',
            title = _L('lua.client.contact_title'),
            desc = _L('lua.client.buyer_wants_contact', { name = data.from }),
            time = 5000,
        })
    end
end)

RegisterCommand('carmarket_refreshzone', function()
    if Config.Commands and Config.Commands.RequireAdminForRefreshZone and not Misc.Utils.CarMarketHasClientAce() then
        KOJA.Client.SendNotify({ type = 'error', title = _L('lua.client.error'), desc = _L('lua.client.no_ace_permission'), time = 5000 })
        return
    end
    local pCoords = GetEntityCoords(PlayerPedId())
    for _, zonePoint in ipairs(Config.Zones or {}) do
        local radius = Misc.Utils.GetZoneSpawnRadius(zonePoint)
        local c = zonePoint.coords
        if c and #(pCoords - vector3(c.x, c.y, c.z)) <= radius then
            KOJA.Client.RefreshZone(zonePoint.id)
            KOJA.Client.SendNotify({ type = 'success', title = _L('lua.client.zone_refreshed'), desc = tostring(zonePoint.id), time = 5000 })
            return
        end
    end
    local errZ = _L('lua.client.not_in_exchange_zone')
    KOJA.Client.SendNotify({ type = 'error', title = errZ, desc = errZ, time = 5000 })
end, false)

RegisterCommand('addparkingslot', function()
    if Config.Commands and Config.Commands.RequireAdminForAddParkingSlot and not Misc.Utils.CarMarketHasClientAce() then
        KOJA.Client.SendNotify({ type = 'error', title = _L('lua.client.error'), desc = _L('lua.client.no_ace_permission'), time = 5000 })
        return
    end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local zoneId = Misc.Utils.GetNearestZoneId(coords)
    if not zoneId then
        local z = _L('lua.client.not_in_exchange_zone')
        KOJA.Client.SendNotify({ type = 'error', title = z, desc = z, time = 5000 })
        return
    end
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getMyParkings', {}, function(res)
        if not res or not res.parkings then
            local e = _L('lua.client.error')
            KOJA.Client.SendNotify({ type = 'error', title = e, desc = e, time = 5000 })
            return
        end
        local parking = nil
        for _, p in ipairs(res.parkings) do if p.zone_id == zoneId then parking = p break end end
        if not parking then
            local np = _L('lua.client.no_parking_in_zone')
            KOJA.Client.SendNotify({ type = 'error', title = np, desc = np, time = 5000 })
            return
        end
        KOJA.Client.TriggerServerCallback('koja_carmarket:server:addParkingSlot', { parkingId = parking.id, coords = { x = coords.x, y = coords.y, z = coords.z }, heading = heading }, function(r)
            local okSlot = r and r.success
            local m = okSlot and _L('lua.client.slot_added') or _L('lua.client.error')
            KOJA.Client.SendNotify({ type = okSlot and 'success' or 'error', title = m, desc = m, time = 5000 })
        end)
    end)
end, false)
