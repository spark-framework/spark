local Groups, Server, Jobs =
    Spark:getConfig('Groups'),
    Spark:getConfig('Server'),
    Spark:getConfig('Jobs')

--- @param player player
--- @param def defferals
Spark:listenEvent('Connecting', function(player, def)
    if player:isBanned() then -- Is user banned
        return def.done('You are banned!')
    end

    if not player:isWhitelisted() and Server.Whitelisted then -- Is server whitelisted and user is not
        return def.done('You are not whitelisted!')
    end
end)

--- @param player player
--- @param first boolean
Spark:listenEvent('Spawned', function(player, first)
    local coords = player:getData('Coords')

    if first then
        player:notification('Welcome to the server! Use F9 to open the main menu')
        player:setPosition(coords)

        player:setCustomization(player:getData('Customization')) -- set the player's skin
        player:setWeapons(player:getData('Weapons')) -- set the player's weapon

        player:setHealth(player:getData('Health')) -- set the player's health

        for _, group in pairs(player:getData('Groups')) do
            Spark:triggerEvent('AddGroup', player, group) -- TODO: fix this
        end

        Spark:triggerEvent('SetJob', player, player:getJob())

        CreateThread(function() -- save weapons
            while true do
                if not player:isLoaded() then
                    return
                end

                local data = player:triggerCallback('Spark:State')

                player:setData('Customization', data.customization)
                player:setData('Weapons', data.weapons)

                Wait(5 * 1000) -- 5 seconds
            end
        end)

        CreateThread(function()
            while true do
                if not player:isLoaded() then
                    return
                end

                local user = player:getJob()
                local data = Jobs[user.name]

                local job = data.grades and data.grades[user.grade] or data

                if user.time == 0 then -- pay user
                    user.time = job.time + 1000
                    player:addCash(job.paycheck)

                    data.events.paycheck(player, job.paycheck)
                end

                user.time = (user.time or job.time) - 1000
                player:setData('Job', user)

                Wait(1000)
            end
        end)
    else -- if the user died and spawned again
        coords = Default.Coords
        player:setPosition(coords)

        player:setCustomization(player:getData('Customization'))
        -- player:setHealth(player:getMaxHealth()) client handles this

        player:setWeapons({})
        player:setData('Weapons', {})
        player:setData('Attachments', {})
    end
end)

--- @param player player
--- @param job job
Spark:listenEvent('SetJob', function(player, job)
    local events = Jobs[job.name].events
    if events.recieved then
        events.recieved(player, job)
    end
end)

--- @param player player
--- @param group string
Spark:listenEvent('AddGroup', function(player, group)
    local events = Groups[group].events
    if events.spawn then
        events.spawn(player)
    end
end)

--- @param player player
--- @param group string
Spark:listenEvent('RemoveGroup', function(player, group)
    local events = Groups[group].events
    if events.remove then
        events.remove(player)
    end
end)

--- @param player player
Spark:listenEvent('Dropped', function(player)
    local coords = player:getPosition()

    player:setData('Coords', {x = coords.x, y = coords.y, z = coords.z})
    player:setData('Health', player:getHealth())
end)