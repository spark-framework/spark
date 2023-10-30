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
                player:notification("Not made yet")
            end
        },

        {
            label = "Remove Job",
            permission = "removejob",
            action = function()
                player:notification("Not made yet")
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
            data = v.label == button and v
        end

        if not player:hasPermission(data.permission) then
            return
        end

        data.action()
    end)
end

function Spark:openDeveloperMenu(player)
    player:showMenu('Developer Menu', 'rgb(214, 45, 30)', {}, function(button)
        
    end)
end

function Spark:openPoliceMenu(player)
    player:showMenu('Police Menu', 'rgb(214, 45, 30)', {}, function(button)
        
    end)
end

--- @param player player
Spark:listenEvent('Spawned', function(player)
    player:keybind('Open Main Menu', 'F9', function()
        Spark:openMainMenu(player)
    end)
end)