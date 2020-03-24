local gtable = require('gears.table')
local base = require("wibox.widget.base")
local layout = require('wibox.layout.fixed')

local menu = {}
local menu_mt = {}

function menu.set_focus(self, index)
    if index ~= self.focus then
        if self.focus then
            self.children[self.focus].focus = false
        end
        self._private.focus = (type(index) == 'number' and index or 1) or false
        if self.focus and self.children[self.focus] then
            self.children[self.focus].focus = true
            self:emit_signal('property::focus', self.focus)
        end  
    end
end

function menu.get_focus(self)
    return self._private.focus or false
end

function menu.next(self)
    if self.focus then
        local new_focus
        for i = self.focus+1, #self.children, 1 do
            if self.children[i] and self.children[i].visible then
                new_focus = i
                break
            end
        end
        self.focus = new_focus or self.focus
    else
        self.focus = true
    end
end

function menu.previous(self)
    if self.focus then
        local new_focus
        for i = self.focus-1, 1, -1 do
            if self.children[i] and self.children[i].visible then
                new_focus = i
                break
            end
        end
        self.focus = new_focus or self.focus
    else
        self.focus = true
    end
end

function menu.select(self)
    if self.focus then
        return self.children[self.focus]
    end
end

function menu.filter(self, filter)
    for i,widget in ipairs(self.children) do
        widget.visible = filter(widget.userdata)
    end
end

function menu.order(self, comp)
    local children = self.children
    table.sort(children, comp)
    self.children = children
end

local function new(orientation)
    local widget = layout[orientation or 'horizontal']()
    return gtable.crush(widget, menu, true)
end

function menu.horizontal()
    return new('horizontal')
end

function menu.vertical()
    return new('vertical')
end

function menu_mt.__call(_, ...)
    return new(...)
end

return setmetatable(menu, menu_mt)

