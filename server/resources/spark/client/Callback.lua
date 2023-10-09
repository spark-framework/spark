---@diagnostic disable: duplicate-set-field

-- TODO: make run function for client-server callback

function Spark:Callback(name, callback)
    RegisterNetEvent('Spark:Callbacks:Client:Run:' .. name, function(args)
        TriggerServerEvent('Spark:Callbacks:Server:Response:' .. name,
            callback(table.unpack(args or {}))
        )
    end)
end

Spark:Callback('FarmandUwU', function()
    return "Farmand"
end)