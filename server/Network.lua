--- @param url string
--- @param method "GET" | "POST" | "PUT" | "PATCH" | "DELETE"
--- @param data? string
--- @param headers? table
--- @return string, boolean
function Spark:perform(url, method, data, headers)
    local promise = promise.new()

    PerformHttpRequest(url, function(err, data)
        promise:resolve({data, err})
    end, method, data or '', headers or {})

    local result = Citizen.Await(promise)
    return result[1], result[2]
end