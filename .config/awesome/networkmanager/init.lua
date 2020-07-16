local tabl = table
local setmetatable = setmetatable

local callback_handler = require('callback_handler')

local lgi = require('lgi')
local NM = lgi.NM

local wibox = require('wibox')
local beautiful = require('beautiful')

local access_point_template = {

}

local device_templates = {
    ETHERNET = {
        layout = wibox.container.background,
    }
}

local networkmanager = {}

