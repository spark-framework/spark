local Identifiers, Groups = {
    "steam",
    "source",
    "id"
}, Spark:Config('Groups')

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
            return Spark.Table:Clone(self:Raw().data)[key]
        else
            local user = Spark.Players.Raw:Data(steam)
            
            if not user then
                return print("user not found")
            end

            return user[key]
        end
    end

    --- @return number
    function player:ID()
        return id
    end

    --- @return string
    function player:Steam()
        return steam
    end

    function player:Source()
        return player.Data:Raw().source
    end

    --- @return number
    function player:Ped()
        return GetPlayerPed(self:Source() or 0)
    end

    --- Register the Is module
    player.Is = {}

    --- @return boolean
    function player.Is:Online() return player.Data:Raw() ~= nil end

    --- @return boolean
    function player.Is:Loaded() return(player.Data:Raw()?.spawns or 0) > 0 end

    --- @param reason string
    function player:Kick(reason)
        reason = reason or ''
        DropPlayer(self.Get:Source(), reason)
    end

    --- Register the Client module
    player.Client = {
        CurrentId = 0
    }

    --- @param name string
    function player.Client:Event(name, ...)
        return TriggerClientEvent(name, player:Source(), ...)
    end

    --- @param name string
    --- @return any
    function player.Client:Callback(name, ...)
        local promise = promise.new()
        local id = self.CurrentId + 1
        self.CurrentId = id

        RegisterNetEvent('Spark:Callbacks:Server:Response:'.. name .. ':' .. id, function(response)
            promise:resolve(response)
        end)

        self:Event('Spark:Callbacks:Client:Run:' .. name, id, ...)
        return Citizen.Await(promise)
    end

    --- Register the Weapons module
    player.Weapons = {}

    --- @param weapons table
    function player.Weapons:Set(weapons)
        player.Client:Callback('Spark:Update', {
            weapons = weapons
        })
    end

    --- @return table
    function player.Weapons:Get()
        return player.Client:Callback('Spark:State').weapons
    end

    --- Register the Customization module
    player.Customization = {}

    --- @param customization table
    function player.Customization:Set(customization)
        player.Client:Callback('Spark:Update', {
            customization = customization
        })
    end

    --- @return table
    function player.Customization:Get()
        return player.Client:Callback('Spark:State').customization
    end

    --- Register the Health module
    player.Health = {}

    --- @param health number
    function player.Health:Set(health)
        player.Client:Callback('Spark:Update', {
            health = health
        })
    end

    --- @return number
    function player.Health:Max()
        return GetEntityMaxHealth(player:Ped())
    end

    --- @return number
    function player.Health:Get()
        return GetEntityHealth(player:Ped())
    end

    --- Register the Position module
    player.Position = {}

    --- @param coords vector3
    function player.Position:Set(coords)
        SetEntityCoords(player:Ped(), coords.x, coords.y, coords.z, false, false, false, false)
    end

    --- @return vector3
    function player.Position:Get()
        return GetEntityCoords(player:Ped())
    end

    --- Register the Ban module
    player.Ban = {}

    --- @param value boolean
    --- @param reason? string
    --- @return boolean
    function player.Ban:Set(value, reason)
        if not value then
            return true, player.Data:Set('Banned', nil)
        end

        player.Data:Set('Banned', reason)
        if player.Is:Online() then
            player:Kick('[Banned] ' .. reason)
        end

        return true
    end

    --- @return string | boolean
    function player.Ban:Reason()
        return player.Data:Get('Banned') or false
    end

    --- @return boolean
    function player.Ban:Is()
        return player.Data:Get('Banned') ~= nil
    end

    --- Register the Whitelist module
    player.Whitelist = {}

    --- @param value boolean
    function player.Whitelist:Set(value)
        return player.Data:Set('Whitelisted', value)
    end

    --- @return boolean
    function player.Whitelist:Is()
        return player.Data:Get('Whitelisted') ~= nil
    end

    --- @param text string
    function player:Notification(text)
        player.Client:Callback('Spark:Update', {
            notification = text
        })
    end

    player.Groups = {}

    --- @return table
    function player.Groups:Get()
        return player.Data:Get('Groups')
    end

    --- @param group string
    --- @return boolean
    function player.Groups:Add(group)
        local groups = self:Get()
        if self:Has(group) or not Groups[group] then -- if the user already has the group
            return false
        end

        table.insert(groups, group)
        player.Data:Set('Groups', groups)

        TriggerEvent('Spark:Player:Group:Add', steam, group) -- run event

        return true
    end

    --- @param permission string | table
    --- @return boolean
    function player.Groups:Permission(permission)
        for _, v in pairs(Groups) do
            for _, perm in pairs(type(permission) == "table" and permission or {permission}) do
                if not Spark.Table:Contains(v.permissions, perm) then
                    return false
                end
            end
        end

        return true
    end

    --- @param group string
    --- @return string
    function player.Groups:Has(group)
        return Spark.Table:Contains(self:Get(), group)
    end

    --- @param group string
    --- @return boolean
    function player.Groups:Remove(group)
        local groups = self:Get()
        if not self:Has(group) then -- if the user does not have the group
            return false
        end

        for i, v in pairs(groups) do -- find and remove the group
            if v == group then
                table.remove(groups, i)
            end
        end

        player.Data:Set('Groups', groups)
        TriggerEvent('Spark:Player:Group:Remove', steam, group) -- run event

        return true
    end

    player.Cash = {}

    --- @return number
    function player.Cash:Get()
        return player.Data:Get('Cash')
    end

    --- @param cash number
    function player.Cash:Set(cash)
        player.Data:Set('Cash', cash)
    end

    --- @param cash number
    function player.Cash:Add(cash)
        self:Set(self:Get() + cash)
    end

    --- @param cash number
    --- @return boolean
    function player.Cash:Has(cash)
        return self:Get() >= cash
    end

    --- @param cash number
    function player.Cash:Remove(cash)
        if (self:Get() - cash) >= 0 then
            self:Set(self:Get() - cash)
        end
    end

    --- @param cash number
    --- @return boolean
    function player.Cash:Payment(cash)
        if (self:Get() - cash) < 0 then
            return false
        end

        return true, self:Set(self:Get() - cash)
    end

    return player
end