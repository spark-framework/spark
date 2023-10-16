local Config = Spark:Config('Survival')
Spark.Survival = {
    Dead = false,
    Left = 30,
}

--- Revive command (debugging)
RegisterCommand('revive', function()
    Spark.Survival:Revive(true)
end, false)

--- Begin the death timer
function Spark.Survival:Start()
    Spark.Survival.Dead = true
    Spark.Survival.Left = Config.Time -- restart time

    StartScreenEffect(Config.Effect, 0, false) -- start the death screen effect

    CreateThread(function()
        while Spark.Survival.Left > 0 and Spark.Survival.Dead do -- while the player is death and the time is over 0
            Wait(5)
            Spark.Player:DrawText2Ds("You can respawn in ~r~".. Spark.Survival.Left .."~w~ seconds")
            Spark.Player:Invincible(true)
        end

        Spark.Survival:Respawn() -- respawn the user if the time has ran out
    end)
end

--- Revive the player
--- @param health boolean | nil
function Spark.Survival:Revive(health)
    local coords = Spark.Player.Position:Get()
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, 0.0, true, false)

    AnimpostfxStop('DeathFailOut') -- Stop screen effect

    Spark.Survival.Dead = false

    Spark.Player:Blood()
    Spark.Player:Invincible(false)
    Spark.Player.Heading:Set(0.0)

    if health or health == nil then
        Spark.Player.Health:Set(Spark.Player.Health:Max())
    end
end

--- Respawn the player (remove weapons, etc)
function Spark.Survival:Respawn()
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
    while Spark.Survival.Left > 0 and Spark.Survival.Dead do
        Wait(1000)
        Spark.Survival.Left = Spark.Survival.Left - 1 -- remove 1 second
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsPlayerActive(PlayerId()) then -- is player active
            if not IsPedFatallyInjured(PlayerPedId()) then
                Spark.Survival.Dead = false -- set that the user is not dead
            else
                if not Spark.Survival.Dead then -- if the player is not dead, start timer
                    Spark.Survival:Start()
                end
            end
        end
    end
end)