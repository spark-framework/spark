Spark:Callback('Spark:Update', function(data) -- Update user-data, with original delays
    local player = PlayerPedId()

    if data.customization then
        Spark.Player.Customization:Set(data.customization)
    end

    if data.weapons then
        Spark.Player.Weapons:Set(data.weapons)
    end

    if data.health then
        SetEntityHealth(player, data.health)
    end

    if data.notification then
        Spark.Player:Notification(data.notification)
    end
end)

Spark:Callback('Spark:State', function() -- Get state-data from the client
    return {
        weapons = Spark.Player.Weapons:Get(),
        customization = Spark.Player.Customization:Get()
    }
end)