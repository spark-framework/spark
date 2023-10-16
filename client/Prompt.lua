Spark.Prompt = {}

local Text = nil

--- Show a prompt with text
--- @param text string
function Spark.Prompt:Show(text)
    Text = text
end

--- Remove prompt from the player
function Spark.Prompt:Remove()
    Text = nil
end

CreateThread(function()
    while true do
        Wait(0)

        if Text ~= nil then
            SetTextComponentFormat("STRING")
            AddTextComponentString(Text)
            DisplayHelpTextFromStringLabel(0, false, true, -1)
        end
    end
end)