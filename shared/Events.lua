local Events = {}

--- @param name string
function Spark:registerEvent(name)
    Events[name] = {}
end

--- @param name string
function Spark:triggerEvent(name, ...)
    if IsDuplicityVersion() and (...)?.Source() == 0 then
        return
    end

    for _, v in pairs(Events[name] or {}) do
        pcall(v, ...)
    end
end

--- @param name string
--- @param callback function
function Spark:listenEvent(name, callback)
    if not Events[name] then
        self:registerEvent(name)
    end

    table.insert(Events[name], callback)
end