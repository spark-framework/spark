Spark.Area = { Id = 0 }

local Areas = {}

--- @param x number
--- @param y number
--- @param z number
--- @param radius number
--- @param height number
--- @param enter fun()
--- @param leave fun()
--- @return number
function Spark.Area:Add(x, y, z, radius, height, enter, leave)
    local id = self.Id + 1
    self.Id = id

    local resource = GetInvokingResource()
    AddEventHandler('onResourceStop', function(name)
        if resource == name then
            Areas[id] = nil
        end
    end)

    Areas[id] = {
        x = x,
        y = y,
        z = z,
        radius = radius,
        height = height,
        enter = enter or function () end,
        leave = leave or function () end
    }

    return id
end

--- @param area number
function Spark.Area:Remove(area)
    Areas[area] = nil
end

CreateThread(function() -- Displays all areas
    while true do
        Wait(250)

        for id, v in pairs(Areas) do
            local isIn = (
                Spark.Player.Position:Distance(v.x, v.y, v.z) <= v.radius and
                math.abs(Spark.Player.Position:Get().z - v.z) <= v.height
            )

            if v.in_area and not isIn then
                v.leave(id)
            elseif not v.in_area and isIn then
                v.enter(id)
            end

            v.in_area = isIn
        end
    end
end)