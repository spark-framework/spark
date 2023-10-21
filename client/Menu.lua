---@diagnostic disable: param-type-mismatch
local Open, Index, Data, Color, Callback = false, 1, {}, '', nil

Spark.Menu = {}

--- @return boolean
function Spark.Menu:Open()
    return Open
end

--- @return string
function Spark.Menu:Current()
    return Data[Index]
end

--- @param title string
--- @param color string
--- @param data table
--- @param callback fun(button:  string)
function Spark.Menu:Show(title, color, data, callback)
    Open, Index, Data = true, 1, data
    Color, Callback = color, callback

    return SendNUIMessage({
        type = "menu",
        action = "open",
        data = {
            title = title,
            buttons = data,
            color = color
        }
    })
end

function Spark.Menu:Close()
    Open, Callback = false, nil
    return SendNUIMessage({
        type = "menu",
        action = "close",
    })
end

function Spark.Menu:Update() -- update key index in NUI
    return SendNUIMessage({
        type = "menu",
        action = "update",
        data = {
            index = Index,
            color = Color
        }
    })
end

Spark.Player:Keybind('Close Menu', 'BACK', function()
    if Open then
        Spark.Menu:Close()
    end
end)

Spark.Player:Keybind('Press Button', 'RETURN', function()
    if Open then
        Callback(Spark.Menu:Current())
    end
end)

Spark.Player:Keybind('Move Up', 'UP', function()
    if Open then
        Index = Index == 1
            and #Data or Index - 1
        Spark.Menu:Update()
    end
end)

Spark.Player:Keybind('Move Down', 'DOWN', function()
    if Open then
        Index = Index == #Data
            and 1 or Index + 1
        Spark.Menu:Update()
    end
end)

Spark:Callback('Spark:Menu:Show', function(title, color, data, id)
    Spark.Menu:Show(title, color, data, function(button)
        TriggerServerEvent('Spark:Menu:' .. id, button)
    end)
end)

Spark:Callback('Spark:Menu:Close', function()
    Spark.Menu:Close()
end)