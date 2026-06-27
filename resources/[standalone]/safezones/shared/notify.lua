-- Notification wrapper
-- Customize this function to use your preferred notification system
-- Supports: rme (RME glass UI), standalone (chat), ox_lib, qb, esx
-- Change Config.NotifyType in config.lua to switch

local function L(key, fallback)
    local ok, val = pcall(function() return _L and _L(key) end)
    if ok and type(val) == 'string' and val ~= '' and val ~= key then return val end
    return fallback
end

function Notify(msg, type)
    type = type or 'info'

    local notifyType = Config.NotifyType or 'chat'

    if notifyType == 'rme' then
        -- RME custom glass UI (resource: rme-safezone-ui)
        local entered = L('notify.entered_safezone', 'You entered a safe zone')
        local left = L('notify.left_safezone', 'You left the safe zone')
        if msg and entered ~= '' and string.find(msg, entered, 1, true) then
            -- Persistent indicator while the player is inside the zone
            TriggerEvent('rme-safezone:show', msg, type)
        elseif msg and left ~= '' and string.find(msg, left, 1, true) then
            -- Remove the indicator once the player is outside the zone
            TriggerEvent('rme-safezone:hide')
        else
            -- Other messages (admin actions, errors) as a transient toast
            TriggerEvent('rme-safezone:notify', msg, type)
        end
    elseif notifyType == 'ox_lib' and GetResourceState('ox_lib') == 'started' then
        lib.notify({
            title = 'SafeZone',
            description = msg,
            type = type, -- 'info', 'success', 'error', 'warning'
        })
    elseif notifyType == 'qb' and GetResourceState('qb-core') == 'started' then
        TriggerEvent('QBCore:Notify', msg, type)
    elseif notifyType == 'esx' and GetResourceState('es_extended') == 'started' then
        TriggerEvent('esx:showNotification', msg)
    else
        -- Standalone: chat message
        TriggerEvent('chat:addMessage', {
            color = { 59, 130, 246 },
            args = { 'SafeZone', msg },
        })
    end
end
