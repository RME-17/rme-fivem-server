-- RME SafeZone glass notification UI
-- Triggered by safezones/shared/notify.lua when Config.NotifyType = 'rme'
RegisterNetEvent('rme-safezone:notify', function(message, ntype)
    if not message then return end
    SendNUIMessage({
        action = 'notify',
        message = message,
        type = ntype or 'info',
    })
end)
