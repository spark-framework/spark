Spark.Ped = {}

--- @class PedOptions 
--- @field delete? boolean
--- @field freeze? boolean
--- @field invincible? boolean
--- @field block? boolean
--- @field ragdoll? boolean
--- @field injured? boolean
--- @field canPlay? boolean
--- @field functions? table[]

--- @param type number
--- @param model string
--- @param coords vector3
--- @param heading number
--- @param options PedOptions | nil
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

    if options?.delete then
        Spark.Ped:Delete(ped)
    end

    if options?.freeze then
        FreezeEntityPosition(ped, options?.freeze)
    end

    if options?.invincible then
        SetEntityInvincible(ped, options?.invincible)
    end

    if options?.block then
        SetBlockingOfNonTemporaryEvents(ped, options?.block)
    end

    if options?.ragdoll then
        SetPedCanRagdollFromPlayerImpact(ped, options?.ragdoll)
    end

    if options?.injured then
        SetPedDiesWhenInjured(ped, not options?.injured)
    end

    if options?.canPlay then
        SetPedCanPlayAmbientAnims(ped, options?.canPlay)
    end

    if options?.functions then
        for k, v in pairs(options?.functions) do
            _G[k](ped, table.unpack(v))
        end
    end

    return ped
end

--- @param ped number
function Spark.Ped:Delete(ped)
    local resource = GetInvokingResource()
    AddEventHandler('onResourceStop', function(name)
        if name == resource then
            DeleteEntity(ped)
        end
    end)
end