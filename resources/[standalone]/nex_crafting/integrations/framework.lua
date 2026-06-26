--[[
    nex-Crafting | Editable Server Functions
    ============================================
    This file contains customizable server-side functions that integrate
    with external resources. Edit these to swap gang systems, etc.

    These functions are loaded BEFORE core files.

    IMPORTANT: Do not rename the functions - only change their internal implementation.
]]

----------------------------------------------------------------
-- nexCrafting.Functions.GetPlayerGang(source)
-- @param source: number - the player server ID
-- @return: table - { name = string|nil, label = string|nil, grade = number, gradeLabel = string }
--
-- Returns the player's gang information. The default implementation uses
-- nex-Turfs. Replace the body of this function with your own gang system.
--
-- Example for qb-gangs / QBCore:
--   local QBCore = exports['qb-core']:GetCoreObject()
--   local Player = QBCore.Functions.GetPlayer(source)
--   if Player then
--       local gang = Player.PlayerData.gang
--       return {
--           name = gang.name ~= 'none' and gang.name or nil,
--           label = gang.label ~= 'No Gang' and gang.label or nil,
--           grade = gang.grade and gang.grade.level or 0,
--           gradeLabel = gang.grade and gang.grade.name or '0'
--       }
--   end
--   return { name = nil, label = nil, grade = 0, gradeLabel = "0" }
--
-- Example for zyke_gangsystem:
--   local gangData = exports['zyke_gangsystem']:GetPlayerGang(source)
--   if gangData then
--       return {
--           name = gangData.gang,
--           label = gangData.label or gangData.gang,
--           grade = gangData.rank or 0,
--           gradeLabel = tostring(gangData.rank or 0)
--       }
--   end
--   return { name = nil, label = nil, grade = 0, gradeLabel = "0" }
--
-- Example for wasabi_gangs:
--   local gangData = exports['wasabi_gangs']:getPlayerGang(source)
--   if gangData and gangData.name then
--       return {
--           name = gangData.name,
--           label = gangData.label or gangData.name,
--           grade = gangData.grade or 0,
--           gradeLabel = tostring(gangData.grade or 0)
--       }
--   end
--   return { name = nil, label = nil, grade = 0, gradeLabel = "0" }
----------------------------------------------------------------
function nexCrafting.Functions.GetPlayerGang(source)
    local success, gangInfo = pcall(function()
        return exports['nex-Turfs']:GetPlayerGang(source)
    end)
    if success and gangInfo and gangInfo.gang then
        local gangConfig = nil
        pcall(function()
            gangConfig = exports['nex-Turfs']:GetGangConfig(gangInfo.gang)
        end)
        return {
            name = gangInfo.gang,
            label = gangConfig and gangConfig.label or gangInfo.gang,
            grade = gangInfo.grade or 0,
            gradeLabel = tostring(gangInfo.grade or 0)
        }
    end
    return {
        name = nil,
        label = nil,
        grade = 0,
        gradeLabel = "0"
    }
end
