RegisterNetEvent('Spark:Spawned', function(source, first)
    local player = Spark.Players:Get("source", source)
    local coords = player.Data:Get('Coords')
    if first then
        player.Set:Health(player.Data:Get('Health'))
        player.Set:Position(coords.x, coords.y, coords.z)

        CreateThread(function() -- save weapons
            local weapons = player.Client:Callback('GetWeapons')
            print(json.encode(weapons))
        end)
    end

    print(player, first)
end)

RegisterNetEvent('Spark:Dropped', function(steam)
    local player = Spark.Players:Get("source", player)
    if player.Get:Source() == 0 then
        return
    end

    local coords = player.Get:Position()


    --print(coords)

    player.Data:Set('Coords', {x = coords.x, y = coords.y, z = coords.z})
    player.Data:Set('Health', player.Get:Health())

    --Wait(250)
    --print(json.encode(Spark.Players.Players[player.Get:Steam()].data))
    --print("SET DATA?")
end)