local Callback = nil

--- @param text string
--- @param size number
--- @param callback fun(result: boolean, text?: string)
function Spark:showSurvey(text, size, callback)
    Callback = callback

    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "prompt",
        data = {
            text = text,
            size = size
        }
    })
end

RegisterNUICallback('Prompt:Result', function(data, cb)
    SetNuiFocus(false, false)

    if Callback then
        pcall(Callback, data.result, data.text)
    end

    cb()
end)

Spark:createCallback('Spark:Survey', function(text, size, id)
    Spark:showSurvey(text, size, function(result, text)
        TriggerServerEvent('Spark:Survey:' .. id, result, text)
    end)
end)
