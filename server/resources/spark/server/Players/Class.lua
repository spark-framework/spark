local Identifiers = {
    "steam",
    "source",
    "id"
}

function Spark.Players:Get(method, value)
    if not Spark.Table:Contains(Identifiers, method) then
        return print("method not found")
    end

    local steam, id = value, nil
    if method == "id" then
        steam, id = self.Raw:Convert(value), value
    elseif identifier == "source" then
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

    return player
end

CreateThread(function()
    Spark.Players:Get('steam', 'tewstOMG')
end)