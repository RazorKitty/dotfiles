local floor = math.floor
local lgi = require('lgi')
local wibox = require('wibox')
local awful = require('awful')
local naughty = require('naughty')
UPowerGlib = lgi.UPowerGlib

local properties = {
    'battery_level',
    'capacity',
    'energy',
    'energy_empty',
    'energy_full',
    'energy_full_design',
    'energy_rate',
    'has_history',
    'has_statistics',
    'icon_name',
    'is_present',
    'is_rechargeable',
    'kind',
    'luminosity',
    'model',
    'native_path',
    'online',
    'percentage',
    'power_supply',
    'serial',
    'state',
    'technology',
    'temperature',
    'time_to_empty',
    'time_to_full',
    'update_time',
    'vendor',
    'voltage',
    'warning_level'
}

local make_device_widget = function (args)
    local widget = wibox.widget(args.template)
    widget.device = args.device
    for _,prop in ipairs(properties) do
        for _,wdg in ipairs(widget:get_children_by_id(prop..'_role')) do
            wdg:update_upower_widget(args.device)
        end
        widget.device.on_notify[prop] = function (obj, pspec)
            for _,wdg in ipairs(widget:get_children_by_id(prop..'_role')) do
                wdg:update_upower_widget(obj)
            end                
        end
    end
    return widget
end

local upower = {}

upower.display_device_widget = function (args)
    local Client = UPowerGlib.Client.new()
    local display_device = Client:get_display_device()
    if not args.templates[UPowerGlib.Device.kind_to_string(display_device.kind)] then
        return nil
    end
    local display_device_widget = make_device_widget {
        template = args.templates[UPowerGlib.Device.kind_to_string(display_device.kind)],
        device = display_device,
    }
    return display_device_widget
end

upower.devices_widget = function (args) 
    local container_widget = wibox.widget(args.container_template)
    for _,wdg in ipairs(container_widget:get_children_by_id('devices_container_role')) do
        wdg.Client = UPowerGlib.Client.new()
        wdg.devices = wdg.Client:get_devices()
        
        for _,dev in ipairs(wdg.devices) do
            if args.device_templates[UPowerGlib.Device.kind_to_string(dev.kind)] then
                wdg:upower_device_added( 
                    make_device_widget {
                        -- wrap the templatte for easy identifcation later
                        template = {
                            id = dev.native_path,
                            layout = wibox.container.background,
                            args.device_templates[UPowerGlib.Device.kind_to_string(dev.kind)],
                        },
                        device = dev
                    })
            end
        end
        
        wdg.Client.on_notify.device_added = function (client, dev)
            if args.device_templates[UPowerGlib.Device.kind_to_string(dev.kind)] then
                wdg:upower_device_added(
                    make_device_widget { 
                        template = {
                            id = dev.native_path,
                            layout = wibox.container.background,
                            args.device_templates[UPowerGlib.Device.kind_to_string(dev.kind)],
                        },
                        device = dev
                    }
                )
            end
        end

        wdg.Client.on_notify.device_removed = function (client, dev_path)
            wdg:upower_device_removed(dev_path)
        end
    end
    return container_widget
end


return upower
