--- @param text string
function Spark:copyText(text)
    return SendNUIMessage({
        type = "copy",
        data = {
            text = text
        }
    })
end

Spark:createCallback('Spark:Copy', function(text)
    Spark:copyText(text)
end)