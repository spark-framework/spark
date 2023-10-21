Spark.Version = {
    URL = "https://pastebin.com/raw/JuV2wzZ6"
}

--- @return number?
function Spark.Version:Get()
    return tonumber(GetResourceMetadata(GetCurrentResourceName(), 'version', 0))
end

--- @return number | nil
function Spark.Version:Newest()
    local text, status = Spark.Network:HTTP(self.URL, 'GET')
    if status == 200 then
        return tonumber(text)
    end
end