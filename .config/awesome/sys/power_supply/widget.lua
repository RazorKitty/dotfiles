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

local properties = {
    'online',
    'energy_now',
    'power_now',
    'present',
    'status',
    'voltage_now'
}

local device_class = {}

local power_supply_class = {}

power_supply_class.get_capacity = function (self)
    local total_cap = 0
    local total_full_cap = 0
    for _,dev in pairs(self.Battery) do
        total_cap = total_cap + dev.energy_now
        total_full_cap = total_full_cap + dev.energy_full
    end
    return (total_cap/total_full_cap)*100
end

power_supply_class.get_online = function (self)
    for _,dev in pairs(self.Mains) do
        if dev.online == 1 then
            return true
        end
    end
    return false
end

---[[
device_class.attach = function (self, path)
    self.file = new_for_path(path)
    local enum = self.file.enumerate_children('', Gio.FileQueryInfoFlags.NOFOLLOW_SYMLINKS)
    local info = enum:next_file()
    while info do
        if infor:get_file_type() == 'REGULAR' then
            self[info:get_name()] = enum:get_child(info):load_contents():trim()
        end
        info = enum:next_file()
    end
    self.monitor = self.file:monitor_directory(Gio.FileMonitorFlags.NONE)
    self.monitor.on_changed = function (mon, file, event)
        self[file:get_basename()] = file:load_contents():trim()
    end
end

power_supply_class.init = function (self)
    self.file = File.new_for_path('/sys/class/power_supply')
    local enum = self.file:enumerate_children('', Gio.FileQueryInfoFlags.NOFOLLOW_SYMLINKS)
    local info = enum:next_file()
    while info do
        if info:get_file_type() == 'REGULAR' then
            local dev = gears.object {
                class = device_class,
                enable_auto_signals = true,
                enable_properties = true
            }
            dev:attach('/sys/class/power_supply/'..info:get_name())
            if self[dev.type] then
                self[dev.type][info:get_name()] = dev
            else
                self[dev.type] = { [info:get_name()] = dev }
            end
            for _,prop in ipairs(properties) do
                dev:connect_signal('property::'..prop, function (d, val)
                    self:emit_signal('property::'..prop, self['get_'..prop](self))
                end)
            end
        end
        info = enum:next_file()
    end

end


local widget = function (args)
    local power_supply = gears.object {
        class = power_supply_class,
        enable_properties = true,
        enumerate_children = true
    }
    power_supply:init()
    return power_supply
end
--]]
return widget
