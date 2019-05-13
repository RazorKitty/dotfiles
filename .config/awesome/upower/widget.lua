local floor = math.floor
local lgi = require('lgi')
local wibox = require('wibox')
local awful = require('awful')
local naughty = require('naughty')

local UPowerGlib = lgi.UPowerGlib
local Device = UPowerGlib.Device

local widget = function (args)
    local Client = UPowerGlib.Client.new()
    local display_device = Client:get_display_device()
    if display_device.kind ~= UPowerGlib.DeviceKind.Battery then
        return nil
    end
    local device = Client:get_devices()
    local wdg = wibox.widget(args.widget_template)
    for _, w in ipairs(wdg:get_children_by_id('display_device_percentage_textbox_role')) do
        w.text = floor((display_device.percentage))
        display_device.on_notify['percentage'] = function (obj, pspec)
            w.text = floor((obj.energy/obj.energy_full)*100)
        end
    end
    for _, w in ipairs(wdg:get_children_by_id('display_device_state_textbox_role')) do
        w.text  = w.symbols and w.symbols[display_device.state] or Device.state_to_string(display_device.state)
        display_device.on_notify['state'] = function (obj, pspec)
            w.text = w.symbols and w.symbols[obj.state] or Device.state_to_string(obj.state)
        end
    end

    return wdg
end

return widget
