---@diagnostic disable: duplicate-set-field

--- @param name string
--- @param callback function
function Spark:createCallback(name, callback)
    local allowed = true
    Spark:onResourceStop(GetInvokingResource(), function ()
        allowed = false
    end)

    RegisterNetEvent('Spark:Callbacks:Server:Run:' .. name, function(id, ...)
        local source = source
        if not allowed then
            return
        end

        TriggerClientEvent('Spark:Callbacks:Client:Response:' .. name .. ':' .. id,
            source,
            callback(Spark:getPlayer('source', source), table.unpack(...))
        )
    end)
end