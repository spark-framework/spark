local Config = Spark:getConfig('Survival')
local Player = Spark:getPlayer()

local Dead, Left, Token = false, 0, false

--- Revive command (debugging)
RegisterCommand('revive', function()
    Spark:revivePlayer()
end, false)

function Spark:startDeathTimer() -- start the death timer
    Dead, Left, Token = true, Config.Time, false

    StartScreenEffect(Config.Effect, 0, false) -- start the death screen effect

    CreateThread(function()
        Player:setInvincible(true)
        while Left > 0 and Dead do -- while the player is death and the time is over 0
            Wait(5)
            Player:drawText2Ds("You can respawn in ~r~".. Left .."~w~ seconds")
        end

        print(Token)
        if not Token then
            Spark:respawnPlayer() -- respawn the user if the time has ran out
        else
            Token = false
        end
    end)
end

function Spark:revivePlayer()
    local coords = Player:getPosition()
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, 0.0, true, false)

    AnimpostfxStop('DeathFailOut') -- Stop screen effect

    Dead, Left, Token = false, 0, true

    Player:clearBlood()
    Player:setInvincible(false)
    Player:setHealth(0.0)
end

function Spark:respawnPlayer() -- respawn the player
    CreateThread(function()
		DoScreenFadeOut(1000) -- fade out screen

        repeat Wait(25) until IsScreenFadedOut()
        TriggerServerEvent('playerSpawned') -- notify the server that we have respawned

        Wait(1500)

        self:revivePlayer() -- revive/reset the user user
        DoScreenFadeIn(1000)

        Wait(1000)
        Token = false
	end)
end

CreateThread(function() -- timer clicking down
    while true do
        Wait(1000)

        if Left > 0 and Dead then
            Left = Left - 1 -- remove 1 second
        end
    end
end)

CreateThread(function() -- disable health regen
    while true do
        Wait(100)
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0)
    end
end)

CreateThread(function() -- disable health regen
    --[[ while true do
        Wait(100)
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0)

        if NetworkIsPlayerActive(PlayerId()) then -- is player active
            if not IsPedFatallyInjured(PlayerPedId()) and Left == 0 then
                Dead = false -- set that the user is not dead
            else
                if not Dead and not Token then -- if the player is not dead, start timer
                    print(Player:getHealth())
                    Spark:startDeathTimer()
                end
            end
        end
    end--]]
end)