local gtable = require('gears.table')
local base = require('wibox.widget.base')
local fixed = require('wibox.layout.fixed')
local textbox = require('wibox.widget.textbox')
local prompt = require('awful.prompt')
local utils = require('terrible.utils')

local inputbox = { mt = {} }

function inputbox.clear(self)
    inputbox.text = ''
end

function inputbox.start(self)
    
end

function inputbox.stop(self)
    
end


local function new(default)
    local widget = textbox()
    gtable.crush(widget, inputbox, true)

    widget.default = default

    return widget
end

function inputbox.mt.__call(_, ...)
    return new(...)
end

return setmetatable(inputbox, inputbox.mt)
