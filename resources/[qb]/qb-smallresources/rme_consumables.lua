-- RME: Burger Shot consumables.
-- Loaded right AFTER config.lua (shared) so these entries exist on BOTH client
-- and server before qb-smallresources/server/consumables.lua runs its
-- CreateUseableItem registration loops over Config.Consumables.eat / .drink.
-- This keeps the base config.lua untouched (low blast radius).

Config = Config or {}
Config.Consumables = Config.Consumables or {}
Config.Consumables.eat = Config.Consumables.eat or {}
Config.Consumables.drink = Config.Consumables.drink or {}

-- Food (replenishes hunger, 0-100 scale)
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

-- Drinks (replenishes thirst, 0-100 scale)
local rmeDrink = {
    ['burgershot_colas'] = math.random(20, 30),
    ['burgershot_colab'] = math.random(40, 50),
    ['burgershot_colagoat'] = math.random(40, 50),
    ['burgershot_coffee'] = math.random(15, 25)
}

for k, v in pairs(rmeEat) do
    Config.Consumables.eat[k] = v
end

for k, v in pairs(rmeDrink) do
    Config.Consumables.drink[k] = v
end
