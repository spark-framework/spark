return {
    ["unemployed"] = {
        paycheck = 1000,
        time = 1000 * 20, -- paycheck interval

        events = {
            --- @param player player
            recieved = function(player)
                player:Notification('You are now unemployed')
            end,

            --- @param player player
            --- @param amount number
            paycheck = function(player, amount)
                player:Notification('You recieved ' .. amount .. '!')
            end
        }
    },

    ["police"] = {
        grades = {
            [1] = {
                name = "Police Officer",
                paycheck = 25000,
                time = 1000 * 20 -- paycheck interval
            },

            [2] = {
                name = "Police Chief",
                paycheck = 50000,
                time = 1000 * 20 -- paycheck interval
            }
        },

        events = {
            --- @param player player
            recieved = function(player, grade, name)
                player:Notification('You are now a ' .. name .. '!')
            end,

            --- @param player player
            paycheck = function(player, amount)
                player:Notification('You recieved ' .. amount .. ' from your paycheck! Thank you officer')
            end
        }
    }
}