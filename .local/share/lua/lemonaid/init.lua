local lemonaid = {
    padding = os.getenv('PADDING'),
    color = {
        black          = os.getenv('BLACK'),
        red            = os.getenv('RED'),
        green          = os.getenv('GREEN'),
        yellow         = os.getenv('YELLOW'),
        blue           = os.getenv('BLUE'),
        magenta        = os.getenv('MAGENTA'),
        cyan           = os.getenv('CYAN'),
        white          = os.getenv('WHITE'),
        bright_black   = os.getenv('BRIGHT_BLACK'),
        bright_red     = os.getenv('BRIGHT_RED'),
        bright_green   = os.getenv('BRIGHT_GREEN'),
        bright_yellow  = os.getenv('BRIGHT_YELLOW'),
        bright_blue    = os.getenv('BRIGHT_BLUE'),
        bright_magenta = os.getenv('BRIGHT_MAGENTA'),
        bright_cyan    = os.getenv('BRIGHT_CYAN'),
        bright_white   = os.getenv('BRIGHT_WHITE')
    },
    markup = {}

}

function lemonaid.markup.fg(color)
    return '%{F'..(color or '-')..'}'
end

function lemonaid.markup.bg(color)
    return '%{B'..(color or '-')..'}'
end

function lemonaid.markup.color_fg(color, content, close)
    return lemonaid.markup.fg(color)..content..(close and fg() or '')
end

function lemonaid.markup.color_bg(color, content, close)
    return lemonaid.markup.bg(color)..content..(close and bg() or '')
end

function lemonaid.markup.color(fg, bg, content, close)
    return lemonaid.markup.color_fg(fg, lemonaid.markup.color_bg(bg, content, close), close)
end

function lemonaid.markup.pad_left(width, content)
    return '%{'..width..'}'..content
end

function lemonaid.markup.pad_right(width, content)
    return content..'%{'..width..'}'
end

function lemonaid.markup.pad(width, content, alt_width)
    return lemonaid.markup.pad_left(width, lemonaid.markup.pad_right((alt_width or width), content))
end


return lemonaid

