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

        local player = Spark:getPlayer('source', source)
        if player then
            TriggerClientEvent('Spark:Callbacks:Client:Response:' .. name .. ':' .. id,
                source,
                callback(player, table.unpack(...))
            )
        end
    end)
end