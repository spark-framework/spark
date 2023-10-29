local URL =
    "https://pastebin.com/raw/JuV2wzZ6"

--- @return number?
function Spark:getVersion()
    return tonumber(GetResourceMetadata(GetCurrentResourceName(), 'version', 0))
end

--- @return number | nil
function Spark:getNewestVersion()
    local text, status = self:perform(URL, 'GET')
    if status == 200 then
        return tonumber(text)
    end
end