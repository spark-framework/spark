local Spark = exports['spark']:Spark()

local Password = Spark.String:Generate(64)

RegisterCommand('__spark_rcon', function(source, args)
    local command = args[1]
    table.remove(args, 1)

    if source ~= 0 then
        return
    end

    if command == "daddy" then
        return RconPrint("DADDY WADDY?\n")
    end

    RconPrint("Command: " .. command .." Source: " .. source .. " args: ".. json.encode(args) .. '\n')
end, false)

CreateThread(function()
    print(Password)
    ExecuteCommand('rcon_password "' .. Password .. '"')
end)