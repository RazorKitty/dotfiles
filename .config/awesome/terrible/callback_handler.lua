local table = table

local callback_handler = {}
callback_handler.__index = callback_handler

callback_handler.__call = function (self, ...)
    for _,func in ipairs(self) do
        func(...)
    end
end

callback_handler.add = function (self, func)
    table.insert(self, func)
end

callback_handler.remove = function (self, func)
    self[func] = nil
end

function callback_handler.new(self, obj)
    obj = obj or {}
    return setmetatable(obj, self)
end

return callback_handler
