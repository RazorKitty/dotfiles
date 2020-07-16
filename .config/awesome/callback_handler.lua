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
    for idx,val in ipairs(self) do
        if val == func then
            self[idx] = nil
        end
    end
end

function callback_handler.new(self, obj)
    obj = obj or {}
    return setmetatable(obj, self)
end

return callback_handler
