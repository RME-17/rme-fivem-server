fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'nc-safezone'
author 'NoxCore'
version '1.0.0'
description 'Safe Zone Management System'

ui_page 'web/dist/index.html'

shared_scripts {
    'config.lua',
    'shared/locale.lua',
    'shared/notify.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
}

files {
    'web/dist/**/*',
    'locales/*.lua',
}

escrow_ignore {
    'config.lua',
    'shared/locale.lua',
    'shared/notify.lua',
    'locales/*.lua',
    'data/safezones.json',
}

dependency '/assetpacks'