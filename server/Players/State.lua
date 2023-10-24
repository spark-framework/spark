local Groups, Server, Jobs = Spark:Config('Groups'), Spark:Config('Server'), Spark:Config('Jobs')

--- @param player player
--- @param def defferals
Spark.Events:Listen('Connecting', function(player, def)
    if player.Ban:Is() then -- Is user banned
        return def.done('You are banned!')
    end

    if not player.Whitelist:Is() and Server.Whitelisted then -- Is server whitelisted and user is not
        return def.done('You are not whitelisted!')
    end
end)

--- @param player player
--- @param first boolean
Spark.Events:Listen('Spawned', function(player, first)
    local coords = player.Data:Get('Coords')

    if first then
        player:Notification('Welcome to the server! Use F9 to open the main menu')
        player.Position:Set(coords)

        player.Customization:Set(player.Data:Get('Customization')) -- set the player's skin
        player.Weapons:Set(player.Data:Get('Weapons')) -- set the player's weapon
        --player.Weapons.Attachments:Set(player.Data:Get('Attachments'))

        player.Health:Set(player.Data:Get('Health')) -- set the player's health

        for _, group in pairs(player.Data:Get('Groups')) do
            Spark.Events:Trigger('AddGroup', player, group) -- TODO: fix this
        end

        local job = player.Job:Get()
        Spark.Events:Trigger('SetJob', player, job) -- TODO: fix this

        CreateThread(function() -- save weapons
            while true do
                if not player.Is:Loaded() then
                    return
                end

                local data = player.Client:Callback('Spark:State')

                player.Data:Set('Customization', data.customization)
                player.Data:Set('Weapons', data.weapons)

                --player.Data:Set('Attachments', data.attachments)
                Wait(5 * 1000) -- 5 seconds
            end
        end)

        CreateThread(function()
            while true do
                if not player.Is:Loaded() then
                    return
                end

                local user = player.Job:Get()
                local data = Jobs[user.name]

                local job = data.grades and data.grades[user.grade] or data

                if user.time == 0 then -- pay user
                    user.time = job.time + 1000
                    player.Cash:Add(job.paycheck)

                    data.events.paycheck(player, job.paycheck)
                end

                user.time = (user.time or job.time) - 1000
                player.Data:Set('Job', user)

                Wait(1000)
            end
        end)
    else -- if the user died and spawned again
        coords = Spark.Players.Default.Coords
        player.Position:Set(coords)

        player.Customization:Set(player.Data:Get('Customization'))
        player.Health:Set(player.Health:Max())

        player.Weapons:Set({})
        player.Data:Set('Weapons', {})
        player.Data:Set('Attachments', {})
    end
end)

--- @param player player
--- @param job job
--- @param lastJob job
Spark.Events:Listen('SetJob', function(player, job, lastJob)
    local events = Jobs[job.name].events
    if events.recieved then
        events.recieved(player, job)
    end
end)

--- @param player player
--- @param group string
Spark.Events:Listen('AddGroup', function(player, group)
    local events = Groups[group].events
    if events.spawn then
        events.spawn(player)
    end
end)

--- @param player player
--- @param group string
Spark.Events:Listen('RemoveGroup', function(player, group)
    local events = Groups[group].events
    if events.remove then
        events.remove(player)
    end
end)

--- @param player player
Spark.Events:Listen('Dropped', function(player)
    local coords = player.Position:Get()

    player.Data:Set('Coords', {x = coords.x, y = coords.y, z = coords.z})
    player.Data:Set('Health', player.Health:Get())
end)