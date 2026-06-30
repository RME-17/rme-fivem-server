fx_version 'cerulean'
game 'gta5'

author 'RME'
description 'RME dedicated speedometer (cars + aircraft) + square minimap reposition + vehicle damage'
version '1.7.0'

-- UI page filename intentionally bumped (index.html -> hud.html -> hud2.html ->
-- hud3.html -> hud4.html -> hud5.html -> hud6.html -> hud7.html) to force the client NUI/CEF
-- to fetch a fresh page (old filenames get cached).
ui_page 'html/hud7.html'

client_scripts {
    'client.lua',
    'minimap.lua',
    'damage.lua'
}

files {
    'html/hud7.html'
}
