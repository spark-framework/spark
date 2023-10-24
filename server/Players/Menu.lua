Spark.Players.Menu = {}

function Spark.Players.Menu:Main(player)
    local buttons = {}

    if player.Groups:Has('admin') then -- admin menu
        table.insert(buttons, "Admin")
    end

    if player.Groups:Has('developer') then -- developer menu
        table.insert(buttons, "Development")
    end

    player.Menu:Show('Main Menu', 'rgb(230, 140, 14)', buttons, function(button)
        player.Menu:Close()
        if button == "Admin" then
            self:Admin(player)
        elseif button == "Development" then
            self:Developer(player)
        end
    end)
end

function Spark.Players.Menu:Admin(player)
    player.Menu:Show('Admin Menu', 'rgb(214, 45, 30)', {}, function(button)
        
    end)
end

function Spark.Players.Menu:Developer(player)
    player.Menu:Show('Developer Menu', 'rgb(214, 45, 30)', {}, function(button)
        
    end)
end

AddEventHandler('Spark:Spawned', function(steam, first)
    if not first then
        return
    end

    local player = Spark.Players:Get("steam", steam)
    if player:Source() == 0 then
        return
    end
    
    player:Keybind('Open Main Menu', 'F9', function()
        Spark.Players.Menu:Main(player)
    end)
end)