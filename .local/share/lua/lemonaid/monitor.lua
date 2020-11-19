local setmetatable = setmetatable

local color = require('lemonaid.color')
local markup = require('lemonaid.markup')

local desktop = require('lemonaid.desktop')

local monitor = {
    bg_focus = color.black,
    fg_focus = color.white,
    bg_normal = color.black,
    fg_normal = color.white,
    focus = false,
    name = 'monitor',
    desktop_settings = {}
}

function monitor.new(self, obj)
    obj = obj or {}
    obj.desktops = obj.desktops or {}
    self.__index = self
    return setmetatable(obj, self)
end

function monitor.render_desktops(self)
    local desktops = ''
    for _,desktop in ipairs(self.desktops) do
        desktops = desktops .. desktop:render()
    end
    return desktops
end

function monitor.render_node_state(self)
    return ''
end

function monitor.render_node_flags(self)
    return ''
end

function monitor.render_desktop_layout(self)
    return ''
end

function monitor.render(self, display)
    local fg
    local bg

    if self.focus then
        fg = self.fg_focus
        bg = self.bg_focus
    else
        fg = self.fg_normal
        bg = self.bg_normal
    end
 
    local line = ''

    for _, part in ipairs(display) do
        if self['render_'..part] then
            line = line .. self['render_'..part](self)
        end
    end

    return markup.color(fg, bg, line, true)
end

function monitor.state(self, state)
    -- buffer
    local parts = {}

    -- split string
    for part in state:gmatch('[^:]+') do
        table.insert(parts, part)
    end

    -- set focus, name, flags, state, and layout
    self.focus = parts[1]:match('M') and true or false
    self.name = parts[1]:match('[W]?[Mm]([%g]*)')
    table.remove(parts, 1)

    self.node_flags = parts[#parts]:match('[G]([%g])')
    -- pop!
    table.remove(parts)

    self.node_state = parts[#parts]:match('[T]([%g])')
    -- pop!
    table.remove(parts)

    self.desktop_layout = parts[#parts]:match('[L]([%g])')
    -- pop!
    table.remove(parts)

    -- update or create desktops
    for i,part in ipairs(parts) do
        if not self.desktops[i] then
            self.desktops[i] = desktop:new(self.desktop_settings)
        end
        self.desktops[i]:state(part)
    end
    
    -- remove extra desktops
    while #self.desktops > #parts do
        -- pop!
        table.remove(self.desktops)
    end    
end

return monitor
