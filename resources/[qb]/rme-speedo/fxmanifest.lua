fx_version 'cerulean'
game 'gta5'

author 'RME'
description 'RME dedicated speedometer (cars + aircraft) + square minimap reposition'
version '1.4.0'

-- UI page filename intentionally bumped (index.html -> hud.html -> hud2.html ->
-- hud3.html) to force the client NUI/CEF to fetch a fresh page (old filenames
-- get cached).
ui_page 'html/hud3.html'

client_scripts {
    'client.lua',
    'minimap.lua'
}

files {
    'html/hud3.html'
}
