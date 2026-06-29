-- rme-pdm-display | server
-- Authoritative store of the PDM showroom display vehicles. Persists to
-- display_vehicles.json so placements survive restarts, and syncs the list to
-- every client. Only admins can save/change the showroom.

local QBCore = exports['qb-core']:GetCoreObject()
local FILE = 'display_vehicles.json'
local displays = {}

local function loadFromDisk()
    local raw = LoadResourceFile(GetCurrentResourceName(), FILE)
    if raw and raw ~= '' then
        local ok, data = pcall(json.decode, raw)
        if ok and type(data) == 'table' then
            displays = data
        end
    end
    print(('^2[rme-pdm-display]^7 loaded %d display vehicle(s)'):format(#displays))
end

local function saveToDisk()
    SaveResourceFile(GetCurrentResourceName(), FILE, json.encode(displays), -1)
end

local function isAdmin(src)
    if src == 0 then return true end -- server console
    if IsPlayerAceAllowed(src, 'command') then return true end
    local ok, res = pcall(function()
        return QBCore.Functions.HasPermission(src, 'admin') or QBCore.Functions.HasPermission(src, 'god')
    end)
    return (ok and res) and true or false
end

AddEventHandler('onResourceStart', function(res)
    if res == GetCurrentResourceName() then loadFromDisk() end
end)

-- A client asks for the current state (on join / resource start).
RegisterNetEvent('rme-pdm-display:server:requestState', function()
    local src = source
    TriggerClientEvent('rme-pdm-display:client:setAdmin', src, isAdmin(src))
    TriggerClientEvent('rme-pdm-display:client:setDisplays', src, displays)
end)

-- An admin saves the full showroom layout.
RegisterNetEvent('rme-pdm-display:server:save', function(list)
    local src = source
    if not isAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, 'You are not allowed to edit the showroom.', 'error')
        return
    end
    if type(list) ~= 'table' then return end

    local clean = {}
    for _, v in ipairs(list) do
        if type(v) == 'table' and type(v.model) == 'string'
            and tonumber(v.x) and tonumber(v.y) and tonumber(v.z) then
            clean[#clean + 1] = {
                model = v.model,
                x = tonumber(v.x) + 0.0,
                y = tonumber(v.y) + 0.0,
                z = tonumber(v.z) + 0.0,
                w = (tonumber(v.w) or 0.0) + 0.0,
            }
        end
    end

    displays = clean
    saveToDisk()
    -- Push the new layout to everyone so it spawns identically for all players.
    TriggerClientEvent('rme-pdm-display:client:setDisplays', -1, displays)
    TriggerClientEvent('QBCore:Notify', src, ('Saved %d showroom car(s) for everyone.'):format(#displays), 'success')
    print(('^2[rme-pdm-display]^7 %s saved %d display vehicle(s)'):format(GetPlayerName(src) or 'console', #displays))
end)
