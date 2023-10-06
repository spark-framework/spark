Spark.Players = {
    Players = {},
    Raw = {},
    
    Default = {}
}

function Spark.Players:playerConnecting(source, def)
    local steam = Spark.Source:Steam(source)

    def.defer()
    Wait(0)

    if not steam then
        return def.done('Cannot find your steam')
    end

    if self.Players[steam] then
        return def.done('You are already registered?')
    end

    local data = self:Authenticate(steam)

    if not data?.id then
        return def.done("Error while returning your data, please report this.")
    end

    def.update('You are now logged in! ID: ' .. data.id)
    print("User joined id " .. data.id .. " steam " .. steam .. " source " .. source)

    Wait(0)
    def.done()
end

function Spark.Players:playerSpawned(source)
    local steam = Spark.Source:Steam(source)
    local player = self.Players[steam]

    if not player then
        return print("Player is not registered when spawned?")
    end

    player.source = source
end

function Spark.Players:playerDropped(source, reason)
    local steam = Spark.Source:Steam(source)

    local data = self.Players[steam]
    if not data then
        return print("Player is not registered when dropped?")
    end

    print("User left! Steam " .. steam .. " id " .. data.id .. " source " .. source .. " reason " .. reason)

    data.data = {}

    self.Raw:Dump(steam, data.data)
    self.Players[steam] = nil
end

function Spark.Players:Authenticate(steam)
    local data = self.Raw:Pull('steam', steam)

    if not data then
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

function Spark.Players.Raw:Pull(method, value)
    return Spark.Driver:Query('SELECT * FROM users WHERE ' .. method .. ' = ?', value)[1]
end

function Spark.Players.Raw:Dump(steam, data)
    return Spark.Driver:Execute('UPDATE users SET data = ? WHERE steam = ?', json.encode(
        data,
        { indent = true }
    ), steam)
end

function Spark.Players.Raw:Convert(id)
    for k,v in pairs(Spark.Players.Players) do
        if v.id == id then
            return k
        end
    end
end

AddEventHandler('playerConnecting', function(_, __, def)
    local source = source
    Spark.Players:playerConnecting(source, def)
end)

RegisterNetEvent('playerSpawned', function()
    local source = source
    Spark.Players:playerSpawned(source)
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    Spark.Players:playerDropped(source, reason)
end)

RegisterCommand('debug', function(source)
    Spark.Players:playerConnecting(source, {
        defer = function ()
            print("DEFERED")
        end,
        update = function (text)
            print("UPDATE " .. text)
        end,
        done = function (text)
            print("DONE " .. (text or ""))
        end,
    })

    Wait(1000)
    Spark.Players:playerSpawned(0)

    Wait(1000)
    Spark.Players:playerDropped(0, 'Kicked')
end, false)