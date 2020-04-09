local gtable = require('gears.table')
local wibox = require('wibox')
local beautiful = require('beautiful')
local background = require('wibox.container.background')

local item = {}
local item_mt = {}
item.class = 'item'

function item.set_focus(self, val)
    val = val and true
    if val ~= self._private.focus then
        self._private.focus = val
        self:emit_signal('property::focus', val)
    end
end

function item.get_focus(self)
    return self._private.focus or false
end

function item.execute(self, menu)
    return (type(self.executable) == 'function' and self.executable or function (s, m) end)(self, menu)
end

function item.set_executable(self, exec)
    if type(exec) == 'function' or type(exec) == 'table' then
        self._private.executable = exec
    else
        self._private.executable = function (self)
            return exec
        end
    end
end

function item.get_executable(self)
    return self._private.executable
end

function item.set_userdate(self, userdata)
    self._private.userdata = userdata
    self:emit_signal('property::userdata', userdata)
end

function item.get_userdata(self)
    return self._private.userdata 
end

local function new()
    local widget = wibox.widget {
        layout = background
    }
    widget.class = item
    return gtable.crush(widget, item, true)
end

function item_mt.__call(_, ...)
    return new(...)
end

return setmetatable(item, item_mt)

