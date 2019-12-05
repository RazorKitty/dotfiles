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


globalkeys = gears.table.join(
    -- media
    awful.key({}, 'XF86AudioMute', function ()
        awful.spawn.with_shell('pactl set-sink-mute @DEFAULT_SINK@ toggle')
    end,
    {description = 'Toggle Mute', group='media'}),    

    awful.key({}, 'XF86AudioLowerVolume', function ()
        awful.spawn.with_shell('pactl set-sink-volume @DEFAULT_SINK@ -1%')
    end,
    {description = 'Lower Volume', group='media'}),    

    awful.key({}, 'XF86AudioRaiseVolume', function ()
        awful.spawn.with_shell('pactl set-sink-volume @DEFAULT_SINK@ +1%')
    end,
    {description = 'Raise Volume', group='media'}),

    
    -- help
    awful.key({ settings.modkey }, 's',  hotkeys_popup.show_help,
              {description='show help', group = 'awesome'}),


    -- awesome

    awful.key({ settings.modkey }, 'r', function ()
        awful.screen.focused().prompt_widget:run()
    end,
    {description = 'run prompt', group = 'awesome'}),

    awful.key({ settings.modkey }, 'Return', function ()
            awful.spawn(settings.terminal)
        end,
        {description = 'open a terminal', group = 'awesome'}),

    awful.key({ settings.modkey, 'Control' }, 'r', awesome.restart,
        {description = 'reload awesome', group = 'awesome'}),

    awful.key({ settings.modkey, 'Shift'   }, 'q', awesome.quit,
        {description = 'quit awesome', group = 'awesome'}),
    

    -- layout

    awful.key({ settings.modkey, 'Control' }, 'h', function ()
            awful.client.swap.global_bydirection('left')
        end,
        {description = 'Swap wiith left side Client', group = 'layout'}),

    awful.key({ settings.modkey, 'Control' }, 'j', function ()
            awful.client.swap.global_bydirection('down')
        end,
        {description = 'Swap wiith right side Client', group = 'layout'}),

    awful.key({ settings.modkey, 'Control' }, 'k', function ()
            awful.client.swap.global_bydirection('up')
        end,
        {description = 'Swap with upper side Client', group = 'layout'}),

    awful.key({ settings.modkey, 'Control' }, 'l', function ()
            awful.client.swap.global_bydirection('right')
        end,
        {description = 'Swap with lower side Client', group = 'layout'}),

    awful.key({ settings.modkey }, '+', function ()
            awful.tag.incncol( 1, nil, true)
        end,
        {description = 'increase the number of columns', group = 'layout'}),

    awful.key({ settings.modkey }, '-', function () 
            awful.tag.incncol(-1, nil, true) 
        end,
        {description = 'decrease the number of columns', group = 'layout'}),

    awful.key({ settings.modkey }, '[', function ()
            awful.tag.incmwfact( 0.002)
        end,
        {description = "increase master width factor", group = "layout"}),

    awful.key({ settings.modkey }, ']', function ()
            awful.tag.incmwfact(-0.002)
        end,
        {description = "decrease master width factor", group = "layout"}),

    awful.key({ settings.modkey }, 'space', function () 
            awful.layout.inc( 1) 
        end,
        {description = 'select next', group = 'layout'}),

    awful.key({ settings.modkey, 'Shift' }, 'space', function () 
            awful.layout.inc(-1) 
        end,
        {description = 'select previous', group = 'layout'}),


    -- tag
    awful.key({ settings.modkey }, 'p', awful.tag.viewprev,
              {description = 'view previous', group = 'tag'}),

    awful.key({ settings.modkey }, 'n', awful.tag.viewnext,
              {description = 'view next', group = 'tag'}),

    awful.key({ settings.modkey }, 'Escape', awful.tag.history.restore,
              {description = 'go back', group = 'Tag'}),



    -- screen


    -- client
    awful.key({ settings.modkey }, 'h', function ()
            awful.client.focus.global_bydirection('left')
        end,
        {description = 'Move client focus left', group = 'client'}),

    awful.key({ settings.modkey }, 'j', function ()
            awful.client.focus.global_bydirection('down')
        end,
        {description = 'Move client focus down', group = 'client'}),

    awful.key({ settings.modkey }, 'k', function ()
            awful.client.focus.global_bydirection('up')
        end,
        {description = 'Move client focus up', group = 'client'}),

    awful.key({ settings.modkey }, 'l', function ()
            awful.client.focus.global_bydirection('right')
        end,
        {description = 'Move client focus right', group = 'client'}),

    awful.key({ settings.modkey }, 'u', awful.client.urgent.jumpto,
        {description = 'jump to urgent client', group = 'client'}),


    awful.key({ settings.modkey, 'Shift' }, 'm',
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = 'restore minimized client', group = 'client'})
)


-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ settings.modkey }, '#' .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            {description = 'view tag #'..i, group = 'tag'}),
        -- Toggle tag display.
        awful.key({ settings.modkey, 'Control' }, '#' .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = 'toggle tag #' .. i, group = 'tag'}),
        -- Move client to tag.
        awful.key({ settings.modkey, 'Shift' }, '#' .. i + 9,
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
        awful.key({ settings.modkey, 'Control', 'Shift' }, '#' .. i + 9,
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
    awful.button({}, 3, function () awful.screen.focused().main_menu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))

