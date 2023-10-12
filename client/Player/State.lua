Spark:Callback('Spark:Update', function(data)
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
end)

Spark:Callback('Spark:State', function()
    return {
        weapons = Spark.Player.Weapons:Get(),
        customization = Spark.Player.Customization:Get()
    }
end)