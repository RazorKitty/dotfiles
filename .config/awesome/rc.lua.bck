--------------------------------------------------------------------------------
----------------------- AwesomeWM 4.2 void linux config ------------------------
-----------------------     by RazorKitty@null.net      ------------------------
--------------------------------------------------------------------------------
-- globals
local awesome = awesome
local root = root
local client = client
local screen = screen

local settings = require('settings')

-- Standard awesome library
local beautiful = require('beautiful')
beautiful.init(os.getenv('HOME')..'/.config/awesome/theme/theme.lua')

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == 'function' then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.centered(wallpaper, s, true)
    end
end
screen.connect_signal('property::geometry', function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == 'function' then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- Standard awesome library
local gears = require('gears')
local wibox = require('wibox')
local naughty = require('naughty')
local awful = require('awful')
              require('awful.autofocus')

-- extras
local terrible = require('terrible')
local autostart = require('terrible.xdg.autostart')
autostart:start()

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
