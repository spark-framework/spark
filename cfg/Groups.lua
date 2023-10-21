return {
    ["admin"] = {
        config = {
            spawn = function(player)
                player:Notification('You are now admin.')
            end,
            remove = function(player)
                player:Notification('You are no longer admin.')
            end
        },
        permissions = {
            "revive"
        }
    },

    ["developer"] = {
        config = {
            spawn = function(player)
                player:Notification('You are now a developer.')
            end,
            remove = function(player)
                player:Notification('You are no longer a developer.')
            end
        },
        permissions = {
            "runcode"
        }
    }
}