-- QBCore vehicle-data compatibility shim for koja_carmarket
-- Koja's bridge expects player_vehicles.vehicle to be a JSON blob (ESX style).
-- QBCore instead stores the spawn/model name there as plain text (e.g. "t20")
-- and keeps tuning/props JSON in a separate `mods` column. Without this the
-- decoded vehicle table comes back empty and the UI shows "vehicle error2"
-- with default specs. We wrap the shared decoder so a bare model-name string
-- is turned into a minimal vehicle table carrying the model name, which the
-- display helpers (modelToRespname / listingDisplayName) then use.

if KOJA and KOJA.Shared and type(KOJA.Shared.decodeJsonStringOrTable) == "function" then
    local _kojaQbOrigDecode = KOJA.Shared.decodeJsonStringOrTable

    KOJA.Shared.decodeJsonStringOrTable = function(input)
        local v = _kojaQbOrigDecode(input)
        if type(v) ~= "table" then
            v = {}
        end
        if KOJA.Framework == "qb" and type(input) == "string" then
            local s = input:gsub("^%s+", ""):gsub("%s+$", "")
            if s ~= "" and not s:match("^[%[{]") and next(v) == nil then
                v.model = s
                v.respname = s
            end
        end
        return v
    end
end
