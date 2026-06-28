nexCrafting = nexCrafting or {}

nexCrafting.Language = 'en'

function nexCrafting.Debug(...)
    if nexCrafting.Config and nexCrafting.Config.Get then
        local settings = nexCrafting.Config.Get('settings')
        if settings and settings.debug then
            print('^3[nex-Crafting DEBUG]^7', ...)
        end
    end
end

-- Set your item images path here. This is the folder/URL where your inventory item images are stored.
-- Examples:
--   'nui://ox_inventory/web/images/'       (ox_inventory default)
--   'nui://qs-inventory/html/images/'      (qs-inventory)
--   'nui://codem-inventory/html/img/'      (codem-inventory)
--   'https://your-cdn.com/images/'         (custom web URL)
nexCrafting.ItemImagePath = 'nui://ox_inventory/web/images/'

if not IsDuplicityVersion() then
    nexCrafting.ClientConfig = nil

    RegisterNetEvent('nex-crafting:client:receiveConfig', function(config)
        nexCrafting.ClientConfig = config
        nexCrafting.Debug('Client config received')
    end)

    function nexCrafting.GetConfig(path)
        if not nexCrafting.ClientConfig then return nil end

        if not path then return nexCrafting.ClientConfig end

        local keys = {}
        for key in string.gmatch(path, "[^.]+") do
            table.insert(keys, key)
        end

        local current = nexCrafting.ClientConfig
        for _, key in ipairs(keys) do
            if type(current) == 'table' and current[key] ~= nil then
                current = current[key]
            else
                return nil
            end
        end

        return current
    end

    CreateThread(function()
        Wait(500)
        TriggerServerEvent('nex-crafting:server:requestConfig')
    end)
end
