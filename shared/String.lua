local Characters =
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

local Symbols =
    "!@#$%^&*()_+-={}|[]`~"

--- @param length number
--- @param symbols boolean?
--- @return string
function Spark:generateString(length, symbols)
    local result = ''
    local chars = self:splitString(Characters .. (symbols and Symbols or ''), '')

    math.randomseed(os.time())
    for i = 1, length do
        result = result .. chars[math.random(1, #chars)]
    end

    return result
end

--- @param text string
--- @param separator string
--- @return table
function Spark:splitString(text, separator)
    local result = {}

    if separator == "" then
        for i = 1, #text do
            table.insert(result, text:sub(i, i))
        end
    else
        for part in (text..separator):gmatch("(.-)"..separator) do
            table.insert(result, part)
        end
    end

    return result
end