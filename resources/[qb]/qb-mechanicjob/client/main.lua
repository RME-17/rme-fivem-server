local sharedVehicles = exports['qb-core']:GetShared('Vehicles')
PlayerData = {}

-- Handlers

AddEventHandler('OnResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUpdated', function(key, val)
    if key == 'job' then
        local JobInfo = val
        PlayerData.job = JobInfo
    elseif key == 'all' then
        local JobInfo = val.job
        PlayerData.job = JobInfo
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

-- Global Functions

function Trim(plate)
    return (string.gsub(plate, '^%s*(.-)%s*$', '%1'))
end

function ToggleHood(vehicle)
    if GetVehicleDoorAngleRatio(vehicle, 4) > 0.0 then
        SetVehicleDoorShut(vehicle, 4, false)
    else
        SetVehicleDoorOpen(vehicle, 4, false, false)
    end
end

function IsNearBone(vehicle, bone)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local vehicleBoneIndex = GetEntityBoneIndexByName(vehicle, bone)
    if vehicleBoneIndex ~= -1 then
        local bonePos = GetWorldPositionOfEntityBone(vehicle, vehicleBoneIndex)
        if #(playerCoords - bonePos) <= 1.5 then
            return true
        end
    end
    return false
end

function GetClosestWheel(vehicle)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local closestWheelIndex
    for wheelIndex, wheelBone in pairs(Config.WheelBones) do
        local wheelBoneIndex = GetEntityBoneIndexByName(vehicle, wheelBone)
        if wheelBoneIndex ~= -1 then
            local wheelPos = GetWorldPositionOfEntityBone(vehicle, wheelBoneIndex)
            if #(playerCoords - wheelPos) <= 1.5 then
                closestWheelIndex = wheelIndex
                break
            end
        end
    end
    return closestWheelIndex
end

-- Local Functions

local function SpawnListVehicle(model, spawnPoint)
    QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
        local veh = NetToVeh(netId)
        SetVehicleNumberPlateText(veh, 'MECH' .. tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, spawnPoint.w)
        exports[Config.FuelResource]:SetFuel(veh, 100.0)
        TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true, false)
    end, model, spawnPoint, true)
end

local function VehicleList(shop)
    local vehicleMenu = { { header = Lang:t('menu.vehicle_list'), isMenuHeader = true } }
    local list = Config.Shops[shop].vehicles.list
    for i = 1, #list do
        local v = list[i]
        vehicleMenu[#vehicleMenu + 1] = {
            header = sharedVehicles[v].name,
            params = {
                event = 'qb-mechanicjob:client:SpawnListVehicle',
                args = {
                    spawnName = v,
                    location = Config.Shops[shop].vehicles.spawn
                }
            }
        }
    end
    vehicleMenu[#vehicleMenu + 1] = {
        header = Lang:t('menu.close'),
        txt = '',
        params = {
            event = 'qb-menu:client:closeMenu'
        }

    }
    exports['qb-menu']:openMenu(vehicleMenu)
end

-- Events

RegisterNetEvent('qb-mechanicjob:client:SpawnListVehicle', function(data)
    local vehicleSpawnName = data.spawnName
    local spawnPoint = data.location
    SpawnListVehicle(vehicleSpawnName, spawnPoint)
end)

-- Main Thread

CreateThread(function()
    print('[RME-BAY-DEBUG] qb-mechanicjob main thread started; iterating Config.Shops')
    for k, v in pairs(Config.Shops) do
        print(('[RME-BAY-DEBUG] processing shop=%s managed=%s'):format(tostring(k), tostring(v.managed)))
        if v.showBlip then
            local blip = AddBlipForCoord(v.blipCoords)
            SetBlipSprite(blip, v.blipSprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.6)
            SetBlipColour(blip, v.blipColor)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(v.shopLabel)
            EndTextCommandSetBlipName(blip)
        end

        exports['qb-target']:AddCircleZone(k .. '_duty', v.duty, 0.5, {
            name = k .. '_duty',
            debugPoly = false,
            useZ = true
        }, {
            options = { {
                type = 'server',
                event = 'QBCore:ToggleDuty',
                label = Lang:t('target.duty'),
                icon = 'fas fa-user-clock',
                job = v.managed and k or nil
            } },
            distance = 2.0
        })

        exports['qb-target']:AddCircleZone(k .. '_stash', v.stash, 0.5, {
            name = k .. '_stash',
            debugPoly = false,
            useZ = true
        }, {
            options = { {
                label = Lang:t('target.stash'),
                icon = 'fas fa-box-open',
                job = v.managed and k or nil,
                type = 'server',
                event = 'qb-mechanicjob:server:stash',
            } },
            distance = 2.0
        })

        -- Paint booth (optional: a shop may skip this and rely on the custom bay's paint menu)
        if v.paint then
            exports['qb-target']:AddCircleZone(k .. '_paintbooth', v.paint, 0.5, {
                name = k .. '_paintbooth',
                debugPoly = false,
                useZ = true
            }, {
                options = { {
                    label = Lang:t('target.paint'),
                    icon = 'fas fa-fill-drip',
                    job = v.managed and k or nil,
                    action = function()
                        PaintCategories() -- cosmetics.lua
                    end
                } },
                distance = 2.0
            })
        end

        -- Service-vehicle spawner (optional: a shop may skip the vehicles block entirely)
        if v.vehicles then
            exports['qb-target']:AddCircleZone(k .. '_spawner', v.vehicles.withdraw, 0.5, {
                name = k .. '_spawner',
                debugPoly = false,
                useZ = true
            }, {
                options = {
                    {
                        label = Lang:t('target.withdraw'),
                        icon = 'fas fa-car',
                        job = v.managed and k or nil,
                        canInteract = function()
                            local inVehicle = GetVehiclePedIsUsing(PlayerPedId())
                            if inVehicle ~= 0 then return false end
                            return true
                        end,
                        action = function()
                            VehicleList(k)
                        end
                    },
                    {
                        label = Lang:t('target.deposit'),
                        icon = 'fas fa-car',
                        job = k,
                        canInteract = function()
                            local inVehicle = GetVehiclePedIsUsing(PlayerPedId())
                            if inVehicle == 0 then return false end
                            return true
                        end,
                        action = function()
                            SetEntityAsMissionEntity(GetVehiclePedIsUsing(PlayerPedId()), true, true)
                            DeleteVehicle(GetVehiclePedIsUsing(PlayerPedId()))
                        end
                    }
                },
                distance = 5.0
            })
        end

        -- RME: drive-in customization bay(s).
        -- *** TEMP DEBUG BUILD ***
        --   debugPoly = true  -> zone circles are drawn on the floor so we can SEE them
        --   job lock removed  -> tests whether the redline job gate was the blocker
        --   F8 prints         -> confirm the loop reaches this shop and how many bays register
        local bays = v.custombays or (v.custombay and { v.custombay })
        if bays then
            print(('[RME-BAY-DEBUG] shop=%s has %d custombay(s)'):format(tostring(k), #bays))
            for i = 1, #bays do
                print(('[RME-BAY-DEBUG] registering %s_custombay_%d at %s'):format(tostring(k), i, tostring(bays[i])))
                exports['qb-target']:AddCircleZone(k .. '_custombay_' .. i, bays[i], 3.5, {
                    name = k .. '_custombay_' .. i,
                    debugPoly = true,
                    useZ = true
                }, {
                    options = { {
                        label = 'Customize Vehicle (Bay)',
                        icon = 'fas fa-paint-roller',
                        -- job lock intentionally omitted for this debug build
                        action = function()
                            OpenCustomBay() -- custombay.lua
                        end
                    } },
                    distance = 3.5
                })
            end
        end
    end
    print('[RME-BAY-DEBUG] finished iterating Config.Shops')
end)
