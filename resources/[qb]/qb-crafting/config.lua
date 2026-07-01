Config = {
    EnableSkillCheck = true,
    ImageBasePath = 'nui://qb-inventory/html/images/',
    item_bench = {
        object = `prop_tool_bench02`,
        xpType = 'craftingrep',
        recipes = {
            {
                item = 'lockpick',
                xpRequired = 0,
                xpGain = 1,
                requiredItems = {
                    { item = 'metalscrap', amount = 22 },
                    { item = 'plastic',    amount = 32 }
                }
            },
            {
                item = 'screwdriverset',
                xpRequired = 0,
                xpGain = 2,
                requiredItems = {
                    { item = 'metalscrap', amount = 30 },
                    { item = 'plastic',    amount = 42 }
                }
            },
            {
                item = 'electronickit',
                xpRequired = 0,
                xpGain = 3,
                requiredItems = {
                    { item = 'metalscrap', amount = 30 },
                    { item = 'plastic',    amount = 45 },
                    { item = 'aluminum',   amount = 28 }
                }
            },
            {
                item = 'radioscanner',
                xpRequired = 0,
                xpGain = 4,
                requiredItems = {
                    { item = 'electronickit', amount = 2 },
                    { item = 'plastic',       amount = 52 },
                    { item = 'steel',         amount = 40 }
                }
            },
            {
                item = 'gatecrack',
                xpRequired = 110,
                xpGain = 5,
                requiredItems = {
                    { item = 'metalscrap',    amount = 10 },
                    { item = 'plastic',       amount = 50 },
                    { item = 'aluminum',      amount = 30 },
                    { item = 'iron',          amount = 17 },
                    { item = 'electronickit', amount = 2 }
                }
            },
            {
                item = 'handcuffs',
                xpRequired = 160,
                xpGain = 6,
                requiredItems = {
                    { item = 'metalscrap', amount = 36 },
                    { item = 'steel',      amount = 24 },
                    { item = 'aluminum',   amount = 28 }
                }
            },
            {
                item = 'repairkit',
                xpRequired = 200,
                xpGain = 7,
                requiredItems = {
                    { item = 'metalscrap', amount = 32 },
                    { item = 'steel',      amount = 43 },
                    { item = 'plastic',    amount = 61 }
                }
            },
            {
                item = 'pistol_ammo',
                xpRequired = 250,
                xpGain = 8,
                requiredItems = {
                    { item = 'metalscrap', amount = 50 },
                    { item = 'steel',      amount = 37 },
                    { item = 'copper',     amount = 26 }
                }
            },
            {
                item = 'ironoxide',
                xpRequired = 300,
                xpGain = 9,
                requiredItems = {
                    { item = 'iron',  amount = 60 },
                    { item = 'glass', amount = 30 }
                }
            },
            {
                item = 'aluminumoxide',
                xpRequired = 300,
                xpGain = 10,
                requiredItems = {
                    { item = 'aluminum', amount = 60 },
                    { item = 'glass',    amount = 30 }
                }
            },
            {
                item = 'armor',
                xpRequired = 350,
                xpGain = 11,
                requiredItems = {
                    { item = 'iron',     amount = 33 },
                    { item = 'steel',    amount = 44 },
                    { item = 'plastic',  amount = 55 },
                    { item = 'aluminum', amount = 22 }
                }
            },
            {
                item = 'drill',
                xpRequired = 1750,
                xpGain = 12,
                requiredItems = {
                    { item = 'iron',             amount = 50 },
                    { item = 'steel',            amount = 50 },
                    { item = 'screwdriverset',   amount = 3 },
                    { item = 'advancedlockpick', amount = 2 }
                }
            },
        }
    },
    attachment_bench = {
        object = `prop_tool_bench02_ld`,
        xpType = 'attachmentcraftingrep',
        recipes = {
            {
                item = 'clip_attachment',
                xpRequired = 0,
                xpGain = 10,
                requiredItems = {
                    { item = 'metalscrap', amount = 140 },
                    { item = 'steel',      amount = 250 },
                    { item = 'rubber',     amount = 60 }
                }
            },
            {
                item = 'suppressor_attachment',
                xpRequired = 0,
                xpGain = 10,
                requiredItems = {
                    { item = 'metalscrap', amount = 165 },
                    { item = 'steel',      amount = 285 },
                    { item = 'rubber',     amount = 75 }
                }
            },
            {
                item = 'drum_attachment',
                xpRequired = 0,
                xpGain = 10,
                requiredItems = {
                    { item = 'metalscrap', amount = 230 },
                    { item = 'steel',      amount = 365 },
                    { item = 'rubber',     amount = 130 }
                }
            },
            {
                item = 'smallscope_attachment',
                xpRequired = 0,
                xpGain = 10,
                requiredItems = {
                    { item = 'metalscrap', amount = 255 },
                    { item = 'steel',      amount = 390 },
                    { item = 'rubber',     amount = 145 }
                }
            },
        }
    },
    -- Redline Motorsport parts bench (LOCATION at the Redline shop, no prop item).
    -- Members craft the physical cosmetic parts from materials recycled at the
    -- Paleto recycling warehouse. Adjust `location` to fine-tune the exact spot.
    redline_bench = {
        location = vec4(1160.5, -782.7, 57.6, 100.0),
        xpType = 'craftingrep',
        recipes = {
            {
                item = 'spray_can',
                xpRequired = 0,
                xpGain = 3,
                requiredItems = {
                    { item = 'plastic',  amount = 5 },
                    { item = 'steel',    amount = 3 },
                    { item = 'aluminum', amount = 2 }
                }
            },
            {
                item = 'car_wheel',
                xpRequired = 0,
                xpGain = 6,
                requiredItems = {
                    { item = 'steel',    amount = 8 },
                    { item = 'rubber',   amount = 10 },
                    { item = 'aluminum', amount = 4 }
                }
            },
            {
                item = 'body_kit',
                xpRequired = 0,
                xpGain = 6,
                requiredItems = {
                    { item = 'steel',    amount = 12 },
                    { item = 'aluminum', amount = 8 },
                    { item = 'plastic',  amount = 6 }
                }
            },
            {
                item = 'xenon_bulb',
                xpRequired = 0,
                xpGain = 3,
                requiredItems = {
                    { item = 'glass',   amount = 4 },
                    { item = 'copper',  amount = 3 },
                    { item = 'plastic', amount = 2 }
                }
            },
            {
                item = 'tyre_smoke_kit',
                xpRequired = 0,
                xpGain = 4,
                requiredItems = {
                    { item = 'plastic', amount = 4 },
                    { item = 'rubber',  amount = 4 },
                    { item = 'copper',  amount = 2 }
                }
            },
            {
                item = 'neon_kit',
                xpRequired = 0,
                xpGain = 5,
                requiredItems = {
                    { item = 'glass',   amount = 6 },
                    { item = 'copper',  amount = 6 },
                    { item = 'plastic', amount = 4 }
                }
            },
            {
                item = 'tint_roll',
                xpRequired = 0,
                xpGain = 3,
                requiredItems = {
                    { item = 'plastic', amount = 6 },
                    { item = 'glass',   amount = 3 },
                    { item = 'rubber',  amount = 2 }
                }
            },
            {
                item = 'plate_kit',
                xpRequired = 0,
                xpGain = 3,
                requiredItems = {
                    { item = 'aluminum', amount = 4 },
                    { item = 'steel',    amount = 2 },
                    { item = 'plastic',  amount = 2 }
                }
            },
        }
    }
}
