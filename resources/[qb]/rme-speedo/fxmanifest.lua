fx_version 'cerulean'
game 'gta5'

author 'RME'
description 'RME dedicated speedometer (cars + aircraft) + square minimap reposition'
version '1.2.0'

-- UI page filename intentionally bumped from index.html -> hud.html to force
-- the client NUI/CEF to fetch a fresh page (the old filename was being cached).
ui_page 'html/hud.html'

client_scripts {
    'client.lua',
    'minimap.lua'
}

files {
    'html/hud.html'
}
