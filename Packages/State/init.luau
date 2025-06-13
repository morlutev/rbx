local TableUtil = require(script.Parent.TableUtil)
local Event = require(script.Parent.Event)

local State = {}
State.__index = State

function State.new(data: table)
    local self = setmetatable({
        Data = data or {},
        Observers = {},
        DirectoryObservers = {},
        KeyChanged = Event.new(),
    }, State)

    -- Observer system
    self.KeyChanged:Connect(function (path: string)
        --
    end)

    return self
end

function State:Get(path: string)
    return TableUtil.getPathValue(self.Data, path)
end

function State:Set(path: string, value: any)
    TableUtil.setPathValueetPathValue(self.Data, path, value)
    self.KeyChanged:Fire(path, value)
    return value
end

function State:Increment(path: string, value: number?)
    return self:Set(path, (self:Get(path)) + (value or 1))
end

function State:Observe(path: string)

end

function State:ObserveDirectory(path: string)

end

function State:GetSubState(path: string)
    
end

function State:Destroy()
    self.Destroyed = true
    self.KeyChanged:Destroy()
end

return State