-- RME: Burger Shot consumables.
-- Loaded right AFTER config.lua (shared) so these entries exist on BOTH client
-- and server before qb-smallresources/server/consumables.lua runs its
-- CreateUseableItem registration loops over Config.Consumables.
-- This keeps the base config.lua untouched (low blast radius).
--
-- Drinks (colas + coffee) use the stock 'drink' handler, which plays the
-- standard bottle drink animation with the base-game water-bottle prop.
-- (No genuinely RED Burger Shot cup exists as a base-game or free drop-in
-- prop, so we keep the reliable stock bottle rather than a wrong-looking cup.)
--
-- STORE-FOOD NERF: the default convenience-store food/drinks are intentionally
-- weak (see rmeStoreEat/rmeStoreDrink) so players rely on Burger Shot for real
-- hunger/thirst recovery. Those keys override the higher defaults from
-- qb-smallresources/config.lua because this file loads afterwards and the merge
-- loops below replace matching entries.

Config = Config or {}
Config.Consumables = Config.Consumables or {}
Config.Consumables.eat = Config.Consumables.eat or {}
Config.Consumables.drink = Config.Consumables.drink or {}

-- Food (replenishes hunger, 0-100). Uses the default burger eat animation/prop.
local rmeEat = {
    -- Burgers & wraps
    ['burgershot_bigking'] = math.random(40, 50),
    ['burgershot_bleeder'] = math.random(40, 50),
    ['burgershot_goatwrap'] = math.random(35, 45),
    ['burgershot_lavash'] = math.random(35, 45),
    -- Sides
    ['burgershot_shotnuggets'] = math.random(25, 35),
    ['burgershot_shotrings'] = math.random(25, 35),
    ['burgershot_curly'] = math.random(25, 35),
    ['burgershot_patatos'] = math.random(20, 30),
    ['burgershot_patatob'] = math.random(30, 40),
    -- Desserts
    ['burgershot_macaroon'] = math.random(8, 12),
    ['burgershot_icecreamcone'] = math.random(15, 25),
    ['burgershot_vanillaicecream'] = math.random(15, 25),
    ['burgershot_strawberryicecream'] = math.random(15, 25),
    ['burgershot_chocolateicecream'] = math.random(15, 25),
    ['burgershot_matchaicecream'] = math.random(15, 25),
    ['burgershot_ubeicecream'] = math.random(15, 25),
    ['burgershot_unicornicecream'] = math.random(15, 25),
    ['burgershot_smurfetteicecream'] = math.random(15, 25),
    ['burgershot_thesmurfsicecream'] = math.random(15, 25)
}

-- Drinks (replenishes thirst, 0-100). Stock bottle animation + water-bottle prop.
local rmeDrink = {
    ['burgershot_coffee'] = math.random(15, 25),
    ['burgershot_colas'] = math.random(20, 30),
    ['burgershot_colab'] = math.random(40, 50),
    ['burgershot_colagoat'] = math.random(40, 50)
}

-- Store-food nerf (overrides qb-smallresources/config.lua defaults).
-- Convenience-store snacks barely fill you up -> Burger Shot is the real meal.
local rmeStoreEat = {
    ['sandwich'] = math.random(5, 10),
    ['tosti'] = math.random(5, 10),
    ['twerks_candy'] = math.random(5, 10),
    ['snikkel_candy'] = math.random(5, 10)
}

local rmeStoreDrink = {
    ['water_bottle'] = math.random(5, 10),
    ['kurkakola'] = math.random(5, 10),
    ['coffee'] = math.random(5, 10)
}

for k, v in pairs(rmeEat) do
    Config.Consumables.eat[k] = v
end

for k, v in pairs(rmeDrink) do
    Config.Consumables.drink[k] = v
end

for k, v in pairs(rmeStoreEat) do
    Config.Consumables.eat[k] = v
end

for k, v in pairs(rmeStoreDrink) do
    Config.Consumables.drink[k] = v
end
