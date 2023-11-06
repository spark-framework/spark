--- @param player player
function Spark:openMainMenu(player)
    local buttons = {}

    if player:hasGroup('admin') then -- admin menu
        table.insert(buttons, "Admin")
    end

    if player:hasGroup('developer') then -- developer menu
        table.insert(buttons, "Development")
    end

    if player:hasJob("police") then -- police job
        table.insert(buttons, "Police")
    end

    player:showMenu('Main Menu', buttons, function(button)
        player:closeMenu()
        if button == "Admin" then
            self:openAdminMenu(player)
        elseif button == "Development" then
            self:openDeveloperMenu(player)
        elseif button == "Police" then
            self:openPoliceMenu(player)
        end
    end, function ()
        player:closeMenu()
    end)
end

--- @param player player
function Spark:openAdminMenu(player)
    self:openPermissionMenu(player, 'Admin Menu', {
        {
            label = "Select Player",
            permission = "selectplayer",
            action = function()
                local target = Spark:askForPlayer(player)
                if not target then
                    return player:notification('Cannot find player!')
                end

                player:closeMenu()
                Spark:openPermissionMenu(player, 'Player (' .. target:getId() .. ')', {
                    {
                        label = "Give Cash",
                        permission = "givecash",
                        action = function()
                            player:showSurvey('Amount of cash', 32, function(result, text)
                                if result then
                                    target:addCash(tonumber(text) or 0)
                                    player:notification("You gave ID " .. target:getId() .. " " .. text .."$")
                                end
                            end)
                        end
                    },
                    {
                        label = "Remove Cash",
                        permission = "removecash",
                        action = function()
                            player:showSurvey('Amount of cash', 32, function(result, text)
                                if result then
                                    if target:getCash() >= tonumber(text) then
                                        return player:notification("ID " .. target:getId() .. ' dont have that kind of dough')
                                    end
    
                                    target:removeCash(tonumber(text) or 0)
                                    player:notification("You removed " .. text .."$ from ID " .. target:getId())
                                end
                            end)
                        end
                    },
                    {
                        label = target:isBanned() and 'Unban' or 'Ban',
                        permission = target:isBanned() and 'unban' or 'ban',
                        action = function()
                            if not target:isBanned() then
                                player:showSurvey('Reason of ban', 25, function(result, text)
                                    if result then
                                        target:setBanned(true, text)
                                        player:notification('You banned ID ' .. target:getId())
                                    end
                                end)
                            else
                                target:setBanned(false)
                                player:notification('You unbanned ID ' .. target:getId())
                            end
                        end
                    }
                }, function()
                    player:closeMenu()
                    Spark:openAdminMenu(player)
                end)
            end
        }
    }, function()
        player:closeMenu()
        Spark:openMainMenu(player)
    end)
end

--- @param player player
function Spark:openDeveloperMenu(player)
    player:showMenu('Developer Menu', {
        "Copy Coords"
    }, function(button)
        if button == "Copy Coords" then
            local coords = player:getPosition()
            player:copyText('vector3(' .. coords.x .. ', ' .. coords.y .. ', ' .. coords.z ..')')
            player:notification("Copied coords!")
        end
    end, function()
        player:closeMenu()
        Spark:openMainMenu(player)
    end)
end

function Spark:openPoliceMenu(player)
    player:showMenu('Police Menu', 'rgb(214, 45, 30)', {}, function(button)
        
    end)
end

--- @param player player
--- @param title string
--- @param buttons table
--- @param close? fun()
function Spark:openPermissionMenu(player, title, buttons, close)
    local result = {}
    for _, button in pairs(buttons) do
        if player:hasPermission(button.permission) then
            table.insert(result, button.label)
        end
    end

    player:showMenu(title, result, function(button)
        local data
        for _, v in pairs(buttons) do
            data = v.label == button and v or data
        end

        if not player:hasPermission(data.permission) then
            return
        end

        data.action()
    end, close)
end

--- @param player player
--- @return player | false
function Spark:askForPlayer(player)
    local result = promise.new()
    local players = {}

    for _, target in pairs(Spark:getPlayers()) do
        players[GetPlayerName(target:getSource()) .. ' (' .. target:getId() ..')'] = target
    end

    local buttons = {
        "- Find By Id"
    }

    for text in pairs(players) do
        table.insert(buttons, text)
    end

    player:showMenu("Player Selection", buttons, function(button)
        if button ~= buttons[1] then
            result:resolve(players[button] and players[button] or nil)
        else
            player:showSurvey('Get player by ID', 32, function(status, text)
                if status then
                    local target = Spark:getPlayer("id", text)
                    if target then
                        result:resolve(target)
                    end
                end

                result:resolve()
            end)
        end

        player:closeMenu()
    end)

    return Citizen.Await(result)
end

--- @param player player
Spark:listenEvent('Spawned', function(player)
    player:keybind('Open Main Menu', 'F9', function()
        Spark:openMainMenu(player)
    end)
end)