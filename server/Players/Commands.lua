---@diagnostic disable: need-check-nil
-- hardcoded test commands

local Commands = {
    --- @param player player
    join = function(player)
        Spark:playerConnecting(player:getSource(), {
            defer = function () end,
            update = function (text) end,
            done = function (text) end
        })
    end,

    --- @param player player
    spawn = function(player)
        Spark:playerSpawned(player:getSource())
    end,

    --- @param player player
    drop = function(player)
        Spark:playerDropped(player:getSource(), "Testing")
    end,

    --- @param player player
    data = function(player, args)
        if args[1] == "set" then
            player:setData(args[2], args[3])
        else
            print(player:getData(args[2]))
        end
    end,

    --- @param player player
    group = function(player, args)
        if args[1] == "add" then
            player:addGroup(args[2])
        elseif args[1] == "remove" then
            player:removeGroup(args[2])
        end
    end,

    --- @param player player
    permission = function(player, args)
        print(player:hasPermission(args[1]))
    end,

    --- @param player player
    cash = function(player, args)
        args[2] = tonumber(args[2] or "0")

        if args[1] == "add" then
            player:addCash(args[2])
        elseif args[1] == "remove" then
            player:removeCash(args[2])
        elseif args[1] == "get" then
            print(player:getCash())
        elseif args[1] == "set" then
            player:setCash(args[2])
        elseif args[1] == "has" then
            print(player:hasCash(args[2]))
        elseif args[1] == "payment" then
            print(player:payment(args[2]))
        end
    end,

    --- @param player player
    menu = function(player, args)
        if args[1] == "open" then
            player:showMenu('hello', 'rgb(39, 78, 223)', {
                "Hello"
            }, function(button)
                print(button)
            end)
        elseif args[1] == "close" then
            player:closeMenu()
        end
    end,

    --- @param player player
    ban = function(player, args)
        player:setBanned(true, args[1])
    end,

    --- @param player player
    job = function(player, args)
        if args[1] == "set" then
            player:setJob(args[1], tonumber(args[2]) or 1)
        elseif args[1] == "get" then
            local job, grade = player:getJob()
            print(job, grade)
        end
    end,
}

for command, callback in pairs(Commands) do
    RegisterCommand(command, function(source, args)
        Wait(0) -- Wait so prints doesn't get printed in player's chat

        local player = Spark:getPlayer("source", source)
        if player then
            callback(player, args)
        end
    end, false)
end

CreateThread(function()
    Wait(1500) -- Wait for Spark to load

    for _, source in pairs(GetPlayers()) do -- Loop all players
        Spark:playerConnecting(tonumber(source), {
            defer = function () end,
            update = function () end,
            done = function () end
        })

        Wait(250)

        Spark:playerSpawned(tonumber(source))
    end
end)