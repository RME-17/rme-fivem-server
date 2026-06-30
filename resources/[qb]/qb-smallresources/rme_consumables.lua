-- RME: Burger Shot consumables.
-- Loaded right AFTER config.lua (shared) so these entries exist on BOTH client
-- and server before qb-smallresources/server/consumables.lua runs its
-- CreateUseableItem registration loops over Config.Consumables.
-- This keeps the base config.lua untouched (low blast radius).
--
-- Drinks: the stock 'drink' handler hardcodes a water-bottle prop, so the
-- fountain colas are registered as 'custom' consumables instead, which lets us
-- attach the REAL base-game Burger Shot paper cup (prop_food_bs_juice01). That
-- prop ships with the base game, so no streaming / prop pack is required.
-- NOTE: prop_food_bs_soda_01 is the soda CRATE (big red box), not a cup.

Config = Config or {}
Config.Consumables = Config.Consumables or {}
Config.Consumables.eat = Config.Consumables.eat or {}
Config.Consumables.drink = Config.Consumables.drink or {}
Config.Consumables.custom = Config.Consumables.custom or {}

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

-- Plain drinks (replenishes thirst, 0-100). Uses the default bottle animation.
local rmeDrink = {
    ['burgershot_coffee'] = math.random(15, 25)
}

-- Fountain colas: custom consumables holding the real Burger Shot paper cup.
local BS_CUP = 'prop_food_bs_juice01' -- base-game Burger Shot paper cup (hash 2127253708)

local function bsDrink(label, amount)
    return {
        progress = {
            label = label,
            time = 5000
        },
        animation = {
            animDict = 'mp_player_intdrink',
            anim = 'loop_bottle',
            flags = 49
        },
        prop = {
            model = BS_CUP,
            bone = 60309,
            coords = vec3(0.0, 0.0, -0.05),
            rotation = vec3(0.0, 0.0, -40.0)
        },
        replenish = {
            type = 'Thirst',
            replenish = amount,
            isAlcohol = false,
            event = false,
            server = false
        }
    }
end

local rmeCustom = {
    ['burgershot_colas'] = bsDrink('Sipping a Small Cola...', math.random(20, 30)),
    ['burgershot_colab'] = bsDrink('Sipping a Large Cola...', math.random(40, 50)),
    ['burgershot_colagoat'] = bsDrink('Sipping a Goat Cola...', math.random(40, 50))
}

for k, v in pairs(rmeEat) do
    Config.Consumables.eat[k] = v
end

for k, v in pairs(rmeDrink) do
    Config.Consumables.drink[k] = v
end

for k, v in pairs(rmeCustom) do
    Config.Consumables.custom[k] = v
end
