KOJA.Client.clearZoneSpawnedList = function(zoneId)
    local list = spawnedVehicles[zoneId]
    if not list then return end
    for _, entry in ipairs(list) do
        if entry.listingKey then KojaCarmarketMenus.CleanupVehicleListing(zoneId, entry.listingKey) end
        if DoesEntityExist(entry.vehicle) then DeleteEntity(entry.vehicle) end
    end
    spawnedVehicles[zoneId] = nil
end

KOJA.Client.bumpZoneCarsLoadToken = function(zoneId)
    local n = (KOJA.Client.zoneCarsLoadVersion[zoneId] or 0) + 1
    KOJA.Client.zoneCarsLoadVersion[zoneId] = n
    return n
end

KOJA.Client.zoneCarsLoadTokenMatches = function(zoneId, token)
    return KOJA.Client.zoneCarsLoadVersion[zoneId] == token
end

KOJA.Client.SetupZones = function()
    for _, zone in ipairs(Config.Zones or {}) do
        local zoneId = zone.id
        local c = zone.coords

        RequestModel(zone.npc.hash)
        while not HasModelLoaded(zone.npc.hash) do
            Wait(500)
        end
        local ped = CreatePed(4, zone.npc.hash, c.x, c.y, c.z - 1.0, (c.w or 0.0), false, false)
        SetEntityAsMissionEntity(ped, true, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetEntityInvincible(ped, true)
        SetPedFleeAttributes(ped, 0, false)
        SetPedCombatAttributes(ped, 46, true)
        SetPedCanRagdoll(ped, false)
        local scen = zone.npc and zone.npc.scenario
        if type(scen) == 'string' and scen ~= '' then
            TaskStartScenarioInPlace(ped, scen, 0, true)
        end
        FreezeEntityPosition(ped, true)

        local npcTarget = zone.npc and zone.npc.target or nil
        local npcDist = (npcTarget and npcTarget.distance) or 2.0
        local npcIcon = (npcTarget and npcTarget.icon) or 'fas fa-shopping-basket'
        local npcPointLabel = (npcTarget and npcTarget.label) or zone.name or '[E]'
        local npcPointExtras = (npcTarget and type(npcTarget.key) == 'number') and { key = npcTarget.key } or nil
        local npcActions = {
            { id = 'list_car', icon = npcIcon, label = _L('lua.client.list_car'), distance = npcDist, onSelect = function()
                TriggerEvent('koja_carmarket:client:openTablet')
            end },
            { id = 'buy_zone', icon = 'fas fa-crown', label = _L('lua.client.buy_parking_zone'), distance = npcDist, onSelect = function()
                KOJA.Client.TriggerServerCallback('koja_carmarket:server:buyExchangeZone', { zoneId = zoneId }, function(r)
                    if r and r.success and KOJA.Client.RefreshMySlots then KOJA.Client.RefreshMySlots() end
                    local reason = r and r.reason or 'unknown'
                    local reasonLabels = {
                        no_zone = _L('lua.client.invalid_zone'),
                        zone_taken = _L('lua.client.zone_has_owner'),
                        already_owned = _L('lua.client.zone_has_owner'),
                        no_money = _L('lua.client.no_funds_zone'),
                        pay_failed = _L('lua.client.payment_failed')
                    }
                    KOJA.Client.SendNotify({
                        type = (r and r.success) and 'success' or 'error',
                        title = (r and r.success) and _L('lua.client.success') or _L('lua.client.error'),
                        desc = (r and r.success) and _L('lua.client.zone_purchased') or (reasonLabels[reason] or _L('lua.client.zone_purchase_failed')),
                        time = 5000,
                    })
                end)
            end },
            { id = 'buy_slot', icon = 'fas fa-map-pin', label = _L('lua.client.buy_parking_slot'), distance = npcDist, onSelect = function()
                TriggerEvent('koja_carmarket:client:openTablet', { openToPage = 'my-cars', zoneId = (zoneId and tostring(zoneId):match('%S+')) or zoneId })
            end },
        }
        KojaCarmarketMenus.SetupNpc(ped, zoneId, npcActions, zone.name or _L('lua.client.list_car'), npcPointLabel, npcDist, npcPointExtras)
    end

    for j, zonePoint in ipairs(Config.Zones or {}) do
        local zoneRadius = Misc.Utils.GetZoneSpawnRadius(zonePoint)
        local point = KOJA.Client.points.new(
            vec3(zonePoint.coords.x, zonePoint.coords.y, zonePoint.coords.z),
            zoneRadius,
            {
                resource = GetCurrentResourceName(),
                onEnter = function()
                    KOJA.Client.clearZoneSpawnedList(zonePoint.id)
                    spawnedVehicles[zonePoint.id] = {}
                    local loadToken = KOJA.Client.bumpZoneCarsLoadToken(zonePoint.id)
                    KOJA.Client.TriggerServerCallback("koja_carmarket:server:getCarsInZone", { zoneId = zonePoint.id }, function(res)
                        if not KOJA.Client.zoneCarsLoadTokenMatches(zonePoint.id, loadToken) then return end
                        local cars = res and (res.data or res)
                        if not cars or res and res.success == false then return end
                        KOJA.Client.spawnCarsForZone(zonePoint, cars)
                    end)
                end,
                onExit = function()
                    KOJA.Client.bumpZoneCarsLoadToken(zonePoint.id)
                    KOJA.Client.clearZoneSpawnedList(zonePoint.id)
                end
            }
        )
        KOJA.Client.points[j] = point
    end
end

KOJA.Client.RefreshZone = function(zoneId)
    KOJA.Client.clearZoneSpawnedList(zoneId)
    spawnedVehicles[zoneId] = {}
    local loadToken = KOJA.Client.bumpZoneCarsLoadToken(zoneId)
    KOJA.Client.TriggerServerCallback("koja_carmarket:server:getCarsInZone", { zoneId = zoneId }, function(res)
        if not KOJA.Client.zoneCarsLoadTokenMatches(zoneId, loadToken) then return end
        local cars = res and (res.data or res)
        if not cars or (res and res.success == false) then return end
        local zonePoint = Misc.Utils.GetZoneById(zoneId)
        if not zonePoint then return end
        KOJA.Client.spawnCarsForZone(zonePoint, cars)
    end)
end

CreateThread(function()
    KOJA.Client.getOrFetchMyIdentifier(function() end)
    KOJA.Client.SetupZones()
    KOJA.Client.buildParkingMarkers()
    KOJA.Client.createParkingBlips()
    KOJA.Client.drawParkingMarkersLoop()
    Wait(2000)
    KOJA.Client.refreshMySlots()
    for _ = 1, 5 do
        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)
        if pCoords and (pCoords.x ~= 0 or pCoords.y ~= 0) then
            for _, zonePoint in ipairs(Config.Zones or {}) do
                local radius = Misc.Utils.GetZoneSpawnRadius(zonePoint)
                local c = zonePoint.coords
                if c and #(pCoords - vector3(c.x, c.y, c.z)) <= radius then
                    KOJA.Client.RefreshZone(zonePoint.id)
                    break
                end
            end
            break
        end
        Wait(1000)
    end
end)

CreateThread(function()
    while true do
        Wait(60000)
        KOJA.Client.refreshMySlots()
    end
end)
