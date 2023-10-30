local Player = Spark:getPlayer()
local Areas = {}

--- @param position vector3
--- @param radius number
--- @param height number
--- @param enter fun()
--- @param leave fun()
function Spark:addArea(position, radius, height, enter, leave)
    local area = {}
    local id = Spark:tableEntries(Areas)

    --- @param coords vector3
    ---@ return boolean
    function area:Coords(coords)
        return (
            #(coords - position) <= radius and
            math.abs(coords.z - position.z) <= height
        )
    end

    --- @return boolean
    function area:Player()
        return self:Coords(Player:getPosition())
    end

    --- @param entity number
    --- @return boolean
    function area:Entity(entity)
        return self:Coords(GetEntityCoords(entity))
    end

    Spark:onResourceStop(GetInvokingResource(), function ()
        Areas[id] = nil
    end)

    Areas[id] = {
        enter = enter,
        leave = leave,
        area = area
    }

    return area
end

CreateThread(function()
    while true do
        Wait(300)

        for _, data in pairs(Areas) do
            local success = data.area:Player()

            if data.in_area and not success and data.leave then
                data.leave()
            elseif not data.in_area and success and data.enter then
                data.enter()
            end

            data.in_area = success
        end
    end
end)