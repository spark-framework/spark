local Player = Spark:getPlayer()

Spark:createCallback('Spark:Update', function(data) -- Update user-data, with original delays
    for name, value in pairs(data) do
        print("Updating " .. name .. " to " .. tostring(value))
    end

    if data.customization then
        Player:setCustomization(data.customization)
    end

    if data.weapons then
        Player:setWeapons(data.weapons)
    end

    if data.health then
        Player:setHealth(data.health)
    end

    if data.notification then
        Player:notification(data.notification)
    end
end)

Spark:createCallback('Spark:State', function() -- Get state-data from the client
    return {
        weapons = Player:getWeapons(),
        customization = Player:getCustomization(),
    }
end)