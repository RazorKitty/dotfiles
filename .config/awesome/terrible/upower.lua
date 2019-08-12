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

local make_device_widget = function (template, device)
    local widget = wibox.widget(template)
    widget.device = device
    for _,prop in ipairs(device_properties) do
        for _,wdg in ipairs(widget:get_children_by_id(prop..'_role')) do
            wdg:update_widget(device)
        end
        upower.__callback_handlers[device:get_object_path()][prop]:add( function (...)
            for _,wdg in ipairs(widget:get_children_by_id(prop..'_role')) do
                wdg:update_widget(...)
            end
        end )
    end
    return widget
end

upower = {
    devices = {},
    __callback_handlers = {
        Client = {
            on_device_added = callback_handler:new {
                function (self, dev)
                    local dev_path dev:get_object_path()
                    upower.devices[dev_path] = dev
                    upower.__callback_handlers[dev_path] = {}
                    for _,prop in ipairs(device_properties) do
                        upower.__callback_handlers[dev_path][prop] = callback_handler:new()
                        dev.on_notify[prop] = upower.__callback_handlers[dev_path][prop]
                    end
                end
            },
            on_device_removed = callback_handler:new {
                function (self, dev_path)
                    upower.devices[dev_path] = nil
                    upower.__callback_handlers[dev_path] = nil
                end
            }
        },
    }
}

upower.Client = UPowerGlib.Client.new {
    on_device_added = upower.__callback_handlers.Client.on_device_added,
    on_device_removed = upower.__callback_handlers.Client.on_device_removed
}

for _,prop in ipairs(client_properties) do
    upower.__callback_handlers.Client[prop] = callback_handler:new()
    upower.Client.on_notify[prop] = upower.__callback_handlers.Client[prop]
end

upower.display_device = upower.Client:get_display_device()
upower.__callback_handlers[upower.display_device:get_object_path()] = {}

for _,prop in ipairs(device_properties) do
    upower.__callback_handlers[upower.display_device:get_object_path()][prop] = callback_handler:new()
    upower.display_device.on_notify[prop] = upower.__callback_handlers[upower.display_device:get_object_path()][prop]
end

for _,dev in ipairs(upower.Client:get_devices()) do 
    local dev_path  = dev:get_object_path()
    upower.devices[dev_path] = dev
    upower.__callback_handlers[dev_path] = {}
    for _,prop in ipairs(device_properties) do
        upower.__callback_handlers[dev_path][prop] = callback_handler:new()
        dev.on_notify[prop] = upower.__callback_handlers[dev_path][prop]
    end
end

upower.client_widget = function (args)
    local client_widget = wibox.widget(args.template)
    for _,container in ipairs(client_widget:get_children_by_id('client_container_role')) do
        for _,prop in ipairs(client_properties) do
            for _,wdg in ipairs(container:get_children_by_id(prop..'role')) do
                wdg:update_widget(upower.Client)
            end
            upower.__callback_handlers.Client[prop]:add(function (...)
                for _,wdg in ipairs(container:get_children_by_id(prop..'_role')) do
                    wdg:update_widget(...)
                end
            end)
            upower.__callback_handlers.Client.on_device_added:add(function (...)
                for _,wdg in ipairs(container:get_children_by_id('on_device_added_role')) do
                    wdg:update_widget(...)
                end
            end )
            upower.__callback_handlers.Client.on_device_removed:add(function (...)
                for _,wdg in ipairs(container:get_children_by_id('on_device_removed_role')) do
                    wdg:update_widget(...)
                end
            end )
        end
    end
    return client_widget
end

upower.display_device_widget = function (args)
    local kind = UPowerGlib.Device.kind_to_string(upower.display_device.kind)
    if not args.templates[kind] then
        return nil
    end
    return make_device_widget(args.templates[kind], upower.display_device)
end

upower.devices_widget = function (args)
    local container_widget = wibox.widget(args.container_template)
    for _,wdg in ipairs(container_widget:get_children_by_id('devices_container_role')) do
        wdg.device_templates = args.device_templates
        for dev_path,dev in pairs(upower.devices) do
            local template = wdg.device_templates[UPowerGlib.Device.kind_to_string(dev.kind)]
            if template then
                wdg:device_added(dev_path, make_device_widget(template, dev))
            end
        end
        upower.__callback_handlers.Client.on_device_added:add(function (client, dev)
            local template = wdg.device_templates[UPowerGlib.Device.kind_to_string(dev.kind)]
            if template then
                wdg:device_added(dev:get_object_path(), make_device_widget(template, dev))
            end
        end)
        upower.__callback_handlers.Client.on_device_removed:add(function (client, dev_path)
            wdg:device_removed(dev_path)
        end)
    end
    return container_widget
end

return upower
