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