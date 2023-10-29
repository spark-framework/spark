return {
    ["unemployed"] = {
        label = "Unemployed",
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
                label = "Police Officer",
                paycheck = 25000,
                time = 1000 * 20 -- paycheck interval
            },

            [2] = {
                label = "Police Chief",
                paycheck = 50000,
                time = 1000 * 20 -- paycheck interval
            }
        },

        events = {
            --- @param player player
            recieved = function(player, job)
                player:Notification('You are now a ' .. job.label .. '!')
            end,

            --- @param player player
            paycheck = function(player, amount)
                player:Notification('You recieved ' .. amount .. ' from your paycheck! Thank you officer')
            end
        }
    }
}