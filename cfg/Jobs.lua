return {
    ["unemployed"] = {
        recieved = function(player)
            player:Notification('You are now unemployed')
        end
    },

    ["police"] = {
        grades = {
            [1] = {
                name = "Police Officer",
                paycheck = 25000
            },

            [2] = {
                name = "Police Chief",
                paycheck = 50000
            }
        },

        recieved = function(player, grade, name)
            player:Notification('You are now a ' .. name .. '!')
        end
    }
}