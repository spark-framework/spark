Spark.Ped = {}

--- Create a ped with options
--- @param type number
--- @param model string
--- @param coords vector3
--- @param heading number
--- @param options table | nil
--- @return number
function Spark.Ped:Create(type, model, coords, heading, options)
    local hash = GetHashKey(model)

    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(5)
    end

    local ped = CreatePed(
        type,
        hash,
        coords.x, coords.y, coords.z,
        heading,
        false,
        true
    )

    if options?.freeze then
        FreezeEntityPosition(ped, true)
    end

    if options?.invincible then
        SetEntityInvincible(ped, true)
    end

    if options?.block then
        SetBlockingOfNonTemporaryEvents(ped, true)
    end

    if options?.ragdoll then
        SetPedCanRagdollFromPlayerImpact(ped, options?.ragdoll)
    end

    if options?.injured then
        SetPedDiesWhenInjured(ped, false)
    end

    if options?.canPlay then
        SetPedCanPlayAmbientAnims(ped, true)
    end

    return ped
end

--- Delete a ped when your resource gets restarted
--- @param ped number
function Spark.Ped:Delete(ped)
    local resource = GetInvokingResource()
    AddEventHandler('onResourceStop', function(name)
        if name == resource then
            DeleteEntity(ped)
        end
    end)
end