RegisterCommand('join', function(source)
    print("Tried to join")
    Spark.Players:playerConnecting(source, {
        defer = function () end,
        update = function () end,
        done = function () end
    })
end, false)

RegisterCommand('spawn', function(source)
    Spark.Players:playerSpawned(source)
end, false)

RegisterCommand('drop', function(source)
    Spark.Players:playerDropped(source, 'daddy waddy')
end, false)