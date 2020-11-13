local setmetatable = setmetatable

local color = require('lemonaid.color')
local markup = require('lemonaid.markup')

local monitor = {
    bg_focus = color.black,
    fg_focus = color.white,
    bg_normal = color.black,
    fg_normal = color.white,
    focus = false,
    name = ''
}

function monitor.new(self, obj)
    obj = obj or {}
    self.__index = self
    return setmetatable(obj, self)
end

function monitor.render(self)
    local fg
    local bg

    if self.focus then
        fg = self.fg_focus
        bg = self.bg_focus
    else
        fg = self.fg_normal
        bg = self.bg_normal
    end

    local desktops = ''

    for _,desktop in ipairs(self.desktops) do
        desktops = desktops .. desktop:render()
    end





end
