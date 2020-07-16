local table = table
local callback_handler = require('callback_handler')

local lgi = require('lgi')
local UPowerGlib = lgi.UPowerGlib

local wibox = require('wibox')
local naughty = require('naughty')


local upower

upower = {
    property_callbacks = setmetatable({}, {__mode = 'k'}),
    devices_lookup = {},
    devices = {},
    client_signals = {
        on_device_added = callback_handler:new {
            function (self, device)
                table.insert(upower.devices, device)
                upower.devices_lookup[device:get_object_path()] = device
                upower.property_callbacks[device] = callback_handler:new()
                device.on_notify = upower.property_callbacks[device]
            end
        },
        on_device_removed = callback_handler:new {
            function (self, dev_path)
                upower.devices[upower.devices_lookup[dev_path]] = nil
                upower.devices_lookup[dev_path] = nil
            end
        }
    }
}

-- we need an external reference to these functions
-- as we cannot get them back from the 'on_' accessors
upower.client = UPowerGlib.Client(upower.client_signals)

upower.property_callbacks[upower.client] = callback_handler:new()
upower.client.on_notify = upower.property_callbacks[upower.client]

upower.display_device = upower.client:get_display_device()
upower.property_callbacks[upower.display_device] = callback_handler:new()
upower.display_device.on_notify = upower.property_callbacks[upower.display_device]


for idx,device in ipairs(upower.client:get_devices()) do
    table.insert(upower.devices, device)
    upower.property_callbacks[device] = callback_handler:new()
    device.on_notify = upower.property_callbacks[device]
    upower.devices_lookup[device:get_object_path()] = idx
end


function upower.create_widget(self, args)
    local widget = wibox.widget(args.template)
    if widget:create_callback(args.device) then
        widget:update_callback(args.device)
        self.property_callbacks[args.device]:add( function (...)
            widget:update_callback(...)
        end )
        return widget
    end
end

function upower.client_widget (self, template)
    return self:create_widget { template = template, device = self.client }
end

function upower.display_device_widget (self, template)
    return self:create_widget { template = template, device = self.display_device }
end

function upower.devices_widget (self, args)
    local container_widget = wibox.widget(args.container_template)
    container_widget:create_callback()

    for i, dev in ipairs(self.devices) do
        local device_widget = self:create_widget { template = args.device_template, device = dev }
        if device_widget then
            container_widget:add_device_widget(dev, device_widget)
        end
    end

    self.client_signals.on_device_added:add( function (c, dev)
        local device_widget = self:create_widget { template = args.device_template, device = dev }
        if device_widget then
            container_widget:add_device_widget(dev, device_widget)
        end
    end )

    self.client_signals.on_device_removed:add( function (c, dev_path)
        container_widget:remove_device_widget(dev_path)
    end )

    return container_widget
end


return upower

