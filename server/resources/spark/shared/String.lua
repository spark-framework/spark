Spark.String = {
    Characters =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
    Symbols = 
        "!@#$%^&*()_+-={}|[]`~"
}

function Spark.String:Generate(length, symbols)
    local result = ''
    local chars = self:Split(self.Characters .. (symbols and self.Symbols or ''), '')

    math.randomseed(os.time())
    for i = 1, length do
        result = result .. chars[math.random(1, #chars)]
    end

    return result
end

function Spark.String:Split(text, separator)
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