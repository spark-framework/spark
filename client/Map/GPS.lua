Spark.GPS = {}

--- Set the player's gps
--- @param x number
--- @param y number
function Spark.GPS:Set(x, y)
    SetNewWaypoint(x, y)
end

--- Set the player's waypoint to a blip
--- @param blip number
function Spark.GPS:Blip(blip)
    SetBlipRoute(blip, true)
end

--- Get the player's waypoint location
--- @return vector3 | nil
function Spark.GPS:Get()
    local blip = GetFirstBlipInfoId(8)
    return blip ~= 0 and GetBlipCoords(blip) or nil
end