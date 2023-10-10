Spark.Server = {
    CurrentId = 0
}

--- Trigger a server event
--- @param name string
function Spark.Server:Event(name, ...)
    return TriggerServerEvent(name, ...)
end

--- Trigger a server callback
--- @param name string
--- @return any
function Spark.Server:Callback(name, ...)
    local promise = promise.new()
    local id = self.CurrentId + 1
    RegisterNetEvent('Spark:Callbacks:Client:Response:'.. name .. ':' .. id, function(response)
        promise:resolve(response)
    end)

    self.CurrentId = self.CurrentId + 1
    self:Event('Spark:Callbacks:Server:Run:' .. name, id, ...)

    return Citizen.Await(promise)
end