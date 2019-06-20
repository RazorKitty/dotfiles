local floor = math.floor
local lgi = require('lgi')
local wibox = require('wibox')
local awful = require('awful')
local naughty = require('naughty')

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
    if not args.template then
        return nil
    end
    local widget = wibox.widget(args.template)
    for _,prop in ipairs(properties) do
        for _,wdg in ipairs(widget:get_children_by_id(prop..'_role')) do
            wdg:update_upower_widget(args.device)
        end
        args.device.on_notify[prop] = function (obj, pspec)
            for _,wdg in ipairs(widget:get_children_by_id(prop..'_role')) do
                wdg:update_upower_widget(obj)
            end                
        end
    end
    return widget
end

local upower = {}
upower.UPowerGlib = lgi.UPowerGlib
upower.Client = upower.UPowerGlib.Client.new()
upower.display_device = upower.Client:get_display_device()

upower.display_device_widget = function (args)
    local display_device_widget = make_device_widget {
        template = args.templates[upower.UPowerGlib.Device.kind_to_string(upower.display_device.kind)] or nil,
        device = upower.display_device,
    }
    return display_device_widget
end


return upower
