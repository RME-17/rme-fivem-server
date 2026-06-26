-- Purchasable trucks - semi tractor units only. Every load is hauled on a
-- pre-loaded trailer that spawns in the depot yard.
--   class        = tractor tier (1 entry, 2 workhorse, 3 premium rig);
--                  cargo categories require a minimum tier
--   cargo        = max trailer load in kg (contracts above this can't be taken)
--   fuel         = tank size in liters (informational + range calc)
--   reliability  = 1-100, lowers breakdown odds and AI damage outcomes
--   maintenance  = cost to restore 100% condition (scaled by missing condition)
--   range        = max one-way route distance in miles
--   classMult    = AI revenue multiplier when this truck is assigned

Trucks = {
    { model = 'hauler',   label = 'JoBuilt Hauler',  class = 1, level = 0,  price = 55000,  cargo = 14000, fuel = 190, reliability = 74, maintenance = 2400, range = 30 },
    { model = 'packer',   label = 'MTL Packer',      class = 2, level = 5,  price = 100000, cargo = 22000, fuel = 230, reliability = 82, maintenance = 3300, range = 65 },
    { model = 'phantom',  label = 'JoBuilt Phantom', class = 3, level = 10, price = 160000, cargo = 36000, fuel = 270, reliability = 90, maintenance = 4300, range = 999 },
}

TruckClassMult = { [1] = 1.0, [2] = 1.15, [3] = 1.3 }

-- box trailer used by cargo that doesn't specify its own trailer
DefaultTrailer = 'trailers3'

function GetTruckData(model)
    for _, t in ipairs(Trucks) do
        if t.model == model then return t end
    end
    return nil
end
