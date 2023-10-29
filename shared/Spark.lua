--- @class spark
Spark = setmetatable({}, {
    __newindex = function(self, key, func)
        rawset(self, key, func)
        exports(key, function(...)
            return Spark[key](self, ...)
        end)
    end
})