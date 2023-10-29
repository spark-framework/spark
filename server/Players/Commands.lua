-- hardcoded test commands

RegisterCommand('join', function(source)
    Wait(0)
    Spark:playerConnecting(source, {
        defer = function () end,
        update = function (text) end,
        done = function (text) end
    })
end, false)

RegisterCommand('spawn', function(source)
    Wait(0)
    Spark:playerSpawned(source)
end, false)

RegisterCommand('data', function(source, args)
    Wait(0)

    local player = Spark:getPlayer("source", source)
    if args[1] == "set" then
        player:setData(args[2], args[3])
    else
        print(player:getData(args[2]))
    end
end, false)

RegisterCommand('group', function(source, args)
    Wait(0)
    local player = Spark:getPlayer("source", source)

    if args[1] == "add" then
        print(player:addGroup(args[2]))
    else
        print(player:removeGroup(args[2]))
    end
end, false)

RegisterCommand('permission', function(source, args)
    Wait(0)
    local player = Spark:getPlayer("source", source)

    if args[1] == "1" then
        print(player:hasPermission(args[2]))
    else
        print(player:hasPermission({args[2], args[3]}))
    end
end, false)

RegisterCommand('cash', function(source, args)
    Wait(0)
    local player = Spark:getPlayer("source", source)

    args[2] = tonumber(args[2] or "0")

    local function notification(text)
        player:notification(tostring(text) .. " cash " .. player:getCash())
    end

    if args[1] == "add" then
        notification(player:addCash(args[2]))
    elseif args[1] == "remove" then
        notification(player:removeCash(args[2]))
    elseif args[1] == "get" then
        notification(player:getCash())
    elseif args[1] == "set" then
        notification(player:setCash(args[2]))
    elseif args[1] == "has" then
        notification(player:hasCash(args[2]))
    elseif args[1] == "payment" then
        notification(player:payment(args[2]))
    end
end, false)

RegisterCommand('drop', function(source)
    Wait(0)
    Spark:playerDropped(source, 'daddy waddy')
end, false)

RegisterCommand('openmenu', function(source, args, raw)
    Wait(0)
    local player = Spark:getPlayer("source", source)
    player:showMenu('hello', 'rgb(39, 78, 223)', {
        "Hello"
    }, function(button)
        print(button)
    end)
end, false)

RegisterCommand('closemenu', function(source, args, raw)
    Wait(0)
    local player = Spark:getPlayer("source", source)
    player:closeMenu()
end, false)

RegisterCommand('ban', function(source, args, raw)
    Wait(0)
    local player = Spark:getPlayer("source", source)
    player:setBanned(true, 'Welp')
end, false)

RegisterCommand('setjob', function(source, args, raw)
    Wait(0)
    local player = Spark:getPlayer("source", source)
    player:setJob(args[1], tonumber(args[2]) or 1)
end, false)

RegisterCommand('getjob', function(source, args, raw)
    Wait(0)
    local player = Spark:getPlayer("source", source)
    local job, grade = player:getJob()

    print(job, grade)
end, false)

RegisterCommand('run', function(source, args, raw)
    Wait(0)
    Spark:triggerEvent('Test', Spark:getPlayer('source', source), 'Hello')
end, false)


CreateThread(function()
    Wait(2000)
    for _, source in pairs(GetPlayers()) do
        local src = tonumber(source)
        Spark:playerConnecting(src, {
            defer = function () end,
            update = function () end,
            done = function () end
        })

        Wait(250)

        Spark:playerSpawned(src)
    end
end)