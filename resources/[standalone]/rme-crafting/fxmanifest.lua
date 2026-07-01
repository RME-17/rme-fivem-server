fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'rme-crafting'
author 'RME'
description 'RME custom crafting: placeable benches, qb-target eye, qb-menu UI, config recipes, DB-persisted. Fully editable (no escrow).'
version '1.0.0'

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

dependencies {
    'qb-core',
    'qb-target',
    'qb-menu',
    'qb-inventory',
    'oxmysql',
    'progressbar',
}
