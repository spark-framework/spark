Players = {}
Default = Spark:getConfig('Player') -- default user data

--- @param source number?
--- @param def defferals
function Spark:playerConnecting(source, def)
    local steam = self:getSteamBySource(source)

    def.defer()
    Wait(0)

    if not steam then
        return def.done('Cannot find your steam')
    end

    -- Check if the user is already cached, if this occurs- there is an error in Spark.
    if Players[steam] then
        return def.done('You are already registered?')
    end

    -- Register/or gets data from the database
    local data = self:authenticateUser(steam, source)
    if not data?.id then
        return def.done("Error while returning your data, please report this.")
    end

    -- Let the player join the server
    print('Player joined! ID: ' .. data.id .. " Steam: " .. steam .. " Source: " .. source)
    --print("Data: " .. data.data)

    SetTimeout(5000, function()
        if not Players[steam]?.netid and steam ~= self:getDummySteam() then -- User has not been asigned a netid (cancelled or kicked)
            Players[steam] = nil
        end
    end)

    -- Give scripts a way to reject users
    Spark:triggerEvent('Connecting', self:getPlayer('steam', steam), def)
    Wait(0)

    def.done()
end

function Spark:playerJoining(source, netid)
    local steam = self:getSteamBySource(source)

    Players[steam].netid = netid -- update netid
end

function Spark:playerSpawned(source)
    local steam = self:getSteamBySource(source)
    local player = Players[steam]

    if not player then -- Checks if the user is registered.
        return print("Player is not registered when spawned?")
    end

    if player.spawns == 0 then
        print("Player " .. player.id .. " has spawned! Updating source")
        player.source = source -- Update the source of the user, on spawn 
    end

    player.spawns = player.spawns + 1

    Spark:triggerEvent('Spawned', self:getPlayer("steam", steam), player.spawns == 1)

    if source ~= 0 then
        TriggerClientEvent('Spark:Loaded', source)
    end
end

--- @param source number?
--- @param reason string
function Spark:playerDropped(source, reason)
    local steam = self:getSteamBySource(source)

    local data = Players[steam]
    if not data then -- Checks if the user is registered.
        return print("Player is not registered when dropped?")
    end

    Spark:triggerEvent('Dropped', self:getPlayer("steam", steam))

    print("User left! Steam " .. steam .. " id " .. data.id .. " source " .. source .. " reason " .. reason)
    --print("Data: " .. json.encode(data.data))

    data.data['__temp'] = nil -- remove temporary data

    self:dumpUser(steam, data.data)
    Players[steam] = nil
end

--- @param steam string
--- @return table
function Spark:authenticateUser(steam, source)
    local data = self:getRawDataByMethod('steam', steam)

    if not data then -- If the user is not registered, it will create a account for the person
        if Spark:execute('INSERT INTO users (steam) VALUES (?)', steam) == 1 then
            data = {
                id = self:getRawDataByMethod('steam', steam).id,
                steam = steam
            }
        end
    end

    data.data = json.decode(data.data or json.encode(Default))

    for k, v in pairs(Default) do -- incase of updates
        if data.data[k] == nil then
            data.data[k] = v
        end
    end

    Players[steam] = {
        id = data.id,
        data = data.data,
        source = source,
        spawns = 0
    }

    return data
end

function Spark:getRawPlayers()
    return Players
end

--- @return player[]
function Spark:getPlayers()
    local players = {}
    for steam in pairs(Players) do
        local player = self:getPlayer("steam", steam)
        if player then
            table.insert(players, player)
        end
    end

    return players
end

--- @param method string
--- @param value any
--- @return table
function Spark:getRawDataByMethod(method, value)
    return Spark:query('SELECT * FROM users WHERE ' .. method .. ' = ?', value)[1]
end

--- @param steam string
--- @return table
function Spark:getRawDataBySteam(steam)
    local data = self:getRawDataByMethod('steam', steam)
    return not data and false or json.decode(data.data or "{}")
end

--- @param steam string
--- @param data table
function Spark:dumpUser(steam, data)
    return Spark:execute('UPDATE users SET data = ? WHERE steam = ?', json.encode(data), steam)
end

--- @param id number
--- @return string | nil
function Spark:getSteamById(id)
    for k,v in pairs(Players) do
        if v.id == id then
            return k
        end
    end
end

--- Attach the event to the connecting function.
AddEventHandler('playerConnecting', function(_, __, def)
    local source = source
    Spark:playerConnecting(source, def)
end)

AddEventHandler('playerJoining', function(old)
    local source = source
    Spark:playerJoining(old, source)
end)

--- Attach the event to the connecting function.
RegisterNetEvent('playerSpawned', function()
    local source = source
    Spark:playerSpawned(source)
end)

--- Attach the event to the connecting function.
AddEventHandler('playerDropped', function(reason)
    local source = source
    Spark:playerDropped(source, reason)
end)
