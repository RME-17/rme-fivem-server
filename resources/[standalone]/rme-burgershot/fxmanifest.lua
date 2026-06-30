fx_version 'cerulean'
game 'gta5'

name 'rme-burgershot'
description 'Burger Shot cooking stations (grill / fryer / prep) with ingredient recipes'
author 'RME'
version '1.0.0'

shared_script 'config.lua'
client_script 'client.lua'
server_script 'server.lua'

dependencies {
    'qb-core',
    'qb-target',
    'qb-menu',
    'progressbar',
}

lua54 'yes'
