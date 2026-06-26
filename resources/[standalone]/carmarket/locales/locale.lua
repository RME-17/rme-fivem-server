translations = {}

local function decodeLocaleJson(raw)
    if not raw or type(raw) ~= 'string' then return nil end
    if raw:sub(1, 3) == string.char(0xEF, 0xBB, 0xBF) then raw = raw:sub(4) end
    local ok, out = pcall(json.decode, raw)
    if ok and out then return out end
    return nil
end

local function loadLocaleIntoTranslations()
    local resource = GetCurrentResourceName()
    local locale = (Config and Config.Locale) and tostring(Config.Locale):match('^%s*(.-)%s*$') or 'en'
    if locale == '' then locale = 'en' end

    local jsonFile = LoadResourceFile(resource, ('locales/%s.json'):format(locale))
    if not jsonFile then
        jsonFile = LoadResourceFile(resource, 'locales/en.json')
    end

    if jsonFile then
        local decoded = decodeLocaleJson(jsonFile)
        if decoded ~= nil then
            translations = decoded
        end
    end

    if not next(translations) and locale ~= 'en' then
        local enFile = LoadResourceFile(resource, 'locales/en.json')
        if enFile then
            local enDecoded = decodeLocaleJson(enFile)
            if enDecoded ~= nil then
                translations = enDecoded
            end
        end
    end

    return translations
end

local function loadTranslations()
    return loadLocaleIntoTranslations()
end

loadTranslations()

if not IsDuplicityVersion() and KOJA and KOJA.Client then
    RegisterNUICallback('koja_carmarket:nui:loadLocale', function(_, cb)
        loadLocaleIntoTranslations()
        if KOJA.Client.SendReactMessage then
            KOJA.Client.SendReactMessage('koja_carmarket:nui:setLocale', translations)
        end
        cb('ok')
    end)
end

substituteVariables = function(text, variables)
    if type(text) ~= 'string' then return text end
    if variables then
        for varName, varValue in pairs(variables) do
            text = string.gsub(text, "%%" .. varName, tostring(varValue))
        end
    end
    return text
end

getTranslation = function(key, default)
    if not key then return default end
    local keys = {}
    for k in string.gmatch(key, "[^%.]+") do
        table.insert(keys, k)
    end
    local result = translations
    for _, k in ipairs(keys) do
        if result and result[k] then
            result = result[k]
        else
            if default == nil and KOJA.Shared and KOJA.Shared.KojaCarmarketDebug then
                KOJA.Shared.KojaCarmarketDebug("Missing key:", tostring(key))
            end
            return default
        end
    end
    if type(result) == "string" then
        return result
    end
    return default
end

_L = function(key, variables)
    if not translations or not next(translations) then
        loadLocaleIntoTranslations()
    end
    local s = getTranslation(key, nil)
    if type(s) == 'string' then
        if variables then return substituteVariables(s, variables) end
        return s
    end
    if type(key) == 'string' then
        local tail = key:match('([^%.]+)$')
        return tail or key
    end
    return ''
end

SendNotify = function(data)
    local title = _L(data.title)
    local desc = _L(data.desc)
    desc = substituteVariables(desc, data.variables)
    if type(desc) ~= 'string' or desc == '' then
        desc = type(title) == 'string' and title or ''
    end
    if type(title) ~= 'string' then title = '' end
    local notify = {
        title = title,
        desc = desc,
        type = data.type or 'info',
        time = (type(data.time) == 'number' and data.time > 0) and data.time or 5000,
    }
    if data.icon then notify.icon = data.icon end
    if data.color then notify.color = data.color end
    if KOJA.Client and KOJA.Client.SendNotify then
        if KOJA.Shared and KOJA.Shared.KojaCarmarketDebug then KOJA.Shared.KojaCarmarketDebug('send notify', json.encode(notify)) end
        KOJA.Client.SendNotify(notify)
    else
        TriggerEvent('ox_lib:notify', {
            title = notify.title,
            description = notify.desc,
            type = notify.type,
            duration = notify.time,
        })
    end
end