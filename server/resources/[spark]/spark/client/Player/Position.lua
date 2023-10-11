Spark.Postion = {}

function Spark.Postion:Get()
    return GetEntityCoords(PlayerPedId())
end

function Spark.Postion:Distance(x, y, z)
    return #(vector3(x,y,z) - self:Get())
end

function Spark.Postion:Set(positon)
    return SetEntityCoords(PlayerPedId(), positon.x, positon.y, positon.z, false, false, false, false)
end