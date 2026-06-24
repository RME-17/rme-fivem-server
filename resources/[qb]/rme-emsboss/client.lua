local QBCore = exports['qb-core']:GetCoreObject()

-- Pillbox reception boss desk. Tweak these to move the interaction point.
local bossDesk = vector3(312.6, -598.7, 43.28)

local function isEmsBoss()
    local pd = QBCore.Functions.GetPlayerData()
    return pd and pd.job and pd.job.name == 'ambulance' and pd.job.isboss == true
end

CreateThread(function()
    -- qb-target lives in [qb]; wait until it is started before registering.
    while GetResourceState('qb-target') ~= 'started' do Wait(250) end

    exports['qb-target']:AddBoxZone('ems_bossmenu', bossDesk, 1.4, 1.4, {
        name = 'ems_bossmenu',
        heading = 340.0,
        debugPoly = false,
        minZ = 42.9,
        maxZ = 43.95,
    }, {
        options = {
            {
                type = 'client',
                event = 'qb-bossmenu:client:OpenMenu',
                icon = 'fas fa-clipboard-list',
                label = 'EMS Management',
                job = 'ambulance',
                canInteract = function()
                    return isEmsBoss()
                end,
            },
        },
        distance = 2.0,
    })
end)
