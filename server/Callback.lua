---@diagnostic disable: duplicate-set-field

--- @param name string
--- @param callback function
function Spark:createCallback(name, callback)
    local resource, allowed = GetInvokingResource(), true
    AddEventHandler('onResourceStop', function(resourceName)
        if resourceName == resource then
            allowed = false
        end
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