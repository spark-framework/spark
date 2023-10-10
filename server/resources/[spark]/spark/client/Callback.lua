--- @diagnostic disable: duplicate-set-field
--- TODO: make run function for client-server callback

--- Create a callback with a name and callback
--- @param name string
--- @param callback function
function Spark:Callback(name, callback)
    RegisterNetEvent('Spark:Callbacks:Client:Run:' .. name, function(...)
        TriggerServerEvent('Spark:Callbacks:Server:Response:' .. name,
            callback(...)
        )
    end)
end