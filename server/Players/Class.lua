local Identifiers = {
    "steam",
    "source",
    "id"
}

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

    --- @return table
    function player.Data:Raw()
        return Spark.Players.Players[steam]
    end

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

    --- @return string | boolean
    function player.Get:Ban() return player.Data:Get('Banned') or false end

    function player.Get:ID() return id end

    --- @return string
    function player.Get:Steam() return steam end

    function player.Get:Source() return player.Data:Raw().source end

    --- @return number
    function player.Get:Ped() return GetPlayerPed(self:Source() or 0) end

    --- @return number
    function player.Get:Health() return GetEntityHealth(self:Ped()) end

    --- @return vector3
    function player.Get:Position() return GetEntityCoords(self:Ped()) end
    
    --- @return number
    function player.Get:Max() return GetEntityMaxHealth(self:Ped()) end

    --- Register the Is module
    player.Is = {}

    --- @return boolean
    function player.Is:Online() return player.Data:Raw() ~= nil end

    --- @return boolean
    function player.Is:Banned() return player.Data:Get('Banned') ~= nil end

    --- @return boolean
    function player.Is:Whitelisted() return player.Data:Get('Whitelisted') or false end

    --- @return boolean
    function player.Is:Loaded() return(player.Data:Raw()?.spawns or 0) > 0 end

    --- @param reason string
    function player:Kick(reason)
        reason = reason or ''
        DropPlayer(self.Get:Source(), reason)
    end

    --- Register the Set module
    player.Set = {}

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

    --- @param value boolean
    function player.Set:Whitelisted(value)
        return player.Data:Set('Whitelisted', value)
    end

    --- @param coords vector3
    function player.Set:Position(coords)
        SetEntityCoords(player.Get:Ped(), coords.x, coords.y, coords.z, false, false, false, false)
    end

    --- @param health number
    function player.Set:Health(health)
        player.Client:Callback('Spark:Update', {
            health = health
        })
    end

    --- @param customization table
    function player.Set:Customization(customization)
        player.Client:Callback('Spark:Update', {
            customization = customization
        })
    end

    --- @param weapons table
    function player.Set:Weapons(weapons)
        player.Client:Callback('Spark:Update', {
            weapons = weapons
        })
    end

    --- Register the Client module
    player.Client = {}

    --- @param name string
    function player.Client:Event(name, ...)
        return TriggerClientEvent(name, player.Get:Source(), ...)
    end

    --- @param name string
    --- @return any
    function player.Client:Callback(name, ...)
        local promise = promise.new()
        RegisterNetEvent('Spark:Callbacks:Server:Response:'.. name, function(response)
            promise:resolve(response)
        end)

        self:Event('Spark:Callbacks:Client:Run:' .. name, ...)
        return Citizen.Await(promise)
    end

    return player
end