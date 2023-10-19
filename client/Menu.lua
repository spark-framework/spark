---@diagnostic disable: param-type-mismatch
local Open, Index, Data, Color, Callback = false, 1, {}, '', nil

Spark.Menu = {}

function Spark.Menu:Open()
    return Open
end

function Spark.Menu:Current()
    return Data[Index]
end

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
    print("CLOSE?")
    Open, Callback = false, nil
    return SendNUIMessage({
        type = "menu",
        action = "close",
    })
end

function Spark.Menu:Update()
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