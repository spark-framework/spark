local Player = Spark:getPlayer()

Spark:createCallback('Spark:Update', function(data) -- Update user-data, with original delays
    local player = PlayerPedId()
    for name, value in pairs(data) do
        print("Updating " .. name .. " to " .. tostring(value))
    end

    if data.customization then
        Player.Customization:Set(data.customization)
    end

    if data.weapons then
        Player.Weapons:Set(data.weapons)
    end

    if data.attachments then
        --Player.Weapons.Attachments:Set(data.attachments)
    end

    if data.health then
        SetEntityHealth(player, data.health)
    end

    if data.notification then
        Player:Notification(data.notification)
    end
end)

Spark:createCallback('Spark:State', function() -- Get state-data from the client
    return {
        weapons = Player.Weapons:Get(),
        customization = Player.Customization:Get(),
        --attachments = Player.Weapons.Attachments:Get()
    }
end)