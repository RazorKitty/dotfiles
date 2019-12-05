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

-- extras
local mpd = require('mpd')
local terrible = require('terrible')
local power = require('power')
local settings = require('settings')

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
        settings.terminal..' -e man awesome'
    },
    {
        'Edit Config',
        settings.editor_cmd.. ' ' ..awesome.conffile
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


local text_date_widget = wibox.widget {
    id = '_background',
    layout = wibox.container.background,
    bg = beautiful.widget_normal_bg,
    fg = beautiful.widget_normal_fg,
    {
        id = '_margin',
        layout = wibox.container.margin,
        left = 8,
        right = 8,
        wibox.widget.textclock('%H:%M %A %d/%m/%y', 60, 'Europe/London')
    }
}

local mpd_widget = mpd.widget {
    template = {
        id = 'status_state_role',
        layout = wibox.container.background,
        fg = beautiful.widget_normal_fg,
        bg = beautiful.widget_normal_bg,
        update_mpd_widget = function (self, v)
            if v == 'stop' then
                self.visible = false
            else
                if v == 'pause' then
                    self.fg = beautiful.widget_normal_fg
                    self.bg = beautiful.widget_normal_bg
                else
                    self.fg = beautiful.widget_focus_fg
                    self.bg = beautiful.widget_focus_bg
                end
                self.visible = true
            end
        end,
        {
            id = '_margin',
            layout = wibox.container.margin,
            left = 8,
            right = 8,
            {
                id = '_layout',
                layout = wibox.layout.fixed.horizontal,
                spacing = 4,
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
                    id = 'currentsong_artist_role',
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
    s.main_menu = awful.menu {
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
                settings.editor_cmd
            },
            {
                'Steam',
                'steam'
            },
            {
                'Terminal',
                settings.terminal
            }
        }
    }
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
                layout = wibox.layout.fixed.horizontal,
                spacing = 0,
                -- only display widgets on the primary screen
                s == screen.primary and wibox.widget.systray(),
                s == screen.primary and mpd_widget,
                s == screen.primary and power.panel_widget,
                text_date_widget,
                {
                    id = '_layou_background',
                    layout = wibox.container.background,
                    bg = beautiful.widget_normal_bg,
                    fg = beautiful.widget_normal_fg,
                    {
                        id = '_layout_margin',
                        layout = wibox.container.margin,
                        left = 8,
                        right = 0,
                        awful.widget.layoutbox(s)
                    }
                }
            }
        }
    }
end)

return true
