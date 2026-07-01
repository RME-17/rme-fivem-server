fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'rme-crafting'
author 'RME'
description 'RME custom crafting v2: placeable benches, NUI creator (Basic/Access/Recipes/Settings), item picker with images + categories, DB-stored recipes, qb-target eye. Fully editable, no escrow.'
version '2.0.0'

ui_page 'web/index.html'

shared_scripts {
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
}
