fx_version 'cerulean'
game 'gta5'

lua54 'yes'
version '1.0'

client_scripts {
    'cfg/Weapons.lua', -- what configs the client have access to

    'client/Spawn.lua',
    'client/Callback.lua',
    'client/Ped.lua',
    'client/Player/Server.lua',

    'client/Player/Player.lua',
    'client/Player/Weapons.lua',
    'client/Player/Customization.lua',
    'client/Player/State.lua'

}

server_scripts {
    'server/Spark.lua',
    'server/Network.lua',
    'server/Version.lua',
    'server/Driver.lua',

    'server/Events.lua',

    'server/Callback.lua',

    'server/Players/Source.lua',
    'server/Players/Players.lua',
    'server/Players/Class.lua',

    'server/Players/Commands.lua',
    'server/Players/State.lua'
}

shared_scripts {
    'shared/Spark.lua',
    'shared/String.lua',
    'shared/Table.lua',
    'shared/Files.lua',
    'shared/Config.lua',
}