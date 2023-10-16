RegisterNetEvent('Spark:Spawned', function(steam, first)
    local player = Spark.Players:Get("steam", steam)
    if player.Get:Source() == 0 then
        return
    end

    local coords = player.Data:Get('Coords')

    if first then
        player.Set:Position(coords)

        player.Set:Customization(player.Data:Get('Customization')) -- set the player's skin
        player.Set:Weapons(player.Data:Get('Weapons')) -- set the player's weapon

        player.Set:Health(player.Data:Get('Health')) -- set the player's health

        CreateThread(function() -- save weapons
            while true do
                if not player.Is:Loaded() then
                    return
                end

                local data = player.Client:Callback('Spark:State')
                
                player.Data:Set('Customization', data.customization)
                player.Data:Set('Weapons', data.weapons)

                Wait(5 * 1000) -- 5 seconds
            end
        end)
    else -- if the user died and spawned again
        coords = Spark.Players.Default.Coords
        player.Set:Position(coords)

        player.Set:Customization(player.Data:Get('Customization'))
        player.Set:Health(player.Get:Max())

        player.Set:Weapons({})
        player.Data:Set('Weapons', {})
    end
end)

RegisterNetEvent('Spark:Dropped', function(steam)
    local player = Spark.Players:Get("steam", steam)
    if player.Get:Source() == 0 then
        return
    end

    local coords = player.Get:Position()

    player.Data:Set('Coords', {x = coords.x, y = coords.y, z = coords.z})
    player.Data:Set('Health', player.Get:Health())
end)