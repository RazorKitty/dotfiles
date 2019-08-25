local table = table
local callback_handler = require('terrible.callback_handler')
local wibox = require('wibox')
local lgi = require('lgi')
local UPowerGlib = lgi.UPowerGlib

local client_properties = {
    'daemon-version',
    'lid-is-closed',
    'lid-is-present',
    'on-battery'
}

local device_properties = {
    'battery-level',
    'capacity',
    'energy',
    'energy_empty',
    'energy-full',
    'energy-full-design',
    'energy-rate',
    'has_history',
    'has_statistics',
    'icon_name',
    'is-present',
    'is-rechargeable',
    'kind',
    'luminosity',
    'model',
    'native-path',
    'online',
    'percentage',
    'power-supply',
    'serial',
    'state',
    'technology',
    'temperature',
    'time-to-empty',
    'time-to-full',
    'update-time',
    'vendor',
    'voltage',
    'warning-level'
}


local property_callbacks = setmetatable({}, {__mode = 'k'})


-- we need an external refference to these functions
-- as we cannot get them back from the 'on_' accessors
local devices
local client_singals = {
    on_device_added = callback_handler:new {
        function (self, device)
            table.insert(devices, device)
            property_callbacks[device] = callback_handler:new()
            device.on_notify = property_callbacks[device]
        end
    },
    on_device_removed = callback_handler:new()
}

local Client = UPowerGlib.Client(client_singals)
property_callbacks[Client] = callback_handler:new()

local display_device = Client:get_display_device()

property_callbacks[display_device] = callback_handler:new()
display_device.on_notify = property_callbacks[display_device]

devices = setmetatable(Client:get_devices(), {__mode = 'v'})

for _,device in ipairs(devices) do
    property_callbacks[device] = callback_handler:new()
    device.on_notify = property_callbacks[device]
end

Client.on_notify = property_callbacks[Client]

local client_widget = function (args)
    local widget = wibox.widget(args.template)
    for _,prop in ipairs(client_properties) do
        for _,wdg in ipairs(widget:get_children_by_id(prop..'_role')) do
            wdg:update_widget(client)
        end
    end
    property_callbacks[Client]:add( function (self, pspec)
        for _,wdg in ipairs(widget:get_children_by_id(pspec.name..'_role')) do
            wdg:update_widget(self)
        end
    end )
    return widget
end

local make_device_widget = function (device, template)
    local widget = wibox.widget(template)
    for _,prop in ipairs(device_properties) do
        for _,wdg in ipairs(widget:get_children_by_id(prop..'_role')) do
            wdg:update_widget(device)
        end
    end
    property_callbacks[device]:add( function (dev, pspec)
        for _,wdg in ipairs(widget:get_children_by_id(pspec.name..'_role')) do
            wdg:update_widget(dev)
        end
    end )
    return widget
end

local display_device_widget = function (args)
    local kind = args.templates[UPowerGlib.Device.kind_to_string(display_device.kind)] 
    if kind then
        return make_device_widget(display_device, kind)
    end
end

local devices_widget = function (args)
    local container_widget = wibox.widget(args.container_template)
    for _,wdg in ipairs(container_widget:get_children_by_id('container_role')) do
        for _,dev in ipairs(devices) do
            local kind = args.device_templates[UPowerGlib.Device.kind_to_string(dev.kind)]
            if kind then
                wdg:device_added(dev, make_device_widget(dev, kind))
            end
        end
        client_singals.on_device_added:add( function (self, dev)
            local kind = args.device_templates[UPowerGlib.Device.kind_to_string(dev.kind)]
            if kind then
                wdg:device_added(dev, make_device_widget(dev, kind))
            end
        end )
        client_singals.on_device_removed:add( function (self, dev_path)
            wdg:device_removed(dev_path)
        end )
    end
    return container_widget
end

local upower_mt = {
    devices = devices,
    client_singals = client_singals,
    property_callbacks = property_callbacks,
}

return setmetatable({
    client_widget = client_widget,
    display_device_widget = display_device_widget,
    devices_widget = devices_widget,
    add_client_property_callback = function (prop, func)
        property_callbacks[Client]:add( function (self, pspec)
            if pspec.name == prop then
                func(self)
            end
        end )
    end,
    add_client_signal_callback = function (signal, func)
        client_singals[signal]:add(func)
    end,
    add_display_device_callback = function (prop, func)
        property_callbacks[display_device]:add( function (self, pspec)
            if pspec.name == prop then
                func(self)
            end
        end )
    end
}, upower_mt)








