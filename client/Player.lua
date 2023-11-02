---@diagnostic disable: duplicate-set-field, param-type-mismatch
if not Spark then
    Spark = exports['spark']
end

local Weapons = Spark:getConfig('Weapons')

local Ids = {
    Keybind = 0,
    Callback = 0
}

function Spark:getPlayer()
    local player = {}

    --- @param coords vector3
    --- @param text string
    function player:drawText3Ds(coords, text)
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(true)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        SetDrawOrigin(coords.x, coords.y, coords.z, 0)
        DrawText(0.0, 0.0)

        local factor = (string.len(text)) / 370
        DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
        ClearDrawOrigin()
    end

    --- @param text string
    function player:drawText2Ds(text)
        SetTextFont(4)
        SetTextProportional(0)
        SetTextScale(0.0, 0.5)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextCentre(true)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(0.5, 0.8)
    end

    --- @param text string
    function player:notification(text)
        AddTextEntry("NOTIFICATION", text)
        SetNotificationTextEntry("NOTIFICATION")
        DrawNotification(true, false)
    end

    --- @param value boolean
    function player:setInvincible(value)
        SetEntityInvincible(PlayerPedId(), value)
    end

    function player:clearBlood()
        ClearPedBloodDamage(PlayerPedId())
    end

    --- @param custom table
    function player:setCustomization(custom)
        local ped = PlayerPedId()
        local hash = custom.hash ~= nil and custom.hash
        if not hash then
            return
        end

        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Wait(10)
        end

        if HasModelLoaded(hash) then -- update player model
            SetPlayerModel(PlayerId(), hash)
            SetModelAsNoLongerNeeded(hash)
        end

        ped = PlayerPedId() -- player is now new ped

        for k, v in pairs(custom.variations) do
            SetPedComponentVariation(ped, tonumber(k), v[1], v[2], v[3] or 2)
        end

        for k, v in pairs(custom.props) do
            if v[1] < 0 then
                ClearPedProp(ped, tonumber(k))
            else
                SetPedPropIndex(ped, tonumber(k), v[1], v[2], true)
            end
        end
    end

    --- @return table
    function player:getCustomization()
        local ped = PlayerPedId()
        local custom = {
            hash = GetEntityModel(ped),
            variations = {},
            props = {}
        }

        for i = 0, 20 do
            custom.variations[i] = {
                GetPedDrawableVariation(ped, i),
                GetPedTextureVariation(ped, i),
                GetPedPaletteVariation(ped, i)
            }
        end

        for i = 0, 10 do
            custom.props[i] = {
                GetPedPropIndex(ped, i),
                math.max(GetPedPropTextureIndex(ped, i), 0)
            }
        end

        return custom
    end

    --- @return vector3
    function player:getPosition()
        return GetEntityCoords(PlayerPedId())
    end

    --- @param coords vector3
    --- @return number
    function player:getDistance(coords)
        return #(coords - self:getPosition())
    end

    --- @param coords vector3
    function player:setPosition(coords)
        return SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
    end

    --- @param weapons table
    function player:setWeapons(weapons)
        local ped = PlayerPedId()

        RemoveAllPedWeapons(ped, true)

        for key, weapon in pairs(weapons) do
            GiveWeaponToPed(ped, GetHashKey(key), weapon.ammo or 0, false, false)
        end
    end

    --- @param weapon string
    --- @return boolean
    function player:hasWeapon(weapon)
        return HasPedGotWeapon(PlayerPedId(), GetHashKey(weapon), false)
    end

    --- @param weapon string
    --- @param ammo number
    function player:giveWeapon(weapon, ammo)
        GiveWeaponToPed(PlayerPedId(), GetHashKey(weapon), ammo or 0, false, false)
    end

    --- @param weapon string
    function player:removeWeapon(weapon)
        RemoveWeaponFromPed(PlayerPedId(), GetHashKey(weapon))
    end

    --- @return table
    function player:getWeapons()
        local player = PlayerPedId()

        local ammo = {}
        local weapons = {}

        for _, v in pairs(Weapons) do
            local model = string.upper(v)
            local hash = GetHashKey(model)
            if HasPedGotWeapon(player, hash, false) then
                local weapon = {}
                weapons[v] = weapon

                local type = GetPedAmmoTypeFromWeapon(player, hash)
                if ammo[type] == nil then
                    ammo[type] = true
                    weapon.ammo = GetAmmoInPedWeapon(player,hash)
                else
                    weapon.ammo = 0
                end

                weapons[model] = weapon
            end
        end

        return weapons
    end

    --- @param name string
    function player:triggerEvent(name, ...)
        return TriggerServerEvent(name, ...)
    end

    --- @param name string
    --- @return any
    function player:triggerCallback(name, ...)
        local promise = promise.new()
        local id = Ids.Callback + 1
        Ids.Callback = id

        RegisterNetEvent(('Spark:Callbacks:Client:Response:%s+%s'):format(
            name,
            GetPlayerServerId(PlayerId())
        ), function(response)
            promise:resolve(response)
        end)

        self:triggerEvent('Spark:Callbacks:Server:Run:' .. name, id, ...)
        return Citizen.Await(promise)
    end

    --- @param health number
    function player:setHealth(health)
        SetEntityHealth(PlayerPedId(), health)
    end

    --- @return number
    function player:getMaxHealth()
        return GetEntityMaxHealth(PlayerPedId())
    end

    --- @return number
    function player:getHealth()
        return GetEntityHealth(PlayerPedId())
    end

    --- @param heading number
    function player:setHeading(heading)
        SetEntityHeading(PlayerPedId(), heading)
    end

    --- @return number
    function player:getHeading()
        return GetEntityHeading(PlayerPedId())
    end

    --- @param name string
    --- @param key string
    --- @param callback fun()
    function player:keybind(name, key, callback)
        local id = Ids.Keybind + 1
        local resource = GetInvokingResource()

        local command = '+' .. (resource or GetCurrentResourceName()) .. tostring(id)
        Ids.Keybind = id

        if resource then
            Spark:onResourceStop(resource, function()
                callback = function() end
            end)
        end

        RegisterCommand(command, function()
            pcall(callback)
        end, false)

        RegisterKeyMapping(command, name, 'keyboard', key)
        SetTimeout(500, function ()
            TriggerEvent('chat:removeSuggestion', '/+' .. command)
        end)
    end

    return player
end

if GetCurrentResourceName() == "spark" then
    RegisterNetEvent('Spark:Keybind', function(name, key, id)
        Spark:getPlayer():keybind(name, key, function()
            TriggerServerEvent('Spark:Keybind:' .. id)
        end)
    end)
end