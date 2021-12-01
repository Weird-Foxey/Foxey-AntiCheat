fx_version 'cerulean'
game 'gta5'

author 'Foxey#0505'
description 'Foxey Anticheat'
version '1.0.0'

shared_script 'shared.lua'
shared_script 'Config.lua'

client_scripts {
    'Detections/client/client.lua',
    'Detections/client/commands.lua',
    'Detections/client/esx.lua',
    'Detections/client/fpsboost.lua',
    'Detections/client/freecam.lua',
    'Detections/client/godmode.lua',
    'Detections/client/invisble.lua',
    'Detections/client/spectate.lua',
    'Detections/client/resourcecount.lua',
    'Detections/client/Blips.lua',
    'Detections/client/Attached.lua',
    'Detections/client/fuctions.lua',

}

server_scripts {
    'Bansystem/server.lua',
    'Detections/server/Server.lua',
    'Detections/server/entityCreating.lua',
    'Detections/server/event.lua',
    'Detections/server/ExplosionProtection.lua',
    'Detections/server/giveWeapon.lua',
    'Detections/server/words.lua',
    '@oxmysql/lib/MySQL.lua',
}
