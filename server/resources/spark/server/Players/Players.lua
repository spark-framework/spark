Spark.Players = {
    Players = {},
    Raw = {},

    Default = {}
}

--- Event when a user has connected.
--- @param source number
--- @param def table
function Spark.Players:playerConnecting(source, def)
    local steam = Spark.Source:Steam(source)

    def.defer()
    Wait(0)

    -- Check if the steam identifier is valid
    if not steam then
        return def.done('Cannot find your steam')
    end

    -- Check if the user is already cached, if this occurs- there is an error in Spark.
    if self.Players[steam] then
        return def.done('You are already registered?')
    end

    -- Register/or gets data from the database
    local data = self:Authenticate(steam)
    if not data?.id then
        return def.done("Error while returning your data, please report this.")
    end

    -- Let the player join the server
    print("User joined id " .. data.id .. " steam " .. steam .. " source " .. source)

    def.done()
end

--- Event when a user has spawned.
--- @param source number
function Spark.Players:playerSpawned(source)
    local steam = Spark.Source:Steam(source)
    local player = self.Players[steam]

    if not player then -- Checks if the user is registered.
        return print("Player is not registered when spawned?")
    end

    print("Player " .. player.id .. " has spawned!")
    player.source = source -- Update the source of the user, on spawn
end

--- Event when a user has been dropped.
--- @param source number
--- @param reason string
function Spark.Players:playerDropped(source, reason)
    local steam = Spark.Source:Steam(source)

    local data = self.Players[steam]
    if not data then -- Checks if the user is registered.
        return print("Player is not registered when dropped?")
    end

    print("User left! Steam " .. steam .. " id " .. data.id .. " source " .. source .. " reason " .. reason)
    print("Data: " .. json.encode(data.data))

    self.Raw:Dump(steam, data.data)
    self.Players[steam] = nil
end

--- Create/ or retrive data from the database
--- @param steam string
--- @return table
function Spark.Players:Authenticate(steam)
    local data = self.Raw:Pull('steam', steam)

    if not data then -- If the user is not registered, it will create a account for the person
        if Spark.Driver:Execute('INSERT INTO users (steam) VALUES (?)', steam) == 1 then
            data = {
                id = self.Raw:Pull('steam', steam).id,
                steam = steam
            }
        end
    end

    data.data = data.data or json.encode(self.Default)

    self.Players[steam] = {
        id = data.id,
        data = json.decode(data.data),
    }

    return data
end

--- Get a user's data directly from the database.
--- @param method string
--- @param value any
--- @return table
function Spark.Players.Raw:Pull(method, value)
    return Spark.Driver:Query('SELECT * FROM users WHERE ' .. method .. ' = ?', value)[1]
end

--- Get a user's data.data directly from the database.
--- @param method string
--- @param value any
--- @return table
function Spark.Players.Raw:Data(steam)
    local data = self:Pull('steam', steam)
    return not data and false or json.decode(data.data or "{}")
end

--- Dump a user's data directly to the database.
--- @param steam string
--- @param data table
--- @return number
function Spark.Players.Raw:Dump(steam, data)
    return Spark.Driver:Execute('UPDATE users SET data = ? WHERE steam = ?', json.encode(
        data,
        { indent = true }
    ), steam)
end

--- Convert a id to a steam
--- @param id number
--- @return string | nil
function Spark.Players.Raw:Convert(id)
    for k,v in pairs(Spark.Players.Players) do
        if v.id == id then
            return k
        end
    end
end

--- Attach the event to the connecting function.
AddEventHandler('playerConnecting', function(_, __, def)
    local source = source
    Spark.Players:playerConnecting(source, def)
end)

--- Attach the event to the connecting function.
RegisterNetEvent('playerSpawned', function()
    local source = source
    Spark.Players:playerSpawned(source)
end)

--- Attach the event to the connecting function.
AddEventHandler('playerDropped', function(reason)
    local source = source
    Spark.Players:playerDropped(source, reason)
end)

RegisterCommand('connect', function()
    Spark.Players:playerConnecting(0, {
        defer = function() end,
        update = function() end,
        done = function(text) end,
    })
end, false)

RegisterCommand('spawn', function()
    Spark.Players:playerSpawned(0)
end, false)

RegisterCommand('object', function()
    local player = Spark.Players:Get("source", 0)
    print("ID " .. player.Get:ID() .. " Steam " .. player.Get:Steam() .. " Source " .. player.Get:Source())
end, false)

RegisterCommand('data', function(_, args)
    local player = Spark.Players:Get("steam", "tewstOMG")
    if args[1] == "set" then
        player.Data:Set(args[2], args[3])
        print("Set " .. args[2] .. " to " .. args[3])
    else
        print(player.Data:Get(args[2]))
    end
end, false)

RegisterCommand('drop', function()
    Spark.Players:playerDropped(0, 'Kicked')
end, false)