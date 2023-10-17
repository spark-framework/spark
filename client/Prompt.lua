Spark.Prompt = {}

local Text = nil

--- @param text string
--- @param key number
--- @param callback function
function Spark.Prompt:Show(text, key, callback)
    Text = {
        text = text,
        key = key,
        callback = callback
    }
end

function Spark.Prompt:Remove()
    Text = nil
end

CreateThread(function()
    while true do
        Wait(0)

        if Text ~= nil then -- Check if a text needs to be displayed
            SetTextComponentFormat("STRING")
            AddTextComponentString(Text.text)
            DisplayHelpTextFromStringLabel(0, false, true, -1)

            if Text.key and Text.callback and IsControlJustPressed(0, Text.key) then
                Text.callback()
            end
        end
    end
end)