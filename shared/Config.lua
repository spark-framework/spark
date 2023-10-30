--- @param name string
--- @return any
function Spark:getConfig(name)
    return self:getFile(Spark:getSparkName(), 'cfg/' .. name .. '.lua')
end