-- Delivery destinations grouped by region. Regions are unlocked through
-- Config.Tiers. Add as many as you like - contracts pick a random
-- destination whose distance from the depot fits the company's tier.
-- Every point sits on a paved road or open yard reachable by a semi
-- with a trailer attached.
-- Optional per-location `cargo = { 'basic', ... }` restricts what
-- dispatch sends there (omit it to accept any cargo).
-- Edited in-game via the admin UI (this file is rewritten on save).

Locations = {
    city = {
        { name = 'city 2', coords = vector3(834.88, -1972.06, 28.55), heading = 172.9 },
        { name = 'city 3', coords = vector3(104.25, -1817.30, 25.59), heading = 316.4 },
        { name = 'city 1', coords = vector3(70.09, -1429.79, 28.29), heading = 229.9 },
        { name = 'city 4', coords = vector3(748.58, -966.33, 23.93), heading = 91.9 },
        { name = 'city 5', coords = vector3(-1286.89, -807.81, 16.56), heading = 40.5 },
    },
    county = {
        { name = 'bc 1', coords = vector3(3631.78, 3765.57, 27.52), heading = 217.6 },
        { name = 'bc 2', coords = vector3(1947.76, 3752.16, 31.27), heading = 208.9 },
    },
    state = {
        { name = 'state 1', coords = vector3(-3170.66, 1109.76, 19.82), heading = 181.0 },
        { name = 'state 2', coords = vector3(-2534.14, 2340.34, 32.06), heading = 27.4 },
    },
    premium = {
        { name = 'premium 1', coords = vector3(366.69, 333.35, 102.82), heading = 346.6 },
        { name = 'premium 2', coords = vector3(-362.32, 6066.38, 30.48), heading = 134.0 },
    },
}
