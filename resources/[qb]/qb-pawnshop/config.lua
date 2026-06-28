Config = {}

Config.PawnLocation = {
    [1] = {
        coords = vector3(412.34, 314.81, 103.13),
        length = 1.5,
        width = 1.8,
        heading = 207.0,
        debugPoly = false,
        minZ = 100.97,
        maxZ = 105.42,
        distance = 3.0
    },
}

Config.BankMoney = false -- Set to true if you want the money to go into the players bank
Config.UseTimes = false  -- Set to false if you want the pawnshop open 24/7
Config.TimeOpen = 7      -- Opening Time
Config.TimeClosed = 17   -- Closing Time
Config.SendMeltingEmail = true

Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'

Config.PawnItems = {
    [1] = {
        item = 'goldchain',
        price = math.random(1800, 2200)
    },
    [2] = {
        item = 'diamond_ring',
        price = math.random(2800, 3400)
    },
    [3] = {
        item = 'rolex',
        price = math.random(2500, 3000)
    },
    [4] = {
        item = 'tenkgoldchain',
        price = math.random(3500, 4500)
    },
    [5] = {
        item = 'tablet',
        price = math.random(50, 100)
    },
    [6] = {
        item = 'iphone',
        price = math.random(50, 100)
    },
    [7] = {
        item = 'samsungphone',
        price = math.random(50, 100)
    },
    [8] = {
        item = 'laptop',
        price = math.random(50, 100)
    },
    [9] = {
        item = 'emerald_ring',
        price = math.random(2000, 2500)
    },
    [10] = {
        item = 'ruby_ring',
        price = math.random(2500, 3000)
    },
    [11] = {
        item = 'sapphire_ring',
        price = math.random(2200, 2700)
    },
    [12] = {
        item = 'emerald_necklace',
        price = math.random(2900, 3500)
    },
    [13] = {
        item = 'ruby_necklace',
        price = math.random(3800, 4500)
    },
    [14] = {
        item = 'sapphire_necklace',
        price = math.random(3300, 3900)
    },
    [15] = {
        item = 'diamond_chain',
        price = math.random(5000, 6000)
    },
    [16] = {
        item = 'gold_earrings',
        price = math.random(1200, 1600)
    },
    [17] = {
        item = 'diamond_earrings',
        price = math.random(3000, 3800)
    }
}

Config.MeltingItems = { -- meltTime is amount of time in minutes per item
    [1] = {
        item = 'goldchain',
        rewards = {
            [1] = {
                item = 'goldbar',
                amount = 2
            }
        },
        meltTime = 0.15
    },
    [2] = {
        item = 'diamond_ring',
        rewards = {
            [1] = {
                item = 'diamond',
                amount = 1
            },
            [2] = {
                item = 'goldbar',
                amount = 1
            }
        },
        meltTime = 0.15
    },
    [3] = {
        item = 'rolex',
        rewards = {
            [1] = {
                item = 'diamond',
                amount = 1
            },
            [2] = {
                item = 'goldbar',
                amount = 1
            },
            [3] = {
                item = 'electronickit',
                amount = 1
            }
        },
        meltTime = 0.15
    },
    [4] = {
        item = 'tenkgoldchain',
        rewards = {
            [1] = {
                item = 'diamond',
                amount = 5
            },
            [2] = {
                item = 'goldbar',
                amount = 1
            }
        },
        meltTime = 0.15
    },
    [5] = {
        item = 'emerald_ring',
        rewards = {
            [1] = {
                item = 'emerald',
                amount = 1
            },
            [2] = {
                item = 'goldbar',
                amount = 1
            }
        },
        meltTime = 0.15
    },
    [6] = {
        item = 'ruby_ring',
        rewards = {
            [1] = {
                item = 'ruby',
                amount = 1
            },
            [2] = {
                item = 'goldbar',
                amount = 1
            }
        },
        meltTime = 0.15
    },
    [7] = {
        item = 'sapphire_ring',
        rewards = {
            [1] = {
                item = 'sapphire',
                amount = 1
            },
            [2] = {
                item = 'goldbar',
                amount = 1
            }
        },
        meltTime = 0.15
    },
    [8] = {
        item = 'emerald_necklace',
        rewards = {
            [1] = {
                item = 'emerald',
                amount = 2
            },
            [2] = {
                item = 'goldbar',
                amount = 1
            }
        },
        meltTime = 0.15
    },
    [9] = {
        item = 'ruby_necklace',
        rewards = {
            [1] = {
                item = 'ruby',
                amount = 2
            },
            [2] = {
                item = 'goldbar',
                amount = 1
            }
        },
        meltTime = 0.15
    },
    [10] = {
        item = 'sapphire_necklace',
        rewards = {
            [1] = {
                item = 'sapphire',
                amount = 2
            },
            [2] = {
                item = 'goldbar',
                amount = 1
            }
        },
        meltTime = 0.15
    },
    [11] = {
        item = 'diamond_chain',
        rewards = {
            [1] = {
                item = 'diamond',
                amount = 2
            },
            [2] = {
                item = 'goldbar',
                amount = 1
            }
        },
        meltTime = 0.15
    },
    [12] = {
        item = 'gold_earrings',
        rewards = {
            [1] = {
                item = 'goldbar',
                amount = 1
            }
        },
        meltTime = 0.15
    },
    [13] = {
        item = 'diamond_earrings',
        rewards = {
            [1] = {
                item = 'diamond',
                amount = 2
            }
        },
        meltTime = 0.15
    },
}
