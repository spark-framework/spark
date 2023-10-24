local Groups = Spark:Config('Groups')
local Server = Spark:Config('Server')
local Jobs = Spark:Config('Jobs')

RegisterNetEvent('Spark:Connect', function(steam, def)
    local player = Spark.Players:Get("steam", steam)
    if player:Source() == 0 then
        return
    end

    if player.Ban:Is() then
        return def.done('You are banned!')
    end

    if not player.Whitelist:Is() and Server.Whitelisted then
        return def.done('You are not whitelisted!')
    end
end)

RegisterNetEvent('Spark:Spawned', function(steam, first)
    local player = Spark.Players:Get("steam", steam)
    if player:Source() == 0 then
        return
    end

    local coords = player.Data:Get('Coords')

    if first then
        player:Notification('Welcome to the server! Use F9 to open the main menu')
        player.Position:Set(coords)

        player.Customization:Set(player.Data:Get('Customization')) -- set the player's skin
        player.Weapons:Set(player.Data:Get('Weapons')) -- set the player's weapon
        --player.Weapons.Attachments:Set(player.Data:Get('Attachments'))

        player.Health:Set(player.Data:Get('Health')) -- set the player's health

        for _, v in pairs(player.Data:Get('Groups')) do
            TriggerEvent('Spark:Player:Group:Add', player:Steam(), v)
        end

        local job, grade = player.Job:Get()
        TriggerEvent('Spark:Player:Job', player:Steam(), job, grade, Jobs[job].grades and Jobs[job].grades[grade].name or job)

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

                local user = player.Job:Raw()
                local data = Jobs[user.job]

                local job = data.grades and data.grades[user.grade] or data

                if user.time == 0 then -- pay user
                    user.time = job.time + 1000
                    player.Cash:Add(job.paycheck)

                    data.events.paycheck(player, job.paycheck)
                end

                user.time = user.time - 1000
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

RegisterNetEvent('Spark:Player:Job', function(steam, job, grade, name)
    local player = Spark.Players:Get("steam", steam)
    if player:Source() == 0 then
        return
    end

    local config = Jobs[job]
    if config.events.recieved then
        print(job,grade,name)
        config.events.recieved(player, grade, name)
    end
end)

RegisterNetEvent('Spark:Player:Group:Add', function(steam, group)
    local player = Spark.Players:Get("steam", steam)
    if player:Source() == 0 then
        return
    end

    local config = Groups[group].config
    if config.spawn then
        config.spawn(player)
    end
end)

RegisterNetEvent('Spark:Player:Group:Remove', function(steam, group)
    local player = Spark.Players:Get("steam", steam)
    if player:Source() == 0 then
        return
    end

    local config = Groups[group].config
    if config.remove then
        config.remove(player)
    end
end)


RegisterNetEvent('Spark:Dropped', function(steam)
    local player = Spark.Players:Get("steam", steam)
    if player:Source() == 0 then
        return
    end

    local coords = player.Position:Get()

    player.Data:Set('Coords', {x = coords.x, y = coords.y, z = coords.z})
    player.Data:Set('Health', player.Health:Get())
end)