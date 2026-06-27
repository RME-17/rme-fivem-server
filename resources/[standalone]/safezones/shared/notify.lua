-- Notification wrapper
-- Customize this function to use your preferred notification system
-- Supports: rme (RME glass UI), standalone (chat), ox_lib, qb, esx
-- Change Config.NotifyType in config.lua to switch

function Notify(msg, type)
    type = type or 'info'

    local notifyType = Config.NotifyType or 'chat'

    if notifyType == 'rme' then
        -- RME custom glass toast (resource: rme-safezone-ui)
        TriggerEvent('rme-safezone:notify', msg, type)
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
