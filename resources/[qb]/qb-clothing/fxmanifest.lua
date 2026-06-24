fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Kakarot'
description 'A menu providing players the ability to change their clothing and accessories'
version '1.2.0'

ui_page 'html/index.html'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua',
    'client.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/reset.css',
    'html/script.js',
    'html/jquery-3.6.0.min.js',
    'html/fontawesome.min.css',
    'html/poppins-300.woff2',
    'html/poppins-400.woff2',
    'html/poppins-500.woff2',
    'html/poppins-600.woff2',
    'html/poppins-700.woff2',
    'html/webfonts/*.woff2',
    'html/webfonts/*.woff',
    'html/webfonts/*.ttf'
}
