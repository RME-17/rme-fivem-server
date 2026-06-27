--[[ RME_EVP_MENU_V1
  In-car menu for ONX / EVP emergency vehicles.
  The driver can change liveries, toggle extras, and fit attachments
  (modkit slots: push bars, spotlights, antennas, K9, gun racks,
  call-sign stickers, etc.). Standalone -- only needs ox_lib.
  Open with /evp  (or the keybind, default F7 -- rebindable in
  Settings > Key Bindings > FiveM).
]]

local MOD_TYPE_NAMES = {
    [0] = 'Spoiler', [1] = 'Front Push Bar / Bumper', [2] = 'Rear Bumper',
    [3] = 'Side Skirt', [4] = 'Exhaust', [5] = 'Frame', [6] = 'Grille',
    [7] = 'Hood', [8] = 'Left Fender', [9] = 'Right Fender',
    [10] = 'Roof (lightbar)', [11] = 'Engine', [12] = 'Brakes',
    [13] = 'Transmission', [14] = 'Horn', [15] = 'Suspension',
    [16] = 'Armor', [18] = 'Turbo', [22] = 'Xenon', [23] = 'Front Wheels',
    [24] = 'Rear Wheels', [25] = 'Plate Holder', [27] = 'Trim',
    [28] = 'Ornaments', [30] = 'Dial Design', [33] = 'Steering Wheel',
    [34] = 'Shifter', [35] = 'Plaque / Call Sign', [38] = 'Hydraulics',
    [48] = 'Livery / Skin',
}

local openMain, openLiveries, openExtras, openMods, openModCategory

local function getMyVehicle()
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then
        lib.notify({ title = 'EVP Menu', description = 'You must be in a vehicle.', type = 'error' })
        return nil
    end
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 or GetPedInVehicleSeat(veh, -1) ~= ped then
        lib.notify({ title = 'EVP Menu', description = 'You must be in the driver seat.', type = 'error' })
        return nil
    end
    SetVehicleModKit(veh, 0)
    return veh
end

openLiveries = function(veh)
    local options = {}
    local count = GetVehicleLiveryCount(veh)
    if count and count > 0 then
        local current = GetVehicleLivery(veh)
        for i = 0, count - 1 do
            options[#options + 1] = {
                title = 'Livery ' .. (i + 1),
                description = (current == i) and 'Currently equipped' or nil,
                onSelect = function() SetVehicleLivery(veh, i); openLiveries(veh) end,
            }
        end
    else
        local n = GetNumVehicleMods(veh, 48)
        if not n or n <= 0 then
            options[#options + 1] = { title = 'No liveries on this vehicle', disabled = true }
        else
            local current = GetVehicleMod(veh, 48)
            options[#options + 1] = {
                title = 'None',
                description = (current == -1) and 'Currently equipped' or nil,
                onSelect = function() SetVehicleMod(veh, 48, -1, false); openLiveries(veh) end,
            }
            for i = 0, n - 1 do
                options[#options + 1] = {
                    title = 'Livery ' .. (i + 1),
                    description = (current == i) and 'Currently equipped' or nil,
                    onSelect = function() SetVehicleMod(veh, 48, i, false); openLiveries(veh) end,
                }
            end
        end
    end
    lib.registerContext({ id = 'evp_liveries', title = 'Liveries / Skins', menu = 'evp_main', options = options })
    lib.showContext('evp_liveries')
end

openExtras = function(veh)
    local options = {}
    for id = 0, 20 do
        if DoesExtraExist(veh, id) then
            local on = IsVehicleExtraTurnedOn(veh, id)
            options[#options + 1] = {
                title = 'Extra ' .. id,
                description = on and 'ON' or 'OFF',
                onSelect = function()
                    SetVehicleExtra(veh, id, on and 1 or 0)
                    openExtras(veh)
                end,
            }
        end
    end
    if #options == 0 then options[1] = { title = 'No extras on this vehicle', disabled = true } end
    lib.registerContext({ id = 'evp_extras', title = 'Extras (on/off)', menu = 'evp_main', options = options })
    lib.showContext('evp_extras')
end

openModCategory = function(veh, modType, label)
    local num = GetNumVehicleMods(veh, modType)
    local current = GetVehicleMod(veh, modType)
    local options = {
        {
            title = 'None',
            description = (current == -1) and 'Currently fitted' or nil,
            onSelect = function() SetVehicleMod(veh, modType, -1, false); openModCategory(veh, modType, label) end,
        },
    }
    for i = 0, num - 1 do
        options[#options + 1] = {
            title = label .. ' #' .. (i + 1),
            description = (current == i) and 'Currently fitted' or nil,
            onSelect = function() SetVehicleMod(veh, modType, i, false); openModCategory(veh, modType, label) end,
        }
    end
    lib.registerContext({ id = 'evp_modcat', title = label, menu = 'evp_mods', options = options })
    lib.showContext('evp_modcat')
end

openMods = function(veh)
    local options = {}
    for modType = 0, 49 do
        if modType ~= 48 then
            local num = GetNumVehicleMods(veh, modType)
            if num and num > 0 then
                local label = MOD_TYPE_NAMES[modType] or ('Mod slot ' .. modType)
                local current = GetVehicleMod(veh, modType)
                options[#options + 1] = {
                    title = label,
                    description = ('%d option(s) - current: %s'):format(num, current == -1 and 'None' or ('#' .. (current + 1))),
                    arrow = true,
                    onSelect = function() openModCategory(veh, modType, label) end,
                }
            end
        end
    end
    if #options == 0 then options[1] = { title = 'No attachments available', disabled = true } end
    lib.registerContext({ id = 'evp_mods', title = 'Attachments', menu = 'evp_main', options = options })
    lib.showContext('evp_mods')
end

openMain = function(veh)
    lib.registerContext({
        id = 'evp_main',
        title = 'EVP Vehicle Menu',
        options = {
            { title = 'Liveries / Skins', description = 'Change department skin', arrow = true, onSelect = function() openLiveries(veh) end },
            { title = 'Extras', description = 'Toggle bolt-on extras on/off', arrow = true, onSelect = function() openExtras(veh) end },
            { title = 'Attachments', description = 'Push bars, spotlights, antennas, K9, gun racks, call signs, etc.', arrow = true, onSelect = function() openMods(veh) end },
            { title = 'Repair & Clean', description = 'Fix and wash the vehicle', onSelect = function() SetVehicleFixed(veh); SetVehicleDeformationFixed(veh); SetVehicleDirtLevel(veh, 0.0); openMain(veh) end },
        },
    })
    lib.showContext('evp_main')
end

RegisterCommand('evp', function()
    local veh = getMyVehicle()
    if veh then openMain(veh) end
end, false)

RegisterKeyMapping('evp', 'Open EVP vehicle menu', 'keyboard', 'F7')
