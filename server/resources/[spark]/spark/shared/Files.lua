Spark.Files = {
    Files = {}
}

--- Get a file, this is just the name of the file
--- @param resource string
--- @param path string
--- @return table
function Spark.Files:Get(resource, path)
    assert(path, "Cannot access file because path is nil")
    if self.Files[path] then
        return self.Files[path]
    end

    local content = LoadResourceFile(resource, path)

    assert(content, "File cannot be found with path "..path)

    local f, err = load(content, resource..'/'..path)
    assert(f, "Error while loading file in resource ".. resource.. " path ".. path .." error "..tostring(err))

    local response = table.pack(xpcall(f, debug.traceback))
    local file, content = response[1], response[2]
    assert(file, "Error loading file "..path)

    self.Files[path] = content
    return content
end