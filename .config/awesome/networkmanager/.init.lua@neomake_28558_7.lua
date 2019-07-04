local wibox = require('wibox')
local awful = require('awful')
local lgi = require('lgi')

local panel_widget = wibox.widget {
    widget = wibox.container.background,
    bg = theme.netowrkmanager_panel_bg,
    fg = theme.networkmanager_panel_fg,
    {
        id = "_margin",
        widget = wibox.container.margin,
        top = theme.netowrkmanager_panel_margin_top or 0,
        bottom = theme.netowrkmanager_panel_margin_bottom or 0,
        left = theme.netowrkmanager_panel_margin_left or 0,
        right = theme.netowrkmanager_panel_margin_right or 0,
        {
            id = "_info",
            layout = wibox.layout.fixed.horizontal,
            spacing = theme.networkmanager_panel_spacing or 0,
            {
                id = "conname",
                widget = wibox.widget.textbox,
                text = 
            },
            {
                id = "signal_strength",
                widget = wibox.widget.progressbar,
                max_value = 100,
                value =,
                forced_width = 64
            }
        }
    }
}
