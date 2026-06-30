-- RME custom items, merged natively into QBCore.Shared.Items.
-- Loaded right AFTER shared/items.lua in the qb-core fxmanifest so these run in
-- qb-core's own runtime and are guaranteed present for every other resource
-- (qb-crafting, qb-pawnshop, qb-inventory, etc.) without needing a separate
-- resource to be started or to propagate across the resource boundary.

QBCore = QBCore or {}
QBCore.Shared = QBCore.Shared or {}
QBCore.Shared.Items = QBCore.Shared.Items or {}

local RMECustomItems = {
    diamond_chain = {
        name = 'diamond_chain',
        label = 'Diamond Chain',
        weight = 2000,
        type = 'item',
        image = 'diamond_chain.png',
        unique = false,
        useable = false,
        shouldClose = true,
        combinable = nil,
        description = 'An ice-cold diamond-encrusted chain. Pure flex.'
    },
    gold_earrings = {
        name = 'gold_earrings',
        label = 'Gold Earrings',
        weight = 500,
        type = 'item',
        image = 'gold_earring_128x128_17.png',
        unique = false,
        useable = false,
        shouldClose = true,
        combinable = nil,
        description = 'A glistening pair of solid gold earrings.'
    },
    diamond_earrings = {
        name = 'diamond_earrings',
        label = 'Diamond Earrings',
        weight = 500,
        type = 'item',
        image = 'diamond_earring_silver_128x128_15.png',
        unique = false,
        useable = false,
        shouldClose = true,
        combinable = nil,
        description = 'A pair of diamond-studded silver earrings.'
    },

    -- Burger Shot (rz-burgershot) food icons
    -- Burgers & Wraps
    burgershot_bigking            = { name = 'burgershot_bigking', label = 'Big King Burger', weight = 300, type = 'item', image = 'burgershot_bigking.png', unique = false, useable = true, shouldClose = true, description = 'A towering Burger Shot signature burger' },
    burgershot_bleeder            = { name = 'burgershot_bleeder', label = 'Bleeder Burger', weight = 300, type = 'item', image = 'burgershot_bleeder.png', unique = false, useable = true, shouldClose = true, description = 'Juicy Burger Shot classic burger' },
    burgershot_goatwrap           = { name = 'burgershot_goatwrap', label = 'Goat Wrap', weight = 250, type = 'item', image = 'burgershot_goatwrap.png', unique = false, useable = true, shouldClose = true, description = 'A loaded Burger Shot wrap' },
    burgershot_lavash             = { name = 'burgershot_lavash', label = 'Lavash Wrap', weight = 250, type = 'item', image = 'burgershot_lavash.png', unique = false, useable = true, shouldClose = true, description = 'A soft lavash wrap' },

    -- Sides
    burgershot_shotnuggets        = { name = 'burgershot_shotnuggets', label = 'Shot Nuggets', weight = 150, type = 'item', image = 'burgershot_shotnuggets.png', unique = false, useable = true, shouldClose = true, description = 'Crispy chicken nuggets' },
    burgershot_shotrings          = { name = 'burgershot_shotrings', label = 'Onion Rings', weight = 150, type = 'item', image = 'burgershot_shotrings.png', unique = false, useable = true, shouldClose = true, description = 'Golden battered onion rings' },
    burgershot_curly              = { name = 'burgershot_curly', label = 'Curly Fries', weight = 150, type = 'item', image = 'burgershot_curly.png', unique = false, useable = true, shouldClose = true, description = 'Seasoned curly fries' },
    burgershot_patatos            = { name = 'burgershot_patatos', label = 'Small Fries', weight = 150, type = 'item', image = 'burgershot_patatos.png', unique = false, useable = true, shouldClose = true, description = 'A small portion of fries' },
    burgershot_patatob            = { name = 'burgershot_patatob', label = 'Large Fries', weight = 200, type = 'item', image = 'burgershot_patatob.png', unique = false, useable = true, shouldClose = true, description = 'A large portion of fries' },

    -- Drinks
    burgershot_colas              = { name = 'burgershot_colas', label = 'Small Cola', weight = 300, type = 'item', image = 'burgershot_colas.png', unique = false, useable = true, shouldClose = true, description = 'A small Burger Shot soda' },
    burgershot_colab              = { name = 'burgershot_colab', label = 'Large Cola', weight = 500, type = 'item', image = 'burgershot_colab.png', unique = false, useable = true, shouldClose = true, description = 'A large Burger Shot soda' },
    burgershot_colagoat           = { name = 'burgershot_colagoat', label = 'Goat Cola', weight = 500, type = 'item', image = 'burgershot_colagoat.png', unique = false, useable = true, shouldClose = true, description = 'The legendary Goat Cola' },
    burgershot_coffee             = { name = 'burgershot_coffee', label = 'Burger Shot Coffee', weight = 200, type = 'item', image = 'burgershot_coffee.png', unique = false, useable = true, shouldClose = true, description = 'A hot cup of coffee' },

    -- Desserts
    burgershot_macaroon           = { name = 'burgershot_macaroon', label = 'Macaroon', weight = 50, type = 'item', image = 'burgershot_macaroon.png', unique = false, useable = true, shouldClose = true, description = 'A sweet little macaroon' },
    burgershot_icecreamcone       = { name = 'burgershot_icecreamcone', label = 'Ice Cream Cone', weight = 100, type = 'item', image = 'burgershot_icecreamcone.png', unique = false, useable = true, shouldClose = true, description = 'A plain ice cream cone' },
    burgershot_vanillaicecream    = { name = 'burgershot_vanillaicecream', label = 'Vanilla Ice Cream', weight = 100, type = 'item', image = 'burgershot_vanillaicecream.png', unique = false, useable = true, shouldClose = true, description = 'Creamy vanilla ice cream' },
    burgershot_strawberryicecream = { name = 'burgershot_strawberryicecream', label = 'Strawberry Ice Cream', weight = 100, type = 'item', image = 'burgershot_strawberryicecream.png', unique = false, useable = true, shouldClose = true, description = 'Sweet strawberry ice cream' },
    burgershot_chocolateicecream  = { name = 'burgershot_chocolateicecream', label = 'Chocolate Ice Cream', weight = 100, type = 'item', image = 'burgershot_chocolateicecream.png', unique = false, useable = true, shouldClose = true, description = 'Rich chocolate ice cream' },
    burgershot_matchaicecream     = { name = 'burgershot_matchaicecream', label = 'Matcha Ice Cream', weight = 100, type = 'item', image = 'burgershot_matchaicecream.png', unique = false, useable = true, shouldClose = true, description = 'Green tea matcha ice cream' },
    burgershot_ubeicecream        = { name = 'burgershot_ubeicecream', label = 'Ube Ice Cream', weight = 100, type = 'item', image = 'burgershot_ubeicecream.png', unique = false, useable = true, shouldClose = true, description = 'Purple yam ube ice cream' },
    burgershot_unicornicecream    = { name = 'burgershot_unicornicecream', label = 'Unicorn Ice Cream', weight = 100, type = 'item', image = 'burgershot_unicornicecream.png', unique = false, useable = true, shouldClose = true, description = 'Magical unicorn ice cream' },
    burgershot_smurfetteicecream  = { name = 'burgershot_smurfetteicecream', label = 'Smurfette Ice Cream', weight = 100, type = 'item', image = 'burgershot_smurfetteicecream.png', unique = false, useable = true, shouldClose = true, description = 'Smurfette themed ice cream' },
    burgershot_thesmurfsicecream  = { name = 'burgershot_thesmurfsicecream', label = 'The Smurfs Ice Cream', weight = 100, type = 'item', image = 'burgershot_thesmurfsicecream.png', unique = false, useable = true, shouldClose = true, description = 'The Smurfs themed ice cream' },

    -- Ingredients (job prep, not directly useable)
    burgershot_meat               = { name = 'burgershot_meat', label = 'Beef Patty', weight = 100, type = 'item', image = 'burgershot_meat.png', unique = false, useable = false, shouldClose = true, description = 'A cooked beef patty' },
    burgershot_frozenmeat         = { name = 'burgershot_frozenmeat', label = 'Frozen Patty', weight = 100, type = 'item', image = 'burgershot_frozenmeat.png', unique = false, useable = false, shouldClose = true, description = 'A raw frozen beef patty' },
    burgershot_frozennuggets      = { name = 'burgershot_frozennuggets', label = 'Frozen Nuggets', weight = 100, type = 'item', image = 'burgershot_frozennuggets.png', unique = false, useable = false, shouldClose = true, description = 'Uncooked frozen nuggets' },
    burgershot_frozenrings        = { name = 'burgershot_frozenrings', label = 'Frozen Onion Rings', weight = 100, type = 'item', image = 'burgershot_frozenrings.png', unique = false, useable = false, shouldClose = true, description = 'Uncooked frozen onion rings' },
    burgershot_bigfrozenpotato    = { name = 'burgershot_bigfrozenpotato', label = 'Large Frozen Fries', weight = 100, type = 'item', image = 'burgershot_bigfrozenpotato.png', unique = false, useable = false, shouldClose = true, description = 'Uncooked large frozen fries' },
    burgershot_smallfrozenpotato  = { name = 'burgershot_smallfrozenpotato', label = 'Small Frozen Fries', weight = 100, type = 'item', image = 'burgershot_smallfrozenpotato.png', unique = false, useable = false, shouldClose = true, description = 'Uncooked small frozen fries' },
    burgershot_bread              = { name = 'burgershot_bread', label = 'Burger Bun', weight = 50, type = 'item', image = 'burgershot_bread.png', unique = false, useable = false, shouldClose = true, description = 'A fresh burger bun' },
    burgershot_cheddar            = { name = 'burgershot_cheddar', label = 'Cheddar Cheese', weight = 50, type = 'item', image = 'burgershot_cheddar.png', unique = false, useable = false, shouldClose = true, description = 'A slice of cheddar cheese' },
    burgershot_tomato             = { name = 'burgershot_tomato', label = 'Tomato', weight = 50, type = 'item', image = 'burgershot_tomato.png', unique = false, useable = false, shouldClose = true, description = 'A fresh tomato' },
    burgershot_sauce              = { name = 'burgershot_sauce', label = 'Burger Sauce', weight = 50, type = 'item', image = 'burgershot_sauce.png', unique = false, useable = false, shouldClose = true, description = 'The secret Burger Shot sauce' },

    -- Packaging & Extras
    burgershot_bigcardboard       = { name = 'burgershot_bigcardboard', label = 'Large Meal Box', weight = 50, type = 'item', image = 'burgershot_bigcardboard.png', unique = false, useable = false, shouldClose = true, description = 'A large takeout box' },
    burgershot_smallcardboard     = { name = 'burgershot_smallcardboard', label = 'Small Meal Box', weight = 50, type = 'item', image = 'burgershot_smallcardboard.png', unique = false, useable = false, shouldClose = true, description = 'A small takeout box' },
    burgershotbag                 = { name = 'burgershotbag', label = 'Burger Shot Bag', weight = 50, type = 'item', image = 'burgershotbag.png', unique = false, useable = false, shouldClose = true, description = 'A Burger Shot takeout bag' },
    burgershot_bigemptyglass      = { name = 'burgershot_bigemptyglass', label = 'Large Empty Cup', weight = 50, type = 'item', image = 'burgershot_bigemptyglass.png', unique = false, useable = false, shouldClose = true, description = 'An empty large cup' },
    burgershot_smallemptyglass    = { name = 'burgershot_smallemptyglass', label = 'Small Empty Cup', weight = 50, type = 'item', image = 'burgershot_smallemptyglass.png', unique = false, useable = false, shouldClose = true, description = 'An empty small cup' },
    burgershot_coffeeemptyglass   = { name = 'burgershot_coffeeemptyglass', label = 'Empty Coffee Cup', weight = 50, type = 'item', image = 'burgershot_coffeeemptyglass.png', unique = false, useable = false, shouldClose = true, description = 'An empty coffee cup' },
    burgershot_toy1               = { name = 'burgershot_toy1', label = 'Burger Shot Toy 1', weight = 50, type = 'item', image = 'burgershot_toy1.png', unique = false, useable = false, shouldClose = true, description = 'A collectible kids meal toy' },
    burgershot_toy2               = { name = 'burgershot_toy2', label = 'Burger Shot Toy 2', weight = 50, type = 'item', image = 'burgershot_toy2.png', unique = false, useable = false, shouldClose = true, description = 'A collectible kids meal toy' },
    burgershot_toy3               = { name = 'burgershot_toy3', label = 'Burger Shot Toy 3', weight = 50, type = 'item', image = 'burgershot_toy3.png', unique = false, useable = false, shouldClose = true, description = 'A collectible kids meal toy' },
    burgershot_toy4               = { name = 'burgershot_toy4', label = 'Burger Shot Toy 4', weight = 50, type = 'item', image = 'burgershot_toy4.png', unique = false, useable = false, shouldClose = true, description = 'A collectible kids meal toy' },
    burgershot_toy5               = { name = 'burgershot_toy5', label = 'Burger Shot Toy 5', weight = 50, type = 'item', image = 'burgershot_toy5.png', unique = false, useable = false, shouldClose = true, description = 'A collectible kids meal toy' },
    burgershot_toy6               = { name = 'burgershot_toy6', label = 'Burger Shot Toy 6', weight = 50, type = 'item', image = 'burgershot_toy6.png', unique = false, useable = false, shouldClose = true, description = 'A collectible kids meal toy' },
}

for name, item in pairs(RMECustomItems) do
    QBCore.Shared.Items[name] = item
end
