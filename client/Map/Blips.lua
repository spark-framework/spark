Spark.Blips = {}

--- @param x number
--- @param y number
--- @param z number
--- @param blip number
--- @param color number
--- @param text string | nil
--- @return number
function Spark.Blips:Add(x, y, z, blip, color, text)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, blip)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, color)
    SetBlipScale(blip, 0.6)

    if text ~= nil then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(text)
        EndTextCommandSetBlipName(blip)
    end

    return blip
end

--- @param blip number
function Spark.Blips:Remove(blip)
    RemoveBlip(blip)
end