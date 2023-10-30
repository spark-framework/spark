local URL =
    "https://pastebin.com/raw/JuV2wzZ6"

--- @return number?
function Spark:getVersion()
    return tonumber(GetResourceMetadata(GetCurrentResourceName(), 'version', 0))
end

--- @return number
function Spark:getNewestVersion()
    local text, status = self:perform(URL, 'GET')
    return status == 200 and tonumber(text) or 1.0
end