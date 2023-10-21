CreateThread(function ()
    local loaded = false

    print(Spark.Version:Get() == Spark.Version:Newest()
        and "Spark is up-to-date"
        or "Spark is out-of-date. Please download the newest version")

    SetTimeout(2000, function()
        if not loaded then -- If the database driver has not loaded
            print('Cannot seem to connect to database driver?')
        end
    end)

    Spark.Driver:Ready(function()
        local users = Spark.Driver:Query('SELECT * FROM users')
        loaded = true

        print('Database driver is ready!')
        print("Loaded " .. #users .. " user(s)!")
    end)
end)
