---@diagnostic disable: duplicate-set-field, param-type-mismatch
if not Spark then
    Spark = exports['spark']:Spark()
end

Spark.Player = {}

--- @param coords vector3
--- @param text string
function Spark.Player:DrawText3Ds(coords, text)
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
function Spark.Player:DrawText2Ds(text)
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

--- @param value boolean
function Spark.Player:Invincible(value)
    SetEntityInvincible(PlayerPedId(), value)
end

function Spark.Player:Blood()
    ClearPedBloodDamage(PlayerPedId())
end

Spark.Player.Customization = {}

--- @param custom table
function Spark.Player.Customization:Set(custom)
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
function Spark.Player.Customization:Get()
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

Spark.Player.Position = {}

--- @return vector3
function Spark.Player.Position:Get()
    return GetEntityCoords(PlayerPedId())
end

--- @param coords vector3
--- @return number
function Spark.Player.Position:Distance(coords)
    return #(coords - self:Get())
end

--- @param coords vector3
function Spark.Player.Position:Set(coords)
    return SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
end

Spark.Player.Weapons = {
    Weapons = Spark:Config('Weapons'),
    Components = Spark:Config('Components')
}

--- @param weapons table
function Spark.Player.Weapons:Set(weapons)
    local player = PlayerPedId()

    RemoveAllPedWeapons(player, true)

    for key, weapon in pairs(weapons) do
        GiveWeaponToPed(player, GetHashKey(key), weapon.ammo or 0, false, false)
    end
end

--- @return table
function Spark.Player.Weapons:Get()
    local player = PlayerPedId()

    local ammo = {}
    local weapons = {}

    for _, v in pairs(self.Weapons) do
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

Spark.Player.Weapons.Attachments = {}

function Spark.Player.Weapons.Attachments:Set(attachments)
    local ped = PlayerPedId()
end

--- @return table
function Spark.Player.Weapons.Attachments:Get()
    local ped = PlayerPedId()
    local weapons = self:Get()
    local attachments = {}

    for k in pairs(weapons) do
        local weapon = GetHashKey(k)
        if self.Components[k] then
            local data = {}
            for _, v in pairs(self.Components[k]) do
                local component = GetHashKey(v)
                if HasPedGotWeaponComponent(ped, weapon, component) then
                    table.insert(data, v)
                end
            end

            if #data > 0 then
                attachments[k] = data
            end
        end
    end

    return attachments
end

Spark.Player.Server = {
    CurrentId = 0
}

--- @param name string
function Spark.Player.Server:Event(name, ...)
    return TriggerServerEvent(name, ...)
end

--- @param name string
--- @return any
function Spark.Player.Server:Callback(name, ...)
    local promise = promise.new()
    local id = self.CurrentId + 1
    self.CurrentId = id

    RegisterNetEvent(('Spark:Callbacks:Client:Response:%s+%s'):format(
        name,
        GetPlayerServerId(PlayerId())
    ), function(response)
        promise:resolve(response)
    end)

    self:Event('Spark:Callbacks:Server:Run:' .. name, id, ...)

    return Citizen.Await(promise)
end

Spark.Player.Health = {}

--- @param health number
function Spark.Player.Health:Set(health)
    SetEntityHealth(PlayerPedId(), health)
end

--- @return number
function Spark.Player.Health:Max()
    return GetEntityMaxHealth(PlayerPedId())
end

--- @return number
function Spark.Player.Health:Get()
    return GetEntityHealth(PlayerPedId())
end

Spark.Player.Heading = {}

--- @param heading number
function Spark.Player.Heading:Set(heading)
    SetEntityHeading(PlayerPedId(), heading)
end

--- @return number
function Spark.Player.Heading:Get()
    return GetEntityHeading(PlayerPedId())
end

--- @param text string
function Spark.Player:Notification(text)
    AddTextEntry("NOTIFICATION", text)
    SetNotificationTextEntry("NOTIFICATION")
    DrawNotification(true, false)
end

local Keybinds = 0

--- @param name string
--- @param key string
--- @param callback fun()
function Spark.Player:Keybind(name, key, callback)
    local id = Keybinds + 1
    local command = '+' .. (GetInvokingResource() or GetCurrentResourceName()) .. tostring(id)
    Keybinds = id

    RegisterCommand(command, callback, false)

    RegisterKeyMapping(command, name, 'keyboard', key)
    SetTimeout(500, function ()
        TriggerEvent('chat:removeSuggestion', '/+' .. command)
    end)
end

if GetCurrentResourceName() == "spark" then
    RegisterNetEvent('Spark:Keybind', function(name, key, id)
        Spark.Player:Keybind(name, key, function()
            TriggerServerEvent('Spark:Keybind:' .. id)
        end)
    end)
end