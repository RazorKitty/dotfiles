--------------------------------------------------------------------------------
----------------------- AwesomeWM 4.2 void linux config ------------------------
-----------------------     by RazorKitty@null.net      ------------------------
--------------------------------------------------------------------------------
--
-- make the globals local
local awesome = awesome
local root = root
local client = client
local screen = screen

-- Standard awesome library
local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')
local awful = require('awful')
              require('awful.autofocus')
-- Notification library
local naughty = require('naughty')

local hotkeys_popup = require('awful.hotkeys_popup').widget
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
                      require('awful.hotkeys_popup.keys')
-- extras
local lgi = require('lgi')
local upower = require('upower')
local mpd = require('mpd')
local terrible = require('terrible')
--local sys = require('sys')

local terminal = 'st'
local editor = 'nvim'
local editor_cmd = terminal..' -e '..editor
local modkey = 'Mod4'

-------------------------------------------------------------- Error handling --
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify { 
        preset = naughty.config.presets.critical,
        title = 'Oops, there were errors during startup!',
        text = awesome.startup_errors 
    }
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal('debug::error',
        function (err)
            -- Make sure we don't go into an endless error loop
            if in_error then return end
            in_error = true

            naughty.notify({
                preset = naughty.config.presets.critical,
                title = 'Oops, an error happened!',
                text = tostring(err) 
            })
            in_error = false
        end)
end

----------------------------------------------------------------------- Theme --

beautiful.init('~/.config/awesome/theme/theme.lua')

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == 'function' then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

screen.connect_signal('property::geometry', set_wallpaper)

------------------------------------------------------------ useful functions --

local client_menu_toggle_fn = function()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                 c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),

    awful.button({ }, 3, client_menu_toggle_fn()),
 
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
    end),

    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
    end)
)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) 
        t:view_only() 
    end),

    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),

    awful.button({ }, 3, awful.tag.viewtoggle),

    awful.button({ modkey }, 3, function(t)
        if client.focus then
          client.focus:toggle_tag(t)
        end
    end),
        
    awful.button({ }, 4, function(t) 
        awful.tag.viewnext(t.screen) 
    end),
     
    awful.button({ }, 5, function(t) 
        awful.tag.viewprev(t.screen) 
    end)
)

local format_time = function(seconds)
    if seconds <= 0 then
	    return "00:00:00";
	else
		hours = string.format("%02.f", math.floor(seconds/3600));
		mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
		secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
		return hours..":"..mins..":"..secs
	end
end

---------------------------------------------------------------------- Config --

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
    awful.layout.suit.floating,
}

local awesome_menu = {
    {
        'Hotkeys',
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end
    },
    {
        'Manual',
        terminal..' -e man awesome'
    },
    {
        'Edit Config',
        editor_cmd.. ' ' ..awesome.conffile
    },
    {
        'Restart',
        awesome.restart
    },
    {
        'Quit',
        function()
            awesome.quit()
        end
    }
}

local web_menu = {
    {
        'New Window',
        'qutebrowser'
    },
    {
        'Private',
        'qutebrowser ":open -p duckduckgo.com"'
    }
}

local main_menu = awful.menu {
    items = {
        {
            'Awesome',
            awesome_menu, beautiful.awesome_icon
        },
        {
            'Web',
            web_menu
        },
        {
            'Editor',
            editor_cmd
        },
        {
            'Steam',
            'steam'
        },
        {
            'Terminal',
            terminal
        }
    }
}

local text_date_widget = wibox.widget {
    id = '_background',
    layout = wibox.container.background,
    bg = beautiful.bg_normal,
    fg = beautiful.fg_normal,
    {
        id = '_margin',
        layout = wibox.container.margin,
        left = 4,
        right = 4,
        {
            id = '_layout',
            layout = wibox.layout.fixed.horizontal,
            {
                id = '_date_title',
                widget = wibox.widget.textbox,
                text = 'Date:'
            },
            {
                layout = wibox.container.background,
                bg = beautiful.bg_focus,
                fg = beautiful.fg_focus,
                wibox.widget.textclock('%d/%m/%y', 60, 'Europe/London')
            }
        }
    }
}

local calendar_popup = awful.widget.calendar_popup.month()
calendar_popup:attach(text_date_widget, 'tr', {on_hover = false})

local text_clock_widget = wibox.widget {
    id = '_background',
    layout = wibox.container.background,
    bg = beautiful.bg_normal,
    fg = beautiful.fg_normal,
    {
        id = '_margin',
        layout = wibox.container.margin,
        left = 4,
        right = 4,
        {
            id = '_layout',
            layout = wibox.layout.fixed.horizontal,
            {
                id = '_clock_title',
                widget = wibox.widget.textbox,
                text = 'Time:'
            },
            {
                id = '_clock',
                layout = wibox.container.background,
                bg = beautiful.bg_focus,
                fg = beautiful.fg_focus,
                wibox.widget.textclock('%H:%M', 60, 'Europe/London')
            }
        }
    }
}

local terrible_upower_widget = terrible.upower.display_device_widget {
    templates = {
        battery = {
            id = '_background',
            layout = wibox.container.background,
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal,
            {
                id = '_margin',
                layout = wibox.container.margin,
                left = 4,
                right = 4,
                {
                    id = '_layout',
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 4,
                    {
                        id = 'kind_role',
                        widget = wibox.widget.textbox,
                        update_widget = function (self, dev)
                            self:set_text(dev.kind_to_string(dev.kind))
                        end
                    },
                    {
                        id = 'percentage_container',
                        layout = wibox.container.constraint,
                        width = 64,
                        hieght = 18,
                        {
                            id = 'percentage_role',
                            widget = wibox.widget.progressbar,
                            max_value = 100,
                            color = beautiful.green,
                            update_widget = function (self, dev)
                                self.color = (dev.percentage < 10 and beautiful.red) or (dev.percentage < 25 and beautiful.yellow) or beautiful.green
                                self:set_value(dev.percentage)
                            end
                        }
                    },
                    {
                        id = '_time_container',
                        layout = wibox.layout.fixed.horizontal,
                        {
                            id = '_time_remaining_background',
                            layout = wibox.container.background,
                            fg = beautiful.fg_focus,
                            bg = beautiful.bg_focus,
                            {
                                id = 'time-to-empty_role',
                                widget = wibox.widget.textbox,
                                update_widget = function (self, dev)
                                    self.visible = dev.time_to_empty > 0
                                    self.text = format_time(dev.time_to_empty) ..' remaining'
                                end
                            }

                        },
                        {
                            id = 'time-to-full_role',
                            widget = wibox.widget.textbox,
                            update_widget = function (self, dev)
                                self.visible = dev.time_to_full > 0
                                self.text = format_time(dev.time_to_full) ..' until full'
                            end
                        }
                    },
                    --{
                    --    id = 'state_role',
                    --    widget = wibox.widget.textbox,
                    --    update_upower_widget = function (self, dev)
                    --        self.text = dev.state_to_string(dev.state)
                    --    end
                    --}
                }
            }
        }
    }
}


local upower_display_widget = upower.display_device_widget {
    templates = {
        battery = {
            id = '_background',
            layout = wibox.container.background,
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal,
            {
                id = '_margin',
                layout = wibox.container.margin,
                left = 4,
                right = 4,
                {
                    id = '_layout',
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 4,
                    {
                        id = 'kind_role',
                        widget = wibox.widget.textbox,
                        update_upower_widget = function (self, dev)
                            self:set_text(dev.kind_to_string(dev.kind))
                        end
                    },
                    {
                        id = 'percentage_container',
                        layout = wibox.container.constraint,
                        width = 64,
                        hieght = 18,
                        {
                            id = 'percentage_role',
                            widget = wibox.widget.progressbar,
                            max_value = 100,
                            color = beautiful.green,
                            update_upower_widget = function (self, dev)
                                self.color = (dev.percentage < 10 and beautiful.red) or (dev.percentage < 25 and beautiful.yellow) or beautiful.green
                                self:set_value(dev.percentage)
                            end
                        }
                    },
                    {
                        id = '_time_container',
                        layout = wibox.layout.fixed.horizontal,
                        {
                            id = '_time_remaining_background',
                            layout = wibox.container.background,
                            fg = beautiful.fg_focus,
                            bg = beautiful.bg_focus,
                            {
                                id = 'time-to-empty_role',
                                widget = wibox.widget.textbox,
                                update_upower_widget = function (self, dev)
                                    self.visible = dev.time_to_empty > 0
                                    self.text = format_time(dev.time_to_empty) ..' remaining'
                                end
                            }

                        },
                        {
                            id = 'time-to-full_role',
                            widget = wibox.widget.textbox,
                            update_upower_widget = function (self, dev)
                                self.visible = dev.time_to_full > 0
                                self.text = format_time(dev.time_to_full) ..' until full'
                            end
                        }
                    },
                    --{
                    --    id = 'state_role',
                    --    widget = wibox.widget.textbox,
                    --    update_upower_widget = function (self, dev)
                    --        self.text = dev.state_to_string(dev.state)
                    --    end
                    --}
                }
            }
        }
    }
}
local upower_devices_widget = upower.devices_widget {
    device_templates = {
        battery = {
            id = '_background',
            layout = wibox.container.background,
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal,
            {
                id = '_margin',
                layout = wibox.container.margin,
                left = 4,
                right = 4,
                {
                    id = '_layout',
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 4,
                    {
                        id = 'kind_role',
                        widget = wibox.widget.textbox,
                        update_upower_widget = function (self, dev)
                            self:set_text(dev.kind_to_string(dev.kind))
                        end
                    },
                    {
                        id = 'percentage_container',
                        layout = wibox.container.constraint,
                        width = 64,
                        height = 18,
                        {
                            id = 'percentage_role',
                            widget = wibox.widget.progressbar,
                            max_value = 100,
                            color = beautiful.green,
                            update_upower_widget = function (self, dev)
                                self.color = dev.percentage < 10 and beautiful.red or dev.percentage < 25 and beautiful.yellow or beautiful.green
                                self:set_value(dev.percentage)
                            end
                        }
                    },
                    {
                        id = 'state_role',
                        widget = wibox.widget.textbox,
                        update_upower_widget = function (self, dev)
                            self:set_text(dev.state_to_string(dev.state))
                        end
                    }
                }
            }
        },
        ['line-power'] = {
            id = '_background',
            layout = wibox.container.background,
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal,
            {
                id = '_margin',
                layout = wibox.container.margin,
                left = 4,
                right = 4,
                {
                    id = '_layout',
                    layout = wibox.layout.align.horizontal,
                    spacing = 4,
                    {
                        id = 'kind_role',
                        widget = wibox.widget.textbox,
                        update_upower_widget = function (self, dev)
                            self:set_text(dev.kind_to_string(dev.kind))
                        end
                    },
                    {
                        id = '_place_holder',
                        layout = wibox.layout.fixed.horizontal
                    },
                    {
                        id = 'online_constraint',
                        layout = wibox.container.constraint,
                        width = 18,
                        height = 18,
                        {
                            id = 'online_container',
                            layout = wibox.container.margin,
                            top = 4,
                            bottom = 4,
                            {
                                id = 'online_role',
                                widget = wibox.widget.checkbox,
                                update_upower_widget = function (self, dev)
                                    self.checked = dev.online
                                end

                            }
                        }
                    }
                }
            }
        },
        mouse = {
            id = '_background',
            layout = wibox.container.background,
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal,
            {
                id = '_margin',
                layout = wibox.container.margin,
                left = 4,
                right = 4,
                {
                    id = '_layout',
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 4,
                    {
                        id = 'kind_role',
                        widget = wibox.widget.textbox,
                        update_upower_widget = function (self, dev)
                            self:set_text(dev.kind_to_string(dev.kind))
                        end
                    },
                    {
                        id = 'percentage_container',
                        layout = wibox.container.constraint,
                        width = 64,
                        height = 18,
                        {
                            id = 'percentage_role',
                            widget = wibox.widget.progressbar,
                            max_value = 100,
                            color = beautiful.green,
                            update_upower_widget = function (self, dev)
                                self:set_value(dev.percentage)
                            end
                        }
                    },
                    {
                        id = 'state_role',
                        widget = wibox.widget.textbox,
                        update_upower_widget = function (self, dev)
                            self:set_text(dev.state_to_string(dev.state))
                        end
                    }
                
                }
            }
        }
    },
    container_template = {
        id = '_backround',
        layout = wibox.container.background,
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
        {
            id = '_margin',
            layout = wibox.container.margin,
            left = 0,
            right = 0,
            {
                id = 'devices_container_role',
                layout = (upower_display_widget and wibox.layout.fixed.vertical) or wibox.layout.fixed.horizontal,
                spacing = 4,
                upower_device_added = function (self, wdg, dev_path)
                    self[dev_path] = wdg
                    self:add(wdg)
                end,
                upower_device_removed = function (self, dev_path)
                    self:remove_widgets(self[dev_path])
                    self.dev_path = nil
                end
            }
        }
    }
}


--local backlight_widget = sys.backlight.widget {
--    backlight_device = 'intel_backlight',
--    widget_template = {
--        id = '_background',
--        layout = wibox.container.background,
--        bg = beautiful.bg_normal,
--        fg = beautiful.fg_normal,
--        {
--            id = '_margin',
--            layout = wibox.container.margin,
--            left = 8,
--            right = 8,
--            {
--                id = '_layout',
--                layout = wibox.layout.fixed.horizontal,
--                {
--                    id = '_name',
--                    widget = wibox.widget.textbox,
--                    text = 'Backlight:'
--                },
--                {
--                    id = '_background',
--                    layout = wibox.container.background,
--                    bg = beautiful.bg_focus,
--                    fg = beautiful.fg_focus,
--                    {
--                        id = '_layout',
--                        layout = wibox.layout.fixed.horizontal,
--                        {
--                            id = 'backlight_text_role',
--                            widget = wibox.widget.textbox
--                        },
--                        {
--                            id = '_percentage_symbol',
--                            widget = wibox.widget.textbox,
--                            text = '%'
--                        }
--                    }
--                }
--            }
--        }
--    }
--}

local mpd_widget = mpd.widget {
    template = {
        id = 'status_state_role',
        layout = wibox.container.background,
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
        update_mpd_widget = function (self, v)
            if v == 'stop' then
                self.visible = false
            else
                if v == 'pause' then
                    self.fg = beautiful.fg_normal
                    self.bg = beautiful.bg_normal
                else
                    self.fg = beautiful.fg_focus
                    self.bg = beautiful.bg_focus
                end
                self.visible = true
            end
        end,
        {
            id = '_margin',
            layout = wibox.container.margin,
            left = 4,
            right = 4,
            {
                id = '_layout',
                layout = wibox.layout.fixed.horizontal,
                spacing = 4,
                {
                    id = 'currentsong_artist_role',
                    widget = wibox.widget.textbox,
                    update_mpd_widget = function (self, v)
                        self.text = v..':'
                    end
                },
                {
                    id = 'currentsong_title_role',
                    widget = wibox.widget.textbox,
                    update_mpd_widget = function (self, v)
                        self.text = v
                    end
                },
                {
                    id = '_hiphen',
                    widget = wibox.widget.textbox,
                    text = '-'
                },
                {
                    id = 'currentsong_album_role',
                    widget = wibox.widget.textbox,
                    update_mpd_widget = function (self, v)
                        self.text = v
                    end
                }
            }
        }
    }
}

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag(
        {'1', '2', '3', '4', '5', '6', '7', '8', '9'},
        s,
        -- different starting layouts for portrait and lanscape screens
        s.geometry.height < s.geometry.width and awful.layout.layouts[1] or awful.layout.layouts[3]
    )
    s.prompt_widget = awful.widget.prompt()
    s.panel = awful.wibar {
        position = 'top',
        screen = s,
        widget = wibox.widget {
            layout = wibox.layout.align.horizontal,
            {
                layout = wibox.layout.fixed.horizontal,
                awful.widget.taglist {
                    screen = s,
                    filter = awful.widget.taglist.filter.noempty,
                    buttons = taglist_buttons,
                    layout = {
                        layout = wibox.layout.fixed.horizontal
                    },
                    template_widget = {
                        {
                            id = 'background_role',
                            widget = wibox.container.background,
                            {
                                id = 'text_margin_role',
                                widget = wibox.container.margin,
                                {
                                    'text_role',
                                    widget = wibox.widget.textbox
                                }
                            }
                        }
                    }
                },
                awful.widget.tasklist {
                    screen = s,
                    filter = awful.widget.tasklist.filter.currenttags,
                    buttons = tasklist_buttons,
                    layout = {
                        layout = wibox.layout.fixed.horizontal
                    },
                    template_widget = {
                        {
                            id = 'background_role',
                            widget = wibox.container.background,
                            {
                                id = 'taxt_margin_role',
                                widget = wibox.container.margin,
                                {
                                    id = 'text_role',
                                    widget = wibox.widget.textbox
                                }
                            }
                        }
                    }
                },
                s.prompt_widget
            },
            {
                layout = wibox.layout.fixed.horizontal
            },
            {
                layout = wibox.container.background,
                fg = beautiful.fg_normal,
                bg = beautiful.bg_normal,
                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 16,
                    -- only display widgets on the primary screen
                    s == screen.primary and wibox.widget.systray(),
                    s == screen.primary and mpd_widget,
                    --s == screen.primary and backlight_widget,
                    s == screen.primary and (upower_display_widget or upower_devices_widget),
                    text_clock_widget,
                    text_date_widget,
                    awful.widget.layoutbox(s)
                }
            }
        }
    }

end)

local upower_devices_popup
if upower_display_widget then
    upower_devices_popup = awful.popup {
        widget = upower_devices_widget,
        visible = false,
        preferred_positions = 'bottom',
        hide_on_right_click = true,
        ontop = true
    }
    upower_devices_popup:bind_to_widget(upower_display_widget,1)
end
---------------------------------------------------------------- Key bindings --

globalkeys = gears.table.join(
    awful.key({}, 'XF86AudioMute', function ()
        awful.spawn.with_shell('pactl set-sink-mute @DEFAULT_SINK@ toggle')
    end,
    {description = 'Toggle Mute', group='Media'}),    

    awful.key({}, 'XF86AudioLowerVolume', function ()
        awful.spawn.with_shell('pactl set-sink-volume @DEFAULT_SINK@ -1%')
    end,
    {description = 'Lower Volume', group='Media'}),    

    awful.key({}, 'XF86AudioRaiseVolume', function ()
        awful.spawn.with_shell('pactl set-sink-volume @DEFAULT_SINK@ +1%')
    end,
    {description = 'Raise Volume', group='Media'}),

    awful.key({ modkey }, 's',  hotkeys_popup.show_help,
              {description='show help', group='awesome'}),

    awful.key({ modkey }, 'w', function ()
        main_menu:show();
    end,
    {description = 'display menu', group = 'awesome'}),

    awful.key({ modkey }, 'r', function ()
        awful.screen.focused().prompt_widget:run()
    end,
    {description = 'run prompt', group = 'awesome'}),

    awful.key({ modkey }, 'p', awful.tag.viewprev,
              {description = 'view previous', group = 'tag'}),

    awful.key({ modkey }, 'n', awful.tag.viewnext,
              {description = 'view next', group = 'tag'}),

    awful.key({ modkey }, 'Escape', awful.tag.history.restore,
              {description = 'go back', group = 'tag'}),

    awful.key({ modkey, 'Shift' }, '=', function ()
            local t = awful.screen.focused().selected_tag
            t.gap = t.gap + beautiful.useless_gap or 1
        end,
        {description = 'increase useless gap', group = 'tag'}),

    awful.key({ modkey }, '-', function ()
            local t = awful.screen.focused().selected_tag
            t.gap = t.gap - beautiful.useless_gap or 1
        end,
        {description = 'decrease useless gap', group = 'tag'}),

    awful.key({ modkey }, '=', function ()
            local t = awful.screen.focused().selected_tag
            t.gap = beautiful.useless_gap
        end,
        {description = 'reset useless gap', group = 'tag'}),

    -- Layout manipulation

    awful.key({ modkey, 'Control' }, 'j', function ()
            awful.screen.focus_relative( 1)
        end,
       {description = 'focus the next screen', group = 'screen'}),

    awful.key({ modkey, 'Control' }, 'k', function ()
            awful.screen.focus_relative(-1)
        end,
        {description = 'focus the previous screen', group = 'screen'}),

    awful.key({ modkey }, 'h', function ()
            awful.client.focus.global_bydirection('left')
        end,
        {description = 'Move client focus left', group = 'client'}),

    awful.key({ modkey }, 'j', function ()
            awful.client.focus.global_bydirection('down')
        end,
        {description = 'Move client focus down', group = 'client'}),

    awful.key({ modkey }, 'k', function ()
            awful.client.focus.global_bydirection('up')
        end,
        {description = 'Move client focus up', group = 'client'}),

    awful.key({ modkey }, 'l', function ()
            awful.client.focus.global_bydirection('right')
        end,
        {description = 'Move client focus right', group = 'client'}),

    awful.key({ modkey }, 'u', awful.client.urgent.jumpto,
        {description = 'jump to urgent client', group = 'client'}),

    -- Standard program
    awful.key({ modkey }, 'Return', function ()
            awful.spawn(terminal)
        end,
        {description = 'open a terminal', group = 'launcher'}),

    awful.key({ modkey, 'Control' }, 'r', awesome.restart,
        {description = 'reload awesome', group = 'awesome'}),

    awful.key({ modkey, 'Shift'   }, 'q', awesome.quit,
        {description = 'quit awesome', group = 'awesome'}),
    
    awful.key({ modkey, 'Control' }, 'h', function ()
            awful.tag.incncol( 1, nil, true)
        end,
        {description = 'increase the number of columns', group = 'layout'}),

    awful.key({ modkey, 'Control' }, 'l', function () 
            awful.tag.incncol(-1, nil, true) 
        end,
        {description = 'decrease the number of columns', group = 'layout'}),

    awful.key({ modkey }, 'space', function () 
            awful.layout.inc( 1) 
        end,
        {description = 'select next', group = 'layout'}),

    awful.key({ modkey, 'Shift' }, 'space', function () 
            awful.layout.inc(-1) 
        end,
        {description = 'select previous', group = 'layout'}),

    awful.key({ modkey, 'Control' }, 'm',
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = 'restore minimized', group = 'client'})
)


-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, '#' .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            {description = 'view tag #'..i, group = 'tag'}),
        -- Toggle tag display.
        awful.key({ modkey, 'Control' }, '#' .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = 'toggle tag #' .. i, group = 'tag'}),
        -- Move client to tag.
        awful.key({ modkey, 'Shift' }, '#' .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = 'move focused client to tag #'..i, group = 'tag'}),
        -- Toggle tag on focused client.
        awful.key({ modkey, 'Control', 'Shift' }, '#' .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
             end,
             {description = 'toggle focused client on tag #' .. i, group = 'tag'})
    )
end


root.keys(globalkeys)

-------------------------------------------------------------- Mouse bindings --

root.buttons(gears.table.join(
    awful.button({}, 3, function () main_menu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))

--------------------------------------------------------------------------------

clientkeys = gears.table.join(
    awful.key({ modkey }, 'f', function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = 'toggle fullscreen', group = 'client'}),

    awful.key({ modkey, 'Shift' }, 'c', function (c) 
            c:kill()
        end,
        {description = 'close', group = 'client'}),

    awful.key({ modkey, 'Control' }, 'space', awful.client.floating.toggle,
              {description = 'toggle floating', group = 'client'}),

    awful.key({ modkey, 'Control' }, 'Return', function (c)
            c:swap(awful.client.getmaster())
        end,
        {description = 'move to master', group = 'client'}),

    awful.key({ modkey, 'Shift' }, 'j', function (c)
            c:move_to_screen(c.screen:get_next_in_direction('down'))
        end,
        {description = 'move client down a screen', group = 'client'}),

    awful.key({ modkey, 'Shift' }, 'k', function (c)
            c:move_to_screen(c.screen:get_next_in_direction('up')) 
        end,
        {description = 'move client up a screen',  group = 'client'}),
        
    awful.key({ modkey, 'Shift' }, 'h', function (c)
            c:move_to_screen(c.screen:get_next_in_direction('left')) 
        end,
        {description = 'move client left a screen',  group = 'client'}),

    awful.key({ modkey, 'Shift' }, 'l', function (c)
            c:move_to_screen(c.screen:get_next_in_direction('right')) 
        end,
        {description = 'move client right a screen',  group = 'client'}),

    awful.key({ modkey }, 'm', function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
        end,
        {description = 'minimize', group = 'client'}),

    awful.key({ modkey, 'Shift' }, 'n', function (c)
        c:move_to_tag(c.screen.tags[c.first_tag.index +1] or c.screen.tags[1])
    end,
    {description = 'move client to next tag', group='client'}),

    awful.key({ modkey, 'Shift' }, 'p', function (c)
        c:move_to_tag(c.screen.tags[c.first_tag.index -1] or c.screen.tags[#c.screen.tags])
    end,
    {description = 'move client to previous tag', group='client'})

)

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

----------------------------------------------------------------------- Rules --

local spread_layout = function (obj, args)
    args.margins = 32
    local l = awful.placement.no_overlap+awful.no_offscreen
    return l(obj, args)
end


-- Rules to apply to new clients (through the 'manage' signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { 
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = spread_layout, --awful.placement.no_overlap,
            size_hints_honor = false
        }
    },
    {
        rule = {
            class = 'csgo_linux64'
        },
        properties = {
            border_width = 0,
            fullscreen = true
        }
    },
    {
        rule_any = {
            type = {
                'normal',
                'dialog'
            }
        },
        properties = {
            titlebars_enabled = false
        }
    }
}
--------------------------------------------------------------------------------

--------------------------------------------------------------------- Signals --
-- Signal function to execute when a new client appears.
client.connect_signal('manage', function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal('request::titlebars', function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = 'center',
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal('mouse::enter', function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal('focus', function(c)
        c.border_color = beautiful.border_focus 
end)
client.connect_signal('unfocus', function(c)
    c.border_color = beautiful.border_normal 
end)
client.connect_signal('property::maximized', function (c)
    if c.maximized then
        c.border_width = 0
    else
        c.border_width = beautiful.border_width
    end
end)

