fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name        'rme-tv'
author      'RME'
description 'xSound audio layer for rde_oxmedia world TVs/radios - gives screens working sound on builds where DUI audio is muted'
version     '1.1.0'

-- NOTE: no hard dependencies block on purpose, so rme-tv ALWAYS starts and can
-- report (in console) whether xsound / rde_oxmedia are present. Load order and
-- readiness are handled with runtime GetResourceState checks in client.lua.
-- Still put `ensure xsound` BEFORE `ensure rme-tv` in server.cfg for clean startup.

client_script 'client.lua'
