fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name        'rme-tv'
author      'RME'
description 'xSound audio layer for rde_oxmedia world TVs/radios - gives screens working sound on builds where DUI audio is muted'
version     '1.0.0'

-- rde_oxmedia draws the video (DUI). xSound plays the sound (NUI).
dependencies {
    'xsound',
    'rde_oxmedia',
}

client_script 'client.lua'
