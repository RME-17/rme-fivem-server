local QBCore = exports['qb-core']:GetCoreObject()

local ZONE = 'ems_bossmenu'
local DEFAULT_LOC = { x = 312.6, y = -598.7, z = 43.28, h = 340.0 } -- Pillbox reception
local current = nil

local function isEmsBoss()
    local pd = QBCore.Functions.GetPlayerData()
    return pd and pd.job and pd.job.name == 'ambulance' and pd.job.isboss == true
end

local function loadLoc()
    local raw = GetResourceKvpString('rme_emsboss_loc')
    if raw then
        local ok, data = pcall(json.decode, raw)
        if ok and data and data.x then return data end
    end
    return DEFAULT_LOC
end

local function addZone(loc)
    exports['qb-target']:AddBoxZone(ZONE, vector3(loc.x, loc.y, loc.z), 1.4, 1.4, {
        name = ZONE,
        heading = loc.h or 0.0,
        debugPoly = false,
        minZ = loc.z - 1.0,
        maxZ = loc.z + 1.2,
    }, {
        options = {
            {
                type = 'client',
                event = 'qb-bossmenu:client:OpenMenu',
                icon = 'fas fa-clipboard-list',
                label = 'EMS Management',
                job = 'ambulance',
                canInteract = function() return isEmsBoss() end,
            },
        },
        distance = 2.0,
    })
    current = loc
end

CreateThread(function()
    while GetResourceState('qb-target') ~= 'started' do Wait(250) end
    addZone(loadLoc())
end)

-- Medical Director: stand where you want the boss desk and run /setemsboss
RegisterCommand('setemsboss', function()
    if not isEmsBoss() then
        QBCore.Functions.Notify('Only the EMS Medical Director can move the boss menu.', 'error')
        return
    end
    local ped = PlayerPedId()
    local c = GetEntityCoords(ped)
    local loc = {
        x = math.floor(c.x * 100) / 100,
        y = math.floor(c.y * 100) / 100,
        z = math.floor(c.z * 100) / 100,
        h = math.floor(GetEntityHeading(ped) * 100) / 100,
    }
    SetResourceKvp('rme_emsboss_loc', json.encode(loc))
    if current then exports['qb-target']:RemoveZone(ZONE) end
    addZone(loc)
    QBCore.Functions.Notify(('EMS boss menu placed here (%.2f, %.2f, %.2f).'):format(loc.x, loc.y, loc.z), 'success')
end, false)

-- Reset back to the reception default
RegisterCommand('resetemsboss', function()
    if not isEmsBoss() then
        QBCore.Functions.Notify('Only the EMS Medical Director can do that.', 'error')
        return
    end
    DeleteResourceKvp('rme_emsboss_loc')
    if current then exports['qb-target']:RemoveZone(ZONE) end
    addZone(DEFAULT_LOC)
    QBCore.Functions.Notify('EMS boss menu reset to reception.', 'success')
end, false)
