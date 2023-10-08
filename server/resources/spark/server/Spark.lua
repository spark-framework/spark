CreateThread(function ()
    local Loaded = false
    Spark.Driver:Ready(function()
        Citizen.Await(Spark.Version.Loaded) -- Wait for the version to be printed

        print('Database driver is ready!')
        Loaded = true
    end)

    SetTimeout(2000, function()
        if not Loaded then
            print('Cannot seem to connect to database driver?')
        end
    end)
end)