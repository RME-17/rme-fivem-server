fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'rme-crafting'
author 'RME'
description 'RME custom crafting v3: placeable benches, NUI creator (Basic/Access/Recipes/Settings), item picker w/ images+categories, per-recipe access/level/fail/xp, skill-check, batch crafting, DB-stored. Fully editable, no escrow.'
version '3.0.0'

ui_page 'web/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

files {
    'web/index.html',
    'web/style.css',
    'web/script.js',
}

dependencies {
    'qb-core',
    'qb-target',
    'qb-inventory',
    'oxmysql',
    'progressbar',
    'ox_lib',
}
