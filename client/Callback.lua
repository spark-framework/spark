--- @diagnostic disable: duplicate-set-field

--- @param name string
--- @param callback function
function Spark:createCallback(name, callback)
    local allowed = true
    Spark:onResourceStop(GetInvokingResource(), function ()
        allowed = false
    end)

    RegisterNetEvent('Spark:Callbacks:Client:Run:' .. name, function(id, ...)
        if not allowed then
            return
        end

        print("Running " .. name)
        TriggerServerEvent('Spark:Callbacks:Server:Response:' .. name .. ":" .. id,
            callback(...)
        )
    end)
end