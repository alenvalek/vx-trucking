fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

dependencies {
    'ox_inventory',
    'ox_lib',
    'ox_core'
}

shared_scripts {
    '@ox_lib/init.lua',
    '@ox_inventory',
    'shared/utils.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

client_scripts {
    '@ox_core/imports/client.lua',
    'client/boss.lua',
    'client/mission.lua',
    'client/player.lua',
    'client/vehicle.lua',
    'client/main.lua',
}

files {
    'locales/*.json'
}
