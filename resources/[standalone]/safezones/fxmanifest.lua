fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'nc-safezone'
author 'NoxCore'
version '1.0.0'
description 'Safe Zone Management System'

-- ui_page disabled by RME: hides NoxCore's built-in white safe-zone popup.
-- Safe-zone alerts are rendered by the rme-safezone-ui resource instead.
-- ui_page 'web/dist/index.html'

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
