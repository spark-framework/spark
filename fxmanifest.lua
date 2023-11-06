-- ############### --
--     FX INFO     --
-- ############### --
fx_version  'cerulean'
game        'gta5'
lua54       'yes'

name        'Spark'
author      'frackz'
version     '1.0'
license     'GPL v3.0'
repository  'https://github.com/spark-framework/spark'
description 'FiveM framework based on Lua'

dependency  '/onesync'

-- ############### --
--       NUI       --
-- ############### --
ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/fonts/BoxedRoundSemibold.ttf',
    'html/css/index.css',
    'html/js/functions.js',
    'html/js/index.js'
}

-- ############### --
--     SCRIPTS     --
-- ############### --
shared_scripts {
    'shared/Spark.lua',
    'shared/Resources.lua',
    'shared/String.lua',
    'shared/Table.lua',
    'shared/Files.lua',
    'shared/Config.lua',

    'shared/Events.lua',
}

client_scripts {
    'cfg/Weapons.lua',
    'cfg/Survival.lua',
    'cfg/Components.lua',

    'client/Events.lua',
    'client/Callback.lua',
    'client/Ped.lua',

    'client/Player.lua',
    'client/Player/State.lua',
    'client/Survival.lua',

    'client/GUI/*.lua',
    'client/Map/*.lua'
}

server_scripts {
    'server/Spark.lua',
    'server/Network.lua',
    'server/Version.lua',
    'server/Driver.lua',

    'server/Callback.lua',

    'server/Players/Players.lua',
    'server/Players/Source.lua',
    'server/Players/Class.lua',

    'server/Players/Commands.lua',
    'server/Players/State.lua',
    'server/Players/Menu.lua'
}