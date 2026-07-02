fx_version 'cerulean'
game 'gta5'

author 'primeScripts (QBCore + ox_lib port by RME)'
description 'primeWeaponshop - QBCore port'
version '1.1'

lua54 'yes'

shared_script '@ox_lib/init.lua'

client_scripts {
    'config.lua',
    'client.lua'
}

server_scripts {
    'config.lua',
    'server.lua'
}

dependencies {
    'qb-core',
    'ox_lib'
}
