fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

name "um-chat"
author "uyuyorum store"
version "1.3.0"
description "UM - Chat"

shared_scripts {
	'@ox_lib/init.lua',
	'config/config.lua',
	'lua/utils/debug.lua',
}

client_scripts {
	'lua/client/*.lua',
	'lua/commands/utils/*.lua',
	'lua/commands/main/client.lua',
	'lua/commands/emotes/*.lua',
	'lua/commands/games/*.lua',
}

server_scripts {
	'config/logs.lua',
	'config/permission.lua',
	'lua/server/*.lua',
	'lua/commands/main/server.lua',
}

ui_page 'web/build/index.html'

files {
	'web/build/**',
}

escrow_ignore {
	'config/**',
	'lua/client/client.lua',
	'lua/server/server.lua',
	'lua/commands/**',
}

dependencies {
	'ox_lib',
}
dependency '/assetpacks'