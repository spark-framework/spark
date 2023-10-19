Spark.Prompt = {}

local Text = nil

--- @param text string
function Spark.Prompt:Show(text)
    Text = text
end

function Spark.Prompt:Remove()
    Text = nil
end

CreateThread(function()
    while true do
        Wait(1)

        if Text ~= nil then -- Check if a text needs to be displayed
            SetTextComponentFormat("STRING")
            AddTextComponentString(Text)
            DisplayHelpTextFromStringLabel(0, false, true, -1)
        end
    end
end)