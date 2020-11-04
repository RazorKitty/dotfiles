local math = math
local setmetatable = setmetatable

local lemonaid = require('lemonaid')
local markup = lemonaid.markup
local color = lemonaid.color

local progressbar = {
    length = 16,
    wrap_left = '[',
    wrap_right = ']',
    wrap_fg = lemonaid.color.white,
    wrap_bg = lemonaid.color.black,
    segment = '=',
    segment_fg = lemonaid.color.white,
    segment_bg = lemonaid.color.black,
    fill = ' ',
    fill_fg = lemonaid.color.white,
    fill_bg = lemonaid.color.black,
    pivot = '>',
    pivot_fg = lemonaid.color.white,
    pivot_bg = lemonaid.color.black,
    reverse = false,
    percentage = 0,
    color = false,
    __mt = {}
}

function progressbar.render(self)
    local level = self.segment:rep(
        math.floor(
            self.length * (
                (self.percentage < 1)
                    and self.percentage
                    or 1
            )
        ) - 1
    )
    local filler = self.fill:rep((self.length -1) - #level)
    
    if not self.color then
        local left = self.reverse and filler or level
        local right = self.reverse and level or filler
        return self.wrap_left..left..self.pivot..right..self.wrap_right
    end
    
    local wrap_left = markup.color(self.wrap_fg, self.wrap_bg, self.wrap_left)
    local wrap_right = markup.color(self.wrap_fg, self.wrap_bg, self.wrap_right)
    



end

function progressbar.new(self, object)
    object = object or {}
    self.__index = self
    return setmetatable(object, self)
end

progressbar.__mt.__call = progressbar.new
return setmetatable(progressbar, progressbar.__mt)
