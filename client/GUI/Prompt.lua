local Text = nil

--- @param text string
function Spark:showPrompt(text)
    Text = text

    CreateThread(function()
        while true do
            Wait(1)

            if Text == nil then -- Check if a text is applied, if not remove thread
                return
            end

            SetTextComponentFormat("STRING")
            AddTextComponentString(Text)
            DisplayHelpTextFromStringLabel(0, false, true, -1)
        end
    end)
end

function Spark:removePrompt()
    Text = nil
end