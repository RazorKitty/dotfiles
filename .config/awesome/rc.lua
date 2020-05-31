--------------------------------------------------------------------------------
----------------------- AwesomeWM 4.2 void linux config ------------------------
-----------------------     by RazorKitty@null.net      ------------------------
--------------------------------------------------------------------------------
-- Global Names
local awesome = awesome
local root = root
local client = client
local screeen = screen
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
local hotkeys_popup = require('awful.hotkeys_popup')
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require('awful.hotkeys_popup.keys')

local autostart = require('xdg.autostart')
local upower = require('upower')

beautiful.init(os.getenv('HOME')..'/.config/awesome/theme/theme.lua')
-- Error handling --------------------------------------------------------------
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = 'Oops, there were errors during startup!',
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal('debug::error', function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = 'Oops, an error happened!',
                         text = tostring(err) })
        in_error = false
    end)
end

-- Set some variables ----------------------------------------------------------

local modkey = 'Mod4'
local terminal = 'st'

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}

-- Useful Functions ------------------------------------------------------------

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

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                'request::activate',
                'tasklist',
                {raise = true}
            )
        end
    end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
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

local format_time = function(seconds)
    if seconds <= 0 then
        return "0h 0m";
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        return hours.."h "..mins.."m"
    end
end

-- Screens ---------------------------------------------------------------------

screen.connect_signal('property::geometry', set_wallpaper)

--set the focused scren on start
awful.placement.centered(mouse, { parent = screen.primary })

-- time widget
local panel_time_widget = wibox.widget {
    layout = wibox.container.background,
    bg = beautiful.widget_normal_bg,
    fg = beautiful.widget_normal_fg,
    {
        layout = wibox.container.margin,
        left = beautiful.widget_outer_margins,
        right = beautiful.widget_outer_margins,
        wibox.widget.textclock('%H:%M %A %d/%m/%y', 60, 'Europe/London')
    }
}

local upower_warning_level_colors = {
    {
        fg = beautiful.widget_normal_fg,
        bg = beautiful.widget_normal_bg,
    },
    {
        fg = beautiful.widget_focus_fg,
        bg = beautiful.widget_focus_bg
    },
    {
        fg = beautiful.widget_warning_fg,
        bg = beautiful.widget_warning_bg,
    },
    {
        fg = beautiful.widget_urgent_fg,
        bg = beautiful.widget_urgent_bg
    }
}


--local panel_upower_widget = upower:display_device_widget {
--    layout = wibox.container.background,
--    fg = beautiful.widget_normal_fg,
--    bg = beautiful.widget_normal_bg,
--    {
--        layout = wibox.container.margin,
--        left = beautiful.widget_outer_margins,
--        right = beautiful.widget_outer_margins,
--        {
--            id = 'data_textbox_role',
--            widget = wibox.widget.textbox
--        }
--    },
--    create_callback = function (self, device)
--        if device.kind_to_string(device.kind) ~= 'battery' then
--            return false
--        end
--        self.states = upower_warning_level_colors
--        self.fg = self.states[device.warning_level].fg
--        self.bg = self.states[device.warning_level].bg
--
--        self.data_textbox = self:get_children_by_id('data_textbox_role')[1]
--        self.data_textbox.text = 'Bat:'..
--            format_time((device.time_to_empty > 0) and device.time_to_empty or device.time_to_full)..
--            device.state_to_string(device.state)
--        
--            return true
--    end,
--    update_callback = function (self, device)
--        self.fg = self.states[device.warning_level].fg
--        self.bg = self.states[device.warning_level].bg
--        self.data_textbox.text = 'Bat:'..
--        format_time((device.time_to_empty > 0) and device.time_to_empty or device.time_to_full)..
--        device.state_to_string(device.state)
--    end
--} or upower.devices_widget {
--    container_template = {
--        wibox.container.background,
--        fg = beautiful.widget_normal_fg,
--        bg = beautiful.widget_normal_bg,
--        {
--            layout = wibox.container.margin,
--            left = beautiful.widget_outer_margins,
--            right = beautiful.widget_outer_margins,
--            {
--                id = 'layout_role',
--                layout = wibox.layout.fixed.horizontal
--            }
--        },
--        create_callback = function (self)
--            self.layout_role = self:get_children_by_id('layout_role')[1]
--            self.devices = {}
--        end,
--        add_device_widget = function (self, device, widget)
--            self.devices[device:get_object_path()] = widget
--            self.layout_role:add(widget)
--        end,
--        remove_device_widget = function (self, device_path)
--            self.layout_role:remove_widgets(self.devices[device_path])
--            self.devices[device_path] = nil
--        end
--    }
--}

--local panel_upower_widget = upower:devices_widget {
--    container_template = {
--        layout = wibox.container.background,
--        fg = beautiful.widget_normal_fg,
--        bg = beautiful.widget_normal_bg,
--        {
--            layout = wibox.container.margin,
--            left = beautiful.widget_outer_margins_left,
--            right = beautiful.widget_outer_margins_right,
--            {
--                id = 'layout_role',
--                layout = wibox.layout.fixed.horizontal,
--            }
--        },
--        device_path_lookup = {},
--        add_device_widget = function (self, device, widget)
--            naughty.notify {
--                text = device:get_object_path(),
--                timeout = 0
--            }
--            self.device_path_lookup[device:get_object_path()] = widget
--            self:get_children_by_id('layout_role')[1]:add(widget)
--        end,
--        remove_device_widget = function (self, dev_path)
--            naughty.notify {
--                text = dev_path,
--                timeout = 0
--            }
--            self:get_children_by_id('layout_role')[1]:remove_widgets(self.device_path_lookup[dev_path])
--        end
--    },
--    device_template = {
--        widget = wibox.widget.textbox,
--        create_callback = function (self, dev)
--            self.text = dev.kind_to_string(dev.kind)..':'..dev.state_to_string(dev.state)
--            return true
--        end,
--        update_callback = function (self, dev)
--            self.text = dev.kind_to_string(dev.kind)..':'..dev.state_to_string(dev.state)
--        end
--    }
--}

awful.screen.connect_for_each_screen(function (s)
    -- Wallpaper
    set_wallpaper(s)
    
    -- Create Tags
    for i=1,9,1 do
        awful.tag.add(i, {
            selected = i == 1,
            index = i,
            screen = s,
            master_width_factor = beautiful.master_width_factor,
            layout = awful.layout.layouts[1],
            layouts = awful.layout.layouts,
            volitile = false,
            gap = beautiful.useless_gap,
            gap_singel_client = true,
            master_fill_policy = beautiful.master_fill_policy,
            master_count = 1,
            column_count = 1,
        })
    end
    
    s.prompt_widget = wibox.widget {
        layout = wibox.container.background,
        fg = beautiful.widget_focus_fg,
        bg = beautiful.widget_focus_bg,
        visible = false,
        {
            layout = wibox.container.margin,
            left = beautiful.widget_outer_margins,
            right = beautiful.widget_outer_margins,
            {
                id = 'prompt_textbox_role',
                widget = wibox.widget.textbox
            }
        }
    }

    s.layout_widget = wibox.widget {
        layout = wibox.container.background,
        fg = beautiful.widget_normal_fg,
        bg = beautiful.widget_normal_bg,
        {
            layout = wibox.container.margin,
            left = beautiful.widget_outer_margins,
            right = beautiful.widget_outer_margins,
            awful.widget.layoutbox(s)
        }
    }

    s.layout_widget:buttons(gears.table.join(
            awful.button({ }, 1, function ()
                awful.layout.inc( 1)
            end),
            awful.button({ }, 3, function ()
                awful.layout.inc(-1)
            end),
            awful.button({ }, 4, function ()
                awful.layout.inc( 1)
            end),
            awful.button({ }, 5, function ()
                awful.layout.inc(-1)
            end)
        )
    )
    -- Create a taglist widget
    s.taglist_widget = awful.widget.taglist {
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
                    left = beautiful.widget_inner_margins_left,
                    right = beautiful.widget_inner_margins_right,
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox
                    }
                }
            }
        }
    }

    -- Create a tasklist widget
    s.tasklist_widget = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        layout = {
            layout = wibox.layout.fixed.horizontal
        },
        template_widget = {
            {
                id = 'background_role',
                layout = wibox.container.background,
                {
                    layout = wibox.container.margin,
                    left = beautiful.widget_inner_margins_left,
                    right = beautiful.widget_inner_margins_right,
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox,
                    }
                }
            }
        }
    }

    s.panel_widget = wibox.widget {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.container.background,
            fg = beautiful.widget_group_normal_fg,
            bg = beautiful.widget_group_normal_bg,
            {
                layout = wibox.layout.fixed.horizontal,
                s.taglist_widget,
                s.tasklist_widget,
                s.prompt_widget
            }
        },
        {
            layout = wibox.layout.fixed.horizontal
        },
        {
            layout = wibox.container.background,
            fg = beautiful.widget_group_normal_fg,
            bg = beautiful.widget_group_normal_bg,
            {
                layout = wibox.layout.fixed.horizontal,
                s == screen.primary and panel_upower_widget,
                panel_time_widget,
                s.layout_widget
            }
        }
    }


    s.panel = awful.popup {
        border_width = beautiful.wibox_border_width,
        border_color = beautiful.wibox_border_color,
        bg = beautiful.wibox_bg,
        fg = beautiful.wibox_fg,
        ontop = false,
        visible = true,
        type = 'dock',
        screen = s,
        height = 16,
        widget = s.panel_widget,
    }

    s.panel:struts {
        top = s.panel.height +  (beautiful.useless_gap)
    }

    --s.panel:connect_signal('property::height', function (self, height)
    --    self:struts {
    --        top = self.height + (2 * beautiful.useless_gap)
    --    }
    --end)


    local f = awful.placement.top + awful.placement.maximize_horizontally
    f(s.panel, {
        margins =  (beautiful.useless_gap),
        attach = true,
    })
end)

-- Mouse Bindings --------------------------------------------------------------

root.buttons(gears.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Key Bindings ----------------------------------------------------------------
local global_key_bindings = gears.table.join(
    -- Awesome
    awful.key({ modkey, 'Control' }, 'r', awesome.restart,
        { description = 'Reload awesome', group = 'Awesome' }),

    awful.key({ modkey, 'Shift' }, 'q', awesome.quit,
        { description = 'Quit awesome', group = 'Awesome' }),

    awful.key({ modkey }, 's', hotkeys_popup.show_help,
    { description = 'Show help', group = 'Awesome' }),

    awful.key( {modkey}, 'z', function ()
        local s = awful.screen.focused()
        s.panel.visible = not s.panel.visible
    end,
    {}),

    -- Launcher
    awful.key({ modkey }, 'Return', function ()
            awful.spawn(terminal)
        end,
        { description = 'Open a terminal', group = 'Launcher' }),

    awful.key({ modkey }, 'r', function ()
        local s = awful.screen.focused()
        local prestate = s.panel.visible
        s.panel.visible = true
        s.prompt_widget.visible = true
        awful.prompt.run {
            fg_cursor = beautiful.prompt_fg_cursor,
            bg_cursor = beautiful.prompt_bg_cursor,
            prompt = '>_ ',
            font = beautiful.font,
            textbox = s.prompt_widget:get_children_by_id('prompt_textbox_role')[1],
            history_path = awful.util.get_cache_dir() .. 'run_history',
            completion_callback = awful.completion.shell,
            --exe_callback = function (command)
            --    awful.spawn(command)
            --end,
            done_callback = function ()
                s.panel.visible = prestate
                s.prompt_widget.visible = false
            end,
            changed_callback = function (command)
            end,
            hooks = {
                {{}, 'Return', function (command)
                    local sn_props = {}
                    if command:sub(1,1) == ':' then
                        local cmd = command:match('^[:](.*)')
                        command = terminal..' -c '..cmd..' -e '..cmd
                    end
                    if #command ~= 0 then
                        awful.spawn(command, sn_props)
                    end

                end}
            }
        }
    end,
    { description = 'Run Prompt', group = 'Launcher' }),

    -- Client
    awful.key({ modkey }, 'j', function ()
            awful.client.focus.global_bydirection('down')
        end,
        { description = 'Move client focus down', group = 'Client' }),

    awful.key({ modkey }, 'k', function ()
            awful.client.focus.global_bydirection('up')
        end,
        { description = 'Move client focus up', group = 'Client' }),
    
    awful.key({ modkey }, 'h', function ()
            awful.client.focus.global_bydirection('left')
        end,
        { description = 'Move client focus left', group = 'Client' }),

    awful.key({ modkey }, 'l', function ()
            awful.client.focus.global_bydirection('right')
        end,
        { description = 'Move client focus right', group = 'Client' }),
    
    awful.key({ modkey }, 'u', awful.client.urgent.jumpto,
              {description = 'Jump to urgent client', group = 'Client' }),

    awful.key({ modkey, 'Shift' }, 'm', function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                client.focus = c
                c:raise()
            end
        end,
        { description = "Restore minimized", group = 'Client' }),

    awful.key({ modkey, 'Control' }, 'h', function ()
            awful.client.swap.global_bydirection('left')
        end,
        { description = 'Swap with left side Client', group = 'Client' }),

    awful.key({ modkey, 'Control' }, 'j', function ()
            awful.client.swap.global_bydirection('down')
        end,
        { description = 'Swap with right side Client', group = 'Client' }),

    awful.key({ modkey, 'Control' }, 'k', function ()
            awful.client.swap.global_bydirection('up')
        end,
        { description = 'Swap with upper side Client', group = 'Client' }),

    awful.key({ modkey, 'Control' }, 'l', function ()
            awful.client.swap.global_bydirection('right')
        end,
        { description = 'Swap with lower side Client', group = 'Client' }),

    awful.key({ modkey }, 'Tab', function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = 'go back', group = 'Client' }),

    -- Layout
    awful.key({ modkey }, 'space', function ()
            awful.layout.inc(1)
        end,
        { description = 'select next', group = 'Layout' }),

    awful.key({ modkey, 'Shift' }, 'space', function ()
            awful.layout.inc(-1)
        end,
        { description = 'select previous', group = 'Layout' }),

    -- Tag
    awful.key({ modkey }, 'p', awful.tag.viewprev,
        { description = 'view previous', group = 'Tag' }),

    awful.key({ modkey }, 'n', awful.tag.viewnext,
        { description = 'view next', group = 'Tag' })
)

for i = 1, 9 do
    global_key_bindings = gears.table.join(global_key_bindings,
        -- View tag only.
        awful.key({ modkey }, '#' .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = 'View tag #'..i, group = 'Tag' }),

        -- Toggle tag display.
        awful.key({ modkey, 'Control' }, '#' .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = 'Toggle tag #' .. i, group = 'Tag' }),
            --
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
            { description = 'Move focused client to tag #' .. i, group = 'Tag' }),
            --
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
            { description = 'Toggle focused client on tag #' .. i, group = 'Tag' })
    )
end

root.keys(global_key_bindings)

-- Client Mouse Bindings -------------------------------------------------------

local client_mouse_bindings = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal('request::activate', 'mouse_click', {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal('request::activate', 'mouse_click', {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal('request::activate', 'mouse_click', {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Client Key Bindings ---------------------------------------------------------

local client_key_bindings = gears.table.join(
    awful.key({ modkey }, 'f', function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = 'Toggle fullscreen', group = 'Client'}),
    
    awful.key({ modkey }, 'x', function (c) 
            c:kill()
        end,
        {description = 'close', group = 'Client'}),
    
    awful.key({ modkey, 'Control' }, 'space', awful.client.floating.toggle,
              {description = 'toggle floating', group = 'Client'}),
    
    awful.key({ modkey, 'Control' }, 'Return', function (c)
            c:swap(awful.client.getmaster())
        end,
        {description = 'Move to master', group = 'Client'}),
    
    
    awful.key({ modkey, 'Shift' }, 'j', function (c)
            local s = c.screen:get_next_in_direction('down')
            if s then
                c.screen = s
            end
        end,
        {description = 'Move client down a screen', group = 'Client'}),
    
    awful.key({ modkey, 'Shift' }, 'k', function (c)
            local s = c.screen:get_next_in_direction('up')
            if s then
                c.screen = s
            end
        end,
        {description = 'Move client up a screen',  group = 'Client'}),
        
    awful.key({ modkey, 'Shift' }, 'h', function (c)
            local s = c.screen:get_next_in_direction('left')
            if s then
                c.screen = s
            end
        end,
        {description = 'Move client left a screen',  group = 'Client'}),
    
    awful.key({ modkey, 'Shift' }, 'l', function (c)
            local s = c.screen:get_next_in_direction('right')
            if s then
                c.screen = s
            end
        end,
        {description = 'Move client right a screen',  group = 'Client'}),
    
    awful.key({ modkey }, 'm', function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        {description = 'minimize', group = 'Client'}),

    
    awful.key({ modkey, 'Shift' }, 'n', function (c)
            c:move_to_tag(c.screen.tags[c.first_tag.index +1] or c.screen.tags[1])
        end,
        {description = 'Move client to next tag', group = 'Client'}),
    
    awful.key({ modkey, 'Shift' }, 'p', function (c)
            c:move_to_tag(c.screen.tags[c.first_tag.index -1] or c.screen.tags[#c.screen.tags])
        end,
        {description = 'Move client to previous tag', group = 'Client'})
)


-- Client Rules ----------------------------------------------------------------

awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = client_key_bindings,
            buttons = client_mouse_bindings,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
       }
    },
    -- Floating clients.
    {
        rule_any = {
            class = {
              'mpv',
              'ncmpcpp'
            },
        },
        properties = {
            floating = true,
            raise = true,
            buttons = {},
            sticky = true
        },
        callback = function (c)
            local count = screen:count()

            c.screen = (count > 2) and screen.primary:get_next_in_direction('up') or screen.primary
            local f = awful.placement.scale + ((count > 2) and awful.placement.bottom_right or awful.placement.top_right)
            f(c, {
                offset = {
                    x = (count > 2) and (-beautiful.useless_gap) or beautiful.useless_gap,
                    y = (count > 2) and (-beautiful.useless_gap) or beautiful.useless_gap
                },
                --margins = beautiful.useless_gap,
                to_percent = 0.33,
                --direction = 'right'
            })

        end
    },
    -- Discord
    {   
        rule_any = {
            class = {
                'discord'
            }
        },
        callback = function (c)
            if screen.count() > 2 then
                c.screen = screen.primary:get_next_in_direction('right')
            end
        end
    },
    
    {
        rule_any = {
            class = 'csgo_linux64'
        },
        properties = {
            screen = screen.primary,
            border_width = 0,
            new_tag = {
                name = 'Game',
                layout = awful.layout.suit.tile,
                volitile = true
            }
        }
    },
    -- Add titlebars to normal clients and dialogs
    {
        rule_any = {
            type = {
                'normal',
                'dialog'
            }
        },
        properties = {
            titlebars_enabled = false,
        }
    }
}

-- Client Signals --------------------------------------------------------------

client.connect_signal('manage', function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

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
            c:emit_signal('request::activate', 'titlebar', {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal('request::activate', 'titlebar', {raise = true})
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

-- Start Extra Services --------------------------------------------------------

autostart:start()
