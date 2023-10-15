---@diagnostic disable: duplicate-set-field
if not Spark then
    Spark = exports['spark']:Spark()
end

print(Spark.Player)

Spark.Player = {}

--- Draw text in 3d
--- @param x number
--- @param y number
--- @param z number
--- @param text string
function Spark.Player:DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)

    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

--- Register customization object
Spark.Player.Customization = {}

--- Set the customization of the player
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

--- Get the customization of the player
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

function Spark.Player.Customization:Parse(key)
    if type(key) == "string" and string.sub(key,1,1) == "p" then
        return true, tonumber(string.sub(key,2))
    else
        return false, tonumber(key)
    end
end

--- Register position object
Spark.Player.Position = {}

--- Get the player's position
--- @return vector3
function Spark.Player.Position:Get()
    return GetEntityCoords(PlayerPedId())
end

--- Get the player's distance to a coord
--- @param x number
--- @param y number
--- @param z number
--- @return number
function Spark.Player.Position:Distance(x, y, z)
    return #(vector3(x,y,z) - self:Get())
end

--- Set the player's coords
--- @param x number
--- @param y number
--- @param z number
function Spark.Player.Position:Set(x, y, z)
    return SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, false)
end

--- Register customization object
Spark.Player.Weapons = {
    Weapons = Spark:Config('Weapons')
}

--- Set the player's weapons
--- @param weapons table
function Spark.Player.Weapons:Set(weapons)
    local player = PlayerPedId()

    RemoveAllPedWeapons(player, true)

    for key, weapon in pairs(weapons) do
        GiveWeaponToPed(player, GetHashKey(key), weapon.ammo or 0, false, false)
    end
end

--- Get the player's weapons
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

--- Trigger a server event
--- @param name string
function Spark.Player.Server:Event(name, ...)
    return TriggerServerEvent(name, ...)
end

--- Trigger a server callback
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