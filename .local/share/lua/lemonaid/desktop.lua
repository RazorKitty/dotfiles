local setmetatable = setmetatable

local color = require('lemonaid.color')
local markup = require('lemonaid.markup')

local desktop = {
    bg_focused_occupied   = color.bright_black,
    fg_focused_occupied   = color.bright_white,

    bg_focused_free       = color.bright_black,
    fg_focused_free       = color.bright_white,

    bg_focused_urgent     = color.bright_black,
    fg_focused_urgent     = color.bright_white,

    bg_unfocused_occupied = color.black,
    fg_unfocused_occupied = color.bright_white,

    bg_unfocused_free     = color.black,
    fg_unfocused_free     = color.white,

    bg_unfocused_urgent   = color.red,
    fg_unfocused_urgent   = color.bright_white,

    padding = 4,
    index = 1,
    desktop_state = 'f',
    focus = false,
    name = 'desktop'
}

function desktop.new(self, obj)
    obj = obj or {}
    self.__index = self
    return setmetatable(obj, self)
end

function desktop.render_name(self)
    return self.name
end

function desktop.render_index(self)
    return self.index ..':'
end

local desktop_state_lookup = {
    f = 'free',
    o = 'occupied',
    u = 'urgent'
}

function desktop.render(self, display)

    local focus = self.desktop_state == self.desktop_state:upper() and '_focused_' or '_unfocused_'
    local desktop_state = desktop_state_lookup[self.desktop_state:lower()]


    local fg = self['fg'..focus..desktop_state]
    local bg = self['bg'..focus..desktop_state]

    local line = ''

    for _, name in ipairs(display) do
        line = line .. self['render_'..name](self)
    end

    return markup.color(fg, bg, markup.pad(self.padding, line), true)

end

function desktop.state(self, state)
    self.name = state:match('^[OoFfUu]([%g ]+)$')
    self.desktop_state = state:match('^([OoFfUu])*?')
end

return desktop
