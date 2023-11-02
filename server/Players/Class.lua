---@diagnostic disable: duplicate-set-field
local Identifiers, Groups, Jobs = {
    "steam",
    "source",
    "id"
}, Spark:getConfig('Groups'), Spark:getConfig('Jobs')

local Ids = {
    Callback = 0,
    Menu = 0,
    Keybind = 0,
    Survey = 0
}

--- @param method "steam" | "source" | "id"
--- @param value any
function Spark:getPlayer(method, value)
    if not Spark:tableContains(Identifiers, method) then
        return error("Method " .. method .. " is invalid!")
    end

    local steam, id = value, nil
    if method == "id" then
        steam, id = self:getSteamById(value), value
    elseif method == "source" then
        steam = self:getSteamBySource(value)
    end

    id = id or Players[steam]?.id
    if not Players[steam] then
        if method == "source" then
            return false, "user_does_not_exist"
        end

        local data = self:getRawDataByMethod(method, value)
        if not data then
            return false, "user_cannot_be_found"
        end

        id, steam = data.id, data.steam
    end

    --- @class player
    local player = {}

    --- @return table
    function player:getRawData()
        return Players[steam]
    end

    --- @param key string
    --- @param value any
    --- @return boolean
    function player:setData(key, value)
        if player:isOnline() then
            self:getRawData().data[key] = value
        else
            local user = Spark:getRawDataBySteam(steam)
            if not user then
                return false
            end

            user[key] = value
            Spark:dumpUser(steam, user)
        end

        Spark:triggerEvent('Data', player, key, value)
        return true
    end

    --- @param key string
    --- @return any
    function player:getData(key)
        if player:isOnline() then
            return Spark:cloneTable(self:getRawData().data)[key]
        else
            local user = Players.Raw:Data(steam)

            if not user then
                return
            end

            return user[key]
        end
    end

    --- @return number
    function player:getId()
        return id
    end

    --- @return string
    function player:getSteam()
        return steam
    end

    function player:getSource()
        return player:getRawData().source
    end

    --- @return number
    function player:getPed()
        return GetPlayerPed(self:getSource() or 0)
    end

    --- @param event string
    --- @param callback fun(player: player, ...)
    function player:listen(event, callback)
        --- @param plr player
        Spark:listenEvent(event, function(plr, ...)
            if plr:getSteam() == player:getSteam() then
                pcall(callback, ...) -- maybe not work because of ... unpack?
            end
        end)
    end

    --- @return boolean
    function player:isOnline() return player:getRawData() ~= nil end

    --- @return boolean
    function player:isLoaded() return (player:getRawData()?.spawns or 0) > 0 end

    --- @param reason string
    function player:kick(reason)
        reason = reason or ''
        DropPlayer(self:getSource(), reason)
    end

    --- @param name string
    function player:triggerEvent(name, ...)
        return TriggerClientEvent(name, player:getSource(), ...)
    end

    --- @param name string
    --- @return any
    function player:triggerCallback(name, ...)
        local promise = promise.new()
        local id = Ids.Callback + 1
        Ids.Callback = id

        RegisterNetEvent('Spark:Callbacks:Server:Response:'.. name .. ':' .. id, function(response)
            local source = source
            if player:getSource() == source then
                promise:resolve(response)
            end
        end)

        self:triggerEvent('Spark:Callbacks:Client:Run:' .. name, id, ...)
        return Citizen.Await(promise)
    end

    --- @param weapons table
    function player:setWeapons(weapons)
        player:triggerCallback('Spark:Update', {
            weapons = weapons
        })
    end

    --- @return table
    function player:getWeapons()
        return player:triggerCallback('Spark:State').weapons
    end

    --- @param customization table
    function player:setCustomization(customization)
        player:triggerCallback('Spark:Update', {
            customization = customization
        })
    end

    --- @return table
    function player:getCustomization()
        return player:triggerCallback('Spark:State').customization
    end

    --- @param health number
    function player:setHealth(health)
        player:triggerCallback('Spark:Update', {
            health = health
        })
    end

    --- @return number
    function player:getMaxHealth()
        return GetEntityMaxHealth(player:getPed())
    end

    --- @return number
    function player:getHealth()
        return GetEntityHealth(player:getPed())
    end

    --- @param coords vector3
    function player:setPosition(coords)
        SetEntityCoords(player:getPed(), coords.x, coords.y, coords.z, false, false, false, false)
    end

    --- @return vector3
    function player:getPosition()
        return GetEntityCoords(player:getPed())
    end

    --- @param value boolean
    --- @param reason? string
    --- @return boolean
    function player:setBanned(value, reason)
        if not value then
            player:setData('Banned', nil)
            return true
        end

        player:setData('Banned', reason or '')
        if player:isOnline() then
            player:kick('[Banned] ' .. (reason or ''))
        end

        return true
    end

    --- @return string | boolean
    function player:getBanReason()
        return player:getData('Banned') or false
    end

    --- @return boolean
    function player:isBanned()
        return player:getData('Banned') ~= nil
    end

    --- @param value boolean
    function player:setWhitelisted(value)
        return player:setData('Whitelisted', value)
    end

    --- @return boolean
    function player:isWhitelisted()
        return player:getData('Whitelisted') ~= nil
    end

    --- @param text string
    function player:notification(text)
        player:triggerCallback('Spark:Update', {
            notification = text
        })
    end

    --- @return table
    function player:getGroups()
        return player:getData('Groups')
    end

    --- @param group string
    --- @return boolean
    function player:addGroup(group)
        local groups = self:getGroups()
        if self:hasGroup(group) or not Groups[group] then -- if the user already has the group
            return false
        end

        table.insert(groups, group)
        player:setData('Groups', groups)

        Spark:triggerEvent('AddGroup', player, group)
        return true
    end

    --- @param permission string
    --- @return boolean
    function player:hasPermission(permission)
        for _, v in pairs(self:getGroups()) do
            local group = Groups[v]
            if Spark:tableContains(group.permissions, permission) then
                return true
            end
        end

        return false
    end

    --- @param group string
    --- @return boolean
    function player:hasGroup(group)
        return Spark:tableContains(self:getGroups(), group)
    end

    --- @param group string
    --- @return boolean
    function player:removeGroup(group)
        local groups = self:getGroups()
        if not self:hasGroup(group) then -- if the user does not have the group
            return false
        end

        for i, v in pairs(groups) do -- find and remove the group
            if v == group then
                table.remove(groups, i)
            end
        end

        player:setData('Groups', groups)
        Spark:triggerEvent('RemoveGroup', player, group)

        return true
    end

    --- @return number
    function player:getCash()
        return player:getData('Cash')
    end

    --- @param cash number
    function player:setCash(cash)
        player:setData('Cash', cash)
        Spark:triggerEvent('SetCash', player, cash)
    end

    --- @param cash number
    function player:addCash(cash)
        self:setCash(self:getCash() + cash)
    end

    --- @param cash number
    --- @return boolean
    function player:hasCash(cash)
        return self:getCash() >= cash
    end

    --- @param cash number
    function player:removeCash(cash)
        if (self:getCash() - cash) >= 0 then
            self:setCash(self:getCash() - cash)
        end
    end

    --- @param cash number
    --- @return boolean
    function player:payment(cash)
        if (self:getCash() - cash) < 0 then
            return false
        end

        return true, self:setCash(self:getCash() - cash)
    end

    --- @param title string
    --- @param color string
    --- @param data table
    --- @param callback fun(button: string)
    --- @param close? fun()
    function player:showMenu(title, color, data, callback, close)
        local id = Ids.Menu + 1
        Ids.Menu = id

        RegisterNetEvent('Spark:Menu:Button:' .. id, function(button)
            local source = source
            if player:getSource() == source then
                pcall(callback, button)
            end
        end)

        if close then
            RegisterNetEvent('Spark:Menu:Close:' .. id, function()
                local source = source
                if player:getSource() == source then
                    pcall(close)
                end
            end)
        end

        player:triggerCallback('Spark:Menu:Show', title, color, data, id, close and id)
    end

    function player:closeMenu()
        player:triggerCallback('Spark:Menu:Close')
    end

    --- @param text string
    --- @param size number
    --- @param callback fun(result: boolean, text?: string)
    function player:showSurvey(text, size, callback)
        local id = Ids.Survey + 1
        Ids.Survey = id

        RegisterNetEvent('Spark:Survey:' .. id, function(result, text)
            local source = source
            if player:getSource() == source then
                pcall(callback, result, text)
            end
        end)

        player:triggerCallback('Spark:Survey', text, size, id)
    end

    --- @param name string
    --- @param key string
    --- @param callback fun()
    function player:keybind(name, key, callback)
        local id = Ids.Keybind + 1
        Ids.Keybind = id

        RegisterNetEvent('Spark:Keybind:' .. id, function()
            local source = source
            if player:getSource() == source then
                pcall(callback)
            end
        end)

        player:triggerEvent('Spark:Keybind', name, key, id)
    end

    --- @return job
    function player:getJob()
        local job = player:getData('Job')

        return {
            name = job.name,
            grade = job.grade,
            time = job.time,
            label = Jobs[job.name].grades and Jobs[job.name].grades[job.grade].label or Jobs[job.name].label
        }
    end

    --- @param job string
    function player:hasJob(job)
        return self:getJob().name == job
    end

    --- @param job string
    --- @param grade number
    --- @return boolean
    function player:setJob(job, grade)
        local data = Jobs[job]
        if not data then
            return false
        end

        if data.grades and not data.grades[grade] then
            return false
        end

        local job = { -- set job
            name = job,
            grade = data.grades and grade or 1,
            time = data.grades and data.grades[grade].time or data.time
        }

        player:setData('Job', job)
        Spark:triggerEvent('SetJob', player, self:getJob())

        return true
    end

    return player
end
