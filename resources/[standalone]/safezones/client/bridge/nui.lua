KOJA.Client.GarageListingCache = KOJA.Client.GarageListingCache or {}
KOJA.Client.GarageListingCacheByPlate = KOJA.Client.GarageListingCacheByPlate or {}

KOJA.Client.ensureRespNameFromClient = function(veh)
    if not veh or not (KOJA.Shared and KOJA.Shared.enrichRespname) then return end
    if not veh.model and veh.vehicle_data and veh.vehicle_data.model then
        veh.model = veh.vehicle_data.model
    end
    local rn = veh.respname and tostring(veh.respname)
    if (not veh.model or tonumber(veh.model) == nil) and rn and rn:match('^%-?%d+$') then
        veh.model = tonumber(rn)
    end
    local isGeneric = (not rn) or rn == "" or string.lower(rn) == "vehicle" or rn:match("^-?%d+$")
    if not isGeneric and not rn:match("^-?%d+$") then return end
    if KOJA.Client and KOJA.Client.modelHashToDisplayName then
        local modelHash = tonumber(veh.model)
        local resolved = KOJA.Client.modelHashToDisplayName(modelHash)
        if resolved and tostring(resolved):match("%S+") then
            veh.respname = resolved
            local n = veh.name and tostring(veh.name) or ""
            local nameGeneric = (n == "" or n:match("^Vehicle") or string.lower(n) == "vehicle" or n:match("^%-?%d+$"))
            if nameGeneric then
                veh.name = resolved
            end
            return
        end
    end
    KOJA.Shared.enrichRespname(veh)
    local n = veh.name and tostring(veh.name) or ""
    local nameGeneric = (n == "" or n:match("^Vehicle") or string.lower(n) == "vehicle" or n:match("^%-?%d+$"))
    if veh.respname and tostring(veh.respname):match("%S+") and nameGeneric then
        veh.name = veh.respname
    end
end

function KOJA.Client.prepareVehicleForNui(veh, opts)
    if not veh or type(veh) ~= "table" then return end
    KOJA.Shared.enrichVehicleData(veh)
    KOJA.Client.forceVehicleCategoryFromModel(veh)
    KOJA.Client.ensureRespNameFromClient(veh)
    KOJA.Client.finalizeVehiclePresentationForNui(veh, opts)
end

function KOJA.Client.pushParkingLocationsToNui()
    KOJA.Client.TriggerServerCallback("koja_carmarket:server:getParkingLocations", {}, function(parkingData)
        if not parkingData then return end
        for _, zone in pairs(parkingData) do
            if zone and zone.spaces then
                for _, ps in ipairs(zone.spaces) do
                    if ps.vehicle then KOJA.Client.prepareVehicleForNui(ps.vehicle) end
                end
            end
        end
        KOJA.Client.SendReactMessage("koja_carmarket:nui:getParkingLocations", parkingData)
    end)
end

function KOJA.Client.refreshWorldZoneAndParkingNui(zoneId)
    if zoneId and KOJA.Client.RefreshZone then KOJA.Client.RefreshZone(zoneId) end
    CreateThread(function()
        Wait(200)
        KOJA.Client.pushParkingLocationsToNui()
    end)
end

function KOJA.Client.finalizeVehiclePresentationForNui(veh, opts)
    if not veh or type(veh) ~= "table" or not KOJA.Shared then return end
    opts = opts or {}
    local vd = type(veh.vehicle_data) == "table" and veh.vehicle_data or nil
    local slug = KOJA.Shared.normalizeVehicleCategorySlug(veh.car_type, vd)
    veh.car_type = slug
    if vd then
        vd.car_type = slug
    end
    KOJA.Client.normalizeUiTypeKeys(veh)
    local storedDrive = (vd and vd.drive_type) or veh.drive_type
    local driveResolved = KOJA.Shared.coalesceDriveType(slug, storedDrive)
    if vd then
        vd.drive_type = driveResolved
    end
    veh.drive_type = driveResolved
    local rawFuel = (vd and vd.fuel_type) or veh.fuel_type
    local fuelSlug = KOJA.Shared.wireFuelSlugGasOrElectric(rawFuel)
    if vd then
        vd.fuel_type = fuelSlug
    end
    KOJA.Client.ensureAccentColorFromType(veh)
    veh.car_type = slug
    veh.fuel_type = KOJA.Shared.marketEnumDisplayLabel(fuelSlug)
    veh.drive_type = KOJA.Shared.marketEnumDisplayLabel(driveResolved)
    if opts.garageCache then
        local mid = veh.model or (vd and vd.model)
        local cacheEntry = {
            model = mid and tonumber(mid) or nil,
            car_type = slug,
            drive_type = driveResolved,
        }
        local nid = veh.id ~= nil and tonumber(veh.id) or nil
        if nid then
            KOJA.Client.GarageListingCache[nid] = cacheEntry
        end
        local pl = veh.plate and tostring(veh.plate):gsub("%s+", ""):upper() or ""
        if pl ~= "" then
            KOJA.Client.GarageListingCacheByPlate[pl] = cacheEntry
        end
    end
    KOJA.Client.rebuildMarketTagsForVehicle(veh)
end

function KOJA.Client.rebuildMarketTagsForVehicle(veh)
    if not veh or type(veh) ~= "table" then return end
    local out = KOJA.Shared.buildPresentationTagLabelsForVehicle(veh)
    if type(veh.tags) == "table" and type(veh.tags.list) == "table" then
        veh.tags.list = out
    else
        veh.tags = out
    end
end

function KOJA.Client.ensureAccentColorFromType(veh)
    if not veh or type(veh) ~= 'table' then return end
    if veh.color and tostring(veh.color):match('^#%x%x%x%x%x%x$') then return end
    local c = KOJA.Shared.resolveAccentHexForVehicle(veh)
    if c then
        veh.color = c
    end
end

function KOJA.Client.normalizeUiTypeKeys(veh)
    if not veh or type(veh) ~= 'table' then return end
    local vd = type(veh.vehicle_data) == 'table' and veh.vehicle_data or nil
    local src = (vd and vd.car_type) or veh.car_type
    local n = KOJA.Shared.normalizeVehicleCategorySlug(src, vd)
    if n and n ~= '' then
        veh.car_type = n
        if vd then
            vd.car_type = n
        end
    end
end

function KOJA.Client.forceVehicleCategoryFromModel(veh)
    if not veh or type(veh) ~= 'table' then return end
    if KOJA.Shared and type(KOJA.Shared.applyCategoryFromModelToVehicle) == 'function' then
        KOJA.Shared.applyCategoryFromModelToVehicle(veh)
        KOJA.Client.normalizeUiTypeKeys(veh)
        return
    end
end

KOJA.Client.SendReactMessage = function(action, data)
    SendNUIMessage({ action = action, data = data })
end

KOJA.Client.closeUI = function()
    SetNuiFocus(false, false)
    KOJA.Client.setVisibility(false)
    KOJA.Client.Visible = false
end

KOJA.Client.setVisibility = function(isVisible)
    KOJA.Client.Visible = isVisible
    KOJA.Client.SendReactMessage('koja_carmarket:nui:Visibility', isVisible)
end

KOJA.Client.openTablet = function(opts)
    SetNuiFocus(true, true)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getPlayerName', {}, function(result)
        local playerName = (result and result.playerName) or ''
        KOJA.Client.SendReactMessage('koja_carmarket:nui:setPlayerInfo', { playerName = playerName })
    end)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getParkingLocations', {}, function(data)
        if data then
            for zoneId, zone in pairs(data) do
                if zone and zone.spaces then 
                    for _, ps in ipairs(zone.spaces) do 
                        if ps.vehicle then
                            KOJA.Client.prepareVehicleForNui(ps.vehicle)
                        end
                    end 
                end
            end
        end
        KOJA.Client.SendReactMessage('koja_carmarket:nui:getParkingLocations', data or {})
    end)
    if opts then
        local openToPageData = {}
        if opts.openToPage then
            openToPageData.page = opts.openToPage
            if opts.zoneId then openToPageData.zoneId = tostring(opts.zoneId) end
            if opts.listingId then openToPageData.editListingId = tonumber(opts.listingId) or opts.listingId end
        elseif opts.listingId then
            openToPageData.page = 'market-view'
            openToPageData.vehicleId = tonumber(opts.listingId) or opts.listingId
        end
        if openToPageData.page then
            KOJA.Client.SendReactMessage('koja_carmarket:nui:openToPage', openToPageData)
        end
    end
    CreateThread(function()
        KOJA.Client.setVisibility(true)
    end)
end

KOJA.Client.closeTablet = function()
    KOJA.Client.closeUI()
end

RegisterNetEvent('koja_carmarket:client:openTablet', function(opts)
    KOJA.Client.openTablet(opts)
end)

RegisterCommand('carmarket', function()
    KOJA.Client.openTablet()
end, false)

RegisterNUICallback('closeTablet', function(_, cb)
    KOJA.Shared.KojaCarmarketDebug('NUI closeTablet')
    SetNuiFocus(false, false)
    KOJA.Client.Visible = false
    KOJA.Client.SendReactMessage('koja_carmarket:nui:Visibility', false)
    cb({ success = true })
end)

RegisterNUICallback('koja_carmarket:nui:ready', function(_, cb)
    KOJA.Client.setVisibility(KOJA.Client.Visible or false)
    local customImages = {}
    if Config and type(Config.CustomVehicleImages) == 'table' then
        for _, name in ipairs(Config.CustomVehicleImages) do
            if type(name) == 'string' and name ~= '' then
                customImages[#customImages + 1] = string.lower(name)
            end
        end
    end
    KOJA.Client.SendReactMessage('koja_carmarket:nui:setAppConfig', {
        customVehicleImages = customImages,
    })
    cb({ success = true })
end)

RegisterNUICallback('koja_carmarket:nui:getVehicleData', function(data, cb)
    if data and type(data.filters) == 'table' then
        local f = data.filters
        if data.priceRange == nil then data.priceRange = f.priceRange end
        if data.distanceRange == nil then data.distanceRange = f.distanceRange end
        if data.carTypes == nil then data.carTypes = f.carTypes end
        if data.driveTypes == nil then data.driveTypes = f.driveTypes end
        if data.fuelTypes == nil then data.fuelTypes = f.fuelTypes end
        if data.offerTypes == nil then data.offerTypes = f.offerTypes end
        if data.page == nil then data.page = f.page end
    end
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getFilteredVehicles', {
        page = data.page or 1,
        priceRange = data.priceRange,
        distanceRange = data.distanceRange,
        carTypes = data.carTypes,
        driveTypes = data.driveTypes,
        fuelTypes = data.fuelTypes,
        offerTypes = data.offerTypes,
    }, function(result)
        if result then
            if result.vehicles then
                KOJA.Shared.KojaCarmarketDebug('[market] results totalPages=' .. tostring(result.totalPages) .. ' count=' .. tostring(#result.vehicles))
                for _, veh in ipairs(result.vehicles) do
                    KOJA.Client.prepareVehicleForNui(veh)
                end
                for i, veh in ipairs(result.vehicles) do
                    KOJA.Shared.KojaCarmarketDebug(
                        '[market][' ..
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
            end
            KOJA.Client.SendReactMessage('koja_carmarket:nui:setMarketData', result)
        end
        cb({ success = true })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:getVehicleViewData', function(data, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getVehicleViewData', { vehicleId = data.vehicleId }, function(result)
        if result and result.success and result.vehicle then
            if result.vehicle.vehicle_data and result.vehicle.vehicle_data.model then result.vehicle.model = result.vehicle.vehicle_data.model end
            KOJA.Client.prepareVehicleForNui(result.vehicle)
            KOJA.Client.SendReactMessage('koja_carmarket:nui:setMarketViewData', result)
            cb({ success = true })
        else
            if result and result.success then KOJA.Client.SendReactMessage('koja_carmarket:nui:setMarketViewData', result) end
            cb({ success = result and result.success or false })
        end
    end)
end)

RegisterNUICallback('koja_carmarket:nui:getMyOffers', function(_, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getMyOffers', {}, function(result)
        if result then
            if result.vehicles then
                for _, veh in ipairs(result.vehicles) do
                    KOJA.Client.prepareVehicleForNui(veh)
                end
            end
            KOJA.Client.SendReactMessage('koja_carmarket:nui:setMyOffersData', result)
        end
        cb({ success = true })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:deleteMyOffer', function(data, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:deleteMyOffer', { vehicleId = data.vehicleId }, function(result)
        local ok = result and result.success
        if ok then
            if result.zoneId and KOJA.Client.RefreshZone then KOJA.Client.RefreshZone(result.zoneId) end
            CreateThread(function()
                Wait(200)
                KOJA.Client.TriggerServerCallback('koja_carmarket:server:getParkingLocations', {}, function(parkingData)
                    if parkingData then
                        for zoneId, zone in pairs(parkingData) do
                            if zone and zone.spaces then
                                for _, ps in ipairs(zone.spaces) do
                                    if ps.vehicle then
                                        KOJA.Client.prepareVehicleForNui(ps.vehicle)
                                    end
                                end
                            end
                        end
                        KOJA.Client.SendReactMessage('koja_carmarket:nui:getParkingLocations', parkingData)
                    end
                end)
            end)
        end
        cb({ success = ok == true, reason = result and result.reason })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:buyVehicle', function(data, cb)
    KOJA.Shared.KojaCarmarketDebug(json.encode(data))
    if not data or data.listingId == nil then
        KOJA.Shared.KojaCarmarketDebug('^1buyVehicle invalid data')
        cb({ success = false, reason = 'invalid_data' })
        return
    end
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:buyVehicle', { listingId = data.listingId     }, function(result)
        KOJA.Shared.KojaCarmarketDebug(json.encode(result))
        if result and result.success then
            KOJA.Shared.KojaCarmarketDebug('buyVehicle success')
            cb({ success = true })
        else
            KOJA.Shared.KojaCarmarketDebug('buyVehicle error:', result and result.reason or 'unknown_error')
            cb({ success = false, reason = result and result.reason or 'unknown_error' })
            return
        end
    end)
end)

RegisterNUICallback('koja_carmarket:nui:submitOffer', function(data, cb)
    local listingId = tonumber(data.listingId or data.listing_id)
    local amount = tonumber(data.amount)
    if not listingId or not amount or amount < 1 then
        cb({ success = false })
        return
    end
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:submitOffer', { listingId = listingId, amount = amount }, function(result)
        cb(result and result.success and result or { success = false })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:editMyOffer', function(data, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:editMyOffer', {
        vehicleId = data.vehicleId,
        price = data.price,
        tags = data.tags or {},
    }, function()
        cb({ success = true })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:getGarageVehicles', function(data, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getGarageVehicles', { page = data.page or 1 }, function(result)
        if result and result.vehicles then
            for _, veh in ipairs(result.vehicles) do
                KOJA.Client.prepareVehicleForNui(veh, { garageCache = true })
            end
        end
        if result then KOJA.Client.SendReactMessage('koja_carmarket:nui:setGarageData', result) end
        cb({ success = true })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:createOffer', function(data, cb)
    local vehicleId = data.vehicleId or data.vehicle_id
    if vehicleId then vehicleId = tonumber(vehicleId) end

    if data then
        local g = nil
        if vehicleId then
            g = KOJA.Client.GarageListingCache[vehicleId]
        end
        if not g and data.plate then
            local pl = tostring(data.plate):gsub('%s+', ''):upper()
            if pl ~= '' then
                g = KOJA.Client.GarageListingCacheByPlate[pl]
            end
        end
        if g then
            if g.model then
                data.model = g.model
            end
            if g.car_type and tostring(g.car_type):match('%S+') then
                data.car_type = g.car_type
            end
            if g.drive_type and tostring(g.drive_type):match('%S+') then
                data.drive_type = g.drive_type
            end
        end

        local modelHash = tonumber(data.model) or tonumber(data.modelHash) or tonumber(data.hash)
        if not modelHash then
            local rn = data.respname and tostring(data.respname):match('%S+')
            if rn then modelHash = GetHashKey(rn) end
        end
        if (not data.car_type or tostring(data.car_type) == '') and modelHash and KOJA.Shared and type(KOJA.Shared.resolveVehicleCategorySlugFromModel) == 'function' then
            local slug = KOJA.Shared.resolveVehicleCategorySlugFromModel(modelHash)
            if slug and tostring(slug):match('%S+') then
                data.car_type = slug
            end
        end

        if (not data.drive_type or tostring(data.drive_type) == '') and KOJA.Shared and type(KOJA.Shared.defaultDriveTypeForCategorySlug) == 'function' then
            data.drive_type = KOJA.Shared.defaultDriveTypeForCategorySlug(data.car_type)
        end
    end

    local payloadRespname = data.respname
    if (not payloadRespname or tostring(payloadRespname) == '' or string.lower(tostring(payloadRespname)) == 'vehicle') and KOJA.Client and KOJA.Client.modelHashToDisplayName then
        local modelHash = tonumber(data.model) or tonumber(data.modelHash) or tonumber(data.hash) or tonumber(data.vehicle and data.vehicle.model) or tonumber(data.vehicle_data and data.vehicle_data.model)
        local resolved = modelHash and KOJA.Client.modelHashToDisplayName(modelHash) or nil
        if resolved and tostring(resolved):match('%S+') then
            payloadRespname = resolved
        end
    end
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:createOffer', {
        vehicleId = vehicleId,
        plate = data.plate,
        respname = payloadRespname,
        name = data.name,
        price = data.price,
        car_type = data.car_type,
        drive_type = data.drive_type,
        description = data.description or '',
        offerType = data.offerType or 'buy',
        auctionPrice = data.auctionPrice,
        auctionStart = data.auctionStart,
        auctionEnd = data.auctionEnd,
    }, function(result)
        cb(result and result.success and result or { success = false })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:getMyCarsData', function(data, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getMyCarsData', {
        zoneId = data.zoneId,
        parkingPage = data.parkingPage or 1,
        vehiclesPage = data.vehiclesPage or 1,
    }, function(result)
        if result then
            if result.vehicles then
                for _, veh in ipairs(result.vehicles) do
                    KOJA.Client.prepareVehicleForNui(veh)
                end
            end
            if result.parkingSpaces then
                for _, ps in ipairs(result.parkingSpaces) do
                    if ps.vehicle then
                        KOJA.Client.prepareVehicleForNui(ps.vehicle)
                    end
                end
            end
            KOJA.Client.SendReactMessage('koja_carmarket:nui:setMyCarsData', result)
        end
        cb({ success = true })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:getMyCarsParking', function(data, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getMyCarsParking', { zoneId = data.zoneId, page = data.page or 1 }, function(result)
        if result and result.spaces then
            for _, ps in ipairs(result.spaces) do
                if ps.vehicle then
                    KOJA.Client.prepareVehicleForNui(ps.vehicle)
                end
            end
        end
        if result then KOJA.Client.SendReactMessage('koja_carmarket:nui:setMyCarsParking', result) end
        cb({ success = true })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:getMyCarsVehicles', function(data, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getMyCarsVehicles', { page = data.page or 1 }, function(result)
        if result and result.vehicles then
            for _, veh in ipairs(result.vehicles) do
                KOJA.Client.prepareVehicleForNui(veh)
            end
        end
        if result then KOJA.Client.SendReactMessage('koja_carmarket:nui:setMyCarsVehicles', result) end
        cb({ success = true })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:purchaseParkingSlot', function(data, cb)
    KOJA.Shared.KojaCarmarketDebug('purchaseParkingSlot', json.encode(data or {}))
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:buySlot', {
        slot = data.slot,
        duration = data.duration,
        zoneId = data.zoneId,
    }, function(result)
        if result and result.success then
            if KOJA.Client.RefreshMySlots then KOJA.Client.RefreshMySlots() end
            CreateThread(function()
                Wait(200)
                KOJA.Client.TriggerServerCallback('koja_carmarket:server:getParkingLocations', {}, function(parkingData)
                    if parkingData then
                        for zoneId, zone in pairs(parkingData) do
                            if zone and zone.spaces then
                                for _, ps in ipairs(zone.spaces) do
                                    if ps.vehicle then
                                        KOJA.Client.prepareVehicleForNui(ps.vehicle)
                                    end
                                end
                            end
                        end
                        KOJA.Client.SendReactMessage('koja_carmarket:nui:getParkingLocations', parkingData)
                    end
                end)
            end)
        end
        cb({ success = result and result.success, slot = data.slot, duration = data.duration, zoneId = data.zoneId })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:assignVehicleToSlot', function(data, cb)
    KOJA.Shared.KojaCarmarketDebug('assignVehicleToSlot', json.encode(data or {}))
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:assignVehicleToSlot', {
        zoneId = data.zoneId,
        plate = data.plate,
        slot = data.slot,
    }, function(result)
        KOJA.Shared.KojaCarmarketDebug('assignVehicleToSlot result', json.encode(result or {}))
        if result and result.success then
            KOJA.Client.refreshWorldZoneAndParkingNui(result.zoneId or data.zoneId)
        end
        cb(result and result.success and result or { success = false })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:unassignVehicleFromSlot', function(data, cb)
    KOJA.Client.TriggerServerCallback("koja_carmarket:server:unassignVehicleFromSlot", { zoneId = data.zoneId, slot = data.slot }, function(result)
        if result and result.success then
            KOJA.Client.refreshWorldZoneAndParkingNui(result.zoneId or data.zoneId)
            KOJA.Client.SendNotify({
                type = "success",
                title = _L("lua.client.vehicle_removed_from_slot_title"),
                desc = _L("lua.client.vehicle_removed_from_slot_desc"),
                time = 5000,
            })
        end
        cb(result and result.success and result or { success = false })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:getStatisticsData', function(data, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getStatisticsData', {
        page = data.page or 1,
        limit = data.limit or 5
    }, function(result)
        if result then
            if result.logs and type(result.logs) == "table" then
                for _, log in ipairs(result.logs) do KOJA.Client.prepareVehicleForNui(log) end
            end
            KOJA.Client.SendReactMessage('koja_carmarket:nui:setStatisticsData', result)
        end
        cb({ success = true })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:getExchangeOwnerPanel', function(_, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getExchangeOwnerPanel', {}, function(result)
        if result then
            KOJA.Client.SendReactMessage('koja_carmarket:nui:setExchangeOwnerPanel', result)
        end
        cb({ success = true, data = result or {} })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:getExchange', function(data, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getExchange', { zoneId = data.zoneId }, function(result)
        cb(result or { success = false })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:updateExchange', function(data, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:updateExchange', {
        zoneId = data.zoneId,
        owner_identifier = data.owner_identifier,
        listing_fee_per_week = data.listing_fee_per_week,
        max_listings = data.max_listings,
        commission_percent = data.commission_percent,
    }, function(result)
        cb(result or { success = false })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:buyParking', function(data, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:buyParking', {
        zoneId = data.zoneId,
        name = data.name
    }, function(result)
        if result and result.success and KOJA.Client.RefreshMySlots then
            KOJA.Shared.KojaCarmarketDebug('buyParking: refresh my slots')
            KOJA.Client.RefreshMySlots()
        end
        cb(result or { success = false })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:getMyParkings', function(_, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getMyParkings', {}, function(result)
        cb(result or { success = false, parkings = {} })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:getParkingSlots', function(data, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getParkingSlots', {
        parkingId = data.parkingId
    }, function(result)
        cb(result or { success = false, slots = {} })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:addParkingSlot', function(data, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:addParkingSlot', {
        parkingId = data.parkingId,
        coords = data.coords,
        heading = data.heading
    }, function(result)
        if result and result.success and KOJA.Client.RefreshMySlots then KOJA.Client.RefreshMySlots() end
        cb(result or { success = false })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:updateParkingSlot', function(data, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:updateParkingSlot', {
        parkingId = data.parkingId,
        slotIndex = data.slotIndex,
        coords = data.coords,
        heading = data.heading
    }, function(result)
        cb(result or { success = false })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:buySlot', function(data, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:buySlot', {
        slotId = data.slotId,
        zoneId = data.zoneId
    }, function(result)
        if result and result.success then
            if KOJA.Client.RefreshMySlots then KOJA.Client.RefreshMySlots() end
            CreateThread(function()
                Wait(200)
                KOJA.Client.TriggerServerCallback('koja_carmarket:server:getParkingLocations', {}, function(parkingData)
                    if parkingData then
                        for zoneId, zone in pairs(parkingData) do
                            if zone and zone.spaces then
                                for _, ps in ipairs(zone.spaces) do
                                    if ps.vehicle then
                                        KOJA.Client.prepareVehicleForNui(ps.vehicle)
                                    end
                                end
                            end
                        end
                        KOJA.Client.SendReactMessage('koja_carmarket:nui:getParkingLocations', parkingData)
                    end
                end)
            end)
        end
        cb(result or { success = false })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:getMySlots', function(_, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getMySlots', {}, function(result)
        cb(result or { success = false, slots = {} })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:getAllSlotStatuses', function(data, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getAllSlotStatuses', {
        zoneId = data.zoneId
    }, function(result)
        cb(result or { success = false, statuses = {} })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:moveCarToSlot', function(data, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:moveCarToSlot', {
        plate = data.plate,
        targetSlotId = data.targetSlotId
    }, function(result)
        if result and result.success and result.zoneId then
            KOJA.Client.RefreshZone(result.zoneId)
        end
        cb(result or { success = false })
    end)
end)

RegisterNUICallback('koja_carmarket:nui:removeParkingSlot', function(data, cb)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:removeParkingSlot', {
        parkingId = data.parkingId,
        slotIndex = data.slotIndex
    }, function(result)
        cb(result or { success = false })
    end)
end)

do
    if not KOJA then KOJA = {} end
    if not KOJA.Client then KOJA.Client = {} end
    KOJA.Client.OpenCarMarketTablet = KOJA.Client.openTablet
end
