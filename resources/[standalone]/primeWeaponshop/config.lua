Config = {}

Config.Locale = 'en'
Config.Currency = '$'
Config.Payments = { cash = true, bank = true }

Config.Blip = { enable = true, id = 110, size = 0.9, color = 5 }

-- type = 'weapon' gives the weapon item (QBCore weapons are inventory items, lowercase names)
-- type = 'item' gives a normal item, buyer can choose an amount (1-50)
Config.Weapons = {
    { type = 'weapon', name = 'weapon_pistol', label = 'Pistol', price = 10000 },
    { type = 'weapon', name = 'weapon_pistol_mk2', label = 'Pistol MK2', price = 15000 },
    { type = 'item', name = 'pistol_ammo', label = 'Pistol Ammo', price = 500 },
}

Config.PedModels = {
    'u_m_y_hippie_01',
    'u_m_y_imporage',
    'u_m_y_juggernaut_01',
    'u_m_y_danceburl_01',
    's_m_y_clown_01',
    'cs_jimmyboston',
    'cs_joeminuteman',
    'a_m_m_hasjew_01',
}

Config.Weaponshops = {
    { x = -662.5524, y = -933.5625, z = 21.8292, rot = 177.0535 },
    { x = 810.4322, y = -2159.0740, z = 29.6190, rot = 358.8568 },
    { x = 1692.0865, y = 3760.8291, z = 34.7053, rot = 232.7353 },
    { x = -331.6919, y = 6084.8354, z = 31.4548, rot = 223.7086 },
    { x = 253.9358, y = -50.2546, z = 69.9411, rot = 72.5361 },
    { x = 22.3709, y = -1105.4161, z = 29.7970, rot = 159.2573 },
    { x = 2568.1768, y = 292.6276, z = 108.7348, rot = 358.1265 },
    { x = -1119.1722, y = 2699.5972, z = 18.5541, rot = 225.0948 },
    { x = 842.5545, y = -1035.2521, z = 28.1948, rot = 356.6090 },
}

Translation = {
    ['de'] = {
        ['infobar'] = 'Drücke E, um auf den Waffenladen zuzugreifen',
        ['menu_title'] = 'Waffenladen',
        ['amount'] = 'Anzahl',
        ['cash'] = 'Bargeld',
        ['notenough_money'] = '~r~Du hast nicht genug Geld!',
        ['bank'] = 'Bank',
        ['boughtnotify'] = 'Du hast ~g~',
        ['boughtnotify2'] = ' ~s~für ~g~',
        ['boughtnotify3'] = ' ~s~gekauft!',
        ['gotweapon'] = '~r~Du hast diese Waffe bereits.',
        ['cantcarry'] = '~r~Du kannst nicht so viel tragen.',
        ['blip'] = 'Waffenladen',
    },
    ['en'] = {
        ['infobar'] = 'Press ~INPUT_CONTEXT~ to access the weapon shop',
        ['menu_title'] = 'Weapon Shop',
        ['amount'] = 'Amount',
        ['cash'] = 'Cash',
        ['notenough_money'] = "~r~You don't have enough money!",
        ['bank'] = 'Bank',
        ['boughtnotify'] = 'You bought ~g~',
        ['boughtnotify2'] = ' ~s~for ~g~',
        ['boughtnotify3'] = '~s~!',
        ['gotweapon'] = '~r~You already have this weapon.',
        ['cantcarry'] = "~r~You can't carry that much.",
        ['blip'] = 'Weapon Shop',
    },
}
