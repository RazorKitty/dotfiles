local table = table
local setmetatable = setmetatable

local gtable = require('gears.table')
local gcolor = require("gears.color")
local beautiful = require('beautiful')
local base = require('wibox.widget.base')
local background = require('wibox.container.background')
local button = require('awful.button')

local item = { mt = {} }

local valid_states = {
    normal = true,
    focus = true,
    disabled = true,
    press = true
}

-- this looks complicated and odd but it generates the getters and setters for the state colors fg and bg 
-- people say we should avoid magic like this and to 'make your life easy' or 'dont be clever'
-- but whats the point in having these language features or spending 3 years at 9k p/y on a degree to not use them?
-- fuck you ben, with love, im using them
-- plus it saves wrting out basically the same 2 functions 3 times each

for state in pairs(valid_states) do
    for _,prop in ipairs { 'fg', 'bg' } do

        -- getters
        item['get_'..prop..'_'..state] = function (self)
            return self._private[prop..'_'..state] or beautiful['item_'..prop..'_'..state] or beautiful[prop..'_'..state] 
        end
        
        -- setters
        item['set_'..prop..'_'..state] = function (self, color)
            color = gcolor(color)

            if self._private[prop..'_'..state] == color then
                return
            end
            
            self._private[prop..'_'..state] = color
            
            if self.state == state then
                self[prop] = self[prop..'_'..state]
            end

            self:emit_signal('property::'..prop..'_'..state, color)
        end

    end
end


function item.set_state(self, state)
    if (not valid_states[state]) or (self._private.state == state) then
        return
    end

    self._private.state = state

    self.fg = self['fg_'..state] or beautiful['item_fg_'..state] or beautiful['fg_'..state]
    self.bg = self['bg_'..state] or beautiful['item_bg_'..state] or beautiful['bg_'..state]

    self:emit_signal('property::state', state)
end

function item.get_state(self)
    return self._private.state or 'normal'
end


function item.set_executable(self, func)
    if (not func) or (self._private.executable == func) then
        return
    end

    self._private.executable = func
    self:emit_signal('property::executable', func)
end

function item.get_executable(self)
    return self._private.executable
end


function item.execute(self, ...)
    local exe = self.executable
    local exe_type = type(exe)
    -- if exe is a function or a table with a __call metamethod we call it, else we just return the data
    if (exe_type == 'function') or ((exe_type == 'table') and getmetatable(self.executable).__call) then
        exe(self, ...)
    end
end


function item.new(self, child, executable)
    local widget = background()
    widget.child = child
    widget.executable = executable

    local function func(self)
        self:execute()
    end
    
    widget:connect_signal('mouse::enter', function (self)
        if widget.state == 'disabled' then
            return
        end
        self.state = 'focus'
    end)
    
    widget:connect_signal('mouse::leave', function (self)
        if widget.state == 'disabled' then
            return
        end
        self.state = 'normal'
    end)

    widget:buttons( 
        button({}, 1, function ()
            if widget.state == 'disabled' then
                return
            end
            widget.state = 'press'
        end, function ()
            if widget.state == 'disabled' then
                return
            end
            widget.state = 'focus'
            widget:execute()
        end)
    )


    return gtable.crush(widget, item, true)
end

item.mt.__call = item.new

return setmetatable(item, item.mt)

