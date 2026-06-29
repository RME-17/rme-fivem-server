fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'RME'
description 'Gym workout system - train Strength / Stamina / Running at gym equipment. Integrates with rme-playerstats.'
version '1.0.0'

shared_script 'config.lua'
client_script 'client.lua'
server_script 'server.lua'

dependencies {
    'qb-core',
    'rme-playerstats',
}
