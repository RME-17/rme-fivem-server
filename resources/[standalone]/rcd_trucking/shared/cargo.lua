-- Cargo categories and items. Everything ships on a trailer behind a semi.
--   class      = minimum tractor tier required (see shared/trucks.lua)
--   trailer    = trailer model spawned pre-loaded in the depot yard
--   payPerMile / xpPerMile / basePay / baseXP feed the reward formula
--   weight     = { min, max } in kg, affects payout slightly
--   minLevel   = overrides the category gate for individual items

Cargo = {
    basic = {
        label = 'Basic Cargo', minLevel = 0, class = 1,
        basePay = 900,  payPerMile = 340, baseXP = 40, xpPerMile = 14,
        items = {
            { item = 'food',      label = 'Food & Produce',     weight = { 3000, 8000 },  trailer = 'trailers3' },
            { item = 'furniture', label = 'Furniture',          weight = { 4000, 9000 },  trailer = 'trailers3' },
            { item = 'building',  label = 'Building Supplies',  weight = { 6000, 12000 }, trailer = 'trflat' },
        },
    },
    fragile = {
        label = 'Fragile Cargo', minLevel = 8, class = 2, fragile = true, requiresUpgrade = 'fragile',
        basePay = 2600, payPerMile = 680, baseXP = 95, xpPerMile = 28,
        items = {
            { item = 'glassware', label = 'Glassware',        weight = { 2000, 6000 }, trailer = 'trailers3' },
            { item = 'ceramics',  label = 'Ceramics & China',  weight = { 3000, 8000 }, trailer = 'trailers3' },
            { item = 'lab_glass', label = 'Lab Equipment',     weight = { 2500, 7000 }, trailer = 'trailers3' },
            { item = 'fine_art',  label = 'Fine Art',          weight = { 1500, 5000 }, trailer = 'trailers3', minLevel = 12, payMult = 1.3, xpMult = 1.2 },
        },
    },
    valuable = {
        label = 'Valuable Cargo', minLevel = 12, class = 2, requiresUpgrade = 'valuable',
        basePay = 4200, payPerMile = 950, baseXP = 140, xpPerMile = 40,
        items = {
            { item = 'jewelry',   label = 'Jewelry',        weight = { 1000, 4000 }, trailer = 'trailers3' },
            { item = 'bullion',   label = 'Gold Bullion',   weight = { 3000, 9000 }, trailer = 'docktrailer' },
            { item = 'banknotes', label = 'Banknotes',      weight = { 1500, 5000 }, trailer = 'trailers3' },
            { item = 'watches',   label = 'Luxury Watches', weight = { 800, 3000 },  trailer = 'trailers3', minLevel = 15, payMult = 1.3, xpMult = 1.2 },
        },
    },
    illegal = {
        label = 'Illegal Cargo', minLevel = 0, class = 1,
        basePay = 900,  payPerMile = 340, baseXP = 40, xpPerMile = 14,
        items = {
            { item = 'contraband',  label = 'Unmarked Crates',    weight = { 3000, 9000 },  trailer = 'docktrailer' },
            { item = 'untaxed',     label = 'Untaxed Cigarettes', weight = { 4000, 11000 }, trailer = 'docktrailer' },
            { item = 'counterfeit', label = 'Counterfeit Goods',  weight = { 3000, 8000 },  trailer = 'docktrailer' },
            { item = 'weapons',     label = 'Crated Firearms',    weight = { 5000, 14000 }, trailer = 'trflat',   minLevel = 12 },
            { item = 'narcotics',   label = 'Narcotics Shipment', weight = { 2000, 7000 },  trailer = 'docktrailer', minLevel = 15 },
        },
    },
}

-- weight nudges payout: heaviest possible load of a category pays +20%
function GetWeightFactor(weight, range)
    if range[2] == range[1] then return 1.0 end
    return 1.0 + 0.2 * ((weight - range[1]) / (range[2] - range[1]))
end
