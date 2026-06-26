name 'KOJA CARMARKET'
author 'Koja Scripts'
version '1.0'
description 'Player-driven car market with auctions, exchange zones, rentable parking slots and test drives. Supports ESX & QBCore via koja-lib.'
fx_version 'cerulean'
game 'gta5'

use_fxv2_oal 'yes'
lua54 'yes'

dependencies {
	'koja-lib',
	'oxmysql',
}

shared_scripts {
	'init.lua',
	'shared/config.lua',
	'shared/utils.lua',
	'shared/testdrive.lua',
	'shared/vehicle_labels.lua',
	'locales/locale.lua',
	'shared/exports.lua',
}

client_scripts {
	'client/bridge/utils/utils.lua',
	'client/bridge/utils/targets.lua',
	'client/bridge/utils/menus.lua',
	'client/bridge/utils/utils_market.lua',
	'client/bridge/utils/utils_parking.lua',
	'client/client.lua',
	'client/bridge/zones.lua',
	'client/bridge/events.lua',
	'client/bridge/nui.lua',
	'client/bridge/testdrive.lua',
	'client/bridge/dui.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/database.lua',
	'server/bridge/utils.lua',
	'server/bridge/vehicle_compat.lua',
	'server/server.lua',
	'server/bridge/callbacks/callbacks_exchange.lua',
	'server/bridge/callbacks/callbacks_admin.lua',
	'server/bridge/callbacks/callbacks_market.lua',
	'server/bridge/callbacks/callbacks_mycars.lua',
}

files {
	'web/build/index.html',
	'web/build/**/*',
	'web/build/dui.html',
	'locales/*.json',
}

ui_page 'web/build/index.html'

exports {
	'OpenTablet',
	'RefreshZone',
	'CloseTablet',
	'IsTabletOpen',
	'GetCarsInZone',
	'GiveVehicleToPlayer',
}
escrow_ignore {
  '*.lua',
  '*.sql',
  '*.md',
  'init.lua',
  'fxmanifest.lua',
  'database.sql',
  'client/**',
  'server/**',
  'shared/**',
  'locales/**',
  'web/**',
  '**/*',
}

dependency '/assetpacks'