--- Get a configuration file by name
--- @param name string
--- @return any
function Spark:Config(name)
    return Spark.Files:Get(GetCurrentResourceName(), 'cfg/' .. name .. '.lua')
end