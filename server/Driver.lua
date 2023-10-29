--- @param callback function
function Spark:ready(callback) end

--- @param query string
--- @return number
function Spark:execute(query, ...) return 0 end

--- @param query string
--- @return table
function Spark:query(query, ...) return {} end

local driver = Spark:getFile(
    GetCurrentResourceName(),
    'server/Drivers/' .. Spark:getConfig('Driver') .. '.lua'
)

Spark.ready = driver.ready
Spark.execute = driver.execute
Spark.query = driver.query