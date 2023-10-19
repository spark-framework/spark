local Config = Spark:Config('Survival')
Spark.Survival = {
    Dead = false,
    Left = 0,
    Token = false -- respawn token
}

--- Revive command (debugging)
RegisterCommand('revive', function()
    Spark.Survival:Revive(true)
end, false)

function Spark.Survival:Start() -- start the death timer
    Spark.Survival.Dead = true
    Spark.Survival.Left = Config.Time -- restart time
    Spark.Survival.Token = false

    StartScreenEffect(Config.Effect, 0, false) -- start the death screen effect

    CreateThread(function()
        Spark.Player:Invincible(true)
        while Spark.Survival.Left > 0 and Spark.Survival.Dead do -- while the player is death and the time is over 0
            Wait(5)
            Spark.Player:DrawText2Ds("You can respawn in ~r~".. Spark.Survival.Left .."~w~ seconds")
        end

        if not Spark.Survival.Token then
            Spark.Survival:Respawn() -- respawn the user if the time has ran out
        else
            Spark.Survival.Token = false
        end
    end)
end

--- @param health boolean | nil
function Spark.Survival:Revive(health)
    local coords = Spark.Player.Position:Get()
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, 0.0, true, false)

    AnimpostfxStop('DeathFailOut') -- Stop screen effect

    Spark.Survival.Dead = false
    Spark.Survival.Left = 0
    Spark.Survival.Token = true

    Spark.Player:Blood()
    Spark.Player:Invincible(false)
    Spark.Player.Heading:Set(0.0)

    if health or health == nil then
        Spark.Player.Health:Set(Spark.Player.Health:Max())
    end
end

function Spark.Survival:Respawn() -- respawn the player
    CreateThread(function()
		DoScreenFadeOut(1000) -- fade out screen

        repeat Wait(25) until IsScreenFadedOut()
        TriggerServerEvent('playerSpawned') -- notify the server that we have respawned

        Wait(1500)

        self:Revive(false) -- revive/reset the user user
		DoScreenFadeIn(1000)
	end)
end

CreateThread(function() -- timer clicking down
    while true do
        Wait(1000)

        if Spark.Survival.Left > 0 and Spark.Survival.Dead then
            Spark.Survival.Left = Spark.Survival.Left - 1 -- remove 1 second
        end
    end
end)

CreateThread(function() -- disable health regen
    while true do
        Wait(100)
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0)
    end
end)

CreateThread(function()
    while true do
        Wait(100)
        if NetworkIsPlayerActive(PlayerId()) then -- is player active
            if not IsPedFatallyInjured(PlayerPedId()) and Spark.Survival.Left == 0 then
                Spark.Survival.Dead = false -- set that the user is not dead
            else
                if not Spark.Survival.Dead then -- if the player is not dead, start timer
                    Spark.Survival:Start()
                end
            end
        end
    end
end)