local setmetatable = setmetatable
local table = table
local callback_handler = require('callback_handler')

local lgi = require('lgi')
local UPowerGlib = lgi.UPowerGlib
local Device = UPowerGlib.Device

local wibox = require('wibox')

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


function upower.create_device_widget(self, args)
    if not args.device_templates[Device.kind_to_string(args.device.kind)] then
        return nil
    end

    local widget = wibox.widget(args.device_templates[Device.kind_to_string(args.device.kind)])

    widget:on_init(args.device)

    self.property_callbacks[args.device]:add( function (dev, pspec)
        local method = 'on_'..pspec.name:gsub('-', '_')

        if widget[method] then
            widget[method](widget, dev)
        end
    end )

    return widget
end

function upower.client_widget (self, template)
    local widget = wibox.widget(template)

    widget:on_init(self.client)

    self.property_callbacks[self.client]:add( function (c, pspec)
        local method = 'on_'..pspec.name:gsub('-', '_')

        if widget[method] then
            widget[method](widget, c)
        end
    end )
    
    return widget
end

function upower.display_device_widget (self, device_templates)
    return self:create_device_widget { device_templates = device_templates, device = self.display_device }
end

function upower.devices_widget (self, args)
    local container_widget = wibox.widget(args.container_template)
    container_widget:on_init()

    for i, dev in ipairs(self.devices) do
        local device_widget = self:create_device_widget { device_templates = args.device_templates, device = dev }
        if device_widget then
            container_widget:add_device_widget(dev, device_widget)
        end
    end

    self.client_signals.on_device_added:add( function (c, dev)
        local device_widget = self:create_device_widget { device_templates = args.device_templates, device = dev }
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

