---@diagnostic disable: duplicate-set-field
function Spark:Callback(name, callback)
    RegisterNetEvent('Spark:Callbacks:Server:Run:' .. name, function(id, ...)
        local source = source

        TriggerClientEvent('Spark:Callbacks:Client:Response:' .. name .. ":" .. id,
            source,
            callback(Spark.Players:Get('source', source), table.unpack(...))
        )
    end)
end