RegisterCommand('join', function(source)
    Wait(0)
    Spark.Players:playerConnecting(source, {
        defer = function () end,
        update = function () end,
        done = function () end
    })
end, false)

RegisterCommand('spawn', function(source)
    Wait(0)
    Spark.Players:playerSpawned(source)
end, false)

RegisterCommand('data', function(source, args)
    Wait(0)

    local player = Spark.Players:Get("source", source)
    if args[1] == "set" then
        player?.Data:Set(args[2], args[3])
    else
        print(player?.Data:Get(args[2]))
    end
end, false)

RegisterCommand('drop', function(source)
    Wait(0)
    Spark.Players:playerDropped(source, 'daddy waddy')
end, false)

CreateThread(function()
    Wait(2000)
    for _, source in pairs(GetPlayers()) do
        local src = tonumber(source)
        Spark.Players:playerConnecting(src, {
            defer = function () end,
            update = function () end,
            done = function () end
        })

        Wait(250)

        Spark.Players:playerSpawned(src)
    end
end)