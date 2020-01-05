--------------------------------------------------------------------------------
----------------------- AwesomeWM 4.2 void linux config ------------------------
-----------------------     by RazorKitty@null.net      ------------------------
--------------------------------------------------------------------------------
--local wibox = require('wibox')
--local awful = require('awful')
--              require('awful.autofocus')
-- Notification library

--local hotkeys_popup = require('awful.hotkeys_popup').widget
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
 --                     require('awful.hotkeys_popup.keys')
-- extras
--local mpd = require('mpd')
--local terrible = require('terrible')
--local power = require('power')
--local settings = require('settings')
-- make the globals local
--local awesome = awesome
--local root = root
--local client = client
--local screen = screen
--local gears = require('gears')

-- Standard awesome library
local beautiful = require('beautiful')
beautiful.init(os.getenv('HOME')..'/.config/awesome/theme/theme.lua')
local naughty = require('naughty')
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

--add the bits
local display = require('display')
local globalcontrols = require('globalcontrols')
local clientcontrols = require('clientcontrols')
