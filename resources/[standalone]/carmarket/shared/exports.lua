if not IsDuplicityVersion() then
    exports('OpenTablet', function()
        TriggerEvent('koja_carmarket:client:openTablet')
    end)
    exports('RefreshZone', function(zoneId)
        if (type(zoneId) == 'string' or type(zoneId) == 'number') and KOJA.Client and KOJA.Client.RefreshZone then
            KOJA.Client.RefreshZone(tostring(zoneId))
        end
    end)
    exports('CloseTablet', function()
        if KOJA.Client and KOJA.Client.closeUI then KOJA.Client.closeUI() end
    end)
    exports('IsTabletOpen', function()
        return KOJA.Client and KOJA.Client.Visible == true
    end)
else
    exports('GetCarsInZone', function(zoneId)
        if type(zoneId) ~= 'string' and type(zoneId) ~= 'number' then return {} end
        return KOJA.Server.CarsInZone[tostring(zoneId)] or {}
    end)
    exports('GiveVehicleToPlayer', function(targetSource, modelName, cb)
        if not KOJA.Server.GiveVehicleToPlayer then if cb then cb(false, nil) end return end
        KOJA.Server.GiveVehicleToPlayer(targetSource, modelName, cb or function() end)
    end)
end
