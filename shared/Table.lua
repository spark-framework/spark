--- @param list table
--- @param value any
--- @return boolean
function Spark:tableContains(list, value)
    for _, v in pairs(list) do
        if v == value then
            return true
        end
    end

    return false
end

--- @param list table
--- @return number
function Spark:tableEntries(list)
    local count = 0
    for _ in pairs(list) do
        count = count + 1
    end

    return count
end

--- @param list table
--- @return table
function Spark:cloneTable(list)
    local result = {}
    for k, v in pairs(list) do
        result[k] = type(v) == "table" and self:cloneTable(v) or v
    end

    return result
end