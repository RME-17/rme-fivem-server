local Locales = {}

local function loadLocale(locale)
    local data = LoadResourceFile(GetCurrentResourceName(), ('locales/%s.lua'):format(locale))
    if data then
        local fn, err = load(data)
        if fn then
            return fn()
        else
            DebugPrint(('[nc-safezone] Failed to parse locale "%s": %s'):format(locale, err))
        end
    else
        DebugPrint(('[nc-safezone] Locale file not found: locales/%s.lua'):format(locale))
    end
    return {}
end

Locales = loadLocale(Config.Locale or 'en')

local fallback = Config.Locale ~= 'en' and loadLocale('en') or {}

function L(key, ...)
    local str = Locales[key] or fallback[key] or key
    if ... then
        return str:format(...)
    end
    return str
end

function GetLocaleStrings()
    local merged = {}
    for k, v in pairs(fallback) do
        merged[k] = v
    end
    for k, v in pairs(Locales) do
        merged[k] = v
    end
    return merged
end
