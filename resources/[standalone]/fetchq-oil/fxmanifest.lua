fx_version 'cerulean'
version '1.0.2'
game 'gta5'

shared_scripts {
    '@ox_lib/init.lua',
    'locales/locale.lua',
    'shared/compat.lua',
    'shared/config.lua',
}
client_scripts {
	'client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua'
}

ui_page 'html/index.html'
files {
	'html/index.html',
	'html/style.css',
	'html/script.js',
}

escrow_ignore {
	'shared/*.lua',
	'locales/*.lua',
}


dependency '/assetpacks'

dependency '/assetpacks'
dependency '/assetpacks'