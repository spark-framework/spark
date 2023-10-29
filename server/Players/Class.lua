---@diagnostic disable: duplicate-set-field
local Identifiers, Groups, Jobs = {
    "steam",
    "source",
    "id"
}, Spark:getConfig('Groups'), Spark:getConfig('Jobs')

local Ids = {
    Callback = 0,
    Menu = 0,
    Keybind = 0
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

    player.Data = {}

    --- @return table
    function player.Data:Raw()
        return Players[steam]
    end

    --- @param key string
    --- @param value any
    --- @return boolean
    function player.Data:Set(key, value)
        if player.Is:Online() then
            self:Raw().data[key] = value
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
    function player.Data:Get(key)
        if player.Is:Online() then
            return Spark:cloneTable(self:Raw().data)[key]
        else
            local user = Players.Raw:Data(steam)

            if not user then
                return
            end

            return user[key]
        end
    end

    player.Data.Temp = {}

    --- @param key string
    --- @param value any
    function player.Data.Temp:Set(key, value)
        local temp = player.Data:Get('__temp') or {}
        temp[key] = value

        player.Data:Set('__temp', temp)
    end

    --- @param key string
    function player.Data.Temp:Get(key)
        return player.Data:Get('__temp')[key]
    end

    --- @return number
    function player:ID()
        return id
    end

    --- @return string
    function player:Steam()
        return steam
    end

    function player:Source()
        return player.Data:Raw().source
    end

    --- @return number
    function player:Ped()
        return GetPlayerPed(self:Source() or 0)
    end
    
    --- @param event string
    --- @param callback fun(player: player, ...)
    function player:Listen(event, callback)
        Spark:listenEvent(event, function(plr, ...)
            if plr:Steam() == player:Steam() then
                callback(...)
            end
        end)
    end

    player.Is = {}

    --- @return boolean
    function player.Is:Online() return player.Data:Raw() ~= nil end

    --- @return boolean
    function player.Is:Loaded() return(player.Data:Raw()?.spawns or 0) > 0 end

    --- @param reason string
    function player:Kick(reason)
        reason = reason or ''
        DropPlayer(self:Source(), reason)
    end

    player.Client = {}

    --- @param name string
    function player.Client:Event(name, ...)
        return TriggerClientEvent(name, player:Source(), ...)
    end

    --- @param name string
    --- @return any
    function player.Client:Callback(name, ...)
        local promise = promise.new()
        local id = Ids.Callback + 1
        Ids.Callback = id

        RegisterNetEvent('Spark:Callbacks:Server:Response:'.. name .. ':' .. id, function(response)
            local source = source
            if player:Source() == source then
                promise:resolve(response)
            end
        end)

        self:Event('Spark:Callbacks:Client:Run:' .. name, id, ...)
        return Citizen.Await(promise)
    end

    player.Weapons = {}

    --- @param weapons table
    function player.Weapons:Set(weapons)
        player.Client:Callback('Spark:Update', {
            weapons = weapons
        })
    end

    --- @return table
    function player.Weapons:Get()
        return player.Client:Callback('Spark:State').weapons
    end

    player.Weapons.Attachments = {}

    --- @param attachments table
    function player.Weapons.Attachments:Set(attachments)
        player.Client:Callback('Spark:Update', {
            attachments = attachments
        })
    end

    --- @return table
    function player.Weapons.Attachments:Get()
        return player.Client:Callback('Spark:State').attachments
    end

    player.Customization = {}

    --- @param customization table
    function player.Customization:Set(customization)
        player.Client:Callback('Spark:Update', {
            customization = customization
        })
    end

    --- @return table
    function player.Customization:Get()
        return player.Client:Callback('Spark:State').customization
    end

    player.Health = {}

    --- @param health number
    function player.Health:Set(health)
        player.Client:Callback('Spark:Update', {
            health = health
        })
    end

    --- @return number
    function player.Health:Max()
        return GetEntityMaxHealth(player:Ped())
    end

    --- @return number
    function player.Health:Get()
        return GetEntityHealth(player:Ped())
    end

    player.Position = {}

    --- @param coords vector3
    function player.Position:Set(coords)
        SetEntityCoords(player:Ped(), coords.x, coords.y, coords.z, false, false, false, false)
    end

    --- @return vector3
    function player.Position:Get()
        return GetEntityCoords(player:Ped())
    end

    player.Ban = {}

    --- @param value boolean
    --- @param reason? string
    --- @return boolean
    function player.Ban:Set(value, reason)
        if not value then
            player.Data:Set('Banned', nil)
            return true
        end

        player.Data:Set('Banned', reason or '')
        if player.Is:Online() then
            player:Kick('[Banned] ' .. (reason or ''))
        end

        return true
    end

    --- @return string | boolean
    function player.Ban:Reason()
        return player.Data:Get('Banned') or false
    end

    --- @return boolean
    function player.Ban:Is()
        return player.Data:Get('Banned') ~= nil
    end

    player.Whitelist = {}

    --- @param value boolean
    function player.Whitelist:Set(value)
        return player.Data:Set('Whitelisted', value)
    end

    --- @return boolean
    function player.Whitelist:Is()
        return player.Data:Get('Whitelisted') ~= nil
    end

    --- @param text string
    function player:Notification(text)
        player.Client:Callback('Spark:Update', {
            notification = text
        })
    end

    player.Groups = {}

    --- @return table
    function player.Groups:Get()
        return player.Data:Get('Groups')
    end

    --- @param group string
    --- @return boolean
    function player.Groups:Add(group)
        local groups = self:Get()
        if self:Has(group) or not Groups[group] then -- if the user already has the group
            return false
        end

        table.insert(groups, group)
        player.Data:Set('Groups', groups)

        Spark:triggerEvent('AddGroup', player, group)
        return true
    end

    --- @param permission string | table
    --- @return boolean
    function player.Groups:Permission(permission)
        for _, v in pairs(Groups) do
            for _, perm in pairs(type(permission) == "table" and permission or {permission}) do
                if not Spark:tableContains(v.permissions, perm) then
                    return false
                end
            end
        end

        return true
    end

    --- @param group string
    --- @return string
    function player.Groups:Has(group)
        return Spark:tableContains(self:Get(), group)
    end

    --- @param group string
    --- @return boolean
    function player.Groups:Remove(group)
        local groups = self:Get()
        if not self:Has(group) then -- if the user does not have the group
            return false
        end

        for i, v in pairs(groups) do -- find and remove the group
            if v == group then
                table.remove(groups, i)
            end
        end

        player.Data:Set('Groups', groups)
        Spark:triggerEvent('RemoveGroup', player, group)

        return true
    end

    player.Cash = {}

    --- @return number
    function player.Cash:Get()
        return player.Data:Get('Cash')
    end

    --- @param cash number
    function player.Cash:Set(cash)
        player.Data:Set('Cash', cash)
        Spark:triggerEvent('SetCash', player, cash)
    end

    --- @param cash number
    function player.Cash:Add(cash)
        self:Set(self:Get() + cash)
    end

    --- @param cash number
    --- @return boolean
    function player.Cash:Has(cash)
        return self:Get() >= cash
    end

    --- @param cash number
    function player.Cash:Remove(cash)
        if (self:Get() - cash) >= 0 then
            self:Set(self:Get() - cash)
        end
    end

    --- @param cash number
    --- @return boolean
    function player.Cash:Payment(cash)
        if (self:Get() - cash) < 0 then
            return false
        end

        return true, self:Set(self:Get() - cash)
    end

    player.Menu = {}

    --- @param title string
    --- @param color string
    --- @param data table
    --- @param callback fun(button: string)
    --- @param close? fun()
    function player.Menu:Show(title, color, data, callback, close)
        local id = Ids.Menu + 1
        Ids.Menu = id

        RegisterNetEvent('Spark:Menu:Button:' .. id, function(button)
            local source = source
            if player:Source() == source then
                callback(button)
            end
        end)

        if close then
            RegisterNetEvent('Spark:Menu:Close:' .. id, function()
                local source = source
                if player:Source() == source then
                    close()
                end
            end)
        end

        player.Client:Callback('Spark:Menu:Show', title, color, data, id, close and id)
    end

    function player.Menu:Close()
        player.Client:Callback('Spark:Menu:Close')
    end

    --- @param name string
    --- @param key string
    --- @param callback fun()
    function player:Keybind(name, key, callback)
        local id = Ids.Keybind + 1
        Ids.Keybind = id

        RegisterNetEvent('Spark:Keybind:' .. id, function()
            local source = source
            if player:Source() == source then
                callback()
            end
        end)

        player.Client:Event('Spark:Keybind', name, key, id)
    end

    player.Job = {}

    --- @return job
    function player.Job:Get()
        local job = player.Data:Get('Job')

        return {
            name = job.name,
            grade = job.grade,
            time = job.time,
            label = Jobs[job.name].grades and Jobs[job.name].grades[job.grade].label or Jobs[job.name].label
        }
    end

    --- @param group string
    function player.Job:Is(group)
        return self:Get().name == group
    end

    --- @param job string
    --- @param grade number
    --- @return boolean
    function player.Job:Set(job, grade)
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

        player.Data:Set('Job', job)
        Spark:triggerEvent('SetJob', player, self:Get())

        return true
    end

    return player
end
