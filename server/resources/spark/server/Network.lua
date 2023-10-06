Spark.Network = {}

--- Perform a HTTP requests, using promsies instead of callbacks.
--- @param url string
--- @param method "GET" | "POST" | "PUT" | "PATCH" | "DELETE"
--- @param data? string
--- @param headers? table
--- @return string, boolean
function Spark.Network:HTTP(url, method, data, headers)
    local promise = promise.new()

    PerformHttpRequest(url, function(err, data)
        promise:resolve({data, err})
    end, method, data or '', headers or {})

    local result = Citizen.Await(promise)
    return result[1], result[2]
end

function Spark.Network:WebSocket()
    return error('WebSocket is not yet supported.')
end