local Identifiers = {
    "steam",
    "source",
    "id"
}

--- Get a player by a method
--- @param method "steam" | "source" | "id"
--- @param value any
function Spark.Players:Get(method, value)
    if not Spark.Table:Contains(Identifiers, method) then
        return print("method not found")
    end

    local steam, id = value, nil
    if method == "id" then
        steam, id = self.Raw:Convert(value), value
    elseif method == "source" then
        steam = Spark.Source:Steam(value)
    end

    id = id or self.Players[steam]?.id
    if not self.Players[steam] then
        if method == "source" then
            return false, "user_does_not_exist"
        end

        local data = self.Raw:Pull(method, value)
        if not data then
            return false, "user_cannot_be_found"
        end

        id, steam = data.id, data.steam
    end

    local player = {}

    --- Register the Data module
    player.Data = {}

    --- Get the raw data of the user
    --- @return table
    function player.Data:Raw()
        return Spark.Players.Players[steam]
    end

    --- Set a key data of a user
    --- @param key string
    --- @param value any
    function player.Data:Set(key, value)
        if player.Is:Online() then   
            self:Raw().data[key] = value
        else
            local user = Spark.Players.Raw:Data(steam)
            if not user then
                return print("user not found")
            end

            user[key] = value
            Spark.Players.Raw:Dump(steam, user)
        end
    end

    --- Get a key from a user
    --- @param key string
    --- @return any
    function player.Data:Get(key)
        if player.Is:Online() then   
            return self:Raw().data[key]
        else
            local user = Spark.Players.Raw:Data(steam)
            if not user then
                return print("user not found")
            end

            return user[key]
        end
    end

    --- Register the Get module
    player.Get = {}

    --- Get the player's ID
    --- @return number
    function player.Get:ID() return id end

    --- Get the player's steam
    --- @return string
    function player.Get:Steam() return steam end

    --- Get the player's source (can only be accessed after spawning)
    --- @return number
    function player.Get:Source() return player.Data:Raw().source end

    --- Register the Is module
    player.Is = {}

    --- Is the user online
    --- @return boolean
    function player.Is:Online() return player.Data:Raw() ~= nil end

    return player
end

CreateThread(function()
    Spark.Players:Get('steam', 'tewstOMG')
end)