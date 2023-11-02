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
            "revive",
            "setjob",
            "removejob",
            "givecash"
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