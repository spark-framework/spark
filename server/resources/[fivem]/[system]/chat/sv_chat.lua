AddEventHandler('chatMessage', function(source, name, msg)
	sm = stringsplit(msg, " ");

	if string.lower(sm[1]) == "/meall" then
        CancelEvent()
        TriggerClientEvent('chatMessage', -1, "^3[GLOBAL HANDLING]^7 "..name.." | ^1" ..string.sub(msg,7))
	end
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

RegisterNetEvent('chat:init')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('_chat:messageEntered')
RegisterNetEvent('chat:clear')
RegisterNetEvent('__cfx_internal:commandFallback')

AddEventHandler('_chat:messageEntered', function(author, color, message)
    if not message or not author then
        return
    end

    TriggerEvent('chatMessage', source, author, message)

    if not WasEventCanceled() then
        TriggerEvent("vrp-chat:chat_message",source,author,message)
        end

    print(author .. ': ' .. message)
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, "^1[OOC]^0 " .. name .. " - [ID - "..user_id.."] ", { 128, 128, 128 }, '/' .. command)
    end

    CancelEvent()
end)

AddEventHandler('chatMessage', function(source, name, message)
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest('https://discordapp.com/api/webhooks/640570286714126356/PiDb63Hmcqt3ygDyvdWkSdIEitEndAN0YuHju2StFgfIRt9lqcFwzwxDkIEaJ78b8ee_', function(err, text, headers) end, 'POST', json.encode({username = "Chatlog - " .. name, content = message}), { ['Content-Type'] = 'application/json' })
end)
