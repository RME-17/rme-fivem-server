-- RME Redline Mechanic Tablet (custom frosted-glass NUI)
-- The 'tablet' inventory item (mechanic job only) connects to the nearest
-- vehicle and opens a custom UI: live diagnostics, every cosmetic upgrade
-- (each applied with a work animation AND each consuming a physical part item),
-- repair/clean actions, customer billing by server ID that deposits into the
-- shop society account, and an Orders tab where members fulfil customer
-- cosmetics orders one item at a time on the connected car.

local QBCore = exports['qb-core']:GetCoreObject()

local tabletOpen = false
local tabletVehicle = nil
local tabletPlate = nil
local working = false

-- helpers -------------------------------------------------------------------

local function toPct(v, max)
    return math.max(0, math.min(100, math.ceil((v / (max or 1000)) * 100)))
end

local function vehName(veh)
    local model = GetEntityModel(veh)
    local label = GetLabelText(GetDisplayNameFromVehicleModel(model))
    if not label or label == 'NULL' or label == '' then
        label = GetDisplayNameFromVehicleModel(model)
    end
    local make = GetMakeNameFromVehicleModel(model)
    if make and make ~= '' and make ~= 'NULL' then
        local mk = GetLabelText(make)
        if mk and mk ~= 'NULL' and mk ~= '' then label = mk .. ' ' .. label end
    end
    return label
end

local function PlayWorkAnim(ms)
    local ped = PlayerPedId()
    RequestAnimDict('mini@repair')
    local t = GetGameTimer()
    while not HasAnimDictLoaded('mini@repair') and GetGameTimer() - t < 1000 do Wait(0) end
    TaskPlayAnim(ped, 'mini@repair', 'fixing_a_player', 8.0, -8.0, ms, 1, 0, false, false, false)
    Wait(ms)
    ClearPedTasks(ped)
end

local function SaveTabletVehicle()
    if tabletVehicle and DoesEntityExist(tabletVehicle) then
        local props = QBCore.Functions.GetVehicleProperties(tabletVehicle)
        if props then TriggerServerEvent('qb-mechanicjob:server:SaveVehicleProps', props) end
    end
end

-- Ask the server to consume the required part for this action, then run apply().
-- kind = tablet action kind; skip = true for OFF / Stock selections (no part).
local function withPart(kind, skip, apply)
    QBCore.Functions.TriggerCallback('qb-mechanicjob:server:consumePart', function(ok, need)
        if not ok then
            if need == 'not_mechanic' then
                QBCore.Functions.Notify('Only Redline mechanics can do this', 'error')
            else
                QBCore.Functions.Notify('You need a ' .. (need or 'part') .. ' in your inventory to do this', 'error')
            end
            return
        end
        apply()
    end, kind, skip)
end

local function buildModList(veh, modType, isHorn)
    local list = { { label = 'Stock / None', index = -1 } }
    for i = 0, GetNumVehicleMods(veh, modType) - 1 do
        local txt
        if isHorn then
            txt = (Config.HornLabels and Config.HornLabels[i]) or ('Horn ' .. i)
        else
            local l = GetModTextLabel(veh, modType, i)
            txt = (l and GetLabelText(l)) or (tostring(modType) .. ' #' .. i)
            if txt == 'NULL' or txt == '' then txt = 'Style ' .. i end
        end
        list[#list + 1] = { label = txt, index = i }
    end
    return list
end

local function buildTabletData(veh)
    SetVehicleModKit(veh, 0)
    local data = {}
    data.name = vehName(veh)
    data.plate = tabletPlate
    data.requireItems = Config.RequirePartItems and true or false
    data.partItems = Config.PartItems or {}

    local fuel = 0
    pcall(function() fuel = exports[Config.FuelResource]:GetFuel(veh) or 0 end)
    data.diag = {
        engine = toPct(GetVehicleEngineHealth(veh), 1000),
        body = toPct(GetVehicleBodyHealth(veh), 1000),
        fuelTank = toPct(GetVehiclePetrolTankHealth(veh), 1000),
        fuel = math.ceil(fuel),
        dirt = math.ceil((GetVehicleDirtLevel(veh) / 15.0) * 100),
        parts = {},
    }

    data.exterior = {}
    for i = 1, #Config.ExteriorCategories do
        local c = Config.ExteriorCategories[i]
        if GetNumVehicleMods(veh, c.id) > 0 then
            data.exterior[#data.exterior + 1] = { label = c.label, modType = c.id, options = buildModList(veh, c.id, false) }
        end
    end

    data.interior = {}
    for i = 1, #Config.InteriorCategories do
        local c = Config.InteriorCategories[i]
        if GetNumVehicleMods(veh, c.id) > 0 then
            data.interior[#data.interior + 1] = { label = c.label, modType = c.id, horn = (c.id == 14), options = buildModList(veh, c.id, c.id == 14) }
        end
    end

    data.wheelCats = {}
    for i = 1, #Config.WheelCategories do
        local c = Config.WheelCategories[i]
        data.wheelCats[#data.wheelCats + 1] = { label = c.label, id = c.id }
    end

    data.neon = {}
    for i = 1, #Config.NeonColors do
        local c = Config.NeonColors[i]
        data.neon[#data.neon + 1] = { label = c.label, r = c.r, g = c.g, b = c.b }
    end

    data.xenon = {}
    for i = 1, #Config.Xenon do
        local x = Config.Xenon[i]
        data.xenon[#data.xenon + 1] = { label = x.label, id = x.id }
    end

    data.smoke = {}
    for i = 1, #Config.TyreSmoke do
        local s = Config.TyreSmoke[i]
        data.smoke[#data.smoke + 1] = { label = s.label, r = s.r, g = s.g, b = s.b }
    end

    data.tint = {}
    for i = 1, #Config.WindowTints do
        local t = Config.WindowTints[i]
        data.tint[#data.tint + 1] = { label = t.label, id = t.id }
    end

    data.plate = {}
    for i = 1, #Config.PlateIndexes do
        local p = Config.PlateIndexes[i]
        data.plate[#data.plate + 1] = { label = p.label, id = p.id }
    end

    return data
end

-- open ----------------------------------------------------------------------

RegisterNetEvent('qb-mechanicjob:client:useTablet', function()
    if tabletOpen then return end
    local vehicle, distance = QBCore.Functions.GetClosestVehicle()
    if not vehicle or vehicle == 0 or distance > 5.0 then
        QBCore.Functions.Notify('No vehicle nearby to connect to', 'error')
        return
    end
    if Config.IgnoreClasses and Config.IgnoreClasses[GetVehicleClass(vehicle)] then
        QBCore.Functions.Notify('Cannot connect to this vehicle', 'error')
        return
    end
    tabletVehicle = vehicle
    tabletPlate = QBCore.Functions.GetPlate(vehicle)
    local data = buildTabletData(vehicle)
    QBCore.Functions.TriggerCallback('qb-mechanicjob:server:getVehicleStatus', function(status)
        if status then
            for component, value in pairs(status) do
                local part = Config.WearableParts and Config.WearableParts[component]
                local maxv = (part and part.maxValue) or 100
                data.diag.parts[#data.diag.parts + 1] = {
                    label = (part and part.label) or component,
                    pct = math.ceil((value / maxv) * 100),
                }
            end
        end
        tabletOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'openRedlineTablet', data = data })
    end, tabletPlate)
end)

-- apply cosmetics -----------------------------------------------------------

RegisterNUICallback('rmeApply', function(payload, cb)
    if not tabletOpen or working then cb('busy') return end
    local veh = tabletVehicle
    if not veh or not DoesEntityExist(veh) then
        QBCore.Functions.Notify('Lost connection to the vehicle', 'error')
        cb('novehicle') return
    end
    local kind = payload.kind
    local skip = (payload.off == true) or (payload.index == -1)
    withPart(kind, skip, function()
        working = true
        SetVehicleModKit(veh, 0)
        PlayWorkAnim(payload.anim or 1500)
        if kind == 'mod' then
            SetVehicleMod(veh, payload.modType, payload.index, false)
            if payload.horn and payload.index ~= -1 then
                StartVehicleHorn(veh, 3000, GetHashKey('HELDDOWN'), false)
            end
        elseif kind == 'wheel' then
            SetVehicleWheelType(veh, payload.wheelType)
            SetVehicleMod(veh, 23, payload.index, false)
        elseif kind == 'neon' then
            if payload.off then
                for n = 0, 3 do SetVehicleNeonLightEnabled(veh, n, false) end
            else
                for n = 0, 3 do SetVehicleNeonLightEnabled(veh, n, true) end
                SetVehicleNeonLightsColour(veh, payload.r, payload.g, payload.b)
            end
        elseif kind == 'xenon' then
            if payload.off then
                ToggleVehicleMod(veh, 22, false)
            else
                ToggleVehicleMod(veh, 22, true)
                SetVehicleXenonLightsColor(veh, payload.id)
            end
        elseif kind == 'smoke' then
            if payload.off then
                ToggleVehicleMod(veh, 20, false)
            else
                ToggleVehicleMod(veh, 20, true)
                SetVehicleTyreSmokeColor(veh, payload.r, payload.g, payload.b)
            end
        elseif kind == 'tint' then
            SetVehicleWindowTint(veh, payload.id)
        elseif kind == 'plate' then
            SetVehicleNumberPlateTextIndex(veh, payload.id)
        elseif kind == 'paint' then
            if payload.section == 'secondary' then
                SetVehicleCustomSecondaryColour(veh, payload.r, payload.g, payload.b)
            else
                SetVehicleCustomPrimaryColour(veh, payload.r, payload.g, payload.b)
            end
        end
        SaveTabletVehicle()
        working = false
    end)
    cb('ok')
end)

RegisterNUICallback('rmeWheelList', function(payload, cb)
    local veh = tabletVehicle
    if not veh or not DoesEntityExist(veh) then cb({}) return end
    SetVehicleModKit(veh, 0)
    local original = GetVehicleWheelType(veh)
    SetVehicleWheelType(veh, payload.id)
    local list = { { label = 'Stock', index = -1 } }
    for i = 0, GetNumVehicleMods(veh, 23) - 1 do
        local l = GetModTextLabel(veh, 23, i)
        local txt = (l and GetLabelText(l)) or ('Wheel ' .. i)
        if txt == 'NULL' or txt == '' then txt = 'Wheel ' .. i end
        list[#list + 1] = { label = txt, index = i }
    end
    SetVehicleWheelType(veh, original)
    cb(list)
end)

RegisterNUICallback('rmeRepair', function(payload, cb)
    if not tabletOpen or working then cb('busy') return end
    local veh = tabletVehicle
    if not veh or not DoesEntityExist(veh) then cb('novehicle') return end
    working = true
    local kind = payload.kind
    if kind == 'fullrepair' then
        PlayWorkAnim(3000)
        SetVehicleEngineHealth(veh, 1000.0)
        SetVehicleBodyHealth(veh, 1000.0)
        SetVehiclePetrolTankHealth(veh, 1000.0)
        SetVehicleDeformationFixed(veh)
        SetVehicleFixed(veh)
        SetVehicleUndriveable(veh, false)
        if tabletPlate and Config.WearableParts then
            for component in pairs(Config.WearableParts) do
                TriggerServerEvent('qb-mechanicjob:server:repairVehicleComponent', tabletPlate, component)
            end
        end
        QBCore.Functions.Notify('Vehicle fully repaired', 'success')
    elseif kind == 'clean' then
        PlayWorkAnim(2500)
        SetVehicleDirtLevel(veh, 0.0)
        QBCore.Functions.Notify('Vehicle cleaned', 'success')
    elseif kind == 'parts' then
        PlayWorkAnim(3000)
        if tabletPlate and Config.WearableParts then
            for component in pairs(Config.WearableParts) do
                TriggerServerEvent('qb-mechanicjob:server:repairVehicleComponent', tabletPlate, component)
            end
        end
        QBCore.Functions.Notify('Worn parts restored', 'success')
    end
    working = false
    cb('ok')
end)

RegisterNUICallback('rmeBill', function(payload, cb)
    local amount = tonumber(payload.amount)
    if not amount or amount <= 0 then
        QBCore.Functions.Notify('Enter a valid amount', 'error')
        cb('bad') return
    end
    local serverId = tonumber(payload.target)
    if not serverId or serverId <= 0 then
        QBCore.Functions.Notify('Enter a valid player ID to bill', 'error')
        cb('bad') return
    end
    TriggerServerEvent('qb-mechanicjob:server:billCustomer', serverId, math.floor(amount))
    cb('ok')
end)

-- customer cosmetics orders (member fulfilment) -----------------------------

RegisterNUICallback('rmeGetOrders', function(_, cb)
    QBCore.Functions.TriggerCallback('qb-mechanicjob:server:getOrders', function(list)
        cb({ plate = tabletPlate, orders = list or {} })
    end)
end)

RegisterNUICallback('rmeOrderApply', function(payload, cb)
    if not tabletOpen or working then cb('busy') return end
    local veh = tabletVehicle
    if not veh or not DoesEntityExist(veh) then
        QBCore.Functions.Notify('Lost connection to the vehicle', 'error')
        cb('novehicle') return
    end
    if payload.plate and tabletPlate and payload.plate ~= tabletPlate then
        QBCore.Functions.Notify('Connect the tablet to the matching vehicle first', 'error')
        cb('wrongveh') return
    end
    local item = payload.item or {}
    local kind = item.kind
    local skip = (item.off == true) or (item.index == -1)
    withPart(kind, skip, function()
        working = true
        SetVehicleModKit(veh, 0)
        PlayWorkAnim(2000)
        if kind == 'paint' then
            local p, s = GetVehicleColours(veh)
            if item.section == 'secondary' then
                SetVehicleColours(veh, p, item.colorId)
            else
                SetVehicleColours(veh, item.colorId, s)
            end
        elseif kind == 'wheel' then
            SetVehicleWheelType(veh, item.wheelType)
            SetVehicleMod(veh, 23, item.index, false)
        elseif kind == 'neon' then
            if item.off then
                for n = 0, 3 do SetVehicleNeonLightEnabled(veh, n, false) end
            else
                for n = 0, 3 do SetVehicleNeonLightEnabled(veh, n, true) end
                SetVehicleNeonLightsColour(veh, item.r, item.g, item.b)
            end
        elseif kind == 'smoke' then
            if item.off then
                ToggleVehicleMod(veh, 20, false)
            else
                ToggleVehicleMod(veh, 20, true)
                SetVehicleTyreSmokeColor(veh, item.r, item.g, item.b)
            end
        elseif kind == 'tint' then
            SetVehicleWindowTint(veh, item.id)
        elseif kind == 'plate' then
            SetVehicleNumberPlateTextIndex(veh, item.id)
        end
        SaveTabletVehicle()
        TriggerServerEvent('qb-mechanicjob:server:completeOrderItem', tabletPlate, payload.index)
        working = false
        QBCore.Functions.Notify('Applied: ' .. (item.label or kind or 'item'), 'success')
    end)
    cb('ok')
end)

RegisterNUICallback('rmeOrderCancel', function(payload, cb)
    if payload and payload.plate then
        TriggerServerEvent('qb-mechanicjob:server:cancelOrder', payload.plate)
    end
    cb('ok')
end)

RegisterNUICallback('rmeClose', function(_, cb)
    tabletOpen = false
    SetNuiFocus(false, false)
    SaveTabletVehicle()
    tabletVehicle = nil
    tabletPlate = nil
    cb('ok')
end)

-- customer side: accept / decline the invoice --------------------------------

RegisterNetEvent('qb-mechanicjob:client:billPrompt', function(memberName, amount)
    local accepted = lib.alertDialog({
        header = 'Redline Motorsport - Invoice',
        content = ('**%s** is billing you **$%s** for vehicle work. Pay this invoice?'):format(memberName or 'A mechanic', amount),
        centered = true,
        cancel = true,
        labels = { confirm = 'Pay', cancel = 'Decline' },
    })
    TriggerServerEvent('qb-mechanicjob:server:billResponse', accepted == 'confirm')
end)

-- safety: release NUI focus if the resource stops while the tablet is open
AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if tabletOpen then
        tabletOpen = false
        SetNuiFocus(false, false)
    end
end)
