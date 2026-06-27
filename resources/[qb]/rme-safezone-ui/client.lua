-- RME SafeZone glass UI
-- Driven by safezones/shared/notify.lua (Config.NotifyType = 'rme')
local function send(data)
    SendNUIMessage(data)
end

-- Persistent safe-zone indicator: shown on enter, stays until the player leaves
RegisterNetEvent('rme-safezone:show', function(message, ntype)
    send({ action = 'show', message = message or 'Safe Zone', type = ntype or 'info' })
end)

-- Remove the indicator once the player is outside the zone
RegisterNetEvent('rme-safezone:hide', function()
    send({ action = 'hide' })
end)

-- Transient toast for other messages (admin actions, errors)
RegisterNetEvent('rme-safezone:notify', function(message, ntype)
    if not message then return end
    send({ action = 'notify', message = message, type = ntype or 'info' })
end)

-- Safety: clear the banner when this resource (re)starts
AddEventHandler('onResourceStart', function(res)
    if res == GetCurrentResourceName() then send({ action = 'hide' }) end
end)
