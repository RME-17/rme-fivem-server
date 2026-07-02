Config = {}

Config.Lang = "en" -- en/ru

-- Main hunting settings
Config.HuntingZone = vector3(-1498.12, 4578.19, 35.36) -- Hunting zone center
Config.SpawnRadius = 750.0 -- Animal spawn radius
Config.ZoneCheckRadius = 800.0 -- Radius for checking the player is still inside the hunting zone


-- Map markers
Config.Markers = {
    Start = vector3(-1493.67, 4971.6, 63.91), -- Start hunting
    End = vector3(-1491.92, 4975.19, 63.73), -- End hunting
}

-- Permanent map blip at the hunting start point
Config.Blip = {
    enable = true,
    coords = vector3(-1493.67, 4971.6, 63.91),
    sprite = 141, -- hunting/rifle icon
    color = 25, -- dark green
    scale = 0.8,
    label = "Hunting"
}

-- Animal spawn settings
Config.MaxAnimals = 10 -- Maximum number of animals in the zone
Config.SpawnChance = { -- Spawn chance per animal (percent)
    ["a_c_deer"] = 40,
    ["a_c_rabbit_01"] = 30,
    ["a_c_mtlion"] = 20,
    ["a_c_crow"] = 10,
}

-- Animal list
Config.Animals = {
    {
        name = "deer",
        model = "a_c_deer",
        reward = "deer_carcass"
    },
    {
        name = "rabbit",
        model = "a_c_rabbit_01",
        reward = "rabbit_carcass"
    },
    {
        name = "mtlion",
        model = "a_c_mtlion",
        reward = "mtlion_carcass"
    },
    {
        name = "crow",
        model = "a_c_crow",
        reward = "bird_carcass"
    }
}