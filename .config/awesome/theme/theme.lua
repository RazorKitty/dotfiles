--------------------------------------------------------------------------------
--    Awesome theme for Void linux based on                                   --
--    using xrdb config based on the theme by Yauhen Kirylau                  --
--------------------------------------------------------------------------------

local gears = require('gears')
local theme_assets = require('beautiful.theme_assets')
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

local theme_dir = os.getenv('HOME')..'/.config/awesome/theme/'

local theme = {}

theme.font  = 'terminus 8'

-- Default variables

theme.foreground = xrdb.foreground
theme.background = xrdb.background
theme.black = xrdb.color0
theme.red = xrdb.color1
theme.green = xrdb.color2
theme.yellow = xrdb.color3
theme.blue = xrdb.color4
theme.magenta = xrdb.color5
theme.cyan = xrdb.color6
theme.white = xrdb.color7

theme.bright_black = xrdb.color8
theme.bright_red = xrdb.color9
theme.bright_green = xrdb.color10
theme.bright_yellow = xrdb.color11
theme.bright_blue = xrdb.color12
theme.bright_magenta = xrdb.color13
theme.bright_cyan = xrdb.color14
theme.bright_white = xrdb.color15

theme.useless_gap = dpi(4)

theme.bg_normal = theme.black
theme.fg_normal = theme.white

theme.bg_focus = theme.bright_black
theme.fg_focus = theme.bright_white

theme.bg_important = theme.white
theme.fg_important = theme.black

theme.bg_urgent = theme.red
theme.fg_urgent = theme.bright_white

theme.bg_minimize = theme.bg_normal
theme.fg_minimize = theme.blue


theme.bg_systray = theme.black

theme.border_width = dpi(1)
theme.border_normal = theme.black
theme.border_focus = theme.white
theme.border_marked = theme.blue
theme.wallpaper = theme_dir..'wallpaper.png'

local wallpaper_bg = theme.background
local wallpaper_fg = theme.bright_black
local wallpaper_alt_fg = theme.white
--theme.wallpaper = function(s)
--    return theme_assets.wallpaper(wallpaper_bg, wallpaper_fg, wallpaper_alt_fg, s)
--end

-- arcchart
-- theme.arcchart_border_color = nil
-- theme.arcchart_color = nil
-- theme.arcchart_border_width = nil
-- theme.arcchart_paddings = nil
-- theme.arcchart_thickness = nil

-- awesome
theme.awesome_icon = theme_assets.awesome_icon(dpi(96), theme.white, theme.black)

-- generic widget themeing colors
theme.widget_normal_fg = theme.fg_normal
theme.widget_normal_bg = theme.bg_normal

theme.widget_focus_fg = theme.fg_focus
theme.widget_focus_bg = theme.bg_focus

theme.widget_warning_fg = theme.black
theme.widget_warning_bg = theme.yellow

theme.widget_urgent_fg = theme.fg_urgent
theme.widget_urgent_bg = theme.bg_urgent

theme.widget_important_fg = theme.black
theme.widget_important_bg = theme.blue

theme.widget_online_fg = theme.black
theme.widget_online_bg = theme.green

-- calendar
-- theme.calendar_style = nil
theme.calendar_font = theme.font
-- theme.calendar_spacing = nil
-- theme.calendar_week_numbers = nil
theme.calendar_start_sunday = false
theme.calendar_long_weekdays = false

-- checkbox
theme.checkbox_border_width = 1
theme.checkbox_bg = theme.bg_normal
theme.checkbox_border_color = theme.fg_normal
theme.checkbox_check_border_color = theme.fg_normal
theme.checkbox_check_border_width = 1
theme.checkbox_check_color = theme.fg_normal
theme.checkbox_shape = gears.shape.square
theme.checkbox_check_shape = gears.shape.square
theme.checkbox_paddings = 0
theme.checkbox_color = theme.fg_normal

-- graph
theme.graph_bg = theme.black
theme.graph_fg = theme.fg_normal
theme.graph_border_color = theme.bg_normal

-- hotkeys
-- theme.hotkeys_bg = theme.bg_normal
-- theme.hotkeys_fg = theme.fg_normal
-- theme.hotkeys_border_width = dpi(2)
-- theme.hotkeys_border_color = theme.border_normal
-- theme.hotkeys_shape = nil
theme.hotkeys_modifiers_fg = theme.bright_white
-- theme.hotkeys_label_bg = theme.bg_normal
-- theme.hotkeys_label_fg = theme.fg_normal
theme.hotkeys_font = theme.font
theme.hotkeys_description_font = theme.font
-- theme.hotkeys_group_margin = nil

-- icon
-- theme.icon_theme = nil

-- layout
theme.layout_tile = theme_dir..'layouts/tile.png'
theme.layout_tiletop = theme_dir..'layouts/tiletop.png'
theme.layout_tilebottom = theme_dir..'layouts/tilebottom.png'
theme.layout_tileleft = theme_dir..'layouts/tileleft.png'
theme.layout_max = theme_dir..'layouts/max.png'
theme.layout_fullscreen = theme_dir..'layouts/fullscreen.png'
theme.layout_fairh = theme_dir..'layouts/fairh.png'
theme.layout_fairv = theme_dir..'layouts/fairv.png'
theme.layout_cornernw = theme_dir..'layouts/cornernw.png'
theme.layout_cornerne = theme_dir..'layouts/cornerne.png'
theme.layout_cornersw = theme_dir..'layouts/cornersw.png'
theme.layout_cornerse = theme_dir..'layouts/cornerse.png'
theme.layout_floating = theme_dir..'layouts/floating.png'
theme.layout_spiral = theme_dir..'layouts/spiral.png'
theme.layout_dwindle = theme_dir..'layouts/dwindle.png'
theme.layout_magnifier = theme_dir..'layouts/magnifier.png'

theme = theme_assets.recolor_layout(theme, theme.fg_normal)

-- master
theme.master_width_factor = 0.54
-- theme.master_fill_policy = nil
theme.master_count = 1

-- column
--theme.column_count = 2

-- cursor
-- theme.cursor_mouse_resize = nil
-- theme.cursor_mouse_move = nil

-- enable
-- theme.enable_spawn_cursor = nil

-- fullscreen
theme.fullscreen_hide_border = true

-- gap
theme.gap_single_client = true

-- maximized
-- theme.maximized_honor_padding = nil

-- theme.mpd_currentsong_title_fg = nil
-- theme.mpd_currentsong_title_bg = nil
-- theme.mpd_currentsong_artist_fg = nil
-- theme.mpd_currentsong_artist_bg = nil
-- theme.mpd_currentsong_album_fg = nil
-- theme.mpd_currentsong_album_fg = nil

-- menu
-- theme.menu_submenu_icon = nil
theme.menu_font = theme.font
-- theme.menu_height = nil
theme.menu_width = dpi(96)
theme.menu_border_color = theme.background
theme.menu_border_width = theme.border_width
theme.menu_fg_focus = theme.fg_focus
theme.menu_bg_focus = theme.bg_focus
theme.menu_fg_normal = theme.fg_normal
theme.menu_bg_normal = theme.bg_normal

theme.menu_submenu = ' > '

-- amenu


-- notification
theme.notification_font = theme.font
theme.notification_bg = theme.bg_normal
theme.notification_fg = theme.fg_normal
theme.notification_border_width = dpi(2)
theme.notification_border_color = theme.border_normal
-- theme.notification_shape = nil
-- theme.notification_opacity = nil
theme.notification_margin = dpi(32)
-- theme.notification_width = dpi(512)
-- theme.notification_height = dpi(128)
--theme.notification_max_width = dpi(512)
--theme.notification_max_height = dpi(128)
-- theme.notification_icon_size = nil

-- piechart
-- theme.piechart_border_color = nil
-- theme.piechart_border_width = nil
-- theme.piechart_colors = nil

-- progressbar
theme.progressbar_bg = theme.background
theme.progressbar_fg = theme.bright_white
-- theme.progressbar_shape = nil
theme.progressbar_border_color = theme.background
theme.progressbar_border_width = dpi(1)
-- theme.progressbar_bar_shape = nil
theme.progressbar_bar_border_width = dpi(0)
theme.progressbar_bar_border_color = theme.bright_white
theme.progressbar_margins = {
    left = dpi(0),
    right = dpi(0),
    top = dpi(6),
    bottom = dpi(6)
}
theme.progressbar_paddings = dpi(0)

-- prompt
theme.prompt_fg_cursor = theme.bg_focus
theme.prompt_bg_cursor = theme.fg_focus
-- theme.prompt_font = nil
theme.prompt_fg = theme.fg_focus
theme.prompt_bg = theme.bg_focus

-- radialprogressbar
-- theme.radialprogressbar_border_color = nil
-- theme.radialprogressbar_color = nil
-- theme.radialprogressbar_border_width = nil
-- theme.radialprogressbar_paddings = nil

-- separator
theme.separator_thickness = dpi(1)
theme.separator_border_color = theme.fg_normal
theme.separator_border_width = dpi(8)
theme.separator_span_ratio = 0.66
theme.separator_color = theme.fg_normal
--theme.separator_shape = nil
-- slider
-- theme.slider_bar_border_width = nil
-- theme.slider_bar_border_color = nil
-- theme.slider_handle_border_color = nil
-- theme.slider_handle_border_width = nil
-- theme.slider_handle_width = nil
-- theme.slider_handle_color = nil
-- theme.slider_handle_shape = nil
-- theme.slider_bar_shape = nil
-- theme.slider_bar_height = nil
-- theme.slider_bar_margins = nil
-- theme.slider_handle_margins = nil
-- theme.slider_bar_color = nil

-- snap
-- theme.snap_bg = nil
-- theme.snap_border_width = nil
-- theme.snap_shape = nil

-- snapper
-- theme.snapper_gap = nil

-- systray
-- theme.systray_icon_spacing = nil

-- taglist
theme.taglist_fg_focus = theme.fg_focus
theme.taglist_bg_focus = theme.bg_focus
theme.taglist_fg_urgent = theme.fg_urgent
theme.taglist_bg_urgent = theme.bg_urgent
theme.taglist_fg_occupied = theme.fg_normal
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_fg_empty = theme.fg_minimize
theme.taglist_bg_empty = theme.bg_minimize
-- theme.taglist_bg_volatile = nil
-- theme.taglist_fg_volatile = nil
-- theme.taglist_squares_sel = nil
-- theme.taglist_squares_unsel = nil
-- theme.taglist_squares_sel_empty = nil
-- theme.taglist_squares_unsel_empty = nil
-- theme.taglist_squares_resize = nil
-- theme.taglist_disable_icon = nil
-- theme.taglist_font = nil
-- theme.taglist_spacing = nil
-- theme.taglist_shape = nil
-- theme.taglist_shape_border_width = nil
-- theme.taglist_shape_border_color = nil
-- theme.taglist_shape_empty = nil
-- theme.taglist_shape_border_width_empty = nil
-- theme.taglist_shape_border_color_empty = nil
-- theme.taglist_shape_focus = nil
-- theme.taglist_shape_border_width_focus = nil
-- theme.taglist_shape_border_color_focus = nil
-- theme.taglist_shape_urgent = nil
-- theme.taglist_shape_border_width_urgent = nil
-- theme.taglist_shape_border_color_urgent = nil
-- theme.taglist_shape_volatile = nil
-- theme.taglist_shape_border_width_volatile = nil
-- theme.taglist_shape_border_color_volatile = nil

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

---[[
-- titlebar
theme.titlebar_fg_normal = theme.fg_normal
theme.titlebar_bg_normal = theme.bg_normal
-- theme.titlebar_bgimage_normal = nil
-- theme.titlebar_fg = nil
-- theme.titlebar_bg = nil
-- theme.titlebar_bgimage = nil
theme.titlebar_fg_focus = theme.fg_focus
theme.titlebar_bg_focus = theme.bg_focus
-- theme.titlebar_bgimage_focus = nil
-- theme.titlebar_floating_button_normal = nil
-- theme.titlebar_maximized_button_normal = nil
theme.titlebar_minimize_button_normal = theme_dir .. 'titlebar/minimize_normal.png' 
-- theme.titlebar_minimize_button_normal_hover = nil
-- theme.titlebar_minimize_button_normal_press = nil
theme.titlebar_close_button_normal = theme_dir .. 'titlebar/close_normal.png'
-- theme.titlebar_close_button_normal_hover = nil
-- theme.titlebar_close_button_normal_press = nil
-- theme.titlebar_ontop_button_normal = nil
-- theme.titlebar_sticky_button_normal = nil
-- theme.titlebar_floating_button_focus = nil
-- theme.titlebar_maximized_button_focus = nil
theme.titlebar_minimize_button_focus = theme_dir .. 'titlebar/minimize_focus.png'
-- theme.titlebar_minimize_button_focus_hover = nil
-- theme.titlebar_minimize_button_focus_press = nil
theme.titlebar_close_button_focus = theme_dir ..  'titlebar/close_normal.png'
-- theme.titlebar_close_button_focus_hover = nil
-- theme.titlebar_close_button_focus_press = nil
-- theme.titlebar_ontop_button_focus = nil
-- theme.titlebar_sticky_button_focus = nil
theme.titlebar_floating_button_normal_active = theme_dir .. 'titlebar/floating_normal_active.png'

-- theme.titlebar_floating_button_normal_active_hover = nil
-- theme.titlebar_floating_button_normal_active_press = nil
theme.titlebar_maximized_button_normal_active = theme_dir .. 'titlebar/maximized_normal_active.png'

-- theme.titlebar_maximized_button_normal_active_hover = nil
-- theme.titlebar_maximized_button_normal_active_press = nil
theme.titlebar_ontop_button_normal_active = theme_dir .. 'titlebar/ontop_normal_active.png'
-- theme.titlebar_ontop_button_normal_active_hover = nil
-- theme.titlebar_ontop_button_normal_active_press = nil
theme.titlebar_sticky_button_normal_active = theme_dir .. 'titlebar/sticky_normal_active.png'

-- theme.titlebar_sticky_button_normal_active_hover = nil
-- theme.titlebar_sticky_button_normal_active_press = nil
theme.titlebar_floating_button_focus_active = theme_dir .. 'titlebar/floating_focus_active.png'

-- theme.titlebar_floating_button_focus_active_hover = nil
-- theme.titlebar_floating_button_focus_active_press = nil
theme.titlebar_maximized_button_focus_active = theme_dir .. 'titlebar/maximized_focus_active.png'

-- theme.titlebar_maximized_button_focus_active_hover = nil
-- theme.titlebar_maximized_button_focus_active_press = nil
theme.titlebar_ontop_button_focus_active = theme_dir .. 'titlebar/ontop_focus_active.png' 
-- theme.titlebar_ontop_button_focus_active_hover = nil
-- theme.titlebar_ontop_button_focus_active_press = nil
theme.titlebar_sticky_button_focus_active = theme_dir .. 'titlebar/sticky_focus_active.png'

-- theme.titlebar_sticky_button_focus_active_hover = nil
-- theme.titlebar_sticky_button_focus_active_press = nil
theme.titlebar_floating_button_normal_inactive = theme_dir .. 'titlebar/floating_normal_inactive.png'

-- theme.titlebar_floating_button_normal_inactive_hover = nil
-- theme.titlebar_floating_button_normal_inactive_press = nil
theme.titlebar_maximized_button_normal_inactive = theme_dir .. 'titlebar/maximized_normal_inactive.png'

-- theme.titlebar_maximized_button_normal_inactive_hover = nil
-- theme.titlebar_maximized_button_normal_inactive_press = nil
theme.titlebar_ontop_button_normal_inactive = theme_dir .. 'titlebar/ontop_normal_inactive.png'
-- theme.titlebar_ontop_button_normal_inactive_hover = nil
-- theme.titlebar_ontop_button_normal_inactive_press = nil
theme.titlebar_sticky_button_normal_inactive = theme_dir .. 'titlebar/sticky_normal_inactive.png'

-- theme.titlebar_sticky_button_normal_inactive_hover = nil
-- theme.titlebar_sticky_button_normal_inactive_press = nil
theme.titlebar_floating_button_focus_inactive = theme_dir .. 'titlebar/floating_focus_inactive.png'

-- theme.titlebar_floating_button_focus_inactive_hover = nil
-- theme.titlebar_floating_button_focus_inactive_press = nil
theme.titlebar_maximized_button_focus_inactive = theme_dir .. 'titlebar/maximized_focus_inactive.png'

-- theme.titlebar_maximized_button_focus_inactive_hover = nil
-- theme.titlebar_maximized_button_focus_inactive_press = nil
theme.titlebar_ontop_button_focus_inactive = theme_dir .. 'titlebar/ontop_focus_inactive.png'
-- theme.titlebar_ontop_button_focus_inactive_hover = nil
-- theme.titlebar_ontop_button_focus_inactive_press = nil
theme.titlebar_sticky_button_focus_inactive = theme_dir .. 'titlebar/sticky_focus_inactive.png'

-- theme.titlebar_sticky_button_focus_inactive_hover = nil
-- theme.titlebar_sticky_button_focus_inactive_press = nil
--]]

---[[
theme = theme_assets.recolor_titlebar(theme, theme.fg_normal, 'normal')
theme = theme_assets.recolor_titlebar(theme, theme.fg_normal, 'normal', 'hover')
theme = theme_assets.recolor_titlebar(theme, theme.bg_normal, 'normal', 'press')
theme = theme_assets.recolor_titlebar(theme, theme.fg_focus, 'focus')
theme = theme_assets.recolor_titlebar(theme, theme.fg_focus, 'focus', 'hover')
theme = theme_assets.recolor_titlebar(theme, theme.bg_focus, 'focus', 'press')
--]]

-- tooltip
theme.tooltip_border_color = theme.border_normal
theme.tooltip_bg = theme.bg_normal
theme.tooltip_fg = theme.fg_normal
-- theme.tooltip_font = nil
theme.tooltip_border_width = dpi(1)
-- theme.tooltip_opacity = nil
-- theme.tooltip_shape = nil
-- theme.tooltip_align = nil

-- wibar
-- theme.wibar_stretch = false
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



return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
