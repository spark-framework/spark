local Server = IsDuplicityVersion()

function Spark:Events(name, callback)
    RegisterNetEvent(name, function(source, ...)
        local response = callback(source, table.unpack(...))
        local isServer = source == 0

        
    end)
end