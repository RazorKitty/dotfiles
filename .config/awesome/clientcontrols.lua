-- make the globals local
local awesome = awesome
local root = root
local client = client
local screen = screen

-- Standard awesome library
local gears = require('gears')
local beautiful = require('beautiful')
beautiful.init('~/.config/awesome/theme/theme.lua')

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
local mpd = require('mpd')
local terrible = require('terrible')
local power = require('power')
local settings = require('settings')

clientkeys = gears.table.join(
    awful.key({ settings.modkey }, 'f', function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = 'toggle fullscreen', group = 'client'}),

    awful.key({ settings.modkey, 'Shift' }, 'c', function (c) 
            c:kill()
        end,
        {description = 'close', group = 'client'}),

    awful.key({ settings.modkey, 'Control' }, 'space', awful.client.floating.toggle,
              {description = 'toggle floating', group = 'client'}),

    awful.key({ settings.modkey, 'Control' }, 'Return', function (c)
            c:swap(awful.client.getmaster())
        end,
        {description = 'move to master', group = 'client'}),

--    awful.key({ settings.modkey, 'Shift' }, 'j', function (c)
--            
--        end,
--        {description = 'move client down a screen', group = 'client'}),
--
--    awful.key({ settings.modkey, 'Shift' }, 'k', function (c)
--            
--        end,
--        {description = 'move client up a screen',  group = 'client'}),
--        
--    awful.key({ settings.modkey, 'Shift' }, 'h', function (c)
--            
--        end,
--        {description = 'move client left a screen',  group = 'client'}),
--
--    awful.key({ settings.modkey, 'Shift' }, 'l', function (c)
--            
--         end,
--        {description = 'move client right a screen',  group = 'client'}),

    awful.key({ settings.modkey }, 'm', function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
        end,
        {description = 'minimize', group = 'client'}),

    awful.key({ settings.modkey, 'Shift' }, 'n', function (c)
        c:move_to_tag(c.screen.tags[c.first_tag.index +1] or c.screen.tags[1])
    end,
    {description = 'move client to next tag', group='client'}),

    awful.key({ settings.modkey, 'Shift' }, 'p', function (c)
        c:move_to_tag(c.screen.tags[c.first_tag.index -1] or c.screen.tags[#c.screen.tags])
    end,
    {description = 'move client to previous tag', group='client'})

)

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ settings.modkey }, 1, awful.mouse.client.move),
    awful.button({ settings.modkey }, 3, awful.mouse.client.resize))

----------------------------------------------------------------------- Rules --

local spread_layout = function (obj, args)
    args.margins = 32
    local l = awful.placement.no_overlap
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
            size_hints_honor = false,
        }
    },
    {
        rule = {
            class = 'csgo_linux64'
        },
        properties = {
            border_width = 0,
            fullscreen = true,
            focus = true,
            new_tag = {
                name = 'CS:GO',
                layout = awful.layout.suit.max,
                volatile = true
            }
        }
    },
    {
        rule = {
            class = 'oblivion.exe'
        },
        properties = {
            border_width = 0,
            fullscreen = true,
            focus = true,
            new_tag = {
                name = 'Oblivion',
                layout = awful.layout.suit.max,
                volatile = true
            }
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
