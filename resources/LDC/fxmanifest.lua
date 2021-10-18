 fx_version "bodacious"
game "gta5"

shared_scripts { 
    "dependencies/map/shared.lua",

    "config/config.lua",
    "config/jobs.lua",
    "config/groups.lua",
    "config/items.lua"
}

client_scripts {
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
    
    "dependencies/map/client.lua",
    "dependencies/rconlog/client.lua",
    "dependencies/spawn/manager.lua",

    "client/player/player.lua",
    "client/player/spawn.lua",
    "client/player/identity.lua",
    "client/player/surgery.lua",
    "client/player/inventory.lua",
    "client/player/pickup.lua",
    "client/modules/*.lua",
    "client/addons/cayo.lua"
}

server_scripts {
    "dependencies/mysql/mysql-async.js",
    "dependencies/mysql/MySQL.lua",
    "dependencies/map/server.lua",
    "dependencies/rconlog/server.lua",

    "server/functions.lua",
    "server/player/inventory.lua",
    "server/player/player.lua",
    "server/player/money.lua",
    "server/player/status.lua",
    "server/player/groups.lua",
    "server/player/pickup.lua",
    "server/jobs/jobs.lua",
    "server/modules/*.lua",
}