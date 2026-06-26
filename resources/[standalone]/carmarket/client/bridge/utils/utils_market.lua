KOJA.Client.listingKeyFor = function(carData, pairKey)
    if carData.listing_id ~= nil then return tostring(carData.listing_id) end
    if carData.plate and tostring(carData.plate):match('%S') then return tostring(carData.plate) end
    return tostring(pairKey or 'unknown')
end

KOJA.Client.mergeListingVehicleProps = function(carData)
    local v = {}
    if carData and carData.vehicle ~= nil then
        local decoded = Misc.Utils.DecodeVehicleRaw(carData.vehicle)
        if type(decoded) == 'table' then
            for k, val in pairs(decoded) do
                v[k] = val
            end
        end
    end
    local vd = carData and carData.vehicle_data
    if type(vd) == 'table' then
        for k, val in pairs(vd) do
            v[k] = val
        end
    end
    return v
end

KOJA.Client.modelHashToDisplayName = function(modelHash)
    if type(modelHash) ~= 'number' or modelHash == 0 then return nil end
    local display = GetDisplayNameFromVehicleModel(modelHash)
    if not display or display == '' then return nil end
    local label = GetLabelText(display)
    if label and label ~= '' and label ~= 'NULL' then return label end
    return display
end

KOJA.Client.resolveListingVehicleName = function(carData)
    local explicitName = carData and carData.name
    if explicitName and tostring(explicitName):match('%S') and not KOJA.Shared.isGenericVehicleName(explicitName) then
        return tostring(explicitName)
    end
    local raw = carData and carData.vehicle
    local modelHash = Misc.Utils.ExtractVehicleModelHash(raw)
    local modelName = KOJA.Client.modelHashToDisplayName(modelHash)
    if modelName and modelName:match('%S') then return modelName end
    if carData and carData.plate and tostring(carData.plate):match('%S') then return tostring(carData.plate) end
    return _L('lua.client.list_car')
end

KOJA.Client.buildVehicleListingActions = function(zoneId, carData)
    local listingId = carData.listing_id
    local plate = carData.plate
    local owner = carData.owner
    local testDriveAction = {
        id = 'test_drive',
        icon = 'fas fa-road',
        label = _L('lua.client.test_drive'),
        distance = 2.0,
        canInteract = function()
            return Config.TestDrive and Config.TestDrive.Enabled and not KOJA.Client.testDriveActive
        end,
        onSelect = function()
            if KOJA.Client.startMarketTestDriveFromCarData then
                KOJA.Client.startMarketTestDriveFromCarData(zoneId, carData)
            end
        end,
    }
    local buyerActions = {
        { id = 'contact_seller', icon = 'fas fa-envelope', label = _L('lua.client.contact_seller'), distance = 2.0, onSelect = function()
            TriggerServerEvent('koja_carmarket:server:contactSeller', { listingId = listingId, owner = owner })
        end },
        testDriveAction,
        { id = 'buy_on_site', icon = 'fas fa-shopping-cart', label = _L('lua.client.buy_on_site'), distance = 2.0, onSelect = function()
            local opts = { listingId = listingId, carData = carData }
            TriggerEvent('koja_carmarket:client:openTablet', opts)
        end },
        { id = 'leave_offer', icon = 'fas fa-tag', label = _L('lua.client.leave_offer'), distance = 2.0, onSelect = function()
            local input = Misc.Utils.InputDialog(_L('lua.client.offer'), { { type = 'number', label = _L('lua.client.amount'), required = true } })
            if input and input[1] then KOJA.Client.TriggerServerCallback('koja_carmarket:server:submitOffer', { listingId = listingId, amount = input[1] }, function(r)
                    local ok = r and r.success
                    local msg = ok and _L('lua.client.offer_submitted') or _L('lua.client.error')
                    KOJA.Client.SendNotify({ type = ok and 'success' or 'error', title = msg, desc = msg, time = 5000 })
                end) end
        end },
    }
    local ownerActions = {
        testDriveAction,
        { id = 'edit_offer', icon = 'fas fa-edit', label = _L('lua.client.edit_offer'), distance = 2.0, onSelect = function()
            TriggerEvent('koja_carmarket:client:openTablet', { openToPage = 'my-offers', listingId = listingId })
        end },
        { id = 'remove_listing', icon = 'fas fa-times', label = _L('lua.client.remove_from_exchange'), distance = 2.0, onSelect = function()
            KOJA.Client.TriggerServerCallback('koja_carmarket:server:removeFromMarket', { plate = plate, zoneId = zoneId }, function(r)
                local ok = r and (r.success == true or (r.data and r.data.success == true))
                if ok then
                    local okMsg = _L('lua.client.success')
                    KOJA.Client.SendNotify({ type = 'success', title = okMsg, desc = okMsg, time = 5000 })
                    KOJA.Client.RefreshZone(zoneId)
                else
                    KOJA.Client.SendNotify({ type = 'error', title = _L('lua.client.error'), desc = _L('lua.client.failed_remove'), time = 5000 })
                end
            end)
        end },
    }
    if KOJA.Client.myIdentifier and KOJA.Client.myIdentifier == owner then
        return ownerActions
    end
    return buyerActions
end

KOJA.Client.attachVehicleListingInteraction = function(vehicle, zId, carData, pairKey)
    local key = KOJA.Client.listingKeyFor(carData, pairKey)
    local title = KOJA.Client.resolveListingVehicleName(carData)
    local dt = Config and Config.DrawText
    local pointLabel = (type(dt) == 'table' and type(dt.vehicleText) == 'string' and dt.vehicleText ~= '') and dt.vehicleText or title
    local actions = KOJA.Client.buildVehicleListingActions(zId, carData)
    KojaCarmarketMenus.SetupVehicleListing(vehicle, zId, key, actions, title, pointLabel, 2.5)
    return key
end

KOJA.Client.applyDecodedVehicleProps = function(vehicle, vData)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) or not vData or type(vData) ~= 'table' then return end
    SetVehicleModKit(vehicle, 0)
    if GetResourceState('ox_lib') == 'started' then
        pcall(function()
            exports.ox_lib:setVehicleProperties(vehicle, vData)
        end)
    end
    KOJA.Shared.applyVehicleData(vehicle, vData)
end

KOJA.Client.spawnCarsForZone = function(zonePoint, cars)
    if not cars then return end
    for carKey, carData in pairs(cars) do
        local vData = KOJA.Client.mergeListingVehicleProps(carData)
        local modelHash = tonumber(vData.model) or tonumber(vData.modelHash) or tonumber(vData.hash) or 0
        if not modelHash or modelHash == 0 then
            modelHash = Misc.Utils.ExtractVehicleModelHash(carData.vehicle)
        end
        if not modelHash or modelHash == 0 then goto continue end
        Misc.Utils.LoadModel(modelHash)
        local sx, sy, sz, sh = KOJA.Shared.getVehicleSpawnCoords(zonePoint.id, carData)
        local vehicle = CreateVehicle(modelHash, sx, sy, sz, sh, false, false)
        SetEntityAsMissionEntity(vehicle, true, true)
        KOJA.Client.applyDecodedVehicleProps(vehicle, vData)
        FreezeEntityPosition(vehicle, true)
        SetVehicleDoorsLocked(vehicle, 2)
        SetVehicleNumberPlateText(vehicle, carData.plate)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        local lk = KOJA.Client.attachVehicleListingInteraction(vehicle, zonePoint.id, carData, carKey)
        table.insert(spawnedVehicles[zonePoint.id], { vehicle = vehicle, carData = carData, listingKey = lk })
        ::continue::
    end
end

KOJA.Client.getOrFetchMyIdentifier = function(cb)
    if KOJA.Client.myIdentifier ~= nil then cb(KOJA.Client.myIdentifier) return end
    KOJA.Client.TriggerServerCallback("koja_carmarket:server:getPlayerIdentifier", {}, function(res)
        KOJA.Client.myIdentifier = (res and res.identifier) or ''
        cb(KOJA.Client.myIdentifier)
    end)
end
