fx_version 'cerulean'
game 'gta5'

author 'primeScripts'
description 'primeWeaponshop - Discord: https://dsc.gg/primescripts'
version '1.0'

lua54 'yes'

shared_script '@ox_lib/init.lua'

escrow_ignore {
    'config.lua',
    'client.lua',
    'server.lua'
}

client_scripts {
    '@NativeUILua_Reloaded/src/NativeUIReloaded.lua',
    'config.lua',
    'client.lua'
}

server_scripts {
    'config.lua',
    'server.lua'
}
