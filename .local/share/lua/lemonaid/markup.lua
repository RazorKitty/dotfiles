local color = require('lemonaid.color')
local padding = os.getenv('PADDING')

local markup = {}

function markup.fg(color)
    return '%{F'..(color or '-')..'}'
end

function markup.bg(color)
    return '%{B'..(color or '-')..'}'
end

function markup.color_fg(color, content, close)
    return markup.fg(color)..content..(close and markup.fg() or '')
end

function markup.color_bg(color, content, close)
    return markup.bg(color)..content..(close and markup.bg() or '')
end

function markup.color(fg, bg, content, close)
    return markup.color_fg(fg, markup.color_bg(bg, content, close), close)
end

function markup.pad_left(width, content)
    return '%{P'..width..'}'..content
end

function markup.pad_right(width, content)
    return content..'%{P'..width..'}'
end

function markup.pad(width, content, alt_width)
    return markup.pad_left(width, markup.pad_right((alt_width or width), content))
end

return markup
