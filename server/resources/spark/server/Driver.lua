Spark.Driver = {}

--- @param callback function
function Spark.Driver:Ready(callback) end

--- @param query string
function Spark.Driver:Execute(query, ...) end

--- @param query string
function Spark.Driver:Query(query, ...) end

Spark.Driver = Spark.Files:Get(
    GetCurrentResourceName(),
    'server/Drivers/' .. Spark:Config('Driver') .. '.lua'
)