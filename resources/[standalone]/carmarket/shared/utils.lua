KOJA.Shared = KOJA.Shared or {}

KOJA.Shared.KojaCarmarketDebug = function(...)
    if Config and Config.Debug then
        print('[^5koja-carmarket^7]', ...)
    end
end

KOJA.Shared.clean = function(raw)
    if raw == nil then return '' end
    local s = tostring(raw):match('^%s*(.-)%s*$') or ''
    if s:sub(1, 1) == '#' then s = s:sub(2):match('^%s*(.-)%s*$') or '' end
    return s
end

KOJA.Shared.norm = function(s)
    return tostring(s):lower():gsub('%s+', '_'):gsub('%-', '_')
end

KOJA.Shared.normalizeCategorySlug = function(raw)
    local k = KOJA.Shared.norm(raw)
    if k == '' or k == '-' then return '' end
    if k == 'off_road' then return 'offroad' end
    return k
end

KOJA.Shared.normalizeDriveToken = function(raw)
    local u = KOJA.Shared.clean(raw):upper()
    if u == 'FWD' or u == 'RWD' or u == 'AWD' then return u end
    return ''
end

KOJA.Shared.wireFuelSlugGasOrElectric = function(raw)
    local s = KOJA.Shared.clean(raw)
    if s == '' then return 'gasoline' end
    return KOJA.Shared.norm(s) == 'electric' and 'electric' or 'gasoline'
end

KOJA.Shared.normalizeVehicleCategorySlug = function(carType, vdata)
    local from = KOJA.Shared.clean(carType)
    if from == '' and type(vdata) == 'table' then from = KOJA.Shared.clean(vdata.car_type) end
    local slug = KOJA.Shared.normalizeCategorySlug(from)
    return (slug ~= '' and slug ~= '-') and slug or 'sedan'
end

KOJA.Shared.isMarketAllowedCategorySlug = function(raw)
    local slug = KOJA.Shared.normalizeVehicleCategorySlug(raw, nil)
    if slug == 'motorbike' then
        return true
    end
    if slug == 'compact' or slug == 'sedan' or slug == 'suv' or slug == 'coupe' or slug == 'muscle' or slug == 'drift' or slug == 'van' or
        slug == 'offroad' or slug == 'sports' or slug == 'sportsclassics' or slug == 'super' then
        return true
    end
    return false
end

KOJA.Shared.defaultDriveTypeForCategorySlug = function(carType)
    local slug = KOJA.Shared.normalizeVehicleCategorySlug(carType, nil)
    if slug == 'motorbike' then return 'RWD' end
    if slug == 'suv' or slug == 'offroad' then return 'AWD' end
    if slug == 'muscle' or slug == 'drift' or slug == 'sportsclassics' or slug == 'sports' or slug == 'super' or slug == 'coupe' then
        return 'RWD'
    end
    return 'FWD'
end

KOJA.Shared.coalesceDriveType = function(categorySlug, stored)
    if KOJA.Shared.normalizeVehicleCategorySlug(categorySlug, nil) == 'motorbike' then return 'RWD' end
    local tok = KOJA.Shared.normalizeDriveToken(stored)
    if tok ~= '' then return tok end
    return KOJA.Shared.defaultDriveTypeForCategorySlug(categorySlug)
end

KOJA.Shared.resolveDriveTypeFromHandlingBias = function(bias, carType)
    if KOJA.Shared.normalizeVehicleCategorySlug(carType, nil) == 'motorbike' then return 'RWD' end
    if type(bias) == 'number' then
        if bias < 0.2 then return 'RWD' end
        if bias > 0.8 then return 'FWD' end
        return 'AWD'
    end
    return KOJA.Shared.defaultDriveTypeForCategorySlug(carType)
end

KOJA.Shared.marketEnumDisplayLabel = function(raw)
    local s = KOJA.Shared.clean(raw)
    if s == '' then return '' end
    local driveTok = KOJA.Shared.normalizeDriveToken(s)
    if driveTok ~= '' then return driveTok end
    local k = KOJA.Shared.normalizeCategorySlug(s)
    if k == '' then k = KOJA.Shared.norm(s) end
    local L = rawget(_G, '_L')
    if type(L) == 'function' then
        local tr = L('ui.market.' .. k)
        if type(tr) == 'string' and tr ~= '' then return tr end
    end
    return s
end

KOJA.Shared.decodeJsonStringOrTable = function(raw)
    -- RME_QB_DECODE_FIX_V2: QB stores player_vehicles.vehicle as a bare model name
    -- string (e.g. "hauler"), which is not valid JSON. Treat such a string as
    -- { model = name, respname = name } so name resolution works on QBCore.
    local v = raw and (type(raw) == 'string' and json.decode(raw) or raw) or {}
    if type(v) ~= 'table' then v = {} end
    if type(raw) == 'string' and next(v) == nil then
        local s = raw:gsub('^%s+', ''):gsub('%s+$', '')
        if s ~= '' and not s:match('^[%[{]') then
            v.model = s
            v.respname = s
        end
    end
    return v
end

KOJA.Shared.isGenericVehicleName = function(name)
    local n = tostring(name or ''):gsub('%s+', ' '):match('^%s*(.-)%s*$') or ''
    local nl = n:lower()
    return n == '' or nl == 'vehicle' or nl:match('^vehicle%s+') ~= nil
end

local ACCENT_HEX_BY_CATEGORY_SLUG = {
    compact = '#3AA9FF',
    sedan = '#4CC17A',
    suv = '#E0A93A',
    coupe = '#9F6DFF',
    muscle = '#FF6B4A',
    drift = '#46D4C2',
    motorbike = '#F08C2E',
    van = '#7AC943',
    offroad = '#D9B26A',
}

KOJA.Shared.resolveAccentHexForVehicle = function(veh)
    if not veh or type(veh) ~= 'table' then return nil end
    local vd = type(veh.vehicle_data) == 'table' and veh.vehicle_data or nil
    local src = (vd and vd.car_type) or veh.car_type
    return ACCENT_HEX_BY_CATEGORY_SLUG[KOJA.Shared.normalizeVehicleCategorySlug(src, vd)]
end

KOJA.Shared.getTransmissionModLevelFromVdata = function(vdata)
    if type(vdata) ~= 'table' then return -1 end
    local v = vdata.transmission or vdata.modTransmission
    if v == nil or v == '' then
        local mods = vdata.mods
        if type(mods) == 'table' then v = mods[tostring(13)] or mods[13] end
    end
    return (v ~= nil and v ~= '') and (tonumber(v) or -1) or -1
end

KOJA.Shared.getTurboEnabledFromVdata = function(vdata)
    if type(vdata) ~= 'table' then return false end
    local v = vdata.modTurbo or vdata.turbo
    if v == true or v == 1 or v == '1' then return true end
    local mods = vdata.mods
    if type(mods) == 'table' then
        v = mods[tostring(18)] or mods[18]
        if v == true or v == 1 or v == '1' then return true end
    end
    return false
end

KOJA.Shared.buildPresentationTagLabelsForVehicle = function(veh)
    if not veh or type(veh) ~= 'table' then return {} end
    local vd = type(veh.vehicle_data) == 'table' and veh.vehicle_data or {}
    local driveRaw = KOJA.Shared.clean(vd.drive_type ~= nil and vd.drive_type or veh.drive_type)
    local carRaw = KOJA.Shared.clean(vd.car_type ~= nil and vd.car_type or veh.car_type)
    local out = {}
    local function add(v)
        if not v or v == '' then return end
        for i = 1, #out do if out[i] == v then return end end
        out[#out + 1] = v
    end
    add(KOJA.Shared.marketEnumDisplayLabel(driveRaw))
    add(KOJA.Shared.marketEnumDisplayLabel(carRaw))
    return out
end
