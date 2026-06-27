KOJA.Shared = KOJA.Shared or {}
KOJA.Shared.VehicleLabels = KOJA.Shared.VehicleLabels or {}
KOJA.Shared.VehicleLabels.IS_SERVER = IsDuplicityVersion()
KOJA.Shared.VehicleLabels.MOD_ENGINE = 11
KOJA.Shared.VehicleLabels.MOD_BRAKES = 12
KOJA.Shared.VehicleLabels.MOD_TRANSMISSION = 13

KOJA.Shared.VehicleLabels.LocaleLabel = function(key, fallback)
    local L = rawget(_G, '_L') or rawget(_G, 'getTranslation')
    return (L and L(key)) or fallback
end

KOJA.Shared.VehicleLabels.ModLevelToLabel = function(n)
    local lbl = KOJA.Shared.VehicleLabels.LocaleLabel
    if n == nil or n == -1 or n == 0 then return lbl('vehicle_labels.labels.mod_level_stock', 'Stock') end
    local fmt = lbl('vehicle_labels.labels.mod_level', 'Level %s')
    return string.format(fmt, tostring(n))
end

KOJA.Shared.VehicleLabels.tableFromLocale = function(subkey)
    local t = rawget(_G, 'translations')
    if not t or type(t) ~= 'table' then return {} end
    t = t.vehicle_labels
    if not t or type(t) ~= 'table' then return {} end
    t = t[subkey]
    if not t or type(t) ~= 'table' or not next(t) then return {} end
    local out = {}
    for k, v in pairs(t) do out[tonumber(k) or k] = v end
    return out
end

KOJA.Shared.VehicleLabels.GetColorNames = function()
    return KOJA.Shared.VehicleLabels.tableFromLocale('color_names')
end

KOJA.Shared.VehicleLabels.GetColorName = function(id)
    if id == nil then return nil end
    local n = tonumber(id)
    local names = KOJA.Shared.VehicleLabels.GetColorNames()
    return (n and names[n]) and names[n] or nil
end

KOJA.Shared.VehicleLabels.ColorIdToName = function(val)
    if val == nil then return nil end
    if type(val) == 'string' and not tostring(val):match('^-?%d+$') then return val end
    local id = tonumber(val)
    local names = KOJA.Shared.VehicleLabels.GetColorNames()
    if id and names[id] then return names[id] end
    return tostring(val)
end

KOJA.Shared.VehicleLabels.GetModLabels = function()
    return KOJA.Shared.VehicleLabels.tableFromLocale('mod_labels')
end

KOJA.Shared.VehicleLabels.GetModLabel = function(id)
    if id == nil then return nil end
    local n = tonumber(id)
    local labels = KOJA.Shared.VehicleLabels.GetModLabels()
    return (n and labels[n]) and labels[n] or nil
end

KOJA.Shared.VehicleLabels.GetVehicleClassToType = function()
    return KOJA.Shared.VehicleLabels.tableFromLocale('vehicle_class_to_type')
end

KOJA.Shared.VehicleLabels.VehicleClassToType = function(vehicleClassId)
    if vehicleClassId == nil then return nil end
    local n = tonumber(vehicleClassId)
    local tbl = KOJA.Shared.VehicleLabels.GetVehicleClassToType()
    return (n and tbl[n]) and tbl[n] or nil
end

KOJA.Shared.VehicleLabels.GetAll = function()
    return {
        color_names = KOJA.Shared.VehicleLabels.GetColorNames(),
        mod_labels = KOJA.Shared.VehicleLabels.GetModLabels(),
        vehicle_class_to_type = KOJA.Shared.VehicleLabels.GetVehicleClassToType()
    }
end

KOJA.Shared.buildExtraInfoCoreRowsFromVdata = function(vdata)
    if type(vdata) ~= 'table' then
        return {}
    end
    local list = {}
    local L = rawget(_G, '_L') or rawget(_G, 'getTranslation')
    local lbl = function(k, fallback)
        return (L and L(k)) or fallback
    end
    list[#list + 1] = {
        label = lbl('vehicle_labels.labels.engine', 'Engine'),
        value = KOJA.Shared.VehicleLabels.ModLevelToLabel(vdata.engine and tonumber(vdata.engine) or -1)
    }
    list[#list + 1] = {
        label = lbl('vehicle_labels.labels.brakes', 'Brakes'),
        value = KOJA.Shared.VehicleLabels.ModLevelToLabel(vdata.brakes and tonumber(vdata.brakes) or -1)
    }
    list[#list + 1] = {
        label = lbl('vehicle_labels.labels.transmission', 'Transmission'),
        value = KOJA.Shared.VehicleLabels.ModLevelToLabel(KOJA.Shared.getTransmissionModLevelFromVdata(vdata))
    }
    list[#list + 1] = {
        label = lbl('vehicle_labels.labels.turbo', 'Turbo'),
        value = KOJA.Shared.getTurboEnabledFromVdata(vdata) and lbl('vehicle_labels.labels.turbo_yes', 'Yes') or
            lbl('vehicle_labels.labels.turbo_no', 'No')
    }
    local prim = vdata.color1 or (vdata.color and type(vdata.color) == 'table' and vdata.color[1])
    local sec = vdata.color2 or (vdata.color and type(vdata.color) == 'table' and vdata.color[2])
    if prim ~= nil then
        list[#list + 1] = {
            label = lbl('vehicle_labels.labels.primary_color', 'Primary Color'),
            value = KOJA.Shared.VehicleLabels.ColorIdToName(prim) or tostring(prim)
        }
    end
    if sec ~= nil then
        list[#list + 1] = {
            label = lbl('vehicle_labels.labels.secondary_color', 'Secondary Color'),
            value = KOJA.Shared.VehicleLabels.ColorIdToName(sec) or tostring(sec)
        }
    end
    if vdata.pearlescentColor ~= nil then
        list[#list + 1] = {
            label = lbl('vehicle_labels.labels.pearlescent', 'Pearlescent'),
            value = KOJA.Shared.VehicleLabels.ColorIdToName(vdata.pearlescentColor) or tostring(vdata.pearlescentColor)
        }
    end
    if vdata.wheelColor ~= nil then
        list[#list + 1] = {
            label = lbl('vehicle_labels.labels.wheel_color', 'Wheel Color'),
            value = KOJA.Shared.VehicleLabels.ColorIdToName(vdata.wheelColor) or tostring(vdata.wheelColor)
        }
    end
    if vdata.dashboardColor ~= nil then
        list[#list + 1] = {
            label = lbl('vehicle_labels.labels.dashboard', 'Dashboard'),
            value = KOJA.Shared.VehicleLabels.ColorIdToName(vdata.dashboardColor) or tostring(vdata.dashboardColor)
        }
    end
    if vdata.interiorColor ~= nil then
        list[#list + 1] = {
            label = lbl('vehicle_labels.labels.interior', 'Interior'),
            value = KOJA.Shared.VehicleLabels.ColorIdToName(vdata.interiorColor) or tostring(vdata.interiorColor)
        }
    end
    return list
end

if not KOJA.Shared.VehicleLabels.IS_SERVER then
    local _categoryByModel = {}

    KOJA.Shared.resolveVehicleCategorySlugFromModel = function(modelHash)
        if type(modelHash) ~= 'number' or modelHash == 0 then return nil end
        local cached = _categoryByModel[modelHash]
        if cached ~= nil then
            return cached ~= false and cached or nil
        end

        if IsThisModelABicycle(modelHash) then
            _categoryByModel[modelHash] = false
            return nil
        end
        if IsThisModelABike(modelHash) then
            _categoryByModel[modelHash] = 'motorbike'
            return 'motorbike'
        end

        if not IsModelInCdimage(modelHash) or not IsModelAVehicle(modelHash) then
            _categoryByModel[modelHash] = false
            return nil
        end

        RequestModel(modelHash)
        local timeout = 0
        while not HasModelLoaded(modelHash) and timeout < 100 do Wait(10) timeout = timeout + 1 end
        if not HasModelLoaded(modelHash) then
            SetModelAsNoLongerNeeded(modelHash)
            _categoryByModel[modelHash] = false
            return nil
        end

        local coords = GetEntityCoords(PlayerPedId())
        local tempVeh = CreateVehicle(modelHash, coords.x + 50.0, coords.y + 50.0, coords.z, 0.0, false, false)
        if not tempVeh or tempVeh == 0 then
            SetModelAsNoLongerNeeded(modelHash)
            _categoryByModel[modelHash] = false
            return nil
        end

        SetEntityAsMissionEntity(tempVeh, true, true)
        Wait(0)
        local vc = GetVehicleClass(tempVeh)
        DeleteEntity(tempVeh)
        SetModelAsNoLongerNeeded(modelHash)

        local slug = KOJA.Shared.VehicleLabels.VehicleClassToType(vc) or (KOJA.Shared.VehicleLabels.GetVehicleClassToType()[vc])
        if type(slug) ~= 'string' or not slug:match('%S') then
            _categoryByModel[modelHash] = false
            return nil
        end

        slug = KOJA.Shared.normalizeVehicleCategorySlug(slug, nil)
        _categoryByModel[modelHash] = slug
        return slug
    end

    KOJA.Shared.applyCategoryFromModelToVehicle = function(veh)
        if not veh or type(veh) ~= 'table' then return end
        local vd = type(veh.vehicle_data) == 'table' and veh.vehicle_data or nil
        local model = (vd and vd.model) or veh.model
        local hash = type(model) == 'number' and model or tonumber(model)
        if not hash or hash == 0 then
            local rn = veh.respname and tostring(veh.respname):match('%S+')
            if rn then hash = GetHashKey(rn) end
        end
        local slug = hash and KOJA.Shared.resolveVehicleCategorySlugFromModel(hash) or nil
        if not slug then return end
        veh.car_type = slug
        if vd then
            vd.car_type = slug
        end
    end

    KOJA.Shared.buildExtraInfoFromVehicleData = function(veh)
        if not veh then return end
        local vd = type(veh.vehicle_data) == 'table' and veh.vehicle_data or {}
        local function val(x, default) return (x ~= nil and tostring(x):match('%S+')) and tostring(x) or (default or '-') end
        local mileageVal = tonumber(vd.mileage or veh.mileage or (veh.information and veh.information.mileage))
        veh.fuel_type = val(vd.fuel_type or veh.fuel_type) ~= '-' and val(vd.fuel_type or veh.fuel_type) or veh.fuel_type
        veh.drive_type = val(vd.drive_type or veh.drive_type) ~= '-' and val(vd.drive_type or veh.drive_type) or veh.drive_type
        local catSlug = KOJA.Shared.normalizeVehicleCategorySlug(veh.car_type, vd)
        veh.car_type = catSlug
        if not veh.plate and vd.plate then veh.plate = tostring(vd.plate) end
        if type(veh.information) ~= 'table' then veh.information = {} end
        veh.information.mileage = mileageVal or (veh.information and veh.information.mileage and tonumber(veh.information.mileage)) or 0
        local list = {}
        local core = KOJA.Shared.buildExtraInfoCoreRowsFromVdata(vd)
        for i = 1, #core do
            list[#list + 1] = core[i]
        end
        local visual, mechanical = {}, {}
        if vd.mods and type(vd.mods) == 'table' then
            for k, modVal in pairs(vd.mods) do
                local idx = tonumber(k)
                if idx ~= nil then
                    if idx >= 0 and idx <= 49 then visual[k] = modVal else mechanical[k] = modVal end
                end
            end
        end
        if vd.visualMods and type(vd.visualMods) == 'table' then for k, modVal in pairs(vd.visualMods) do visual[k] = modVal end end
        if vd.performanceMods and type(vd.performanceMods) == 'table' then for k, modVal in pairs(vd.performanceMods) do mechanical[k] = modVal end end
        local modLabels = KOJA.Shared.VehicleLabels.GetModLabels() or {}
        if type(modLabels) == 'table' then
            for idx, label in pairs(modLabels) do
                if idx ~= 11 and idx ~= 12 and idx ~= 13 then
                    local modVal = visual[tostring(idx)] or mechanical[tostring(idx)]
                    if modVal ~= nil and modVal ~= -1 then
                        list[#list + 1] = { label = label, value = tostring(modVal) }
                    end
                end
            end
        end
        veh.extra_info = list
    end

    KOJA.Shared.setVehicleDataModsFromNative = function(veh, opts)
        if not veh then return end
        local spawnToReadMods = opts and opts.spawnToReadMods
        if type(veh.vehicle_data) ~= 'table' then veh.vehicle_data = {} end
        local vd = veh.vehicle_data
        local model = veh.model or (vd and vd.model)
        if type(model) ~= 'number' then model = tonumber(model) end
        vd.engine = vd.engine and tonumber(vd.engine) or -1
        vd.brakes = vd.brakes and tonumber(vd.brakes) or -1
        vd.transmission = KOJA.Shared.getTransmissionModLevelFromVdata(vd)
        KOJA.Shared.buildExtraInfoFromVehicleData(veh)
        if not spawnToReadMods or not model or model == 0 then
            if opts and opts.onSpawnDone then opts.onSpawnDone() end
            return
        end
        CreateThread(function()
            local function done() if opts and opts.onSpawnDone then opts.onSpawnDone() end end
            local hash = type(model) == 'number' and model or GetHashKey(tostring(model))
            if not IsModelInCdimage(hash) or not IsModelAVehicle(hash) then done() return end
            RequestModel(hash)
            local timeout = 0
            while not HasModelLoaded(hash) and timeout < 100 do Wait(10) timeout = timeout + 1 end
            if not HasModelLoaded(hash) then SetModelAsNoLongerNeeded(hash) done() return end
            local coords = GetEntityCoords(PlayerPedId())
            local tempVeh = CreateVehicle(hash, coords.x + 50.0, coords.y + 50.0, coords.z, 0.0, false, false)
            if not tempVeh or tempVeh == 0 then SetModelAsNoLongerNeeded(hash) done() return end
            SetEntityAsMissionEntity(tempVeh, true, true)
            Wait(0)
            local vc = GetVehicleClass(tempVeh)
            local rawCat = KOJA.Shared.VehicleLabels.VehicleClassToType(vc) or (KOJA.Shared.VehicleLabels.GetVehicleClassToType()[vc]) or 'sedan'
            vd.car_type = KOJA.Shared.normalizeVehicleCategorySlug(rawCat, vd)
            local ok, driveBias = pcall(GetVehicleHandlingFloat, tempVeh, 'CHandlingData', 'fDriveBiasFront')
            vd.drive_type = KOJA.Shared.resolveDriveTypeFromHandlingBias((ok and driveBias) or nil, vd.car_type)
            vd.fuel_type = KOJA.Shared.wireFuelSlugGasOrElectric(GetIsVehicleElectric(tempVeh) and 'electric' or vd.fuel_type)
            vd.engine = GetVehicleMod(tempVeh, KOJA.Shared.VehicleLabels.MOD_ENGINE)
            vd.brakes = GetVehicleMod(tempVeh, KOJA.Shared.VehicleLabels.MOD_BRAKES)
            DeleteEntity(tempVeh)
            SetModelAsNoLongerNeeded(hash)
            KOJA.Shared.buildExtraInfoFromVehicleData(veh)
            if opts and opts.onSpawnDone then opts.onSpawnDone() end
        end)
    end

    KOJA.Shared.enrichRespname = function(veh)
        if veh and (veh.model or (veh.respname and tonumber(veh.respname))) then
            local hash = type(veh.model) == 'number' and veh.model or tonumber(veh.respname)
            if hash then veh.respname = GetDisplayNameFromVehicleModel(hash) or veh.respname end
        end
    end
    _G.enrichRespname = KOJA.Shared.enrichRespname

    KOJA.Shared.enrichVehicleData = function(veh, opts)
        if not veh then return end
        KOJA.Shared.setVehicleDataModsFromNative(veh, opts)
    end

    KOJA.Shared.duiColorIdToName = function(val)
        if val == nil then return '' end
        if KOJA.Shared.VehicleLabels.ColorIdToName then
            local name = KOJA.Shared.VehicleLabels.ColorIdToName(val)
            if name and name ~= '' then return name end
        end
        if type(val) == 'string' and not tostring(val):match('^-?%d+$') then return val end
        return tostring(val)
    end

    KOJA.Shared.applyVehicleData = function(vehicle, v)
        if not vehicle or not DoesEntityExist(vehicle) or type(v) ~= 'table' then return end
        SetVehicleModKit(vehicle, 0)
        local c1 = v.color1 or (v.color and v.color[1])
        local c2 = v.color2 or (v.color and v.color[2])
        if c1 ~= nil and c2 ~= nil then SetVehicleColours(vehicle, tonumber(c1) or 0, tonumber(c2) or 0) end
        local pearlescent = tonumber(v.pearlescentColor)
        local wheelColor = tonumber(v.wheelColor)
        if pearlescent ~= nil or wheelColor ~= nil then SetVehicleExtraColours(vehicle, pearlescent or 0, wheelColor or 0) end
        if type(v.customPrimaryColor) == 'table' then
            local r, g, b = tonumber(v.customPrimaryColor[1]), tonumber(v.customPrimaryColor[2]), tonumber(v.customPrimaryColor[3])
            if r and g and b then SetVehicleCustomPrimaryColour(vehicle, r, g, b) end
        end
        if type(v.customSecondaryColor) == 'table' then
            local r, g, b = tonumber(v.customSecondaryColor[1]), tonumber(v.customSecondaryColor[2]), tonumber(v.customSecondaryColor[3])
            if r and g and b then SetVehicleCustomSecondaryColour(vehicle, r, g, b) end
        end
        if v.dashboardColor ~= nil then SetVehicleDashboardColour(vehicle, tonumber(v.dashboardColor) or 0) end
        if v.interiorColor ~= nil then SetVehicleInteriorColour(vehicle, tonumber(v.interiorColor) or 0) end
        if v.windowTint ~= nil then SetVehicleWindowTint(vehicle, tonumber(v.windowTint) or 0) end
        local plateIdx = v.numberPlateTextIndex or v.plateIndex
        if plateIdx ~= nil then SetVehicleNumberPlateTextIndex(vehicle, tonumber(plateIdx) or 0) end
        if v.wheels ~= nil then SetVehicleWheelType(vehicle, tonumber(v.wheels) or 0) end
        if type(v.extras) == 'table' then
            for k, enabled in pairs(v.extras) do
                local id = tonumber(k)
                if id then SetVehicleExtra(vehicle, id, enabled == false) end
            end
        end
        local function applyModIndex(idx, val)
            if idx == 18 then
                local on = val == true or val == 1 or tonumber(val) == 1
                ToggleVehicleMod(vehicle, 18, on)
            elseif idx == 22 then
                local on = val == true or val == 1 or tonumber(val) == 1
                ToggleVehicleMod(vehicle, 22, on)
            elseif val == nil or val == false then
                return
            elseif tonumber(val) == -1 then
                SetVehicleMod(vehicle, idx, -1, false)
            else
                SetVehicleMod(vehicle, idx, tonumber(val) or 0, false)
            end
        end
        local function applyModsTable(tbl)
            if type(tbl) ~= 'table' then return end
            for k, val in pairs(tbl) do
                local idx = tonumber(k)
                if idx then applyModIndex(idx, val) end
            end
        end
        if v.modTurbo == true or v.modTurbo == 1 then ToggleVehicleMod(vehicle, 18, true) end
        if v.modXenon == true or v.modXenon == 1 then ToggleVehicleMod(vehicle, 22, true) end
        applyModsTable(v.mods)
        applyModsTable(v.visualMods)
        applyModsTable(v.performanceMods)
        if type(v.neonEnabled) == 'table' then
            for i = 1, 4 do
                local en = v.neonEnabled[i]
                SetVehicleNeonLightEnabled(vehicle, i - 1, en == true or en == 1)
            end
        end
        if type(v.neonColor) == 'table' then
            local r = tonumber(v.neonColor[1] or v.neonColor.r) or 0
            local g = tonumber(v.neonColor[2] or v.neonColor.g) or 0
            local b = tonumber(v.neonColor[3] or v.neonColor.b) or 0
            SetVehicleNeonLightsColour(vehicle, r, g, b)
        end
        if type(v.tyreSmokeColor) == 'table' then
            local r = tonumber(v.tyreSmokeColor[1]) or 0
            local g = tonumber(v.tyreSmokeColor[2]) or 0
            local b = tonumber(v.tyreSmokeColor[3]) or 0
            ToggleVehicleMod(vehicle, 20, true)
            SetVehicleTyreSmokeColor(vehicle, r, g, b)
        end
        if v.xenonColor ~= nil then pcall(function() SetVehicleXenonLightsColor(vehicle, tonumber(v.xenonColor) or 0) end) end
        if v.modLivery ~= nil then SetVehicleMod(vehicle, 48, tonumber(v.modLivery) or 0, false) end
        if v.livery ~= nil then SetVehicleLivery(vehicle, tonumber(v.livery) or 0) end
        if v.modRoofLivery ~= nil then SetVehicleRoofLivery(vehicle, tonumber(v.modRoofLivery) or 0) end
    end

    KOJA.Shared.getVehicleSpawnCoords = function(zoneId, carData)
        if not carData.slot_id or carData.slot_id == '' then
            return carData.coords.x, carData.coords.y, carData.coords.z, carData.heading or 0.0
        end
        for _, z in ipairs(Config.Zones or {}) do
            if z.id == zoneId and z.CarMarketBoxes then
                for _, box in ipairs(z.CarMarketBoxes) do
                    if box.id == carData.slot_id then
                        local c = box.coords
                        return c.x, c.y, c.z, box.rotation or 0.0
                    end
                end
            end
        end
        return carData.coords.x, carData.coords.y, carData.coords.z, carData.heading or 0.0
    end

    _G.enrichVehicleData = KOJA.Shared.enrichVehicleData
end
