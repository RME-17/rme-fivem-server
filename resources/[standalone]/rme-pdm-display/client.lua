-- rme-pdm-display | client
-- Spawns the custom PDM showroom display cars (local, frozen, locked) from the
-- synced list, and gives admins an in-game editor to add / position / swap /
-- delete them. Positioning uses the native FiveM gizmo (hold LEFT ALT to drag
-- the 3D handles) with full keyboard controls as a reliable fallback.

local QBCore = exports['qb-core']:GetCoreObject()

local isAdmin = false
local displays = {}      -- { [i] = { entity = veh, model = 'adder' } }
local editing = nil      -- entity currently being edited
local editOriginal = nil -- { x, y, z, w } snapshot for cancel

-- Controls disabled while editing so game actions do not fire.
local EDIT_CONTROLS = { 18, 177, 44, 38, 21, 172, 173, 174, 175, 19, 24, 25, 140, 141, 142, 241, 242, 257, 263, 75, 23, 22 }

local function notify(msg, t)
    QBCore.Functions.Notify(msg, t or 'primary')
end

local function cleanupEntity(veh)
    if veh and DoesEntityExist(veh) then
        SetEntityAsMissionEntity(veh, true, true)
        DeleteEntity(veh)
    end
end

local function clearDisplays()
    for _, d in pairs(displays) do cleanupEntity(d.entity) end
    displays = {}
end

local function spawnDisplay(model, x, y, z, w)
    local hash = (type(model) == 'number') and model or GetHashKey(model)
    if not IsModelInCdimage(hash) or not IsModelAVehicle(hash) then
        notify(('Invalid vehicle model: %s'):format(tostring(model)), 'error')
        return nil
    end
    RequestModel(hash)
    local t = GetGameTimer()
    while not HasModelLoaded(hash) do
        Wait(0)
        if GetGameTimer() - t > 10000 then
            notify('Model load timed out: ' .. tostring(model), 'error')
            return nil
        end
    end
    local veh = CreateVehicle(hash, x + 0.0, y + 0.0, z + 0.0, w + 0.0, false, false)
    SetModelAsNoLongerNeeded(hash)
    SetVehicleOnGroundProperly(veh)
    SetEntityHeading(veh, w + 0.0)
    SetEntityInvincible(veh, true)
    SetVehicleDirtLevel(veh, 0.0)
    SetVehicleDoorsLocked(veh, 3)
    SetVehicleNumberPlateText(veh, 'RME')
    SetVehicleEngineOn(veh, false, true, true)
    FreezeEntityPosition(veh, true)
    displays[#displays + 1] = { entity = veh, model = (type(model) == 'number') and tostring(model) or model }
    return veh
end

local function respawnAll(list)
    clearDisplays()
    for _, v in ipairs(list or {}) do
        spawnDisplay(v.model, v.x, v.y, v.z, v.w or v.heading or 0.0)
    end
end

local function nearestDisplay()
    local pos = GetEntityCoords(PlayerPedId())
    local best, bestDist
    for i, d in pairs(displays) do
        if DoesEntityExist(d.entity) then
            local dd = #(pos - GetEntityCoords(d.entity))
            if not bestDist or dd < bestDist then
                bestDist = dd
                best = i
            end
        end
    end
    return best, bestDist
end

-- ===================== Gizmo / placement editor =====================

local function makeEntityMatrix(entity)
    local r, f, u, p = GetEntityMatrix(entity)
    return {
        r.x, r.y, r.z, 0.0,
        f.x, f.y, f.z, 0.0,
        u.x, u.y, u.z, 0.0,
        p.x, p.y, p.z, 1.0,
    }
end

local function drawEditHelp()
    SetTextFont(4)
    SetTextScale(0.40, 0.40)
    SetTextColour(255, 215, 0, 235)
    SetTextOutline()
    SetTextEntry('STRING')
    AddTextComponentString('PDM DISPLAY EDITOR')
    DrawText(0.015, 0.020)

    SetTextFont(4)
    SetTextScale(0.32, 0.32)
    SetTextColour(235, 235, 235, 225)
    SetTextOutline()
    SetTextEntry('STRING')
    AddTextComponentString('Hold LALT: drag gizmo   Arrows: move   Q/E: down/up   Scroll: rotate   Shift: fine')
    DrawText(0.015, 0.055)

    SetTextFont(4)
    SetTextScale(0.32, 0.32)
    SetTextColour(235, 235, 235, 225)
    SetTextOutline()
    SetTextEntry('STRING')
    AddTextComponentString('ENTER: save spot   BACKSPACE: cancel   (run /pdmsave to apply for everyone)')
    DrawText(0.015, 0.085)
end

local function editEntity(entity)
    if editing then
        notify('Already editing a car - finish that one first (Enter / Backspace).', 'error')
        return
    end
    if not entity or not DoesEntityExist(entity) then return end
    editing = entity
    local oc = GetEntityCoords(entity)
    editOriginal = { x = oc.x, y = oc.y, z = oc.z, w = GetEntityHeading(entity) }

    CreateThread(function()
        local dragging = false
        SetEntityDrawOutline(entity, true)
        while editing == entity and DoesEntityExist(entity) do
            Wait(0)
            for _, c in ipairs(EDIT_CONTROLS) do DisableControlAction(0, c, true) end
            drawEditHelp()

            local altHeld = IsDisabledControlPressed(0, 19) or IsControlPressed(0, 19)
            if altHeld then
                if not dragging then dragging = true end
                EnterCursorMode()
                local matrix = makeEntityMatrix(entity)
                pcall(function() DrawGizmo(matrix, ('rme_pdm_%d'):format(entity)) end)
                local gx, gy, gz = matrix[13], matrix[14], matrix[15]
                -- NaN guard (gx == gx is false only for NaN)
                if gx == gx and gy == gy and gz == gz then
                    SetEntityCoordsNoOffset(entity, gx, gy, gz, false, false, false)
                    SetEntityHeading(entity, GetHeadingFromVector_2d(matrix[5] + 0.0, matrix[6] + 0.0))
                end
            else
                if dragging then
                    LeaveCursorMode()
                    dragging = false
                end
                -- Still render the gizmo as a visual reference.
                local matrix = makeEntityMatrix(entity)
                pcall(function() DrawGizmo(matrix, ('rme_pdm_%d'):format(entity)) end)

                local fine = IsDisabledControlPressed(0, 21)
                local step = fine and 0.015 or 0.10
                local rot = fine and 0.4 or 1.6
                local pos = GetEntityCoords(entity)
                local nx, ny, nz = pos.x, pos.y, pos.z
                local camZ = math.rad(GetGameplayCamRot(2).z)
                local fX, fY = -math.sin(camZ), math.cos(camZ)
                local rX, rY = math.cos(camZ), math.sin(camZ)
                if IsDisabledControlPressed(0, 172) then nx = nx + fX * step; ny = ny + fY * step end -- up arrow
                if IsDisabledControlPressed(0, 173) then nx = nx - fX * step; ny = ny - fY * step end -- down arrow
                if IsDisabledControlPressed(0, 174) then nx = nx - rX * step; ny = ny - rY * step end -- left arrow
                if IsDisabledControlPressed(0, 175) then nx = nx + rX * step; ny = ny + rY * step end -- right arrow
                if IsDisabledControlPressed(0, 38) then nz = nz + step end                          -- E up
                if IsDisabledControlPressed(0, 44) then nz = nz - step end                          -- Q down
                SetEntityCoordsNoOffset(entity, nx, ny, nz, false, false, false)
                if IsDisabledControlPressed(0, 241) then SetEntityHeading(entity, GetEntityHeading(entity) + rot) end -- scroll up
                if IsDisabledControlPressed(0, 242) then SetEntityHeading(entity, GetEntityHeading(entity) - rot) end -- scroll down
            end

            if IsDisabledControlJustPressed(0, 18) then -- ENTER: confirm
                if dragging then LeaveCursorMode() end
                SetEntityDrawOutline(entity, false)
                editing = nil
                notify('Spot saved locally. Run /pdmsave to apply for everyone.', 'success')
                break
            end
            if IsDisabledControlJustPressed(0, 177) then -- BACKSPACE: cancel
                if dragging then LeaveCursorMode() end
                if editOriginal then
                    SetEntityCoordsNoOffset(entity, editOriginal.x, editOriginal.y, editOriginal.z, false, false, false)
                    SetEntityHeading(entity, editOriginal.w)
                end
                SetEntityDrawOutline(entity, false)
                editing = nil
                notify('Edit cancelled.', 'primary')
                break
            end
        end
        if dragging then pcall(LeaveCursorMode) end
        if DoesEntityExist(entity) then SetEntityDrawOutline(entity, false) end
        editing = nil
    end)
end

-- ===================== Commands (admin only) =====================

RegisterCommand('pdmadd', function(_, args)
    if not isAdmin then return notify('You are not allowed to edit the showroom.', 'error') end
    local model = args[1]
    if not model then return notify('Usage: /pdmadd <vehicle spawn name>  (e.g. /pdmadd adder)', 'error') end
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local fwd = GetEntityForwardVector(ped)
    local veh = spawnDisplay(model, pos.x + fwd.x * 4.0, pos.y + fwd.y * 4.0, pos.z, GetEntityHeading(ped))
    if veh then
        notify('Added ' .. model .. '. Position it, then press Enter to save the spot.', 'success')
        editEntity(veh)
    end
end, false)

RegisterCommand('pdmedit', function()
    if not isAdmin then return notify('You are not allowed to edit the showroom.', 'error') end
    local i = nearestDisplay()
    if not i then return notify('No display car nearby.', 'error') end
    editEntity(displays[i].entity)
end, false)

RegisterCommand('pdmmodel', function(_, args)
    if not isAdmin then return notify('You are not allowed to edit the showroom.', 'error') end
    local model = args[1]
    if not model then return notify('Usage: /pdmmodel <vehicle spawn name>', 'error') end
    local i = nearestDisplay()
    if not i then return notify('No display car nearby.', 'error') end
    local d = displays[i]
    local c = GetEntityCoords(d.entity)
    local h = GetEntityHeading(d.entity)
    cleanupEntity(d.entity)
    table.remove(displays, i)
    local veh = spawnDisplay(model, c.x, c.y, c.z, h)
    if veh then notify('Swapped nearest car to ' .. model .. '. Run /pdmsave to apply.', 'success') end
end, false)

RegisterCommand('pdmdelete', function()
    if not isAdmin then return notify('You are not allowed to edit the showroom.', 'error') end
    local i = nearestDisplay()
    if not i then return notify('No display car nearby.', 'error') end
    cleanupEntity(displays[i].entity)
    table.remove(displays, i)
    notify('Deleted nearest display car. Run /pdmsave to apply.', 'success')
end, false)

RegisterCommand('pdmclear', function()
    if not isAdmin then return notify('You are not allowed to edit the showroom.', 'error') end
    clearDisplays()
    notify('Cleared all display cars. Run /pdmsave to apply for everyone.', 'success')
end, false)

RegisterCommand('pdmsave', function()
    if not isAdmin then return notify('You are not allowed to edit the showroom.', 'error') end
    local list = {}
    for _, d in pairs(displays) do
        if DoesEntityExist(d.entity) then
            local c = GetEntityCoords(d.entity)
            list[#list + 1] = {
                model = d.model,
                x = c.x,
                y = c.y,
                z = c.z,
                w = GetEntityHeading(d.entity),
            }
        end
    end
    TriggerServerEvent('rme-pdm-display:server:save', list)
    notify('Saving ' .. #list .. ' showroom car(s)...', 'primary')
end, false)

RegisterCommand('pdmhelp', function()
    print('^3[rme-pdm-display] commands:^7')
    print('  /pdmadd <model>    - spawn a display car in front of you and start placing it')
    print('  /pdmedit           - re-position the nearest display car')
    print('  /pdmmodel <model>  - change the nearest display car to a different model')
    print('  /pdmdelete         - delete the nearest display car')
    print('  /pdmclear          - delete ALL display cars')
    print('  /pdmsave           - save the current layout for everyone (persists across restarts)')
    print('  Editing: hold LALT to drag the gizmo, arrows move, Q/E down/up, scroll rotates, Shift = fine, Enter = save spot, Backspace = cancel')
    notify('PDM display commands printed to F8 console. Type /pdmhelp again to repeat.', 'primary')
end, false)

-- ===================== State sync =====================

RegisterNetEvent('rme-pdm-display:client:setDisplays', function(list)
    respawnAll(list)
end)

RegisterNetEvent('rme-pdm-display:client:setAdmin', function(v)
    isAdmin = v and true or false
end)

local function requestState()
    TriggerServerEvent('rme-pdm-display:server:requestState')
end

AddEventHandler('onClientResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    CreateThread(function()
        Wait(2000)
        requestState()
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    CreateThread(function()
        Wait(1500)
        requestState()
    end)
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then clearDisplays() end
end)
