Spark.Blips = {}

--- Add a blip to the map
--- @param x number
--- @param y number
--- @param z number
--- @param type number
--- @param color number
--- @param text string | nil
--- @return number
function Spark.Blips:Add(x, y, z, type, color, text)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, type)
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

--- Remove a blip from the map
--- @param blip number
function Spark.Blips:Remove(blip)
    RemoveBlip(blip)
end