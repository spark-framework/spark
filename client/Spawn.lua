--- Tell the server that you spawned
AddEventHandler('playerSpawned', function()
    TriggerServerEvent('playerSpawned')
end)