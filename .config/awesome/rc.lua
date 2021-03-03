-- Standard awesome library
local gears = require('gears')
local awful = require('awful')
require('awful.autofocus')
-- Widget and layout library
local wibox = require('wibox')
-- Theme handling library
local beautiful = require('beautiful')
-- Notification library
local naughty = require('naughty')
local menubar = require('menubar')
local hotkeys_popup = require('awful.hotkeys_popup')
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require('awful.hotkeys_popup.keys')

-- Extras
local lgi = require('lgi')
local upower = require('upower')
--local networkmanager = require('networkmanager')
--local playerctl = require('playerctl')


-- {{{ Error handling
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
    awesome.connect_signal('debug::error', function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify {
            preset = naughty.config.presets.critical,
            title = 'Oops, an error happened!',
            text = tostring(err)
        }
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(os.getenv('HOME') .. '/.config/awesome/theme/theme.lua')

-- do this after we initalise the theme so the theming variables are available
-- maybe support for 'auto initialising'beautiful would be a good idea?
-- support for on start theme setting could be moved into beautiful its self?
local widget_templates = require('widget_templates')

-- This is used later as the default terminal and editor to run.
local terminal = 'xst'
local browser = 'qutebrowser'
local editor = os.getenv('EDITOR') or 'nvim'
local editor_cmd = terminal .. ' -e ' .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = 'Mod4'

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
awesomemenu = {
   { 
       'Hotkeys',
       function()
           hotkeys_popup.show_help(nil, awful.screen.focused()) 
       end
   },
   { 
       'Manual',
       terminal .. ' -e man awesome'
   },
   {
       'Edit Config',
       editor_cmd .. ' ' .. awesome.conffile
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

mainmenu = awful.menu {
    items = {
        {
            'Awesome',
            awesomemenu,
            beautiful.awesome_icon
        },
        {
            'Browser',
            browser
        },
        {
            'Terminal',
            terminal
        },
        {
            'Lock',
            'loginctl lock-session'
        },
        {
            'Comms', {
                {
                    'Discord',
                    'Discord'
                },
                {
                    'Signal',
                    'signal-desktop'
                },
                {
                    'Slack',
                    'slack'
                }
            }
        },
        {
            'Power',
            {
                {
                    'Suspend',
                    'loginctl suspend'
                },
                {
                    'Hibernate',
                    'loginctl hibernate'
                },
                {
                    'Power off',
                    'loginctl poweroff'
                }
            }
        }
    }
}


-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar

local system_tray = wibox.widget {
    layout = wibox.container.background,
    bg = beautiful.system_tray.background.bg,
    fg = beautiful.system_tray.background.fg,
    {
        layout = wibox.container.margin,
        left = beautiful.system_tray.margin.left,
        right = beautiful.system_tray.margin.right,
        wibox.widget.systray()
    }

}

-- MPRIS player
--local players_widget = playerctl:players_widget {
--    container_template = {
--        on_init = function (self)
--            self.players = {}
--        end,
--        on_player_appeared = function (self, player, player_widget)
--            self.players[player] = player_widget
--            self:add(player_widget)
--        end,
--        on_player_vanished = function (self, player)
--            self:remove_widgets(self.players[player])
--            self.players[player] = nil
--        end,
--        layout = wibox.layout.fixed.horizontal
--    },
--    player_template = widget_templates.playerctl.player
--}
--
---- network
--local network_widget = networkmanager:primary_connection_widget {
--    container_template = {
--        on_init = function (self)
--            
--        end,
--        on_primary_connection = function (self, primary_connection, primary_connection_widget)
--            self.widget = primary_connection_widget
--        end,
--        layout = wibox.container.background,
--        bg = beautiful.network.background.bg,
--        fg = beautiful.network.background.fg,
--    },
--    active_connection_templates = widget_templates.networkmanager.active_connection,
--    device_templates = widget_templates.networkmanager.device,
--    access_point_template = widget_templates.networkmanager.access_point
--}

-- Power
local power_widget = upower:display_device_widget(widget_templates.upower.display_device) or upower:devices_widget {
    container_template = {
        on_init = function (self)
            self.devices = {}
            self.devices_container_widget = self:get_children_by_id('devices_container_layout')[1]
        end,
        add_device_widget = function (self, dev, widget)
            self.devices[dev:get_object_path()] = widget
            self.devices_container_widget:add(widget)
        end,
        remove_device_widget = function (self, dev_path)
            self.devices_container_widget:remove_widgets(self.devices[dev_path])
            self.devices[dev_path] = nil
        end,
        layout = wibox.container.background,
        bg = beautiful.power.background.bg,
        fg = beautiful.power.background.fg,
        {
            id = 'devices_container_layout',
            layout = wibox.layout.fixed.horizontal
        }
    },
    device_templates = widget_templates.upower.devices
}

-- Datetime
local datetime_widget = wibox.widget {
    layout = wibox.container.background,
    bg = beautiful.panel_datetime_bg,
    fg = beautiful.panel_datetime_fg,
    {
        layout = wibox.container.margin,
        left = beautiful.widget_margin_outer,
        right = beautiful.widget_margin_outer,
        {
            widget = wibox.widget.textclock,
            refresh = 60,
            format = '%H:%M %a, %d/%m/%y'
        }
    }
}

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1,
                 function(t)
                     t:view_only()
                 end),

    awful.button({ modkey }, 1,
                 function(t)
                    if client.focus then
                        client.focus:move_to_tag(t)
                    end
                 end),

    awful.button({ }, 3,
                 awful.tag.viewtoggle),
    awful.button({ modkey }, 3,
                 function(t)
                     if client.focus then
                         client.focus:toggle_tag(t)
                     end
                 end),

    awful.button({ }, 4, 
                 function(t)
                     awful.tag.viewnext(t.screen)
                 end),

    awful.button({ }, 5,
                 function(t)
                     awful.tag.viewprev(t.screen)
                 end)
)

local tasklist_buttons = gears.table.join(
     awful.button({ }, 1,
                  function (c)
                      if c == client.focus then
                          c.minimized = true
                      else
                          c:emit_signal('request::activate','tasklist',{raise = true})
                      end
                  end),
     
    awful.button({ }, 3,
                 function()
                     awful.menu.client_list({ theme = { width = 250 } })
                 end),

     awful.button({ }, 4,
                  function ()
                      awful.client.focus.byidx(1)
                  end),

     awful.button({ }, 5,
                  function ()
                      awful.client.focus.byidx(-1)
                  end)
)

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

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal('property::geometry', set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ '1', '2', '3', '4', '5', '6', '7', '8', '9' }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    local layoutbox = awful.widget.layoutbox(s)


    layoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.taglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.noempty,
        buttons = taglist_buttons,
        layout = {
            layout = wibox.layout.fixed.horizontal
        },
        template_widget = {
            {
                id = 'background_role',
                {
                    layout = wibox.container.margin,
                    left = beautiful.widget_margins_inner,
                    right = beautiful.widget_margins_inner,
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox
                    }
                }
            }
        }
    }

    -- Create a tasklist widget
    s.tasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        layout = {
            layout = wibox.layout.fixed.horizontal
        }
    }

    -- Create the wibox
    s.desktop_panel = awful.wibar { 
        position = 'top',
        screen = s 
    }

    -- Add widgets to the wibox
    s.desktop_panel:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.taglist,
            s.mypromptbox,
            s.tasklist,
        },
        { -- Middle widget
            layout = wibox.layout.fixed.horizontal
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            s == screen.primary and system_tray,
            s == screen.primary and players_widget,
            s == screen.primary and network_widget,
            s == screen.primary and power_widget,
            datetime_widget,
            wibox.widget {
                layout = wibox.container.background,
                bg = beautiful.layoutbox.background.bg,
                fg = beautiful.layoutbox.background.fg,
                {
                    layout = wibox.container.margin,
                    -- since we are on the end of the row dont bother with the other side
                    left = beautiful.layoutbox.margin.left,
                    layoutbox
                }
            }
        }
    }

end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () 
        mainmenu:toggle()
    end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey }, 's', hotkeys_popup.show_help,
              { description='show help', group='awesome' }),

    awful.key({ modkey }, 'p', awful.tag.viewprev,
              { description = 'view previous', group = 'tag' }),

    awful.key({ modkey }, 'n',  awful.tag.viewnext,
              { description = 'view next', group = 'tag' }),

    --awful.key({ modkey }, 'Escape', awful.tag.history.restore,
    --          { description = 'go back', group = 'tag' }),

    awful.key({ modkey }, 'j',
              function ()
                  awful.client.focus.global_bydirection('down')
              end,
              { description = 'shift focus down', group = 'client' }),

    awful.key({ modkey }, 'k',
              function ()
                  awful.client.focus.global_bydirection('up')
              end,
              { description = 'shift focus up', group = 'client' }),

    awful.key({ modkey }, 'h',
              function ()
                  awful.client.focus.global_bydirection('left')
              end,
              { description = 'shift focus left', group = 'client' }),

    awful.key({ modkey }, 'l',
              function ()
                  awful.client.focus.global_bydirection('right')
              end,
              { description = 'shift focus right', group = 'client' }),

    awful.key({ modkey }, 'Menu',
              function ()
                  mainmenu:show()
              end,
              { description = 'show main menu', group = 'awesome' }),

    -- Layout manipulation
    awful.key({ modkey, 'Mod1' }, 'j', 
              function ()
                  awful.client.swap.bydirection('down')
                      --client.focus:move_to_screen(awful.screen.focused{ client = true }:get_next_in_direction('down'))
              end,
              { description = 'swap with client bellow', group = 'client' }),

    awful.key({ modkey, 'Mod1' }, 'k',
              function ()
                  awful.client.swap.bydirection('up')
                      --client.focus:move_to_screen(awful.screen.focused{ client = true }:get_next_in_direction('up'))
              end,
              { description = 'swap with client above', group = 'client' }),

    awful.key({ modkey, 'Mod1' }, 'h', 
              function ()
                  awful.client.swap.bydirection('left')
                      --client.focus:move_to_screen(awful.screen.focused{ client = true }:get_next_in_direction('left'))
              end,
              { description = 'swap with client left', group = 'client' }),

    awful.key({ modkey, 'Mod1' }, 'l',
              function ()
                  awful.client.swap.bydirection('right')
                      --client.focus:move_to_screen(awful.screen.focused{ client = true }:get_next_in_direction('right'))
              end,
              { description = 'swap with client right', group = 'client' }),

    awful.key({ modkey, 'Shift' }, 'j', 
              function ()
                  if awful.screen.focused{ client = true }:get_next_in_direction('down') then
                      client.focus:move_to_screen(awful.screen.focused{ client = true }:get_next_in_direction('down')) 
                  end
              end,
              { description = 'move client to the bottom screen', group = 'client' }),

    awful.key({ modkey, 'Shift' }, 'k',
              function ()
                  if awful.screen.focused{ client = true }:get_next_in_direction('up') then
                      client.focus:move_to_screen(awful.screen.focused{ client = true }:get_next_in_direction('up'))
                  end
              end,
              { description = 'move client to the top screen', group = 'client' }),

    awful.key({ modkey, 'Shift' }, 'h', 
              function ()
                  if awful.screen.focused{ client = true }:get_next_in_direction('left') then
                      client.focus:move_to_screen(awful.screen.focused{ client = true }:get_next_in_direction('left')) 
                  end
              end,
              { description = 'move client to the left screen', group = 'client' }),

    awful.key({ modkey, 'Shift' }, 'l',
              function ()
                  if awful.screen.focused{ client = true }:get_next_in_direction('right') then
                      client.focus:move_to_screen(awful.screen.focused{ client = true }:get_next_in_direction('right')) 
                  end
              end,
              { description = 'move client to the right screen', group = 'client' }),

    --awful.key({ modkey, 'Control' }, 'j', 
    --          function ()
    --              awful.screen.focus_relative( 1) 
    --          end,
    --          { description = 'focus the next screen', group = 'screen' }),

    --awful.key({ modkey, 'Control' }, 'k',
    --          function ()
    --              awful.screen.focus_relative(-1)
    --          end,
    --          { description = 'focus the previous screen', group = 'screen' }),

    awful.key({ modkey }, 'u', 
              awful.client.urgent.jumpto,
              { description = 'jump to urgent client', group = 'client' }),

    --awful.key({ modkey }, 'Tab',
    --          function ()
    --              awful.client.focus.history.previous()
    --              if client.focus then
    --                  client.focus:raise()
    --              end
    --          end,
    --          { description = 'go back', group = 'client' }),

    -- Standard program
    awful.key({ modkey }, 'Return',
              function ()
                  awful.spawn(terminal)
              end,
              { description = 'open a terminal', group = 'launcher' }),

    awful.key({ modkey, 'Control' }, 'r',
              awesome.restart,
              { description = 'reload awesome', group = 'awesome' }),

    awful.key({ modkey, 'Shift' ,}, 'Escape',
              awesome.quit,
              { description = 'kill awesome', group = 'awesome' }),


    awful.key({ modkey, 'Shift' }, 'q',
              function ()
                  awful.spawn('loginctl session-lock')
              end,
              { description = 'lock session', group = 'awesome' }),

    --awful.key({ modkey }, 'l', 
    --          function ()
    --              awful.tag.incmwfact(0.05)
    --          end,
    --          { description = 'increase master width factor', group = 'layout' }),

    --awful.key({ modkey }, 'h',
    --          function ()
    --              awful.tag.incmwfact(-0.05)
    --          end,
    --          { description = 'decrease master width factor', group = 'layout' }),

    --awful.key({ modkey, 'Shift' }, 'h',
    --          function ()
    --              awful.tag.incnmaster(1, nil, true)
    --          end,
    --          { description = 'increase the number of master clients', group = 'layout' }),

    --awful.key({ modkey, 'Shift' }, 'l',
    --          function () awful.tag.incnmaster(-1, nil, true)
    --          end,
    --          { description = 'decrease the number of master clients', group = 'layout' }),

    awful.key({ modkey, 'Control' }, 'h', 
              function ()
                  awful.tag.incncol(1, nil, true)
              end,
              { description = 'increase the number of columns', group = 'layout' }),

    awful.key({ modkey, 'Control' }, 'l',
              function ()
                  awful.tag.incncol(-1, nil, true)
              end,
              { description = 'decrease the number of columns', group = 'layout' }),

    awful.key({ modkey }, 'space',
              function () 
                  awful.layout.inc( 1)
              end,
              { description = 'select next', group = 'layout' }),

    awful.key({ modkey, 'Shift' }, 'space',
              function ()
                  awful.layout.inc(-1)
              end,
              { description = 'select previous', group = 'layout' }),

    awful.key({ modkey, 'Shift' }, 'm',
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        'request::activate', 'key.unminimize', { raise = true }
                    )
                  end
              end,
              { description = 'restore minimized', group = 'client' }),

    -- Prompt
    awful.key({ modkey }, 'r',
              function ()
                  awful.screen.focused().mypromptbox:run()
              end,
              { description = 'run prompt', group = 'launcher' })

    --awful.key({ modkey }, 'x',
    --          function ()
    --              awful.prompt.run {
    --                prompt       = 'Run Lua code: ',
    --                textbox      = awful.screen.focused().mypromptbox.widget,
    --                exe_callback = awful.util.eval,
    --                history_path = awful.util.get_cache_dir() .. '/history_eval'
    --              }
    --          end,
    --          { description = 'lua execute prompt', group = 'awesome' }),

    -- Menubar
    --awful.key({ modkey }, 'p',
    --          function()
    --              menubar.show()
    --          end,
    --          { description = 'show the menubar', group = 'launcher' })

)

clientkeys = gears.table.join(
    awful.key({ modkey }, 'f',
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = 'toggle fullscreen', group = 'client' }),

    awful.key({ modkey, }, 'q', 
              function (c)
                  c:kill()
              end,
              { description = 'close', group = 'client' }),

    --awful.key({ modkey, 'Control' }, 'space',
    --          awful.client.floating.toggle,
    --          { description = 'toggle floating', group = 'client' }),

    --awful.key({ modkey, 'Control' }, 'Return',
    --          function (c)
    --              c:swap(awful.client.getmaster())
    --          end,
    --          { description = 'move to master', group = 'client' }),

    --awful.key({ modkey }, 'o',
    --          function (c)
    --              c:move_to_screen()
    --          end,
    --          { description = 'move to screen', group = 'client' }),

    --awful.key({ modkey }, 't',
    --          function (c)
    --              c.ontop = not c.ontop
    --          end,
    --          { description = 'toggle keep on top', group = 'client' }),

    awful.key({ modkey }, 'm',
              function (c)
                  -- The client currently has the input focus, so it cannot be
                  -- minimized, since minimized clients can't have the focus.
                  c.minimized = true
              end,
              { description = 'minimize', group = 'client' })

    --awful.key({ modkey }, 'm',
    --          function (c)
    --              c.maximized = not c.maximized
    --              c:raise()
    --          end,
    --          { description = '(un)maximize', group = 'client' }),

    --awful.key({ modkey, 'Control' }, 'm',
    --          function (c)
    --              c.maximized_vertical = not c.maximized_vertical
    --              c:raise()
    --          end,
    --          { description = '(un)maximize vertically', group = 'client' }),
    --awful.key({ modkey, 'Shift'   }, 'm',
    --          function (c)
    --              c.maximized_horizontal = not c.maximized_horizontal
    --              c:raise()
    --          end,
    --          { description = '(un)maximize horizontally', group = 'client' })
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
                  { description = 'view tag #'..i, group = 'tag' }),
        -- Toggle tag display.
        awful.key({ modkey, 'Control' }, '#' .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  { description = 'toggle tag #' .. i, group = 'tag' }),
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
                  { description = 'move focused client to tag #'..i, group = 'tag' }),
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
                  { description = 'toggle focused client on tag #' .. i, group = 'tag' })
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, 
                 function (c)
                     c:emit_signal('request::activate', 'mouse_click', {raise = true})
                 end),

    awful.button({ modkey }, 1, 
                 function (c)
                     c:emit_signal('request::activate', 'mouse_click', {raise = true})
                     awful.mouse.client.move(c)
                 end),

    awful.button({ modkey }, 3,
                 function (c)
                     c:emit_signal('request::activate', 'mouse_click', {raise = true})
                     awful.mouse.client.resize(c)
                 end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the 'manage' signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = { 
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                'DTA',  -- Firefox addon DownThemAll.
                'copyq',  -- Includes session name in class.
                'pinentry',
            },
            class = {
                'Arandr',
                'Blueman-manager',
                'Gpick',
                'Kruler',
                'MessageWin',  -- kalarm.
                'Sxiv',
                'Tor Browser', -- Needs a fixed window size to avoid fingerprinting by screen size.
                'Wpa_gui',
                'veromix',
                'xtightvncviewer'
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                'Event Tester',  -- xev.
            },
            role = {
                'AlarmWindow',  -- Thunderbird's calendar.
                'ConfigManager',  -- Thunderbird's about:config.
                'pop-up',       -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = {
            floating = true
        }
    },
    -- Discord
    {
        rule = {
            class = 'discord'
        },
        properties = {
            new_tag = {
                name = 'Discord',
                layout = awful.layout.suit.tile,
                volatile = true
            },
            screen = screen.primary:get_next_in_direction('up')
        }
    },
    -- Signal
    {
        rule = {
            class = 'Signal'
        },
        properties = {
            new_tag = {
                name = 'Signal',
                layout = awful.layout.suit.tile,
                volatile = true
            },
            screen = screen.primary:get_next_in_direction('up')
        }
    },
    -- Slack
    {
        rule = {
            class = 'Slack'
        },
        properties = {
            new_tag = {
                name = 'Slack',
                layout = awful.layout.suit.tile,
                volatile = true
            },
            screen = screen.primary:get_next_in_direction('up')
        }
    },
    -- mpv
    {
        rule = {
            class = 'mpv'
        },
        properties = {
            floating = true,
            sticky = true,
            screen = screen.primary:get_next_in_direction('up'),
            ontop = true,
            above = true,
            focus = false,
            skip_taskbar = true,
            placement = function (c, args)
                local p = awful.placement.scale + awful.placement[awful.screen.primary and 'top_right' or 'bottom_right']
                p(c, {
                    honor_workarea = true,
                    honor_padding = true,
                    --offset = beautiful.useless_gap,
                    margins = beautiful.useless_gap * 4,
                    to_percent = 0.33,
                    direction = 'top'
                    --parent = c.screen,

                })
            end
        }
    },
    
    -- Add titlebars to normal clients and dialogs
    --{ 
    --    rule_any = {
    --        type = {
    --            'normal',
    --            'dialog'
    --        }
    --    },
    --    properties = {
    --        titlebars_enabled = false
    --    }
    --},

    -- Set Firefox to always map on the tag named '2' on screen 1.
    -- { rule = { class = 'Firefox' },
    --   properties = { screen = 1, tag = '2' } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal('manage', function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    c.size_hints_honor = false
    if awesome.startup
      and not c.size_hints.user_position
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
            c:emit_signal('request::activate', 'titlebar', { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal('request::activate', 'titlebar', { raise = true })
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
    c:emit_signal('request::activate', 'mouse_enter', {raise = false})
end)

client.connect_signal('focus', function(c) c.border_color = beautiful.border_focus end)
client.connect_signal('unfocus', function(c) c.border_color = beautiful.border_normal end)
-- }}}
