--- @return string
function Spark:getSparkName()
    return GetCurrentResourceName()
end

--- @param resource string
--- @param callback fun()
function Spark:onResourceStop(resource, callback)
    AddEventHandler('onResourceStop', function(name)
        if name == resource then
            pcall(callback)
        end
    end)
end