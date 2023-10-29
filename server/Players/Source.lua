---@diagnostic disable: redundant-return-value
local Dummy = 'tewstOMG'

function Spark:getDummySteam()
    return Dummy
end

--- @param source number?
--- @return string
function Spark:getSteamBySource(source)
    if not source or source == 0 then
        return Dummy
    end

    for _, v in pairs(GetPlayerIdentifiers(source) or {}) do
        if v:find('steam:') then
            return v:gsub('steam:', '')
        end
    end

    return Dummy
end