local Driver = {}

function Driver:Ready(callback)
    while GetResourceState('oxmysql') ~= 'started' do
		Wait(50)
	end

    exports.oxmysql.awaitConnection()

    return callback and callback() or true
end

function Driver:Execute(query, ...)
    local args = type((...)) == "table" and ... or {...}
    local promise = promise.new()
    exports.oxmysql:update(query, args, function(row)
        promise:resolve(row or 0)
    end)

    return Citizen.Await(promise)
end

function Driver:Query(query, ...)
    local args = type((...)) == "table" and ... or {...}
    local promise = promise.new()
    exports.oxmysql:query(query, args, function(result)
        promise:resolve(result)
    end)

    return Citizen.Await(promise)
end

return Driver