fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'trucking'
author 'RCD'
description 'Trucking Simulator - QBCore / QBox / ESX'
version '1.1.1'

shared_scripts {
    'shared/config.lua',
    'locales/en.lua',
    'locales/fr.lua',
    'locales/de.lua',
    'locales/es.lua',
    'locales/pt.lua',
    'locales/pl.lua',
    'shared/locale.lua',
    'shared/locations.lua',
    'shared/cargo.lua',
    'shared/trucks.lua',
}

server_scripts {
    'bridge/server.lua',
    'server/discord.lua',
    'server/storage.lua',
    'server/main.lua',
    'server/banking.lua',
    'server/contracts.lua',
    'server/police.lua',
    'server/drivers.lua',
    'server/trucks.lua',
    'server/garage.lua',
    'server/crew.lua',
    'server/upgrades.lua',
    'server/leaderboard.lua',
    'server/admin.lua',
    'server/locadmin.lua',
}

client_scripts {
    'bridge/client.lua',
    'bridge/vehicle.lua',
    'client/main.lua',
    'client/job.lua',
    'client/garage.lua',
    'client/admin.lua',
    'client/police.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/img/trucks/*.png',
    'html/img/trailers/*.png',
}

escrow_ignore {
    'shared/config.lua',
    'locales/*.lua',
    'shared/locations.lua',
    'shared/cargo.lua',
    'shared/trucks.lua',
    'data/companies.json',
}

dependency '/assetpacks'
dependency '/assetpacks'
dependency '/assetpacks'
dependency '/assetpacks'