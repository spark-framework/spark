--- @param coords vector2 | vector3
function Spark:setGPSToCoords(coords)
    SetNewWaypoint(coords.x, coords.y)
end

--- @param blip number
function Spark:setGPSToBlip(blip)
    SetBlipRoute(blip, true)
end

--- @return vector3 | nil
function Spark:getGPS()
    local blip = GetFirstBlipInfoId(8)
    return blip ~= 0 and GetBlipCoords(blip) or nil
end