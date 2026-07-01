-- RME: jim-mining item definitions.
--
-- Registered here inside qb-core (loaded after shared/items.lua) so every jim-mining
-- ore, ingot, gem, tool and piece of jewellery exists in QBCore.Shared.Items for
-- qb-inventory and jim-mining. Replaces the old lation_mining (ls_*) item set.
--
-- NOTE: the icons for these items ship inside jim-mining-main/images and must be
-- copied into qb-inventory/html/images (see deploy notes) so they render in the
-- inventory.

QBCore = QBCore or {}
QBCore.Shared = QBCore.Shared or {}
QBCore.Shared.Items = QBCore.Shared.Items or {}

local MiningItems = {
    -- Ores & raw materials
    copperore      = { name = 'copperore', label = 'Copper Ore', weight = 100, type = 'item', image = 'copperore.png', unique = false, useable = false, shouldClose = false, description = 'Raw copper ore, smelt it down' },
    ironore        = { name = 'ironore', label = 'Iron Ore', weight = 100, type = 'item', image = 'ironore.png', unique = false, useable = false, shouldClose = false, description = 'Raw iron ore, smelt it down' },
    goldore        = { name = 'goldore', label = 'Gold Ore', weight = 100, type = 'item', image = 'goldore.png', unique = false, useable = false, shouldClose = false, description = 'Raw gold ore, smelt it down' },
    silverore      = { name = 'silverore', label = 'Silver Ore', weight = 100, type = 'item', image = 'silverore.png', unique = false, useable = false, shouldClose = false, description = 'Raw silver ore, smelt it down' },
    carbon         = { name = 'carbon', label = 'Carbon', weight = 100, type = 'item', image = 'carbon.png', unique = false, useable = false, shouldClose = false, description = 'A lump of carbon, used to make steel' },
    stone          = { name = 'stone', label = 'Stone', weight = 100, type = 'item', image = 'stone.png', unique = false, useable = false, shouldClose = false, description = 'A rough stone, crack or wash it for materials' },
    can            = { name = 'can', label = 'Crushed Can', weight = 100, type = 'item', image = 'can.png', unique = false, useable = false, shouldClose = false, description = 'A crushed aluminium can' },
    bottle         = { name = 'bottle', label = 'Glass Bottle', weight = 100, type = 'item', image = 'bottle.png', unique = false, useable = false, shouldClose = false, description = 'An old glass bottle' },

    -- Ingots
    goldingot      = { name = 'goldingot', label = 'Gold Ingot', weight = 500, type = 'item', image = 'goldingot.png', unique = false, useable = false, shouldClose = false, description = 'A refined bar of gold' },
    silveringot    = { name = 'silveringot', label = 'Silver Ingot', weight = 500, type = 'item', image = 'silveringot.png', unique = false, useable = false, shouldClose = false, description = 'A refined bar of silver' },

    -- Uncut gems
    uncut_emerald  = { name = 'uncut_emerald', label = 'Uncut Emerald', weight = 200, type = 'item', image = 'uncut_emerald.png', unique = false, useable = false, shouldClose = false, description = 'An uncut emerald, needs cutting' },
    uncut_ruby     = { name = 'uncut_ruby', label = 'Uncut Ruby', weight = 200, type = 'item', image = 'uncut_ruby.png', unique = false, useable = false, shouldClose = false, description = 'An uncut ruby, needs cutting' },
    uncut_sapphire = { name = 'uncut_sapphire', label = 'Uncut Sapphire', weight = 200, type = 'item', image = 'uncut_sapphire.png', unique = false, useable = false, shouldClose = false, description = 'An uncut sapphire, needs cutting' },
    uncut_diamond  = { name = 'uncut_diamond', label = 'Uncut Diamond', weight = 200, type = 'item', image = 'uncut_diamond.png', unique = false, useable = false, shouldClose = false, description = 'An uncut diamond, needs cutting' },

    -- Tools
    goldpan        = { name = 'goldpan', label = 'Gold Pan', weight = 500, type = 'item', image = 'goldpan.png', unique = true, useable = true, shouldClose = true, description = 'For panning streams for gold' },
    pickaxe        = { name = 'pickaxe', label = 'Pickaxe', weight = 1000, type = 'item', image = 'pickaxe.png', unique = true, useable = true, shouldClose = true, description = 'For mining stone' },
    miningdrill    = { name = 'miningdrill', label = 'Mining Drill', weight = 2000, type = 'item', image = 'miningdrill.png', unique = true, useable = true, shouldClose = true, description = 'A powered mining drill' },
    mininglaser    = { name = 'mininglaser', label = 'Mining Laser', weight = 2000, type = 'item', image = 'mininglaser.png', unique = true, useable = true, shouldClose = true, description = 'A high-tech mining laser' },
    drillbit       = { name = 'drillbit', label = 'Drill Bit', weight = 100, type = 'item', image = 'drillbit.png', unique = false, useable = false, shouldClose = false, description = 'A replacement drill bit' },

    -- Jewellery (jim-mining jewel cutting)
    gold_ring      = { name = 'gold_ring', label = 'Gold Ring', weight = 1000, type = 'item', image = 'gold_ring.png', unique = false, useable = false, shouldClose = true, description = 'A plain gold ring' },
    silver_ring    = { name = 'silver_ring', label = 'Silver Ring', weight = 1000, type = 'item', image = 'silver_ring.png', unique = false, useable = false, shouldClose = true, description = 'A plain silver ring' },
    silverchain    = { name = 'silverchain', label = 'Silver Chain', weight = 1500, type = 'item', image = 'silverchain.png', unique = false, useable = false, shouldClose = true, description = 'A silver chain' },
    goldearring    = { name = 'goldearring', label = 'Gold Earring', weight = 500, type = 'item', image = 'gold_earring.png', unique = false, useable = false, shouldClose = true, description = 'A gold earring' },
    silverearring  = { name = 'silverearring', label = 'Silver Earring', weight = 500, type = 'item', image = 'silverearring.png', unique = false, useable = false, shouldClose = true, description = 'A silver earring' },

    diamond_ring_silver   = { name = 'diamond_ring_silver', label = 'Silver Diamond Ring', weight = 1000, type = 'item', image = 'diamond_ring_silver.png', unique = false, useable = false, shouldClose = true, description = 'A silver ring set with a diamond' },
    emerald_ring_silver   = { name = 'emerald_ring_silver', label = 'Silver Emerald Ring', weight = 1000, type = 'item', image = 'emerald_ring_silver.png', unique = false, useable = false, shouldClose = true, description = 'A silver ring set with an emerald' },
    ruby_ring_silver      = { name = 'ruby_ring_silver', label = 'Silver Ruby Ring', weight = 1000, type = 'item', image = 'ruby_ring_silver.png', unique = false, useable = false, shouldClose = true, description = 'A silver ring set with a ruby' },
    sapphire_ring_silver  = { name = 'sapphire_ring_silver', label = 'Silver Sapphire Ring', weight = 1000, type = 'item', image = 'sapphire_ring_silver.png', unique = false, useable = false, shouldClose = true, description = 'A silver ring set with a sapphire' },

    diamond_necklace          = { name = 'diamond_necklace', label = 'Diamond Necklace', weight = 2000, type = 'item', image = 'diamond_necklace.png', unique = false, useable = false, shouldClose = true, description = 'A gold necklace set with a diamond' },
    diamond_necklace_silver   = { name = 'diamond_necklace_silver', label = 'Silver Diamond Necklace', weight = 2000, type = 'item', image = 'diamond_necklace_silver.png', unique = false, useable = false, shouldClose = true, description = 'A silver necklace set with a diamond' },
    emerald_necklace_silver   = { name = 'emerald_necklace_silver', label = 'Silver Emerald Necklace', weight = 2000, type = 'item', image = 'emerald_necklace_silver.png', unique = false, useable = false, shouldClose = true, description = 'A silver necklace set with an emerald' },
    ruby_necklace_silver      = { name = 'ruby_necklace_silver', label = 'Silver Ruby Necklace', weight = 2000, type = 'item', image = 'ruby_necklace_silver.png', unique = false, useable = false, shouldClose = true, description = 'A silver necklace set with a ruby' },
    sapphire_necklace_silver  = { name = 'sapphire_necklace_silver', label = 'Silver Sapphire Necklace', weight = 2000, type = 'item', image = 'sapphire_necklace_silver.png', unique = false, useable = false, shouldClose = true, description = 'A silver necklace set with a sapphire' },

    diamond_earring           = { name = 'diamond_earring', label = 'Diamond Earring', weight = 500, type = 'item', image = 'diamond_earring.png', unique = false, useable = false, shouldClose = true, description = 'A gold earring set with a diamond' },
    diamond_earring_silver    = { name = 'diamond_earring_silver', label = 'Silver Diamond Earring', weight = 500, type = 'item', image = 'diamond_earring_silver.png', unique = false, useable = false, shouldClose = true, description = 'A silver earring set with a diamond' },
    emerald_earring           = { name = 'emerald_earring', label = 'Emerald Earring', weight = 500, type = 'item', image = 'emerald_earring.png', unique = false, useable = false, shouldClose = true, description = 'A gold earring set with an emerald' },
    emerald_earring_silver    = { name = 'emerald_earring_silver', label = 'Silver Emerald Earring', weight = 500, type = 'item', image = 'emerald_earring_silver.png', unique = false, useable = false, shouldClose = true, description = 'A silver earring set with an emerald' },
    ruby_earring              = { name = 'ruby_earring', label = 'Ruby Earring', weight = 500, type = 'item', image = 'ruby_earring.png', unique = false, useable = false, shouldClose = true, description = 'A gold earring set with a ruby' },
    ruby_earring_silver       = { name = 'ruby_earring_silver', label = 'Silver Ruby Earring', weight = 500, type = 'item', image = 'ruby_earring_silver.png', unique = false, useable = false, shouldClose = true, description = 'A silver earring set with a ruby' },
    sapphire_earring          = { name = 'sapphire_earring', label = 'Sapphire Earring', weight = 500, type = 'item', image = 'sapphire_earring.png', unique = false, useable = false, shouldClose = true, description = 'A gold earring set with a sapphire' },
    sapphire_earring_silver   = { name = 'sapphire_earring_silver', label = 'Silver Sapphire Earring', weight = 500, type = 'item', image = 'sapphire_earring_silver.png', unique = false, useable = false, shouldClose = true, description = 'A silver earring set with a sapphire' },
}

for name, item in pairs(MiningItems) do
    QBCore.Shared.Items[name] = item
end
