local HttpService = game:GetService("HttpService")
local State = {}
State.__index = State

function State.new(data, prefix, root)
    local new = setmetatable({Data = data or {}})
    return setmetatable({
        Data = data or {},
        Prefix = prefix or "",
        Root = root or {}
    }, State)
end

function State:Extend(prefix)
    return State.new(self.Data, self.Prefix .. prefix .. "/")
end

function State:Set(key, value)
    if self.Destroyed then
        return false
    end
    local indexes = string.split(self.Prefix .. key, "/")
    local dir = self.Data
    while #indexes > 1 do
        local index = indexes[1]
        table.remove(indexes, 1)
        if not dir[index] then
            dir[index] = {}
        end
        dir = dir[index]
    end
    dir[indexes[1]] = value
    return value
end

function State:Get(key)
    if key == nil then
        local data = self.Data
        for _, index in string.split(self.Prefix, "/") do
            if index == "" then
                continue
            end
            data = data[index]
        end
        return data
    end

    local indexes = string.split(self.Prefix .. key, "/")
    local dir = self.Data
    while #indexes > 1 do
        local index = indexes[1]
        table.remove(indexes, 1)
        if not dir[index] then
            return nil
        end
        dir = dir[index]
    end
    return dir[indexes[1]]
end

function State:Increment(key, value)
    self:Set(key, (self:Get(key) or 0) + (value or 1))
end

function State:Observe(key, callback)
    local id = HttpService:GenerateGUID(false)
    return {
        Destroy = function () end
    }
end

function State:Destroy()
    self.Destroyed = true
    self.Data = {}
end

return State