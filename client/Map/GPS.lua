Spark.GPS = {}

--- @param coords vector2 | vector3
function Spark.GPS:Set(coords)
    SetNewWaypoint(coords.x, coords.y)
end

--- @param blip number
function Spark.GPS:Blip(blip)
    SetBlipRoute(blip, true)
end

--- @return vector3 | nil
function Spark.GPS:Get()
    local blip = GetFirstBlipInfoId(8)
    return blip ~= 0 and GetBlipCoords(blip) or nil
end