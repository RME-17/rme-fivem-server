if lib == nil then lib = {} end

if IsDuplicityVersion() then
    local callbacks = {}
    lib.callback = lib.callback or {}

    lib.callback.register = lib.callback.register or function(name, cb)
        callbacks[name] = cb
    end

    RegisterNetEvent('fetchq-oil:compat:callback:request', function(name, requestId, ...)
        local src = source
        local cb = callbacks[name]
        local result = nil
        if cb then
            local ok, value = pcall(cb, src, ...)
            if ok then result = value end
        end
        TriggerClientEvent('fetchq-oil:compat:callback:response', src, requestId, result)
    end)
else
    local callbackId = 0
    local pendingCallbacks = {}

    lib.callback = lib.callback or function(name, _delay, cb, ...)
        callbackId = callbackId + 1
        pendingCallbacks[callbackId] = cb
        TriggerServerEvent('fetchq-oil:compat:callback:request', name, callbackId, ...)
    end

    RegisterNetEvent('fetchq-oil:compat:callback:response', function(requestId, result)
        local cb = pendingCallbacks[requestId]
        if cb then
            pendingCallbacks[requestId] = nil
            cb(result)
        end
    end)

    lib.notify = lib.notify or function(data)
        local msg = type(data) == 'table' and (data.description or data.title or 'Notification') or tostring(data)
        local nType = type(data) == 'table' and (data.type or 'primary') or 'primary'
        if GetResourceState('es_extended') == 'started' then
            TriggerEvent('esx:showNotification', msg)
        else
            TriggerEvent('QBCore:Notify', msg, nType)
        end
    end

    lib.showTextUI = lib.showTextUI or function(message)
        SetTextComponentFormat('STRING')
        AddTextComponentString(message)
        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    end

    lib.hideTextUI = lib.hideTextUI or function()
        BeginTextCommandDisplayHelp('CLEAR')
        EndTextCommandDisplayHelp(0, false, false, -1)
    end

    lib.progressBar = lib.progressBar or function(data)
        Wait((type(data) == 'table' and tonumber(data.duration)) or 0)
        return true
    end

    lib.zones = lib.zones or {}
    lib.zones.box = lib.zones.box or function(config)
        local zone = { destroyed = false }
        local coords = config.coords
        local size = config.size or vec3(4.0, 4.0, 4.0)
        local halfX, halfY, halfZ = (size.x or 4.0) / 2.0, (size.y or 4.0) / 2.0, (size.z or 4.0) / 2.0

        CreateThread(function()
            local wasInside = false
            while not zone.destroyed do
                local sleep = 300
                local ped = PlayerPedId()
                local p = GetEntityCoords(ped)
                local inside = math.abs(p.x - coords.x) <= halfX and math.abs(p.y - coords.y) <= halfY and math.abs(p.z - coords.z) <= halfZ
                if inside then
                    sleep = 0
                    if not wasInside and config.onEnter then config.onEnter() end
                    wasInside = true
                    if config.inside then config.inside() end
                elseif wasInside then
                    wasInside = false
                    if config.onExit then config.onExit() end
                end
                Wait(sleep)
            end
        end)

        function zone:destroy()
            self.destroyed = true
        end

        return zone
    end
end