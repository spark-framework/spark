Spark.Driver = {} -- This is only for intellisense

--- @param callback function
function Spark.Driver:Ready(callback) end

--- @param query string
--- @return number
function Spark.Driver:Execute(query, ...) return 0 end

--- @param query string
--- @return table
function Spark.Driver:Query(query, ...) return {} end

Spark.Driver = Spark:Files(
    GetCurrentResourceName(),
    'server/Drivers/' .. Spark:Config('Driver') .. '.lua'
)