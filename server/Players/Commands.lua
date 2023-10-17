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

RegisterCommand('group', function(source, args)
    Wait(0)
    local player = Spark.Players:Get("source", source)

    if args[1] == "add" then
        print(player?.Groups:Add(args[2]))
    else
        print(player?.Groups:Remove(args[2]))
    end
end, false)

RegisterCommand('permission', function(source, args)
    Wait(0)
    local player = Spark.Players:Get("source", source)

    if args[1] == "1" then
        print(player?.Groups:Permission(args[2]))
    else
        print(player?.Groups:Permission({args[2], args[3]}))
    end
end, false)

RegisterCommand('cash', function(source, args)
    Wait(0)
    local player = Spark.Players:Get("source", source)

    args[2] = tonumber(args[2] or "0")

    local function notification(text)
        player:Notification(tostring(text) .. " cash " .. player.Cash:Get())
    end

    if args[1] == "add" then
        notification(player?.Cash:Add(args[2]))
    elseif args[1] == "remove" then
        notification(player?.Cash:Remove(args[2]))
    elseif args[1] == "get" then
        notification(player?.Cash:Get())
    elseif args[1] == "set" then
        notification(player?.Cash:Set(args[2]))
    elseif args[1] == "has" then
        notification(player?.Cash:Has(args[2]))
    elseif args[1] == "payment" then
        notification(player?.Cash:Payment(args[2]))
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