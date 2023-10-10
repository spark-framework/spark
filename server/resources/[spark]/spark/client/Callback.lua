--- @diagnostic disable: duplicate-set-field
--- TODO: make run function for client-server callback

function Spark:Callback(name, callback)
    RegisterNetEvent('Spark:Callbacks:Client:Run:' .. name, function(...)
        TriggerServerEvent('Spark:Callbacks:Server:Response:' .. name,
            callback(...)
        )
    end)
end