local thisResource = GetCurrentResourceName()
local url = ("nui://%s/web/build/dui.html"):format(thisResource)
local DuiVisible = false
local RenderCoords = nil
SharedDuiInstance = nil

KOJA.Client.StartRenderLoop = function(coords)
    RenderCoords = coords

    if DuiVisible then
        return
    end

    DuiVisible = true

    CreateThread(function()
        while DuiVisible do
            Wait(1)
            local c = RenderCoords
            if not c then break end
            if not c.x then break end
            SetDrawOrigin(c.x, c.y, c.z + 0.25)

            local scale = 3.5

            local x, y = 0.0, 0.0
            local width = 2 * (0.030 * scale)
            local height = GetTextScaleHeight(1 * scale, 0) - 0.005

            DrawSprite(
                SharedDuiInstance.txd,
                SharedDuiInstance.txn,
                x, y,
                width, height,
                0.0,
                255, 255, 255, 255
            )

            ClearDrawOrigin()
        end
    end)
end

KOJA.Client.StopRenderLoop = function()
    DuiVisible = false
    RenderCoords = nil
end

local hideToken = 0

KOJA.Client.HideDuiAnimated = function()
    hideToken = hideToken + 1
    if not DuiVisible then return end
    if SharedDuiInstance then
        SharedDuiInstance:sendMessage({ action = 'koja-carmarket:dui:hide' })
    end
    local myToken = hideToken
    SetTimeout(480, function()
        if myToken == hideToken then
            KOJA.Client.StopRenderLoop()
        end
    end)
end

CreateThread(function()
    SharedDuiInstance = KOJA.Client.CreateDui({
        url = url,
        width = 1536,
        height = 768
    })

    if SharedDuiInstance and SharedDuiInstance.setUrl then
        SharedDuiInstance:setUrl(url)
    end
end)

local function dateToEpoch(y, mo, d, h, mi, s)
    local days = 0
    for yy = 1970, y - 1 do
        days = days + (((yy % 4 == 0 and yy % 100 ~= 0) or yy % 400 == 0) and 366 or 365)
    end
    local mdays = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
    if (y % 4 == 0 and y % 100 ~= 0) or y % 400 == 0 then mdays[2] = 29 end
    for mm = 1, mo - 1 do days = days + mdays[mm] end
    days = days + (d - 1)
    return days * 86400 + h * 3600 + mi * 60 + s
end

local function relativeTimeLabel(listedAt)
    local ts = nil
    if type(listedAt) == 'number' then
        ts = listedAt
    elseif type(listedAt) == 'string' then
        local y, mo, d, h, mi, s = tostring(listedAt):match('(%d+)%D+(%d+)%D+(%d+)%D+(%d+)%D+(%d+)%D*(%d*)')
        if not y then
            y, mo, d = tostring(listedAt):match('(%d+)%D+(%d+)%D+(%d+)')
            h, mi, s = 0, 0, 0
        end
        if y then
            ts = dateToEpoch(tonumber(y), tonumber(mo), tonumber(d), tonumber(h) or 0, tonumber(mi) or 0, tonumber(s) or 0)
        end
    end
    if not ts then return nil end
    local now = GetCloudTimeAsInt and GetCloudTimeAsInt() or ts
    local diff = now - ts
    if diff < 0 then diff = 0 end
    if diff < 60 then return 'just now' end
    local mins = math.floor(diff / 60)
    if mins < 60 then return mins .. 'm ago' end
    local hours = math.floor(diff / 3600)
    if hours < 24 then return hours .. 'h ago' end
    local days = math.floor(diff / 86400)
    if days < 7 then return days .. 'd ago' end
    if days < 30 then return math.floor(days / 7) .. 'w ago' end
    if days < 365 then return math.floor(days / 30) .. 'mo ago' end
    return math.floor(days / 365) .. 'y ago'
end

KOJA.Client.BuildDuiInfo = function(cd)
    local info = {}
    local L = rawget(_G, '_L') or rawget(_G, 'getTranslation')
    local duiLbl = function(k, fallback) return (L and L(k)) or fallback end
    local listedAt = cd and (cd.listedAt or cd.listed_at or cd.created_at or cd.createdAt)
    if listedAt ~= nil then
        local rel = relativeTimeLabel(listedAt)
        if rel then
            info[#info+1] = { id = 'listed_at', value = rel, label = duiLbl('ui.market_view.listed_at', 'Listed') }
        end
    end
    if cd.fuel_type and cd.fuel_type ~= '' then info[#info+1] = { id = 'fuel_type', value = KOJA.Shared.marketEnumDisplayLabel(cd.fuel_type), label = duiLbl('ui.market_view.fuel_type', 'Fuel type') } end
    if cd.mileage then info[#info+1] = { id = 'mileage', value = tostring(cd.mileage) .. ' km', label = duiLbl('ui.market_view.mileage', 'Mileage') } end
    if cd.drive_type and cd.drive_type ~= '' then info[#info+1] = { id = 'drive_type', value = KOJA.Shared.marketEnumDisplayLabel(cd.drive_type), label = duiLbl('ui.market_view.drive', 'Drive') } end
    if cd.car_type and cd.car_type ~= '' then info[#info+1] = { id = 'car_type', value = KOJA.Shared.marketEnumDisplayLabel(cd.car_type), label = duiLbl('ui.market_view.car_type', 'Type') } end
    if cd.plate and cd.plate ~= '' then info[#info+1] = { id = 'plate', value = cd.plate, label = duiLbl('ui.market_view.plate', 'Plate') } end
    if cd.transmission and cd.transmission ~= '' then info[#info+1] = { id = 'transmission', value = cd.transmission, label = duiLbl('ui.market_view.transmission', 'Transmission') } end
    local mainIds = { fuel_type = true, mileage = true, drive_type = true, car_type = true, plate = true, transmission = true }
    if cd.extra_info and #cd.extra_info > 0 then
        for _, e in ipairs(cd.extra_info) do
            local id = e.id
            local val = e.value
            if (not id or id == '') and e.label and tostring(e.label):match('%S') then
                id = (tostring(e.label):gsub('%s+', '_'):gsub('[^%w_]', ''):lower())
            end
            if id and val and not mainIds[id] then
                local displayVal = tostring(val)
                local colorIds = { primary_color = true, secondary_color = true, pearlescent = true, wheel_color = true, dashboard = true, interior = true }
                local idNorm = (id and tostring(id):gsub('%s+', '_'):gsub('[^%w_]', ''):lower()) or ''
                if colorIds[id] or colorIds[idNorm] or (tostring(id or ''):lower():match('color') or tostring(id or ''):lower():match('pearlescent') or tostring(id or ''):lower():match('dashboard') or tostring(id or ''):lower():match('interior') or tostring(id or ''):lower():match('wheel')) then
                    local resolved = KOJA.Shared.duiColorIdToName(val)
                    if resolved and resolved ~= '' then displayVal = resolved end
                end
                info[#info+1] = { id = id, value = displayVal, label = e.label and tostring(e.label):match('%S') and e.label or nil }
            end
        end
    end
    return info
end

local currentDuiVehicle = nil
CreateThread(function()
    while true do
        if not SharedDuiInstance then
            Wait(1000)
            goto continue
        end
        if Misc.Utils.CountSpawnedMarketVehicles(spawnedVehicles) < 1 then
            if currentDuiVehicle ~= nil then
                currentDuiVehicle = nil
                KOJA.Client.HideDuiAnimated()
            end
            Wait(1500)
            goto continue
        end
        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)
        if Misc.Utils.MinDistanceToCarMarketZones(pCoords) > 95.0 then
            if currentDuiVehicle ~= nil then
                currentDuiVehicle = nil
                KOJA.Client.HideDuiAnimated()
            end
            Wait(1000)
            goto continue
        end
        Wait(250)
        local bestEntry = nil
        local bestDist = 2.0
        for _, list in pairs(spawnedVehicles) do
            if type(list) == 'table' then
                for _, entry in ipairs(list) do
                    if entry.vehicle and DoesEntityExist(entry.vehicle) then
                        local vCoords = GetEntityCoords(entry.vehicle)
                        local dist = #(pCoords - vCoords)
                        if dist < bestDist then
                            bestDist = dist
                            bestEntry = entry
                        end
                    end
                end
            end
        end
        if bestEntry and bestEntry.carData then
            if currentDuiVehicle ~= bestEntry.vehicle or bestEntry.carData._duiDirty then
                hideToken = hideToken + 1
                currentDuiVehicle = bestEntry.vehicle
                local cd = bestEntry.carData
                local info = KOJA.Client.BuildDuiInfo(cd)
                KOJA.Shared.KojaCarmarketDebug(json.encode(info))
                local respname = cd.respname
                if not respname or tostring(respname) == '' then
                    local modelHash = Misc.Utils.ExtractVehicleModelHash(cd.vehicle)
                    if modelHash and modelHash ~= 0 then
                        local dn = GetDisplayNameFromVehicleModel(modelHash)
                        if dn and dn ~= '' then respname = string.lower(dn) end
                    end
                end
                SharedDuiInstance:sendMessage({
                    action = 'koja-carmarket:dui:show',
                    data = {
                        name = KOJA.Client.resolveListingVehicleName(cd),
                        price = cd.price or 0,
                        description = cd.description or '',
                        respname = respname,
                        information = info
                    }
                })
                local vCoords = GetEntityCoords(bestEntry.vehicle)
                KOJA.Client.StartRenderLoop(vector3(vCoords.x, vCoords.y, vCoords.z + 1.8))
                cd._duiDirty = false
            end
        else
            if currentDuiVehicle ~= nil then
                currentDuiVehicle = nil
                KOJA.Client.HideDuiAnimated()
            end
        end
        ::continue::
    end
end)

