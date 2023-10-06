fx_version 'cerulean'
game 'gta5'

version '1.0'

server_scripts {
    'server/Spark.lua',
    'server/Network.lua',
    'server/Version.lua',
    'server/Driver.lua'
}

shared_scripts {
    'shared/Spark.lua',
    'shared/String.lua',
    'shared/Table.lua',
    'shared/Files.lua',
    'shared/Config.lua'
}