Spark.Death = {
    Dead = false,
    Hold = 100,
    Left = 30
}

AddEventHandler('onClientMapStart', function()
    Wait(2500)
	exports['spawnmanager']:setAutoSpawn(false)
end)

--- Check if the user should be dead
function Spark.Death:Check()
    if NetworkIsPlayerActive(PlayerId()) then
        if not IsPedFatallyInjured(PlayerPedId()) then
            Spark.Death.Dead = false
        else
            if not Spark.Death.Dead then
                Spark.Death:Timer()
            end
        end
    end
end

--- Begin the death timer
function Spark.Death:Timer()
    Spark.Death.Dead = true
    Spark.Death.Left = 30

    CreateThread(function() -- timer clicking down
        while Spark.Death.Left > 0 and Spark.Death.Dead do
            Wait(1000)
            Spark.Death.Left = Spark.Death.Left - 1
        end
    end)

    StartScreenEffect("DeathFailOut", 0, false)

    CreateThread(function()
        while Spark.Death.Left > 0 and Spark.Death.Dead do
            Wait(5)
            Spark.Player:DrawText2Ds("You can respawn in ~r~".. Spark.Death.Left .."~w~ seconds")

            SetPlayerInvincible(PlayerPedId(), true)

            if Spark.Death.Left == 0 then
                break
            end
        end

        Spark.Death:Respawn()
    end)
end

function Spark.Death:Revive()
    local coords = GetEntityCoords(PlayerPedId())
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, 0.0, true, false)
    AnimpostfxStop('DeathFailOut')
    SetPlayerInvincible(PlayerPedId(), false)
    SetEntityHeading(PlayerPedId(), GetPedMaxHealth(PlayerPedId()))
    SetEntityHealth(PlayerPedId(), GetPedMaxHealth(PlayerPedId()))
end

function Spark.Death:Respawn()
    CreateThread(function()
		DoScreenFadeOut(1000)

        repeat Wait(25) until IsScreenFadedOut()
        Spark.Death.Dead = false

        NetworkResurrectLocalPlayer(0.0, 0.0, 0.0, 0.0, true, false)
        ClearPedBloodDamage(PlayerPedId())

        TriggerServerEvent('playerSpawned')

        Wait(1500)

        AnimpostfxStop('DeathFailOut')
        SetPlayerInvincible(PlayerPedId(), false)
        SetEntityHeading(PlayerPedId(), GetPedMaxHealth(PlayerPedId()))

		DoScreenFadeIn(1000)
	end)
end

RegisterCommand('revive', function()
    Spark.Death:Revive()
end, false)

CreateThread(function()
    while true do
        Wait(0)

        Spark.Death:Check()
    end
end)