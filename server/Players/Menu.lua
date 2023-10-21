AddEventHandler('Spark:Spawned', function(steam, first)
    if not first then
        return
    end

    local player = Spark.Players:Get("steam", steam)
    player:Keybind('Open Main Menu', 'F9', function()
        local buttons = {}

        if player.Groups:Has('admin') then
            table.insert(buttons, "Admin")
        end

        if player.Groups:Has('developer') then
            table.insert(buttons, "Development")
        end

        player.Menu:Show('Main Menu', 'rgb(230, 140, 14)', buttons, function(button)
            print(button)
        end)
    end)
end)