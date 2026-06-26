--[[
    nex-Crafting | Editable Client Functions
    ============================================
    This file contains client-side customizable values and functions.
    Edit these to match your inventory system's image paths or add
    custom weapon preview models.

    These functions are loaded BEFORE core client files.
]]

----------------------------------------------------------------
-- nexCrafting.GetItemImagePath(itemName)
-- @param itemName: string - the item name (e.g. 'water', 'weapon_pistol')
-- @return: string - full URL/path to the item's image
--
-- Default: ox_inventory image path.
-- Change this if you use a different inventory with different image paths.
--
-- Example for qs-inventory:
--   return 'nui://qs-inventory/html/images/' .. itemName .. '.png'
--
-- Example for codem-inventory:
--   return 'nui://codem-inventory/html/img/' .. itemName .. '.png'
--
-- Example for custom web URL:
--   return 'https://your-cdn.com/images/' .. itemName .. '.png'
----------------------------------------------------------------
function nexCrafting.GetItemImagePath(itemName)
    local path = nexCrafting.ItemImagePath or 'nui://ox_inventory/web/images/'
    return path .. itemName .. '.png'
end

----------------------------------------------------------------
-- nexCrafting.ItemPropModels
-- Table mapping weapon/item names to their GTA V prop model hashes.
-- Used for the 3D weapon preview on crafting benches.
--
-- Keys: uppercase weapon name (e.g. 'WEAPON_PISTOL')
-- Values: model hash (use backtick syntax: `model_name`)
--
-- Add or remove entries to match the items available on your server.
-- If an item has no entry here, no 3D preview will be shown.
----------------------------------------------------------------
nexCrafting.ItemPropModels = {
    ['WEAPON_CARBINERIFLE'] = `w_ar_carbinerifle`,
    ['WEAPON_PISTOL'] = `w_pi_pistol`,
    ['WEAPON_PUMPSHOTGUN'] = `w_sg_pumpshotgun`,
    ['WEAPON_MICROSMG'] = `w_sb_microsmg`,
    ['WEAPON_SNIPERRIFLE'] = `w_sr_sniperrifle`,
    ['WEAPON_KNIFE'] = `w_me_knife_01`,
    ['WEAPON_BAT'] = `w_me_bat`,
    ['WEAPON_ASSAULTRIFLE'] = `w_ar_assaultrifle`,
    ['WEAPON_PISTOL50'] = `w_pi_pistol50`,
    ['WEAPON_ASSAULTSHOTGUN'] = `w_sg_assaultshotgun`,
    ['WEAPON_SMG'] = `w_sb_smg`,
    ['WEAPON_COMBATPISTOL'] = `w_pi_combatpistol`,
    ['WEAPON_HEAVYPISTOL'] = `w_pi_heavypistol`,
    ['WEAPON_VINTAGEPISTOL'] = `w_pi_vintage_pistol`,
    ['WEAPON_SNSPISTOL'] = `w_pi_sns_pistol`,
    ['WEAPON_APPISTOL'] = `w_pi_appistol`,
    ['WEAPON_MACHINEPISTOL'] = `w_sb_compactsmg`,
    ['WEAPON_ASSAULTSMG'] = `w_sb_assaultsmg`,
    ['WEAPON_COMBATPDW'] = `w_sb_pdw`,
    ['WEAPON_MINISMG'] = `w_sb_minismg`,
    ['WEAPON_SAWNOFFSHOTGUN'] = `w_sg_sawnoff`,
    ['WEAPON_BULLPUPSHOTGUN'] = `w_sg_bullpupshotgun`,
    ['WEAPON_HEAVYSHOTGUN'] = `w_sg_heavyshotgun`,
    ['WEAPON_ADVANCEDRIFLE'] = `w_ar_advancedrifle`,
    ['WEAPON_SPECIALCARBINE'] = `w_ar_specialcarbine`,
    ['WEAPON_BULLPUPRIFLE'] = `w_ar_bullpuprifle`,
    ['WEAPON_COMPACTRIFLE'] = `w_ar_assaultrifle_smg`,
    ['WEAPON_MG'] = `w_mg_mg`,
    ['WEAPON_COMBATMG'] = `w_mg_combatmg`,
    ['WEAPON_GUSENBERG'] = `w_sb_gusenberg`,
    ['WEAPON_HEAVYSNIPER'] = `w_sr_heavysniper`,
    ['WEAPON_MARKSMANRIFLE'] = `w_sr_marksmanrifle`,
    ['WEAPON_RPG'] = `w_lr_rpg`,
    ['WEAPON_GRENADELAUNCHER'] = `w_lr_grenadelauncher`,
    ['WEAPON_MINIGUN'] = `w_mg_minigun`,
    ['WEAPON_CROWBAR'] = `w_me_crowbar`,
    ['WEAPON_GOLFCLUB'] = `w_me_gclub`,
    ['WEAPON_HAMMER'] = `w_me_hammer`,
    ['WEAPON_HATCHET'] = `w_me_hatchet`,
    ['WEAPON_MACHETE'] = `w_me_machete`,
    ['WEAPON_SWITCHBLADE'] = `w_me_switchblade`,
    ['WEAPON_GRENADE'] = `w_ex_grenadefrag`,
    ['WEAPON_MOLOTOV'] = `w_ex_molotov`,
    ['WEAPON_STICKYBOMB'] = `w_ex_pe`,
    ['WEAPON_SMOKEGRENADE'] = `w_ex_grenadesmoke`,
}
