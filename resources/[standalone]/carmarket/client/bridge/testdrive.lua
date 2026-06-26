KOJA.Client.testDriveActive = false
KOJA.Client.testDriveState = nil

local function isTestDriveCancelPressed(cancelKey)
    if type(cancelKey) ~= 'number' or cancelKey < 0 then return false end
    if IsControlJustPressed(0, cancelKey) then return true end
    if IsDisabledControlJustPressed(0, cancelKey) then return true end
    return false
end

local function testDriveCancelKeyHint(cancelKey)
    if type(cancelKey) ~= 'number' then return '' end
    local ok, s = pcall(function()
        return GetControlInstructionalButton(0, cancelKey, true)
    end)
    if ok and type(s) == 'string' and s ~= '' then
        s = s:gsub('~', ''):gsub('^%s+', ''):gsub('%s+$', '')
        local key = s:match('^t_(.+)$') or s:match('^T_(.+)$')
        if key and key ~= '' then
            return key
        end
        if not s:match('^INPUT_') then
            return s
        end
    end
    local known = {
        [73] = 'X',
        [47] = 'G',
        [38] = 'E',
    }
    return known[cancelKey] or tostring(cancelKey)
end

function KOJA.Client.abortMarketTestDriveOnStop()
    if not KOJA.Client.testDriveActive then return end
    local st = KOJA.Client.testDriveState
    if st and st.entity and DoesEntityExist(st.entity) then
        DeleteEntity(st.entity)
    end
    local ped = PlayerPedId()
    if st and st.backCoords then
        SetEntityCoords(ped, st.backCoords.x, st.backCoords.y, st.backCoords.z, false, false, false, false)
        if st.backHeading then SetEntityHeading(ped, st.backHeading) end
    end
    KOJA.Client.testDriveActive = false
    KOJA.Client.testDriveState = nil
end

function KOJA.Client.BeginMarketTestDriveFromListingId(listingId)
    KOJA.Client.TriggerServerCallback('koja_carmarket:server:getVehicleViewData', { vehicleId = listingId }, function(result)
        if not result or not result.success or not result.vehicle then return end
        if result.auction and result.auction.ended then
            KOJA.Client.SendNotify({
                type = 'error',
                title = _L('lua.client.error'),
                desc = _L('lua.client.test_drive_auction_ended'),
                time = 5000,
            })
            return
        end
        local zoneId = result.vehicle.zone_id
        if not zoneId or tostring(zoneId):match('^%s*$') then
            KOJA.Client.SendNotify({
                type = 'error',
                title = _L('lua.client.error'),
                desc = _L('lua.client.test_drive_no_zone'),
                time = 5000,
            })
            return
        end
        KOJA.Client.startMarketTestDriveFromCarData(zoneId, result.vehicle)
    end)
end

local function runMarketTestDriveAfterPay(_zoneId, carData, cfg)
    local sx, sy, sz = cfg.coords.x, cfg.coords.y, cfg.coords.z
    local sh = cfg.heading
    local seconds = cfg.secondslimit
    local cancelKey = cfg.cancelKey

    local props = KOJA.Client.mergeListingVehicleProps(carData)
    local modelHash = Misc.Utils.ExtractVehicleModelHash(props)
    if not modelHash or modelHash == 0 then
        KOJA.Client.SendNotify({
            type = 'error',
            title = _L('lua.client.error'),
            desc = _L('lua.client.test_drive_no_model'),
            time = 5000,
        })
        return
    end

    local ped = PlayerPedId()
    local backCoords = GetEntityCoords(ped)
    local backHeading = GetEntityHeading(ped)

    KOJA.Client.closeUI()
    SetFollowVehicleCamViewMode(1)

    Misc.Utils.LoadModel(modelHash)
    local entity = CreateVehicle(modelHash, sx, sy, sz, sh or 0.0, false, false)
    if not entity or entity == 0 then
        SetModelAsNoLongerNeeded(modelHash)
        KOJA.Client.SendNotify({
            type = 'error',
            title = _L('lua.client.error'),
            desc = _L('lua.client.test_drive_spawn_failed'),
            time = 5000,
        })
        return
    end
    SetEntityAsMissionEntity(entity, true, true)
    KOJA.Client.applyDecodedVehicleProps(entity, props)
    local plate = carData and carData.plate and tostring(carData.plate):match('%S+') and tostring(carData.plate) or 'TEST'
    SetVehicleNumberPlateText(entity, plate:sub(1, 8))
    FreezeEntityPosition(entity, false)
    SetVehicleDoorsLocked(entity, 1)
    SetVehicleEngineOn(entity, true, true, false)
    SetVehicleHasBeenOwnedByPlayer(entity, true)
    SetPedIntoVehicle(ped, entity, -1)
    SetEntityInvincible(ped, false)

    KOJA.Client.testDriveActive = true
    KOJA.Client.testDriveState = {
        entity = entity,
        backCoords = backCoords,
        backHeading = backHeading,
        modelHash = modelHash,
    }

    local keyHint = testDriveCancelKeyHint(cancelKey)
    KOJA.Client.SendNotify({
        type = 'info',
        title = _L('lua.client.test_drive'),
        desc = _L('lua.client.test_drive_start_desc', {
            seconds = seconds,
            keyhint = keyHint,
        }),
        time = 8000,
    })

    CreateThread(function()
        local playerPed = PlayerPedId()
        local testDriveActive = true
        local wasCancelled = false
        local startTime = GetGameTimer()
        local duration = seconds * 1000

        while testDriveActive and (GetGameTimer() - startTime < duration) and DoesEntityExist(entity) and not IsEntityDead(playerPed) do
            if isTestDriveCancelPressed(cancelKey) then
                wasCancelled = true
                break
            end
            if GetVehiclePedIsIn(playerPed, false) == 0 and DoesEntityExist(entity) then
                SetPedIntoVehicle(playerPed, entity, -1)
            end
            Wait(0)
        end

        testDriveActive = false
        KOJA.Client.testDriveActive = false

        if DoesEntityExist(entity) then
            SetEntityAsMissionEntity(entity, true, true)
            DeleteEntity(entity)
        end
        SetModelAsNoLongerNeeded(modelHash)

        SetEntityCoords(playerPed, backCoords.x, backCoords.y, backCoords.z, false, false, false, false)
        SetEntityHeading(playerPed, backHeading)

        KOJA.Client.testDriveState = nil

        KOJA.Client.SendNotify({
            type = 'info',
            title = _L('lua.client.test_drive'),
            desc = wasCancelled and _L('lua.client.test_drive_cancel') or _L('lua.client.test_drive_end'),
            time = 6000,
        })
    end)
end

function KOJA.Client.startMarketTestDriveFromCarData(zoneId, carData)
    if KOJA.Client.testDriveActive then
        KOJA.Client.SendNotify({
            type = 'error',
            title = _L('lua.client.error'),
            desc = _L('lua.client.test_drive_busy'),
            time = 5000,
        })
        return
    end

    local cfg = KOJA.Shared.resolveTestDriveSettings(zoneId)
    if not cfg then
        KOJA.Client.SendNotify({
            type = 'error',
            title = _L('lua.client.error'),
            desc = _L('lua.client.test_drive_disabled'),
            time = 5000,
        })
        return
    end

    KOJA.Client.TriggerServerCallback('koja_carmarket:server:payTestDriveFee', { zoneId = tostring(zoneId) }, function(pay)
        if not pay or not pay.success then
            local reason = pay and pay.reason
            if reason == 'no_money' then
                KOJA.Client.SendNotify({
                    type = 'error',
                    title = _L('lua.client.error'),
                    desc = _L('lua.client.test_drive_no_money', { price = tostring(pay.price or cfg.price or 0) .. '$' }),
                    time = 6000,
                })
            elseif reason == 'disabled' then
                KOJA.Client.SendNotify({
                    type = 'error',
                    title = _L('lua.client.error'),
                    desc = _L('lua.client.test_drive_disabled'),
                    time = 5000,
                })
            else
                KOJA.Client.SendNotify({
                    type = 'error',
                    title = _L('lua.client.error'),
                    desc = _L('lua.client.test_drive_pay_failed'),
                    time = 5000,
                })
            end
            return
        end

        runMarketTestDriveAfterPay(zoneId, carData, cfg)
    end)
end
