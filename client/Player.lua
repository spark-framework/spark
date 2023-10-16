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
    local hash = nil

    if custom.modelhash ~= nil then
        hash = custom.modelhash
    elseif custom.model ~= nil then
        hash = GetHashKey(custom.model)
    end

    if hash ~= nil then
        local i = 0
        while not HasModelLoaded(hash) and i < 10000 do
            RequestModel(hash)
            Wait(10)
        end

        if HasModelLoaded(hash) then
            SetPlayerModel(PlayerId(), hash)
            SetModelAsNoLongerNeeded(hash)
        end
    end

    ped = PlayerPedId()
    for k,v in pairs(custom) do
        if k ~= "model" and k ~= "modelhash" then
            local isprop, index = self:Parse(k)
            if isprop then
                if v[1] < 0 then
                    ClearPedProp(ped, index)
                else
                    SetPedPropIndex(ped, index, v[1], v[2], true)
                end
            else
                SetPedComponentVariation(ped, index, v[1], v[2], v[3] or 2)
            end
        end
    end
end

--- @return table
function Spark.Player.Customization:Get()
    local ped = GetPlayerPed(-1)
    local custom = {}
    custom.modelhash = GetEntityModel(ped)

    for i = 0, 20 do
        custom[i] = {
            GetPedDrawableVariation(ped, i),
            GetPedTextureVariation(ped, i),
            GetPedPaletteVariation(ped, i)
        }
    end

    for i = 0, 10 do
        custom["p"..i] = {
            GetPedPropIndex(ped, i),
            math.max(GetPedPropTextureIndex(ped, i), 0)
        }
    end

    return custom
end

--- @return boolean, number?
function Spark.Player.Customization:Parse(key)
    if type(key) == "string" and string.sub(key,1,1) == "p" then
        return true, tonumber(string.sub(key,2))
    else
        return false, tonumber(key)
    end
end

--- Register position object
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

--- Register customization object
Spark.Player.Weapons = {
    Weapons = Spark:Config('Weapons')
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

            local type = Citizen.InvokeNative(0x7FEAD38B326B9F74, player, hash)
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

Spark.Player.Server = {}

--- @param name string
function Spark.Player.Server:Event(name, ...)
    return TriggerServerEvent(name, ...)
end

--- @param name string
--- @return any
function Spark.Player.Server:Callback(name, ...)
    local promise = promise.new()
    local id = self.CurrentId + 1
    RegisterNetEvent('Spark:Callbacks:Client:Response:'.. name .. ':' .. id, function(response)
        promise:resolve(response)
    end)

    self.CurrentId = self.CurrentId + 1
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

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

--- @param key string | number
--- @return boolean
function Spark.Player:Key(key)
    if not tonumber(key) then
        key = Keys[key]
    end

    return IsControlJustPressed(0, key)
end