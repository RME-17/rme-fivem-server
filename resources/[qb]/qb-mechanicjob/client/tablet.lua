-- RME Mechanic Tablet
-- Using the 'tablet' inventory item (mechanic job only) connects to the closest
-- vehicle and shows live diagnostics + repair/clean actions.

local QBCore = exports['qb-core']:GetCoreObject()

local TabletMenu, TabletAction

local function pctColor(pct)
    if pct <= 25 then
        return 'red'
    elseif pct <= 50 then
        return 'yellow'
    else
        return 'green'
    end
end

TabletMenu = function()
    local vehicle, distance = QBCore.Functions.GetClosestVehicle()
    if not vehicle or vehicle == 0 or distance > 5.0 then
        QBCore.Functions.Notify('No vehicle nearby to connect to', 'error')
        return
    end
    if Config.IgnoreClasses and Config.IgnoreClasses[GetVehicleClass(vehicle)] then
        QBCore.Functions.Notify('Cannot connect to this vehicle', 'error')
        return
    end
    local plate = QBCore.Functions.GetPlate(vehicle)
    if not plate then return end

    local enginePct = math.ceil(GetVehicleEngineHealth(vehicle) / 10)
    local bodyPct = math.ceil(GetVehicleBodyHealth(vehicle) / 10)
    local fuelTankPct = math.ceil(GetVehiclePetrolTankHealth(vehicle) / 10)
    local fuel = 0
    pcall(function() fuel = exports[Config.FuelResource]:GetFuel(vehicle) or 0 end)
    local dirtPct = math.ceil((GetVehicleDirtLevel(vehicle) / 15.0) * 100)

    QBCore.Functions.TriggerCallback('qb-mechanicjob:server:getVehicleStatus', function(status)
        local menu = {
            { header = 'Mechanic Tablet', txt = 'Connected to vehicle ' .. plate, isMenuHeader = true, icon = 'fas fa-tablet-screen-button' },
            { header = 'Engine', txt = 'Health: <span style="color:' .. pctColor(enginePct) .. ';">' .. enginePct .. '%</span>', isMenuHeader = true },
            { header = 'Body', txt = 'Health: <span style="color:' .. pctColor(bodyPct) .. ';">' .. bodyPct .. '%</span>', isMenuHeader = true },
            { header = 'Fuel Tank', txt = 'Integrity: <span style="color:' .. pctColor(fuelTankPct) .. ';">' .. fuelTankPct .. '%</span>', isMenuHeader = true },
            { header = 'Fuel Level', txt = 'Remaining: ' .. math.ceil(fuel) .. '%', isMenuHeader = true },
            { header = 'Cleanliness', txt = 'Dirt: ' .. dirtPct .. '%', isMenuHeader = true },
        }
        if status then
            for component, value in pairs(status) do
                local part = Config.WearableParts and Config.WearableParts[component]
                local maxv = (part and part.maxValue) or 100
                local pct = math.ceil((value / maxv) * 100)
                menu[#menu + 1] = {
                    header = (part and part.label) or component,
                    txt = 'Wear: <span style="color:' .. pctColor(pct) .. ';">' .. pct .. '%</span>',
                    isMenuHeader = true,
                }
            end
        end
        menu[#menu + 1] = { header = 'Full Repair', txt = 'Engine, body & fuel tank', icon = 'fas fa-wrench', params = { isAction = true, event = function() TabletAction('fullrepair') end, args = {} } }
        menu[#menu + 1] = { header = 'Restore Worn Parts', txt = 'Reset radiator, axle, brakes, clutch, fuel', icon = 'fas fa-gears', params = { isAction = true, event = function() TabletAction('parts') end, args = {} } }
        menu[#menu + 1] = { header = 'Clean Vehicle', icon = 'fas fa-soap', params = { isAction = true, event = function() TabletAction('clean') end, args = {} } }
        menu[#menu + 1] = { header = 'Refresh Diagnostics', icon = 'fas fa-rotate', params = { isAction = true, event = function() TabletMenu() end, args = {} } }
        menu[#menu + 1] = { header = 'Close', params = { event = 'qb-menu:client:closeMenu' } }
        exports['qb-menu']:openMenu(menu)
    end, plate)
end

TabletAction = function(kind)
    local vehicle, distance = QBCore.Functions.GetClosestVehicle()
    if not vehicle or vehicle == 0 or distance > 5.0 then
        QBCore.Functions.Notify('Lost connection to the vehicle', 'error')
        return
    end
    local plate = QBCore.Functions.GetPlate(vehicle)
    local controls = { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true }
    if kind == 'fullrepair' then
        QBCore.Functions.Progressbar('tablet_fullrepair', 'Running full repair...', 8000, false, true, controls,
            { animDict = 'mini@repair', anim = 'fixing_a_player', flags = 1 }, {}, {}, function()
                SetVehicleEngineHealth(vehicle, 1000.0)
                SetVehicleBodyHealth(vehicle, 1000.0)
                SetVehiclePetrolTankHealth(vehicle, 1000.0)
                SetVehicleDeformationFixed(vehicle)
                SetVehicleFixed(vehicle)
                SetVehicleUndriveable(vehicle, false)
                if plate and Config.WearableParts then
                    for component in pairs(Config.WearableParts) do
                        TriggerServerEvent('qb-mechanicjob:server:repairVehicleComponent', plate, component)
                    end
                end
                QBCore.Functions.Notify('Vehicle fully repaired', 'success')
            end, function()
                QBCore.Functions.Notify('Repair cancelled', 'error')
            end)
    elseif kind == 'clean' then
        QBCore.Functions.Progressbar('tablet_clean', 'Cleaning vehicle...', 5000, false, true, controls,
            { animDict = 'amb@world_human_maid_clean@', anim = 'base', flags = 1 }, {}, {}, function()
                SetVehicleDirtLevel(vehicle, 0.0)
                QBCore.Functions.Notify('Vehicle cleaned', 'success')
            end, function()
                QBCore.Functions.Notify('Cleaning cancelled', 'error')
            end)
    elseif kind == 'parts' then
        QBCore.Functions.Progressbar('tablet_parts', 'Restoring worn parts...', 6000, false, true, controls,
            { animDict = 'mini@repair', anim = 'fixing_a_player', flags = 1 }, {}, {}, function()
                if plate and Config.WearableParts then
                    for component in pairs(Config.WearableParts) do
                        TriggerServerEvent('qb-mechanicjob:server:repairVehicleComponent', plate, component)
                    end
                end
                QBCore.Functions.Notify('Worn parts restored', 'success')
                TabletMenu()
            end, function()
                QBCore.Functions.Notify('Restore cancelled', 'error')
            end)
    end
end

RegisterNetEvent('qb-mechanicjob:client:useTablet', function()
    TabletMenu()
end)
