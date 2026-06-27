--[[ RME_PD_GARAGE_V1
  Adds a glowing car blip + glowing ground marker at every police vehicle
  garage point, and a reliable [E] interaction to open the qb-policejob
  vehicle garage menu.

  Why: stock qb-policejob has no marker and relies on a click-to-open
  qb-menu header that often does not register. This gives officers a clear
  glowing spot and a guaranteed keypress to pull vehicles.

  It reuses qb-policejob's own events, so the existing store-vehicle flow,
  spawn coords, and grade-gated vehicle list all keep working.
]]

local QBCore = exports['qb-core']:GetCoreObject()

-- Mirror of qb-policejob Config.Locations.vehicle (keep in sync if you move them)
local GaragePoints = {
    vector4(548.96, -55.61, 71.07, 247.22),   -- Vinewood PD driveway
    vector4(-455.39, 6002.02, 31.34, 87.93),  -- Paleto
    vector4(1862.4, 3699.5, 33.45, 30.0),     -- Sandy Shores
}

local MARKER_DIST = 25.0   -- start drawing the ground marker within this range
local INTERACT_DIST = 1.5  -- must match qb-policejob's garage box so its inGarage flag is set

local function getJob()
    local pdata = QBCore.Functions.GetPlayerData()
    if not pdata or not pdata.job then return nil end
    return pdata.job
end

local function isLeo()
    local job = getJob()
    return job ~= nil and job.type == 'leo'
end

local function isOnDutyLeo()
    local job = getJob()
    return job ~= nil and job.type == 'leo' and job.onduty
end

-- Map blips (car icon) -- only visible to LEO
local blips = {}

local function createBlips()
    if #blips > 0 then return end
    for i = 1, #GaragePoints do
        local p = GaragePoints[i]
        local blip = AddBlipForCoord(p.x, p.y, p.z)
        SetBlipSprite(blip, 357)   -- car icon
        SetBlipColour(blip, 3)     -- light blue
        SetBlipScale(blip, 0.85)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Police Garage')
        EndTextCommandSetBlipName(blip)
        blips[#blips + 1] = blip
    end
end

local function removeBlips()
    for _, b in ipairs(blips) do
        if DoesBlipExist(b) then RemoveBlip(b) end
    end
    blips = {}
end

CreateThread(function()
    while true do
        if isLeo() then createBlips() else removeBlips() end
        Wait(5000)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then removeBlips() end
end)

-- Ground markers + [E] open
CreateThread(function()
    local textShown = false
    while true do
        local sleep = 1000
        if isLeo() then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local nearestIdx, nearestDist
            for i = 1, #GaragePoints do
                local p = GaragePoints[i]
                local d = #(pos - vector3(p.x, p.y, p.z))
                if d < MARKER_DIST then
                    sleep = 0
                    local pulse = (math.sin(GetGameTimer() / 400.0) * 0.5) + 0.5
                    local a = math.floor(70 + (pulse * 140))
                    DrawMarker(1, p.x, p.y, p.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                        1.5, 1.5, 0.6, 0, 150, 255, a, false, true, 2, false, nil, nil, false)
                    if not nearestDist or d < nearestDist then
                        nearestDist = d
                        nearestIdx = i
                    end
                end
            end

            local canInteract = nearestIdx ~= nil and nearestDist <= INTERACT_DIST and not IsPedInAnyVehicle(ped, false)
            if canInteract and isOnDutyLeo() then
                sleep = 0
                if not textShown then
                    exports['qb-core']:DrawText('[E] Open Police Garage', 'left')
                    textShown = true
                end
                if IsControlJustReleased(0, 38) then
                    exports['qb-core']:HideText()
                    textShown = false
                    TriggerEvent('police:client:VehicleMenuHeader', { currentSelection = nearestIdx })
                end
            elseif textShown then
                exports['qb-core']:HideText()
                textShown = false
            end
        elseif textShown then
            exports['qb-core']:HideText()
            textShown = false
        end
        Wait(sleep)
    end
end)
