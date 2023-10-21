local Groups = Spark:Config('Groups')

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