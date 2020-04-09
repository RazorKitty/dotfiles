local gtable = require('gears.table')
local layout = require('wibox.layout.fixed')
local keygrabber = require('awful.keygrabber')

local menu = {}
local menu_mt = {}
menu.class = 'menu'

function menu.set_focus(self, index)
    if index ~= self.focus then
        if self.focus then
            self.children[self.focus].focus = false
        end
        self._private.focus = (type(index) == 'number' and index or 1) or false
        if self.focus and self.children[self.focus] then
            self.children[self.focus].focus = true
            self:emit_signal('children::focus', self.focus)
        end  
    end
end

function menu.get_focus(self)
    return self._private.focus or false
end

function menu.set_keygrabber(self, kg)
    self._private.keygrabber = kg
    self:emit_signal('property::keygrabber', kg)
end

function menu.get_keygrabber(self)
    return self._private.keygrabber
end

function menu.set_selected(self, widget)
    for i,w in pairs(self.children) do
        if w == widget then
            self.focus = i
        end
    end
    self:emit_signal('property::selected')
end

function menu.get_selected(self)
    if self.focus then
        return self.children[self.focus]
    end
end

function menu.next(self)
    if self.focus then
        local new_focus
        for i = self.focus+1, #self.children, 1 do
            if self.children[i] and self.children[i].visible and self.children[i].class == 'item' then
                new_focus = i
                break
            end
        end
        self.focus = new_focus or self.focus
    else
        self.focus = true
    end
    self:emit_signal('menu::next')
end

function menu.previous(self)
    if self.focus then
        local new_focus
        for i = self.focus-1, 1, -1 do
            if self.children[i] and self.children[i].visible and self.children[i].class == 'item' then
                new_focus = i
                break
            end
        end
        self.focus = new_focus or self.focus
    else
        self.focus = true
    end
    self:emit_signal('menu::previous')
end

function menu.start(self)
    self.focus = true
    self._private.last_visible = self.visible
    self.visible = true
    self.keygrabber = self.keygrabber or keygrabber {
        stop_event = 'press',
        keybindings = {
            {{}, 'q', function (kg)
                self:done()
            end},
            {{}, 'h', function (kg)
                self:cancel()
            end},
            {{}, 'j', function (kg)
                self:next()
            end},
            {{}, 'k', function (kg)
                self:previous()
            end},
            {{}, 'l', function (kg)
                self.selected:execute(self)
            end}
        }
    }
    self._private.last_grabber = keygrabber.current_instance

    if self._private.last_grabber then
        self._private.last_grabber:stop()
    end
    self.keygrabber:start()
    
    self:emit_signal('menu::started')
end

function menu.stop(self)
    self.keygrabber:stop()
    self.visible = self._private.last_visible
    if self._private.last_grabber then
        self._private.last_grabber:start()        
    end
    self:emit_signal('menu::stopped')
end

function menu.done(self)
    self:stop()
    self:emit_signal('menu::done')
end

function menu.cancel(self)
    self:stop()
    self:emit_signal('menu::canceled')
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

