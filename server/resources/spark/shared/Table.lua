Spark.Table = {}

--- Check if a table contains a value
--- @param table table
--- @param value any
--- @return boolean
function Spark.Table:Contains(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end

    return false
end