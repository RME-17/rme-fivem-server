-- RME: Burger Shot consumables.
-- Loaded right AFTER config.lua (shared) so these entries exist on BOTH client
-- and server before qb-smallresources/server/consumables.lua runs its
-- CreateUseableItem registration loops over Config.Consumables.
-- This keeps the base config.lua untouched (low blast radius).
--
-- Drinks: the stock 'drink' handler hardcodes a water-bottle prop, so the
-- fountain colas are registered as 'custom' consumables instead, which lets us
-- attach a chosen cup prop + animation.
--
-- CUP MODEL: base-game Burger Shot cups (prop_food_bs_juice01/02) both render
-- DARK/black in-game (Forge 'red' tag = logo accents only). A genuinely RED
-- Burger Shot cup needs a CUSTOM streamed prop. BS_CUP below is a temporary
-- base-game placeholder; swap it to the streamed red cup model once the prop
-- pack resource is installed and ensured.
--   prop_food_bs_juice02 = dark Burger Shot cup (placeholder)
--   prop_food_bs_soda_01 = soda CRATE (big red box), not a cup

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

-- Fountain colas: custom consumables. Cup-to-mouth sip animation.
-- TODO: replace BS_CUP with the streamed RED Burger Shot cup model once the
-- prop pack is installed (see notes at top of file).
local BS_CUP = 'prop_food_bs_juice02' -- placeholder dark base-game cup

local function bsDrink(label, amount)
    return {
        progress = {
            label = label,
            time = 5000
        },
        animation = {
            -- Original cup-to-mouth sip
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
