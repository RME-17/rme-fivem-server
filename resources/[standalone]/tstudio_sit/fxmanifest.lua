fx_version 'cerulean'
lua54 'yes'
game 'gta5'

author 'TStudio'
description 'TStudio Sit — Modular prop sitting system + in-resource seat editor'
version '1.0.0'

ui_page 'html/index.html'

files {
    'html/**/*',
    'data/*.lua',
}

shared_scripts {
    'config.lua',
    'shared/*.lua',
}

client_scripts {
    'client/*.lua',
    'framework/**/*.lua',
    'editor/client/*.lua',
}

server_scripts {
    'server/*.lua',
}

escrow_ignore {
    'config.lua',
    'data/*.lua',
    'html/**/*',
}

dependency '/assetpacks'