--- @param table table
--- @param value any
--- @return boolean | any
function Spark:tableContains(table, value)
    for _, v in pairs(table) do
        if v == value then
            return v
        end
    end

    return false
end

--- @param table table
--- @return number
function Spark:tableEntries(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end

    return count
end

--- @param table table
--- @return table
function Spark:cloneTable(table)
    local result = {}
    for k, v in pairs(table) do
        result[k] = type(v) == "table" and self:cloneTable(v) or v
    end

    return result
end