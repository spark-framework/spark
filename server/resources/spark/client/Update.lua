local Weapons = Spark:Config('Weapons')

RegisterNetEvent('Spark:Player:Update', function(data)
    local player = PlayerPedId()
    if data.health then
        SetEntityHealth(player, data.health)
    end

    if data.customization then
        SetCustomization(data.customization)
    end
end)

Spark:Callback('Spark:Update', function(data)
    if data.customization then
        SetCustomization(data.customization)
    end

    if data.weapons then
        SetWeapons(data.weapons, true)
    end
end)

Spark:Callback('Spark:State', function()
    return {
        weapons = GetWeapons(),
        customization = GetCustomization()
    }
end)

function Parse(key)
    if type(key) == "string" and string.sub(key,1,1) == "p" then
        return true, tonumber(string.sub(key,2))
    else
        return false, tonumber(key)
    end
end

function SetWeapons(weapons, clear)
    local player = GetPlayerPed(-1)

    if clear then
        RemoveAllPedWeapons(player,true)
    end

    for k,weapon in pairs(weapons) do
        local hash = GetHashKey(k)
        local ammo = weapon.ammo or 0
    
        GiveWeaponToPed(player, hash, ammo, false, false)
    end
end

function SetCustomization(custom)
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
            local isprop, index = Parse(k)
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

function GetCustomization()
    local ped = GetPlayerPed(-1)
    local custom = {}

    custom.modelhash = GetEntityModel(ped)

    -- ped parts
    for i=0,20 do -- index limit to 20
        custom[i] = {GetPedDrawableVariation(ped,i), GetPedTextureVariation(ped,i), GetPedPaletteVariation(ped,i)}
    end

    -- props
    for i=0,10 do -- index limit to 10
        custom["p"..i] = {GetPedPropIndex(ped,i), math.max(GetPedPropTextureIndex(ped,i),0)}
    end

    return custom
end

function GetWeapons()
    local player = GetPlayerPed(-1)

    local ammo = {}
    local weapons = {}

    for _, v in pairs(Weapons) do
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