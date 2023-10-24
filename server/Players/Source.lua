---@diagnostic disable: redundant-return-value
Spark.Players.Source = {
    Dummy = 'tewstOMG'
}

--- @param source number?
--- @return string
function Spark.Players.Source:Steam(source)
    if not source or source == 0 then
        return self.Dummy
    end

    for _, v in pairs(GetPlayerIdentifiers(source) or {}) do
        if v:find('steam:') then
            return v:gsub('steam:', '')
        end
    end

    return self.Dummy
end