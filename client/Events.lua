--- Tell the server that you spawned
AddEventHandler('playerSpawned', function()
    TriggerServerEvent('playerSpawned')
end)

--- Remove autospawn
AddEventHandler('onClientMapStart', function()
    Wait(2500)
	exports['spawnmanager']:setAutoSpawn(false)
end)