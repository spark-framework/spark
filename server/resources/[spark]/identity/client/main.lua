local Spark = exports['spark']:Spark()

local Ped = Spark.Ped:Create(4, 's_m_m_fiboffice_01', vector3(
    230.4,
    -403.67,
    47.92 - 1
), 251.26, {
    freeze = true,
    invincible = true,
    block = true,
    ragdoll = false,
    injured = true
})

TaskStartScenarioInPlace(Ped, "WORLD_HUMAN_CLIPBOARD", 0, true)

Spark.Ped:Delete(Ped) -- delete when resource is stopped

CreateThread(function ()
    while true do
        --if Spark.Position:Distance(230.4, -403.67, 48.1) < 1.5 then
        --    Spark.Ped:DrawText3Ds(230.4, -403.67, 48.1, 'HELLO')
        --end

        --Wait(1)
    end
end)