fx_version 'cerulean'
game 'gta5'
author 'ONX'
description 'WiseGuy Emergency Vehicles Pack'
version '1.0.0'
lua54 'yes'

data_file 'HANDLING_FILE' 'data/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/vehicles.meta'
data_file 'CARCOLS_FILE' 'data/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/carvariations.meta'

files {
  'data/*.meta'
}

escrow_ignore {
  'data/*.meta',
  'stream/*.ytd',
}

server_scripts {
  'version.lua',
}

dependency '/assetpacks'