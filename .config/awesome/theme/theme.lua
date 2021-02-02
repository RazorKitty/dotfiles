--------------------------------------------------------------------------------
--    Awesome theme for Void linux based on                                   --
--    using xrdb config based on the theme by Yauhen Kirylau                  --
--------------------------------------------------------------------------------

local gears = require('gears')
local theme_assets = require("beautiful.theme_assets")
local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi

local get_xresources_theme = function()
    local keys = { 'background', 'foreground', 'cursorColor' }
    for i=0,23 do table.insert(keys, 'color'..i) end
    local xresources = {}
    for _, key in ipairs(keys) do
        local color = awesome.xrdb_get_value('', key)
        if color then
            if color:find('rgb:') then
                color = '#'..color:gsub('[a]?rgb:', ''):gsub('/', '')
            end
        end
        xresources[key] = color
    end
    return xresources
end

local xrdb = get_xresources_theme()

local theme = {}
local theme_path = os.getenv('HOME')..'/.config/awesome/theme/'
theme.wallpaper = theme_path..'wallpaper.png'


-- {{{ Styles
theme.font  = 'terminus 8'

theme.foreground = xrdb.foreground
theme.background = xrdb.background
theme.black      = xrdb.color0
theme.red        = xrdb.color1
theme.green      = xrdb.color2
theme.yellow     = xrdb.color3
theme.blue       = xrdb.color4
theme.magenta    = xrdb.color5
theme.cyan       = xrdb.color6
theme.white      = xrdb.color7

theme.bright_black   = xrdb.color8
theme.bright_red     = xrdb.color9
theme.bright_green   = xrdb.color10
theme.bright_yellow  = xrdb.color11
theme.bright_blue    = xrdb.color12
theme.bright_magenta = xrdb.color13
theme.bright_cyan    = xrdb.color14
theme.bright_white   = xrdb.color15

-- {{{ Colors
theme.fg_normal  = theme.white
theme.fg_focus   = theme.bright_white
theme.fg_urgent  = theme.bright_white
theme.bg_normal  = theme.black
theme.bg_focus   = theme.bright_black
theme.bg_urgent  = theme.red
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.useless_gap   = dpi(4)
theme.border_width  = dpi(2)
theme.border_normal = theme.bg_normal
theme.border_focus  = theme.bg_focus
theme.border_marked = theme.blue
-- }}}
theme.awesome_icon = theme_assets.awesome_icon(dpi(96), theme.white, theme.black)

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- tasklist
theme.tasklist_fg_normal = theme.fg_normal
theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_fg_focus = theme.fg_focus
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_fg_urgent = theme.fg_urgent
theme.tasklist_bg_urgent = theme.bg_urgent
theme.tasklist_fg_minimize = theme.fg_minimize
theme.tasklist_bg_minimize = theme.bg_minimize
-- theme.tasklist_bg_image_normal = nil
-- theme.tasklist_bg_image_focus = nil
-- theme.tasklist_bg_image_urgent = nil
-- theme.tasklist_bg_image_minimize = nil
theme.tasklist_disable_icon = true
-- theme.tasklist_disable_task_name = nil
-- theme.tasklist_plain_task_name = nil
-- theme.tasklist_font = nil
-- theme.tasklist_align = nil
-- theme.tasklist_font_focus = nil
-- theme.tasklist_font_minimized = nil
-- theme.tasklist_font_urgent = nil
-- theme.tasklist_spacing = nil
-- theme.tasklist_shape = nil
-- theme.tasklist_shape_border_width = nil
-- theme.tasklist_shape_border_color = nil
-- theme.tasklist_shape_focus = nil
-- theme.tasklist_shape_border_width_focus = nil
-- theme.tasklist_shape_border_color_focus = nil
-- theme.tasklist_shape_minimized = nil
-- theme.tasklist_shape_border_width_minimized = nil
-- theme.tasklist_shape_border_color_minimized = nil
-- theme.tasklist_shape_urgent = nil
-- theme.tasklist_shape_border_width_urgent = nil
-- theme.tasklist_shape_border_color_urgent = nil


theme.widget_margin_outer = dpi(8)
theme.widget_margin_inner = dpi(2)
theme.widget_spacing = dpi(4)

theme.system_tray = {
    background = {
        bg = theme.bg_normal,
        fg = theme.fg_normal
    },
    margin = {
        left = dpi(8),
        right = dpi(8),
    }
}

theme.player =  {
    background = {
        bg = theme.bg_normal,
        fg = theme.fg_normal
    },
    background_playback_status = {
        bg = {
            PLAYING = theme.bg_focus,
            PAUSED = theme.bg_normal,
            STOPPED = theme.bg_normal
        },
        fg = {
            PLAYING = theme.fg_focus,
            PAUSED = theme.fg_normal,
            STOPPED = theme.fg_normal
        }
    },
    margin = {
        left = dpi(8),
        right = dpi(8),
    },
    layout = {
        spacing = dpi(4)
    },
    progressbar = {
        bg = theme.background,
        fg = theme.bright_blue,
        shape = nil,
        border_color = theme.white,
        border_width = dpi(1),
        bar_shape = nil,
        bar_border_width = dpi(0),
        bar_border_color = nil,
        margins = {
            left = dpi(0),
            right = dpi(0),
            top = dpi(6),
            bottom = dpi(6)
        },
        paddings = dpi(1),
        width = dpi(64)
    }
}

theme.network =  {
    background = {
        bg = theme.bg_normal,
        fg = theme.fg_normal
    },
    margin = {
        left = dpi(8),
        right = dpi(8),
    },
    layout = {
        spacing = dpi(4)
    },
    progressbar = {
        bg = theme.background,
        fg = theme.bright_blue,
        shape = nil,
        border_color = theme.white,
        border_width = dpi(1),
        bar_shape = nil,
        bar_border_width = dpi(0),
        bar_border_color = nil,
        margins = {
            left = dpi(0),
            right = dpi(0),
            top = dpi(6),
            bottom = dpi(6)
        },
        paddings = dpi(1),
        width = dpi(64)
    }
}

theme.power =  {
    background = {
        bg = theme.bg_normal,
        fg = theme.fg_normal
    },
    margin = {
        left = dpi(8),
        right = dpi(8),
    },
    layout = {
        spacing = dpi(4)
    },
    progressbar = {
        bg = theme.background,
        fg = {
            theme.bright_red,
            theme.bright_yellow,
            theme.green,
            theme.bright_green
        },
        shape = nil,
        border_color = {
            theme.white,
            theme.green
        },
        border_width = dpi(1),
        bar_shape = nil,
        bar_border_width = dpi(0),
        bar_border_color = nil,
        margins = {
            left = dpi(0),
            right = dpi(0),
            top = dpi(6),
            bottom = dpi(6)
        },
        paddings = dpi(1),
        width = dpi(64)
    }
}

theme.layoutbox = {
    background = {
        bg = theme.bg_normal,
        fg = theme.fg_normal
    },
    margin = {
        left = dpi(8),
        right = dpi(8),
    }
}

theme.panel_datetime_bg = theme.bg_normal
theme.panel_datetime_fg = theme.fg_normal


-- progressbar
theme.progressbar_bg = theme.background
theme.progressbar_fg = theme.white
-- theme.progressbar_shape = nil
theme.progressbar_border_color = theme.white
theme.progressbar_border_width = dpi(1)
-- theme.progressbar_bar_shape = nil
theme.progressbar_bar_border_width = dpi(0)
theme.progressbar_bar_border_color = theme.fg_normal
theme.progressbar_margins = {
    left = dpi(0),
    right = dpi(0),
    top = dpi(6),
    bottom = dpi(6)
}
theme.progressbar_paddings = dpi(1)

theme.progressbar_width = dpi(64)

-- checkbox
theme.checkbox_border_width = dpi(1)
theme.checkbox_bg = theme.bg_normal
theme.checkbox_border_color = theme.fg_normal
theme.checkbox_check_border_color = theme.fg_normal
theme.checkbox_check_border_width = dpi(1)
theme.checkbox_check_color = theme.fg_normal
theme.checkbox_shape = gears.shape.square
theme.checkbox_check_shape = gears.shape.square
theme.checkbox_paddings = {
    left = dpi(1),
    right = dpi(1),
    top = dpi(1),
    bottom = dpi(1)
}
theme.checkbox_color = theme.fg_normal

-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = theme.bright_white
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- theme.menu_submenu_icon = nil
theme.menu_font = theme.font
-- theme.menu_height = nil
theme.menu_width = dpi(96)
theme.menu_border_color = theme.background
theme.menu_border_width = dpi(1)
theme.menu_fg_focus = theme.fg_focus
theme.menu_bg_focus = theme.bg_focus
theme.menu_fg_normal = theme.fg_normal
theme.menu_bg_normal = theme.bg_normal

theme.menu_submenu = ' > '
-- }}}

-- wibar
 theme.wibar_stretch = true
theme.wibar_border_width = dpi(1)
theme.wibar_border_color = theme.background
theme.wibar_ontop = false
-- theme.wibar_cursor = nil
-- theme.wibar_opacity = nil
-- theme.wibar_type = nil
-- theme.wibar_width = nil
theme.wibar_bg = theme.background
-- theme.wibar_bgimage = nil
theme.wibar_fg = theme.foreground
-- theme.wibar_shape = nil

-- {{{ Taglist
theme.taglist_fg_focus = theme.fg_focus
theme.taglist_bg_focus = theme.bg_focus
theme.taglist_fg_urgent = theme.fg_urgent
theme.taglist_bg_urgent = theme.bg_urgent
theme.taglist_fg_occupied = theme.fg_normal
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_fg_empty = theme.fg_minimize
theme.taglist_bg_empty = theme.bg_minimize

--theme.taglist_squares_sel   = theme_path .. "taglist/squarefw.png"
--theme.taglist_squares_unsel = theme_path .. "taglist/squarew.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Layout
theme.layout_tile       = theme_path .. "layouts/tile.png"
theme.layout_tileleft   = theme_path .. "layouts/tileleft.png"
theme.layout_tilebottom = theme_path .. "layouts/tilebottom.png"
theme.layout_tiletop    = theme_path .. "layouts/tiletop.png"
theme.layout_fairv      = theme_path .. "layouts/fairv.png"
theme.layout_fairh      = theme_path .. "layouts/fairh.png"
theme.layout_spiral     = theme_path .. "layouts/spiral.png"
theme.layout_dwindle    = theme_path .. "layouts/dwindle.png"
theme.layout_max        = theme_path .. "layouts/max.png"
theme.layout_fullscreen = theme_path .. "layouts/fullscreen.png"
theme.layout_magnifier  = theme_path .. "layouts/magnifier.png"
theme.layout_floating   = theme_path .. "layouts/floating.png"
theme.layout_cornernw   = theme_path .. "layouts/cornernw.png"
theme.layout_cornerne   = theme_path .. "layouts/cornerne.png"
theme.layout_cornersw   = theme_path .. "layouts/cornersw.png"
theme.layout_cornerse   = theme_path .. "layouts/cornerse.png"
-- }}}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
