local setmetatable = setmetatable

local color = require('lemonaid.color')
local markup = require('lemonaid.markup')

local desktop = {
    bg_focused_occupied = color.bright_black,
    fg_focused_occupied = color.bright_white,

    bg_focused_free = color.bright_black,
    fg_focused_free = color.bright_white,

    bg_focused_urgent = color.bright_black,
    fg_focused_urgent = color.bright_white,

    bg_unfocused_occupied = color.black,
    fg_unfocused_occupied = color.bright_white,

    bg_unfocused_free = color.black,
    fg_unfocused_free = color.white,

    bg_unfocused_urgent = color.red,
    fg_unfocused_urgent = color.bright_white,

    pad = 4,

    desktop_state = 'f',
    focus = false,
    name = 'desktop'
}

function desktop.new(self, obj)
    obj = obj or {}
    self.__index = self
    return setmetatable(obj, self)
end

local desktop_state_loopup = {
    f = 'free',
    o = 'occupied',
    u = 'urgent'
}

function desktop.render(self)
    local fg
    local bg

    if self.desktop_state == self.desktop_state:upper() then
        fg = self['fg_focused_'..desktop_state_loopup[self.desktop_state:lower()]]
        bg = self['bg_focused_'..desktop_state_loopup[self.desktop_state:lower()]]
    else
        fg = self['fg_unfocused_'..desktop_state_loopup[self.desktop_state:lower()]]
        bg = self['bg_unfocused_'..desktop_state_loopup[self.desktop_state:lower()]]
    end

    return markup.color(fg, bg, markup.pad(self.pad, self.name) ,true)

end

function desktop.state(self, state)
    self.name = state:match('^[OoFfUu]([%g ]+)$')
    self.desktop_state = state:match('^[OoFfUu]*')
end

return desktop
