fx_version 'cerulean'
game 'gta5'

lua54 'yes'
version '1.0'

client_scripts {
    'client/Spawn.lua'
}

server_scripts {
    'server/Spark.lua',
    'server/Network.lua',
    'server/Version.lua',
    'server/Driver.lua',

    'server/Players/Source.lua',
    'server/Players/Players.lua',
    'server/Players/Class.lua',

    'server/Players/Commands.lua'
}

shared_scripts {
    'shared/Spark.lua',
    'shared/String.lua',
    'shared/Table.lua',
    'shared/Files.lua',
    'shared/Config.lua',
    'shared/Events.lua',
}