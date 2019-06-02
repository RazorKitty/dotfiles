local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')
local awful = require('awful')

local sink = {}


local get_sinks = function (data)

    -- split the data into seperate sinks
    -- add a new line to the end for easier pattern matching
    data = data..'\n'
    for sinks in data:gmatch('(.-)\n\n') do
        
    end

    -- load each sink into an object
end


local widget = function (args)
    
end
