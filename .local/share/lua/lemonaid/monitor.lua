local setmetatable = setmetatable

local color = require('lemonaid.color')
local markup = require('lemonaid.markup')

local desktop = require('lemonaid.desktop')

local monitor = {
    bg_focus = color.bright_black,
    fg_focus = color.bright_white,
    bg_normal = color.black,
    fg_normal = color.white,
    padding = 4,
    spacing = 0,
    focus = false,
    name = 'monitor',
    desktop_settings = {},
    node_flags = '',
    node_state = '',
    desktop_layout = '',
    desktop_settings = {
        bg_focused_occupied   = color.bright_black,
        fg_focused_occupied   = color.bright_white,

        bg_focused_free       = color.bright_black,
        fg_focused_free       = color.bright_white,

        bg_focused_urgent     = color.bright_black,
        fg_focused_urgent     = color.bright_white,

        bg_unfocused_occupied = color.black,
        fg_unfocused_occupied = color.bright_white,

        bg_unfocused_free     = color.black,
        fg_unfocused_free     = color.blue,

        bg_unfocused_urgent   = color.red,
        fg_unfocused_urgent   = color.bright_white,

        pad = 4,
    }
}

function monitor.new(self, obj)
    obj = obj or {}
    obj.desktops = obj.desktops or {}
    self.__index = self
    return setmetatable(obj, self)
end

function monitor.render_name(self)
    local fg
    local bg

    if self.focus then
        fg = self.fg_focus
        bg = self.bg_focus
    else
        fg = self.fg_normal
        bg = self.bg_normal
    end
    return markup.color(fg, bg, markup.pad(self.padding, self.name), true)
end

function monitor.render_desktops(self, display)
    local desktops = ''
    for _,desktop in ipairs(self.desktops) do
        desktops = desktops .. desktop:render(display)
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
 
    local line = ''

    for _,key in ipairs(display) do
        if self['render_'..key.name] then
            line = line .. self['render_'..key.name](self, key.args)
        end
    end

    return line
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

    local node_flags = parts[#parts]:match('[G](*?)$')
    if node_flags then
        self.node_flags = node_flags
        -- pop!
        table.remove(parts)
    end

    local node_state = parts[#parts]:match('[T]([%g])')
    if node_state then
        self.node_state = node_state
        -- pop!
        table.remove(parts)
    end

    local desktop_layout = parts[#parts]:match('[L]([%g])')

    if desktop_layout then
        self.desktop_layout = desktop_layout
        -- pop!
        table.remove(parts)
    end

    -- update or create desktops
    for i,part in ipairs(parts) do
        if not self.desktops[i] then
            self.desktops[i] = desktop:new {
                bg_focused_occupied   = self.desktop_settings.bg_focused_occupied,
                fg_focused_occupied   = self.desktop_settings.fg_focused_occupied,

                bg_focused_free       = self.desktop_settings.bg_focused_free,
                fg_focused_free       = self.desktop_settings.fg_focused_free,

                bg_focused_urgent     = self.desktop_settings.bg_focused_urgent,
                fg_focused_urgent     = self.desktop_settings.fg_focused_urgent,

                bg_unfocused_occupied = self.desktop_settings.bg_unfocused_occupied,
                fg_unfocused_occupied = self.desktop_settings.fg_unfocused_occupied,

                bg_unfocused_free     = self.desktop_settings.bg_unfocused_free,
                fg_unfocused_free     = self.desktop_settings.fg_unfocused_free,

                bg_unfocused_urgent   = self.desktop_settings.bg_unfocused_urgent,
                fg_unfocused_urgent   = self.desktop_settings.fg_unfocused_urgent,

                index = i
            }
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
