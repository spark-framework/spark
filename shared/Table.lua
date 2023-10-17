Spark.Table = {}

--- @param table table
--- @param value any
--- @return boolean | any
function Spark.Table:Contains(table, value)
    for _, v in pairs(table) do
        if v == value then
            return v
        end
    end

    return false
end

--- @param table table
--- @return number
function Spark.Table:Entries(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end

    return count
end

--- @param table table
--- @return table
function Spark.Table:Clone(table)
    local result = {}
    for k, v in pairs(table) do
        result[k] = type(v) == "table" and self:Clone(v) or v
    end

    return result
end