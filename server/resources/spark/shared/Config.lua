function Spark:Config(name)
    return Spark.Files:Get(GetCurrentResourceName(), 'cfg/' .. name .. '.lua')
end