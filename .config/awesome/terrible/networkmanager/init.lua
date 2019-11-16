local table = table
local callback_handler = require('terrible.callback_handler')
local lgi = require('lgi')
local wibox = require('wibox')
local naughty = require('naughty')

local NM = lgi.NM
local property_callbacks = {}
local devices = {}

local client_signals = {
    on_device_added = function (self, device)
        table.insert(devices, device)
        property_callbacks[device] = callback_handler:new()
        device.on_notify = property_callbacks[device]
    end,
    on_device_removed = function (self, device)
        property_callbacks[device] = nil
    end
}

local Client = NM.Client(client_signals)

for _,device in ipairs(Client.devices) do
    table.insert(devices, device)
    property_callbacks[device] = callback_handler:new()
    device.on_notify = property_callbacks[device]
end


