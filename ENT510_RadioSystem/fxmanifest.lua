fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'ENT510'
version '1.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'shared/*.lua',
}

client_scripts {
    'client/*.lua',

}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

