--- @diagnostic disable: duplicate-set-field

--- @param name string
--- @param callback function
function Spark:Callback(name, callback)
    RegisterNetEvent('Spark:Callbacks:Client:Run:' .. name, function(id, ...)
        TriggerServerEvent('Spark:Callbacks:Server:Response:' .. name .. ":" .. id,
            callback(...)
        )
    end)
end