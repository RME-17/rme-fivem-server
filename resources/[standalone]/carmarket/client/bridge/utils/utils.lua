Misc = {}

Misc.Utils = {}

Misc.Utils.LoadModel = function(model)
    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(250)
        end
    end
end

function Misc.Utils.GetZoneById(zoneId)
    for _, z in ipairs(Config.Zones or {}) do
        if z.id == zoneId then
            return z
        end
    end
    return nil
end

function Misc.Utils.GetZoneSpawnRadius(zonePoint)
    if not zonePoint then
        return 50.0
    end
    local r = zonePoint.radius
    if type(r) == 'number' and r > 0.5 then
        return r
    end
    local d = zonePoint.distance
    if type(d) == 'number' and d >= 20.0 then
        return d
    end
    local def = Config and Config.ZoneSpawnRadiusDefault
    if type(def) == 'number' and def > 0.5 then
        return def
    end
    return 50.0
end

function Misc.Utils.GetNearestZoneId(coords)
    local bestId, minDist = nil, 1e9
    for _, z in ipairs(Config.Zones or {}) do
        local c = z.coords
        if c then
            local d = #(coords - vector3(c.x, c.y, c.z))
            if d < minDist and d < 100.0 then
                minDist = d
                bestId = z.id
            end
        end
    end
    return bestId
end

function Misc.Utils.MinDistanceToCarMarketZones(pcoords)
    local dmin = 1e9
    for _, z in ipairs(Config.Zones or {}) do
        local c = z.coords
        if c then
            local d = #(pcoords - vector3(c.x, c.y, c.z))
            if d < dmin then dmin = d end
        end
    end
    return dmin
end

function Misc.Utils.CountSpawnedMarketVehicles(tbl)
    local n = 0
    for _, list in pairs(tbl or {}) do
        if type(list) == 'table' then
            n = n + #list
        end
    end
    return n
end

function Misc.Utils.CarMarketHasClientAce()
    local ace = (Config.Commands and Config.Commands.AdminAce) or 'group.admin'
    return IsPlayerAceAllowed(PlayerId(), ace) == true
end

function Misc.Utils.DecodeVehicleRaw(raw)
    return KOJA.Shared.decodeJsonStringOrTable(raw)
end

function Misc.Utils.ExtractVehicleModelHash(raw)
    -- RME_QB_MODELHASH_FIX_V1: QBCore stores the model as a NAME string (e.g. "t20"),
    -- not a numeric hash like ESX. tonumber() on a name fails, which previously
    -- returned 0 and made spawnCarsForZone skip the vehicle. Convert name strings
    -- to a model hash via GetHashKey so parked/display cars actually spawn.
    if type(raw) == 'number' then
        return raw
    end
    local v = Misc.Utils.DecodeVehicleRaw(raw)
    local m = v.model or v.modelHash or v.hash
    if type(m) == 'number' then
        return m
    end
    if type(m) == 'string' then
        local n = tonumber(m)
        if n then return n end
        local s = m:gsub('^%s+', ''):gsub('%s+$', '')
        if s ~= '' and not s:match('^[%[{]') then
            return GetHashKey(s)
        end
    end
    if type(raw) == 'string' then
        local s = raw:gsub('^%s+', ''):gsub('%s+$', '')
        if s ~= '' and not s:match('^[%[{]') then
            return GetHashKey(s)
        end
    end
    return 0
end

function Misc.Utils.OnscreenKeyboard(prompt, defaultText)
    AddTextEntry('KOJA_CARMARKET_OSK', tostring(prompt or ''))
    DisplayOnscreenKeyboard(1, 'KOJA_CARMARKET_OSK', '', defaultText or '', '', '', '', 200)
    local status = 0
    while status == 0 do
        status = UpdateOnscreenKeyboard()
        Wait(0)
    end
    if status == 1 then
        local result = GetOnscreenKeyboardResult()
        if result == nil then return nil end
        local s = tostring(result)
        if s == '' then return '' end
        return s
    end
    return nil
end

function Misc.Utils.InputDialog(title, fields)
    local out = {}
    for i, f in ipairs(fields or {}) do
        local label = (type(f) == 'table' and (f.label or f.title)) or ('Field ' .. tostring(i))
        local def = (type(f) == 'table' and f.default ~= nil) and tostring(f.default) or ''
        local val = Misc.Utils.OnscreenKeyboard(label, def)
        if val == nil then return nil end
        if type(f) == 'table' and f.type == 'number' then
            out[i] = tonumber(val) or 0
        else
            out[i] = val
        end
    end
    return out
end
