local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')
local naughty = require('naughty')
local awful = require('awful')

local pulseaudio = {}

local get_sink_data = function (stdout)
    
end

awful.spawn('killall pactl')

local mon = function ()
    awful.spawn.with_line_callback('pactl subscribe ', {
        stdout = function (line)
            words = {}
            for word in line:gmatch("%w+") do table.insert(words, word) end
            if words[4] == 'sink' then
                awful.spawn.easy_async('pacmd list-sinks', function (stdout)
                    naughty.notify {
                        text = stdout
                    }
                end)
            end
        end
    })
end

return {
    mon = mon
}
