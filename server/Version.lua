Spark.Version = {
    URL = "https://pastebin.com/raw/JuV2wzZ6",
    Loaded = promise.new()
}

--- Get the current version Spark is running on.
--- @return number?
function Spark.Version:Get()
    return tonumber(GetResourceMetadata(GetCurrentResourceName(), 'version', 0))
end

--- Get the newest version of Spark.
--- @return number | nil
function Spark.Version:Newest()
    local text, status = Spark.Network:HTTP(self.URL, 'GET')
    if status == 200 then
        return tonumber(text)
    end
end

print(Spark.Version:Get() == Spark.Version:Newest()
    and "Spark is up-to-date"
    or "Spark is out-of-date. Please download the newest version")

Spark.Version.Loaded:resolve()