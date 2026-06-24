fx_version "cerulean"
game "gta5"

author 'devkayne'
description 'NPWD Banking App'
version '1.0.0'

dependency 'qb-core'
dependency 'npwd'
dependency 'oxmysql'

client_script "dist/client.js"
server_script "dist/server.js"

ui_page "web/dist/index.html"

files {
	"web/dist/index.html",
	"web/dist/**/*",
}
