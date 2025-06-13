local HttpService = game:GetService("HttpService")
local Event = {}
Event.__index = Event

function Event.new()
    local self = setmetatable({
        Connections = {}
    }, Event)

    return self
end

function Event:Connect(callback)
    local id = HttpService:GenerateGUID(false)
    if not self.Destroyed then
        self.Connections[id] = callback
    end
    
    return {
        Disconnect = function ()
            self.Connections[id] = nil
        end,
        Destroy = function ()
            self.Connections[id] = nil
        end,
    }
end

function Event:Destroy()
    self.Destroyed = true
    self.Connections = {}
end

function Event:Fire(...)
    for _, callback in self.Connections do
        task.spawn(callback, ...)
    end
end

return Event