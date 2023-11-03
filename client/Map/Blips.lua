--- @param coords vector3
--- @param type number
--- @param color number
--- @param text? string
--- @return number
function Spark:addBlip(coords, type, color, text)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
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

--- @param blip number
function Spark:removeBlip(blip)
    RemoveBlip(blip)
end