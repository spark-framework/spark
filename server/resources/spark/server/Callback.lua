---@diagnostic disable: duplicate-set-field
function Spark:Callback(name, callback)
    RegisterNetEvent('Spark:Callbacks:Server:Run:' .. name, function(args)
        local source = source

        TriggerClientEvent('Spark:Callbacks:Client:Response:' .. name,
            source,
            callback(Spark.Players:Get('source', source), table.unpack(args or {}))
        )
    end)
end