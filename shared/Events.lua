Spark.Events = {
    Events = {}
}

--- @param name string
function Spark.Events:Register(name)
    Spark.Events.Events[name] = {}
end

--- @param name string
function Spark.Events:Trigger(name, ...)
    if IsDuplicityVersion() and (...)?.Source() == 0 then
        return
    end

    for _, v in pairs(Spark.Events.Events[name] or {}) do
        v(...)
    end
end

--- @param name string
--- @param callback function
function Spark.Events:Listen(name, callback)
    if not Spark.Events.Events[name] then
        Spark.Events.Events[name] = {}
    end

    table.insert(Spark.Events.Events[name], callback)
end