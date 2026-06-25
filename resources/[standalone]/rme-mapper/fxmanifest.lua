fx_version 'cerulean'
game 'gta5'

name 'rme-mapper'
description 'RME in-game map editor: spawn, select, move, rotate, duplicate, delete props with a mouse gizmo. Synced to all players + persistent to disk.'
author 'RME'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
}

dependencies {
    'ox_lib',
    'object_gizmo',
    'qb-core',
}
