-- RME dedicated speedometer (bottom-right). Cars + aircraft.
local UseMPH = false -- false = KM/H (KPH) for the whole server; set true for MPH
local speedMult = UseMPH and 2.23694 or 3.6
local speedUnit = UseMPH and 'MPH' or 'KM/H'
local FuelScript = 'LegacyFuel'

local DIRS = { 'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW' }

local function getCompass(entity)
    local heading = GetEntityHeading(entity)
    local bearing = (360.0 - heading) % 360.0
    local idx = math.floor(((bearing + 22.5) % 360.0) / 45.0) + 1
    return math.floor(bearing + 0.5), DIRS[idx]
end

local function getFuel(veh)
    local ok, fuel = pcall(function()
        return exports[FuelScript]:GetFuel(veh)
    end)
    if ok and fuel then
        return math.floor(fuel + 0.5)
    end
    return math.floor(GetVehicleFuelLevel(veh) + 0.5)
end

-- Engine health as a 0-100% value. The spanner/condition meter reflects the
-- ENGINE only (not body/cosmetic damage).
local function getHealth(veh)
    local engH = GetVehicleEngineHealth(veh)  -- 0 .. 1000 (can go negative when on fire)
    return math.max(0, math.min(100, math.floor(engH / 10.0 + 0.5)))
end

local shown = false

CreateThread(function()
    while true do
        local sleep = 350
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            if veh ~= 0 and not IsThisModelABicycle(GetEntityModel(veh)) then
                sleep = 90
                local isAir = IsPedInAnyHeli(ped) or IsPedInAnyPlane(ped)
                local speed = math.floor(GetEntitySpeed(veh) * speedMult + 0.5)
                local rpm = GetVehicleCurrentRpm(veh)
                local gear = GetVehicleCurrentGear(veh)
                local fuel = getFuel(veh)
                local health = getHealth(veh)
                local alt = math.floor(GetEntityCoords(ped).z + 0.5)
                local heading, dir = getCompass(veh)
                if not shown then
                    shown = true
                    SendNUIMessage({ action = 'speedo', show = true })
                end
                SendNUIMessage({
                    action = 'update',
                    speed = speed,
                    unit = speedUnit,
                    rpm = rpm,
                    gear = gear,
                    fuel = fuel,
                    health = health,
                    altitude = alt,
                    isAir = isAir,
                    heading = heading,
                    dir = dir,
                })
            elseif shown then
                shown = false
                SendNUIMessage({ action = 'speedo', show = false })
            end
        elseif shown then
            shown = false
            SendNUIMessage({ action = 'speedo', show = false })
        end
        Wait(sleep)
    end
end)

-- Always-on compass above the minimap (works on foot and in vehicle).
-- Uses the gameplay camera heading so it points where the player is looking.
local function currentStreet(ped)
    local pos = GetEntityCoords(ped)
    local h = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local name = GetStreetNameFromHashKey(h)
    if name == nil then return '' end
    return name
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local camRot = GetGameplayCamRot(0)
        local bearing = (360.0 - ((camRot.z + 360.0) % 360.0)) % 360.0
        local deg = math.floor(bearing + 0.5) % 360
        local idx = math.floor(((bearing + 22.5) % 360.0) / 45.0) + 1
        local dir = DIRS[idx]
        local street = currentStreet(ped)
        -- Always push the current state (not only on change) so a freshly
        -- (re)loaded NUI page immediately shows the compass even when the player
        -- is standing still and nothing has changed yet.
        SendNUIMessage({ action = 'compass', dir = dir, heading = deg, street = street })
        Wait(200)
    end
end)

-- Hide the compass + minimap fade border while the pause menu (Escape) is open,
-- mirroring how the native minimap hides on pause. Re-shows when it closes.
CreateThread(function()
    local paused = false
    while true do
        local active = IsPauseMenuActive()
        if active and not paused then
            paused = true
            SendNUIMessage({ action = 'pause', hidden = true })
        elseif not active and paused then
            paused = false
            SendNUIMessage({ action = 'pause', hidden = false })
        end
        Wait(150)
    end
end)
