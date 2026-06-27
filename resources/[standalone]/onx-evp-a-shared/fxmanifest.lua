fx_version 'cerulean'
game 'gta5'
author 'ONX'
description 'WiseGuy Emergency Vehicles Pack'
version '2.1.1'
lua54 'yes'

data_file 'AUDIO_GAMEDATA' 'audioconfig/onxevp_game.dat'
data_file 'AUDIO_GAMEDATA' 'audioconfig/onxevpems_game.dat'
data_file 'VEHICLE_LAYOUTS_FILE' 'data/vehiclelayouts.meta'
data_file 'WEAPONINFO_FILE' 'data/vehicleweapons_pol.meta'
data_file 'WEAPONINFO_FILE' 'data/vehicleweapons_ems.meta'
data_file 'CARCOLS_FILE' 'data/carcols_sirens.meta'
data_file 'CARCOLS_FILE' 'data/carcols_sirens_ems.meta'

files {
  'audioconfig/*.dat151.rel',
  'data/*.meta'
}

client_script 'data/vehicle_names.lua'

escrow_ignore {
  'data/*.meta',
  'data/*.lua'
}

server_scripts {
  'version.lua',
}

escrow_ignore {
  'dev_extras/**/*.yft',
  'dev_extras/**/*.xml'
}
dependency '/assetpacks'