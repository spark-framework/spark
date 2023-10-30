---@diagnostic disable: param-type-mismatch, missing-parameter
local Player = Spark:getPlayer()
local Markers = {}

--- @param coords vector3
--- @param dcoords vector3
--- @param r number
--- @param g number
--- @param b number
--- @param distance number
--- @return number
function Spark:addMarker(coords, dcoords, r, g, b, distance)
    local id = Spark:tableEntries(Markers)
    Spark:onResourceStop(GetInvokingResource(), function()
        Markers[id] = nil
    end)

    Markers[id] = {
        coords = coords,
        dx = dcoords.x or 2.0,
        dy = dcoords.y or 2.0,
        dz = dcoords.z or 0.7,
        r = r or 0,
        g = g or 155,
        b = b or 255,
        distance = distance or 150
    }

    return id
end

--- @param marker number
function Spark:removeMarker(marker)
    Markers[marker] = nil
end

CreateThread(function() -- draw markers (high ms)
    while true do
        Wait(1)

        for _, v in pairs(Markers) do
            if Player:getDistance(v.coords) <= v.distance then
                DrawMarker(1, v.coords.x, v.coords.y, v.coords.z, 0, 0, 0, 0, 0, 0, v.dx, v.dy, v.dz, v.r, v.g, v.b, 200, 0, 0, 0, 50)
            end
        end
    end
end)