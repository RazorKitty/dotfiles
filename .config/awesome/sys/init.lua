--local backlight = require('backlight')
local power_supply = require('sys/power_supply')
local backlight = require('sys/backlight')
local sys = {
    power_supply = power_supply,
    backlight = backlight
}

return sys
