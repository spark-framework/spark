--- @param player player
function Spark:openMainMenu(player)
    local buttons = {}

    if player.Groups:Has('admin') then -- admin menu
        table.insert(buttons, "Admin")
    end

    if player.Groups:Has('developer') then -- developer menu
        table.insert(buttons, "Development")
    end

    player.Menu:Show('Main Menu', 'rgb(230, 140, 14)', buttons, function(button)
        if button == "Admin" then
            self:openAdminMenu(player)
        end
    end, function ()
        player.Menu:Close()
    end)
end

function Spark:openAdminMenu(player)
    player.Menu:Show('Admin Menu', 'rgb(214, 45, 30)', {}, function(button)
        
    end)
end

function Spark:openDeveloperMenu(player)
    player.Menu:Show('Developer Menu', 'rgb(214, 45, 30)', {}, function(button)
        
    end)
end

--- @param player player
Spark:listenEvent('Spawned', function(player)
    player:Keybind('Open Main Menu', 'F9', function()
        Spark:openMainMenu(player)
    end)
end)