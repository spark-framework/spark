return {
    ["admin"] = {
        events = {
            spawn = function(player)
                player:notification('You are now admin.')
            end,

            remove = function(player)
                player:notification('You are no longer admin.')
            end
        },
        permissions = {
            'selectplayer',

            'givecash',
            'removecash',

            'unban',
            'ban'
        }
    },

    ["developer"] = {
        events = {
            spawn = function(player)
                player:notification('You are now a developer.')
            end,

            remove = function(player)
                player:notification('You are no longer a developer.')
            end
        },
        permissions = {
            "runcode"
        }
    }
}