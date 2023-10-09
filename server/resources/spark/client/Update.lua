local Weapons = Spark:Config('Weapons')

RegisterNetEvent('Spark:Player:Update', function(data)
    local player = PlayerPedId()
    if data.health then
        SetEntityHealth(player, data.health)
    end
end)

Spark:Callback('GetWeapons', function()
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
end)