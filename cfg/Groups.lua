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
    }
}