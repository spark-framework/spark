---@diagnostic disable: param-type-mismatch
local Player = Spark:getPlayer()

local Open, Index, Data, Color, Callback, Close = false, 1, {}, '', nil, nil

--- @return boolean
function Spark:isMenuOpen()
    return Open
end

--- @return string
function Spark:getCurrentButton()
    return Data[Index]
end

function Spark:getMenuIndex()
    return Index
end

function Spark:setMenuIndex(index)
    Index = index
    self:updateMenu()
end

--- @param title string
--- @param color string
--- @param data table
--- @param callback fun(button:  string)
--- @param close? fun()
function Spark:showMenu(title, color, data, callback, close)
    Open, Index, Data = true, 1, data
    Color, Callback, Close = color, callback, close

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

function Spark:updateButton(index, text)
    return SendNUIMessage({
        type = "menu",
        action = "updateButton",
        data = {
            index = index,
            text = text
        }
    })
end

function Spark:closeMenu()
    Open, Callback = false, nil
    return SendNUIMessage({
        type = "menu",
        action = "close",
    })
end

function Spark:updateMenu() -- update key index in NUI
    return SendNUIMessage({
        type = "menu",
        action = "update",
        data = {
            index = Index,
            color = Color
        }
    })
end

Player:keybind('Close Menu', 'BACK', function()
    if Open then
        if not Close then
            return Spark:closeMenu()
        end

        Close()
    end
end)

Player:keybind('Press Button', 'RETURN', function()
    if Open then
        pcall(Callback, Spark:getCurrentButton())
    end
end)

Player:keybind('Move Up', 'UP', function()
    if Open then
        Index = Index == 1
            and #Data or Index - 1
        Spark:updateMenu()
    end
end)

Player:keybind('Move Down', 'DOWN', function()
    if Open then
        Index = Index == #Data
            and 1 or Index + 1
        Spark:updateMenu()
    end
end)

Spark:createCallback('Spark:Menu:Show', function(title, color, data, buttonId, closeId)
    Spark:showMenu(title, color, data, function(button)
        TriggerServerEvent('Spark:Menu:Button:' .. buttonId, button)
    end, closeId and function()
        TriggerServerEvent('Spark:Menu:Close:' .. closeId)
    end or nil)
end)

Spark:createCallback('Spark:Menu:Close', function()
    Spark:closeMenu()
end)