fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'United'
description 'moving company job: load furniture and boxes, deliver them, and get paid.'
version '1.3.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/localization.lua',
    'locales/*.lua'
}

client_scripts {
    'client/notifications.lua',
    'client/fuel.lua',
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

escrow_ignore {
    'shared/config.lua',
    'locales/*.lua',
    'docs/README.md'
}

dependency '/assetpacks'