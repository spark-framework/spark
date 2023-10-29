--- @param name string
--- @return any
function Spark:getConfig(name)
    return self:getFile(GetCurrentResourceName(), 'cfg/' .. name .. '.lua')
end