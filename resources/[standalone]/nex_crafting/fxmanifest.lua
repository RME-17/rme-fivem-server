fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'nex_crafting'
author 'NEX Development | Donk'
description 'Advanced Crafting System — React/Tailwind UI, multi-framework (ESX/QBox/QBCore)'
version '1.0.5'

shared_scripts {
    '@ox_lib/init.lua',
    'locales/*.lua',
    'settings/runtime.lua',
    'settings/general.lua',
    'source/shared/definitions.lua',
    'source/shared/bootstrap.lua',
}

client_scripts {
    'source/client/bridge.lua',
    'integrations/client.lua',
    'source/client/main.lua',
    'source/client/nui.lua',
    'source/client/benches.lua',
    'source/client/placer.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'source/server/database.lua',
    'source/server/bridge.lua',
    'settings/discord.lua',
    'integrations/inventory.lua',
    'integrations/framework.lua',
    'source/server/config.lua',
    'source/server/inventory.lua',
    'source/server/main.lua',
    'source/server/crafting.lua',
    'source/server/commands.lua',
    'source/server/version_check.lua',
}

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
    'web/build/assets/**/*',
}

dependencies {
    'oxmysql',
    'ox_lib',
}

escrow_ignore {
    'settings/*.lua',
    'integrations/*.lua',
    'locales/*.lua',
}
dependency '/assetpacks'