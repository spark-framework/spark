---@diagnostic disable: param-type-mismatch, missing-parameter
Spark.Marker = { Id = 0 }

local Markers = {}

--- Add a marker to the world
--- @param x number
--- @param y number
--- @param z number
--- @param dx number
--- @param dy number
--- @param dz number
--- @param r number
--- @param g number
--- @param b number
--- @param distance number
--- @return number
function Spark.Marker:Add(x, y, z, dx, dy, dz, r, g, b, distance)
    local id = self.Id + 1
    self.Id = id

    Markers[id] = {
        x = x,
        y = y,
        z = z,
        dx = dx or 2.0,
        dy = dy or 2.0,
        dz = dz or 0.7,
        r = r or 0,
        g = g or 155,
        b = b or 255,
        distance = distance or 150
    }

    return id
end

--- Remove a marker from the world
--- @param marker number
function Spark.Marker:Remove(marker)
    Markers[marker] = nil
end

-- draw markers (high ms)
CreateThread(function()
    while true do
        Wait(0)

        for _, v in pairs(Markers) do
            if Spark.Player.Position:Distance(v.x, v.y, v.z) <= v.distance then
                DrawMarker(27, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, v.dx, v.dy, v.dz, v.r, v.g, v.b, 200, 0, 0, 0, 50)
            end
        end
    end
end)