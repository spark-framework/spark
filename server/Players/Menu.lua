--- @param player player
function Spark:openMainMenu(player)
    local buttons = {}

    if player:hasGroup('admin') then -- admin menu
        table.insert(buttons, "Admin")
    end

    if player:hasGroup('developer') then -- developer menu
        table.insert(buttons, "Development")
    end

    player:showMenu('Main Menu', 'rgb(230, 140, 14)', buttons, function(button)
        player:closeMenu()
        if button == "Admin" then
            self:openAdminMenu(player)
        end
    end, function ()
        player:closeMenu()
    end)
end

--- @param player player
function Spark:openAdminMenu(player)
    player:showMenu('Admin Menu', 'rgb(214, 45, 30)', {}, function(button)

    end)
end

function Spark:openDeveloperMenu(player)
    player:showMenu('Developer Menu', 'rgb(214, 45, 30)', {}, function(button)
        
    end)
end

--- @param player player
Spark:listenEvent('Spawned', function(player)
    player:keybind('Open Main Menu', 'F9', function()
        Spark:openMainMenu(player)
    end)
end)