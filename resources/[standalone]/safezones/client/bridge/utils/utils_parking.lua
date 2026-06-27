local parkingBlips = {}
local parkingMarkers = {}
local myOwnedSlots = {}

KOJA.Client.refreshMySlots = function()
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getMySlots', {}, function(res)
        myOwnedSlots = {}
        if res and res.slots then
            for _, s in ipairs(res.slots) do
                myOwnedSlots[s.slot_id] = true
            end
        end
        KOJA.Client.updateParkingBlipColors()
    end)
end

KOJA.Client.RefreshMySlots = KOJA.Client.refreshMySlots

KOJA.Client.buildParkingMarkers = function()
    parkingMarkers = {}
    for _, zone in ipairs(Config.Zones) do
        if zone.CarMarketBoxes then
            for _, box in ipairs(zone.CarMarketBoxes) do
                local c = box.coords
                local sz = box.size or vec3(3, 5, 3)
                parkingMarkers[#parkingMarkers + 1] = {
                    x = c.x, y = c.y, z = c.z,
                    sx = sz.x, sy = sz.y,
                    rotation = box.rotation or 0.0,
                    zoneId = zone.id,
                    slotId = box.id
                }
            end
        end
    end
end

KOJA.Client.clearParkingBlips = function()
    for _, entry in ipairs(parkingBlips) do
        local b = type(entry) == 'table' and entry.blip or entry
        if DoesBlipExist(b) then RemoveBlip(b) end
    end
    parkingBlips = {}
end

KOJA.Client.updateParkingBlipColors = function()
    for _, entry in ipairs(parkingBlips) do
        local blip = type(entry) == 'table' and entry.blip or entry
        if not DoesBlipExist(blip) then goto continue end
        local hasOwned = false
        local zones = (type(entry) == 'table' and entry.zones) or Config.Zones
        for _, zone in ipairs(zones or {}) do
            if zone and zone.CarMarketBoxes then
                for _, box in ipairs(zone.CarMarketBoxes) do
                    if box.id and myOwnedSlots[box.id] then hasOwned = true break end
                end
            end
            if hasOwned then break end
        end
        SetBlipColour(blip, hasOwned and 2 or 3)
        ::continue::
    end
end

KOJA.Client.createParkingBlips = function()
    KOJA.Client.clearParkingBlips()
    local sx, sy, sz = 0.0, 0.0, 0.0
    local n = 0
    for _, zone in ipairs(Config.Zones or {}) do
        if zone.CarMarketBoxes and #zone.CarMarketBoxes > 0 then
            for _, box in ipairs(zone.CarMarketBoxes) do
                if box and box.coords then
                    sx = sx + box.coords.x
                    sy = sy + box.coords.y
                    sz = sz + box.coords.z
                    n = n + 1
                end
            end
        end
    end
    if n < 1 then return end

    local blip = AddBlipForCoord(sx / n, sy / n, sz / n)
    SetBlipSprite(blip, 357)
    SetBlipColour(blip, 3)
    SetBlipScale(blip, 0.85)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Car Market')
    EndTextCommandSetBlipName(blip)
    parkingBlips[#parkingBlips + 1] = { blip = blip, zones = Config.Zones }
    KOJA.Client.updateParkingBlipColors()
end

KOJA.Client.drawParkingMarkersLoop = function()
    CreateThread(function()
        while true do
            Wait(0)
            local ped = PlayerPedId()
            local pCoords = GetEntityCoords(ped)
            local draw = false
            for _, m in ipairs(parkingMarkers) do
                local dist = #(pCoords - vector3(m.x, m.y, m.z))
                if dist < 50.0 then
                    draw = true
                    local mine = m.slotId and myOwnedSlots[m.slotId]
                    local r, g, b = 0, 150, 255
                    if mine then r, g, b = 0, 255, 100 end
                    DrawMarker(1, m.x, m.y, m.z - 0.95, 0, 0, 0, 0, 0, m.rotation, m.sx or 2.5, m.sy or 5.0, 0.15, r, g, b, 120, false, false, 2, false, nil, nil, false)
                end
            end
            if not draw then Wait(500) end
        end
    end)
end
