RegisterCommand('hello', function(source, args)
    --if source ~= 0 then
    --    return
    --end
    --RconPrint("YES?\n")

    local command = args[1]
    args[1] = nil
    
    --RconPrint('"' .. command .. '"' .. '\n')
    if command == "daddy" then
        RconPrint(args[1] .. "\n")
    end
end, false)