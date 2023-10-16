--- @param name string
--- @return any
function Spark:Config(name)
    return Spark:Files(GetCurrentResourceName(), 'cfg/' .. name .. '.lua')
end