-- RME Redline shared parts stash -- physical box at the shop.
-- A qb-target box zone at Config.RedlineStorage.coords lets Redline members open
-- the same shared stash the boss stocks with crafted spray cans / parts. Access
-- is gated server-side (only mechanics), so anyone can target it but non-members
-- are turned away with a notification. Loaded automatically via the client/*.lua
-- glob in fxmanifest.lua.
CreateThread(function()
    local cfg = Config.RedlineStorage
    if not cfg or not cfg.coords then return end
    local c = cfg.coords

    exports['qb-target']:AddBoxZone('redline_storage_box', vector3(c.x, c.y, c.z), 1.2, 1.2, {
        name = 'redline_storage_box',
        heading = 0.0,
        debugPoly = false,
        minZ = c.z - 1.0,
        maxZ = c.z + 1.0,
    }, {
        options = {
            {
                icon = 'fas fa-box-open',
                label = 'Open Redline Storage',
                action = function()
                    TriggerServerEvent('qb-mechanicjob:server:openRedlineStorage')
                end,
            }
        },
        distance = 2.0
    })

    print(('[qb-mechanicjob] Redline storage box registered at %s, %s, %s'):format(c.x, c.y, c.z))
end)
