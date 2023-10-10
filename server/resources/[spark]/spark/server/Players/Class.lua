local Identifiers = {
    "steam",
    "source",
    "id"
}

local CurrentId = 0

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

    --- Get the user's ban reason, will return false if not banned.
    --- @return string | boolean
    function player.Get:Ban() return player.Data:Get('Banned') or false end

    --- Get the user's id, this can be accessed immediately
    function player.Get:ID() return id end

    --- Get the user's steam, this can be accessed immediately
    --- @return string
    function player.Get:Steam() return steam end

    --- Get the user's source, this can only be accessed after the player has spawned
    function player.Get:Source() return player.Data:Raw().source end

    --- Get the user's ped, this can only be accessed after the player has spawned
    --- @return number
    function player.Get:Ped() return GetPlayerPed(self:Source() or 0) end

    --- Get the user's health, this can only be accessed after the player has spawned
    --- @return number
    function player.Get:Health() return GetEntityHealth(self:Ped()) end

    --- Get the position of the player - only after ped is set
    --- @return vector3
    function player.Get:Position() return GetEntityCoords(self:Ped()) end
    
    --- Get the player's max health
    --- @return number
    function player.Get:Max() return GetEntityMaxHealth(self:Ped()) end

    --- Register the Is module
    player.Is = {}

    --- Check if the user is online
    --- @return boolean
    function player.Is:Online() return player.Data:Raw() ~= nil end

    --- Check if the user is banned
    --- @return boolean
    function player.Is:Banned() return player.Data:Get('Banned') ~= nil end

    --- Check if the user is whitelisted
    --- @return boolean
    function player.Is:Whitelisted() return player.Data:Get('Whitelisted') or false end

    --- Check if the user is currently loaded in (has a source)
    --- @return boolean
    function player.Is:Loaded() return(player.Data:Raw()?.spawns or 0) > 0 end

    --- Kick the current user
    --- @param reason string
    function player:Kick(reason)
        reason = reason or ''
        DropPlayer(self.Get:Source(), reason)
    end

    --- Register the Set module
    player.Set = {}

    --- Set the banned value of a player
    --- @param value boolean
    --- @param reason? string
    --- @return boolean
    function player.Set:Banned(value, reason)
        if not value then
            return true, player.Data:Set('Banned', nil)
        end

        player.Data:Set('Banned', reason)
        if player.Is:Online() then
            player:Kick('[Banned] ' .. reason)
        end

        return true
    end

    --- Set the whitelisted value of a player
    --- @param value boolean
    function player.Set:Whitelisted(value)
        return player.Data:Set('Whitelisted', value)
    end

    --- Set the position of the user
    --- @param x number
    --- @param y number
    --- @param z number
    function player.Set:Position(x, y, z)
        SetEntityCoords(player.Get:Ped(), x, y, z, false, false, false, false)
    end

    --- Set the health of the user
    --- @param health number
    function player.Set:Health(health)
        player.Client:Callback('Spark:Update', {
            health = health
        })
    end

    --- Set the customization of the player
    --- @param customization table
    function player.Set:Customization(customization)
        player.Client:Callback('Spark:Update', {
            customization = customization
        })
    end

    --- Set the weapons of the player
    --- @param weapons table
    function player.Set:Weapons(weapons)
        player.Client:Callback('Spark:Update', {
            weapons = weapons
        })
    end

    --- Register the Client module
    player.Client = {}

    --- Trigger an client event
    --- @param name string
    function player.Client:Event(name, ...)
        return TriggerClientEvent(name, player.Get:Source(), ...)
    end

    --- Trigger an callback
    --- @param name string
    --- @return any
    function player.Client:Callback(name, ...)
        local promise = promise.new()
        local id = CurrentId + 1
        RegisterNetEvent('Spark:Callbacks:Server:Response:'.. name .. ':' .. id, function(response)
            promise:resolve(response)
        end)

        CurrentId = CurrentId + 1
        self:Event('Spark:Callbacks:Client:Run:' .. name, id, ...)
        return Citizen.Await(promise)
    end

    return player
end