-- RME override: Ammunation stock.
-- This file loads AFTER config.lua and REPLACES the default qb-shops weapons list.
-- The Ammunation sells everything EXCEPT class-C long guns:
--   excluded -> assault rifles, shotguns, snipers, light machine guns, heavy weapons.
-- To add or remove an item just edit the list below (item names come from
-- qb-core/shared/weapons.lua and qb-core/shared/items.lua).

Config = Config or {}
Config.Products = Config.Products or {}

Config.Products['weapons'] = {
    -- Melee
    { name = 'weapon_knife',         price = 250,  amount = 250 },
    { name = 'weapon_bat',           price = 250,  amount = 250 },
    { name = 'weapon_hatchet',       price = 250,  amount = 250 },
    { name = 'weapon_knuckle',       price = 300,  amount = 250 },
    { name = 'weapon_machete',       price = 350,  amount = 250 },
    { name = 'weapon_switchblade',   price = 350,  amount = 250 },

    -- Ammo
    { name = 'pistol_ammo',          price = 250,  amount = 250, requiredLicense = 'weapon' },
    { name = 'smg_ammo',             price = 350,  amount = 250, requiredLicense = 'weapon' },

    -- Body armor
    { name = 'armor',                price = 1000, amount = 50 },

    -- Handguns
    { name = 'weapon_pistol',        price = 2500, amount = 5, requiredLicense = 'weapon' },
    { name = 'weapon_snspistol',     price = 1500, amount = 5, requiredLicense = 'weapon' },
    { name = 'weapon_combatpistol',  price = 3000, amount = 5, requiredLicense = 'weapon' },
    { name = 'weapon_vintagepistol', price = 4000, amount = 5, requiredLicense = 'weapon' },
    { name = 'weapon_heavypistol',   price = 3500, amount = 5, requiredLicense = 'weapon' },
    { name = 'weapon_pistol50',      price = 4500, amount = 5, requiredLicense = 'weapon' },
    { name = 'weapon_appistol',      price = 4000, amount = 5, requiredLicense = 'weapon' },
    { name = 'weapon_revolver',      price = 4000, amount = 5, requiredLicense = 'weapon' },
    { name = 'weapon_machinepistol', price = 5000, amount = 5, requiredLicense = 'weapon' },

    -- Submachine guns
    { name = 'weapon_microsmg',      price = 7000, amount = 5, requiredLicense = 'weapon' },
    { name = 'weapon_minismg',       price = 7000, amount = 5, requiredLicense = 'weapon' },
    { name = 'weapon_smg',           price = 8500, amount = 5, requiredLicense = 'weapon' },
}
