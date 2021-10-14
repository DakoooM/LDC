fx_version 'bodacious'
game 'gta5'

--

shared_scripts { 
    "config/config.lua",
    "config/jobs.lua",
    "config/groups.lua",
    "config/items.lua"
}

client_scripts {
    "sounds/*.lua",
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
    'client/player/player.lua',
    'client/player/spawn.lua',
    'client/player/identity.lua',
    'client/player/surgery.lua',
    'client/player/inventory.lua',
    'client/player/pickup.lua',
    'client/menus/location.lua',
    'client/menus/makeup.lua',
    'client/menus/cardealer.lua',
    'client/menus/garage.lua',
    'client/modules/functions.lua',
    'client/modules/commands.lua',
    'client/modules/markers.lua',
    'client/addons/cayo.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/functions.lua',
    'server/player/inventory.lua',
    'server/player/player.lua',
    'server/player/money.lua',
    'server/player/status.lua',
    'server/player/groups.lua',
    'server/player/pickup.lua',
    'server/jobs/jobs.lua',
    'server/menus/location.lua',
    'server/menus/makeup.lua',
    'server/menus/surgery.lua',
    'server/menus/carwash.lua',
    'server/menus/cardealer.lua',
    'server/menus/garage.lua',
}

ui_page "html/index.html"

files {
    "html/index.html",
    "html/scripts/listener.js",
    "html/scripts/SoundPlayer.js",
    "html/scripts/functions.js",
}