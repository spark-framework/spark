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

    player:showMenu('Main Menu', 'rgb(230, 140, 14)', buttons, function(button)
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
    local buttons = {
        {
            label = "Set Job",
            permission = "setjob",
            action = function()
                local target = Spark:askForPlayer(player)
                if not target then
                    return player:notification('Cannot find player!')
                end
            end
        },

        {
            label = "Remove Job",
            permission = "removejob",
            action = function()
                player:notification("Not made yet")
            end
        },

        {
            label = "Give Cash",
            permission = "givecash",
            action = function()
                local target = Spark:askForPlayer(player)
                if not target then
                    return
                end

                player:showSurvey('Amount of cash', 32, function(result, text)
                    if not result then
                        return
                    end

                    target:addCash(tonumber(text) or 0)
                    target:notification('You recieved ' .. text .. " from ID " .. player:getId())
                end)
            end
        },
    }

    local result = {}
    for _, button in pairs(buttons) do
        if player:hasPermission(button.permission) then
            table.insert(result, button.label)
        end
    end

    player:showMenu('Admin Menu', 'rgb(214, 45, 30)', result, function(button)
        local data
        for _, v in pairs(buttons) do
            data = v.label == button and v or data
        end

        if not player:hasPermission(data.permission) then
            return
        end

        data.action()
    end, function()
        player:closeMenu()
        Spark:openMainMenu(player)
    end)
end

--- @param player player
function Spark:openDeveloperMenu(player)
    player:showMenu('Developer Menu', 'rgb(214, 45, 30)', {
        "Copy Coords"
    }, function(button)
        if button == "Copy Coords" then
            local coords = player:getPosition()
            player:copyText('vector3(' .. coords.x .. ', ' .. coords.y .. ', ' .. coords.z ..')')
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

    player:showMenu("Player Selection", '', buttons, function(button)
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