local lgi = require('lgi')
local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')
local awful = require('awful')
local naughty = require('naughty')

local Gio = lgi.Gio
local File = Gio.File

local floor = math.floor

string.trim = function (s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local device_class = {}

device_class.attach = function (self, path)
    self.file = File.new_for_path(path)
    local enum = self.file:enumerate_children('', Gio.FileQueryInfoFlags.NOFOLLOW_SYMLINKS)
    local info = enum:next_file()
    while info do
        if info:get_file_type() == 'REGULAR' then
            self[info:get_name()] = enum:get_child(info):load_contents():trim()
        end
        info = enum:next_file()
    end
    self.monitor = self.file:monitor_directory(Gio.FileMonitorFlags.NONE)
    self.monitor.on_changed = function (mon, file, event)
        self[file:get_basename()] = file:load_contents():trim()
    end
end

local widget = function (args)
    local path = '/sys/class/backlight/'..args.backlight_device
    local dev = gears.object {
        class = device_class,
        enable_auto_signals = true,
        enable_properties = true
    }
    dev:attach(path)

    local wdg = wibox.widget(args.widget_template)

    for _,w in ipairs(wdg:get_children_by_id('backlight_text_role')) do
        w.text = floor((dev.actual_brightness / dev.max_brightness)*100)
        dev:connect_signal('property::actual_brightness', function (obj, val)
            w.text = floor((obj.actual_brightness / obj.max_brightness)*100)
        end)
    end


    for _,w in ipairs(wdg:get_children_by_id('backlight_progressbar_role')) do
        w.max_value = tonumber(dev.max_brightness)
        w.value = tonumber(dev.actual_brightness)
        dev:connect_signal('property::actual_brightness', function (obj, val)
            w.value = tonumber(obj.actual_brightness)

        end)
    end
    for _,w in ipairs(wdg:get_children_by_id('backlight_progressbar_role')) do
        w.max_value = tonumber(dev.max_brightness)
        w.value = tonumber(dev.actual_brightness)
        dev:connect_signal('property::actual_brightness', function (obj, val)
            w.value = tonumber(obj.actual_brightness)

        end)
    end

    return wdg
end

return widget
