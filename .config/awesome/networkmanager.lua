local lgi = require('lgi')
local wibox = require('wibox')
local beautiful = require('beautiful')
local naughty = require('naughty')

local NM = lgi.NM
local Client = NM.Client.new()


Client.on_active_connection_added = function (self, active_connection)
    naughty.notify {
        title = 'Network Manager, active connection added'
    }
end


Client.on_active_connection_removed = function (self, active_connection)
    naughty.notify {
        title = 'Network Manager, active connection removed'
    }
end


Client.on_connection_added = function (self, connection)
    naughty.notify {
        title = 'Network Manager, connection added'
    }
end


Client.on_connection_removed = function (self, connection)
    naughty.notify {
        title = 'Network Manager, connection removed'
    }
end


Client.on_any_device_added = function (self, device)
    naughty.notify {
        title = 'Network Manager, any device added'
    }
end


Client.on_any_device_removed = function (self, device)
    naughty.notify {
        title = 'Network Manager, any device removed'
    }
end



Client.on_device_added = function (self, device)
    naughty.notify {
        title = 'Network Manager, device added'
    }
end


Client.on_device_removed = function (self, device)
    naughty.notify {
        title = 'Network Manager, device removed'
    }
end


Client.on_permission_changed = function (self, result)
    naughty.notify {
        title = 'Network Manager, device removed'
    }
end

--[[
local devices = Client:get_devices()

local make_widget = {}

make_widget['ETHERNET'] = function (dev)
    local wdg = wibox.widget {
        layout = wibox.layout.background,
        bg = beautiful.blue,
        fg = beautiful.black,
        {
            id = '_margin',
            layout = wibox.container.marign,
            left = 4,
            right = 4,
            {
                id = '_layout',
                layout = wibox.layout.fixed.horizontal,
                spacing = 2,
                {
                    id  = '_name',
                    widget = wibox.widget.textbox,
                    text = 'Ethernet'
                },
                {
                    id = '_speed',
                    widget = wibox.widget.textbox,
                    text = dev.speed..' Mbit/s'
                },
                {
                    id = '_ipaddress',
                    widget = wibox.widget.textbox,
                    text = dev.ip4_config.addresses[1]:get_address()
                },

            }
        }
    }
    
    dev.on_notify['speed'] = function (dev, pspec)
        wdg._margin._layout._speed:set_markup(dev.speed..' Mbit/s')
    end
    dev.ip4_config['adresses'] = function (ip4_config, pspec)
        wdg._margin._layout._addresses:set_markup(ip4.config.adresses[0]:get_address())
    end
    return wdg
end

make_widget['WIFI'] = function (dev)
    local wdg = wibox.widget {
        layout = wibox.container.background,
        bg = beautiful.blue,
        fg = beautiful.black,
        {
            id = '_margin',
            layout = wibox.container.margin,
            left = 4,
            right = 4,
            {
                id = '_layout',
                layout = wibox.layout.fixed.horizontal,
                spacing = 2,
                {
                    id = '_name',
                    widget = wibox.widget.textbox,
                    text = 'WiFi',
                },
                {
                    id = '_ssid',
                    widget = wibox.widget.textbox,
                    text = NM.utils_ssid_to_utf8(dev.active_access_point.ssid:get_data())
                },
                {
                    layout = wibox.container.constraint,
                    width = 64,
                    {
                        id = '_strength',
                        widget = wibox.widget.progressbar,
                        max_value = 100,
                        value = dev.active_access_point.strength
                    }
                },
                {
                    id = '_address',
                    widget = wibox.widget.textbox,
                    text = dev.ip4_config:get_addresses()[1]:get_address()
                },
                {
                    id = '_bitrate',
                    widget = wibox.widget.textbox,
                    text = dev:get_bitrate() ..  ' Mbps'
                }
            }
        }
    }

    return wdg
end


local networkmanager = {}

networkmanager.panel_widget = function ()
    local wdg = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        make_widget[devices[4].device_type](devices[4])
    }
    return wdg
end
--]]
local networkmanager = {}

networkmanager.panel_widget = function ()
    local Client = NM.Client.new()
    local wdg = wibox.widget {
        layout = wibox.container.background,
        {
            id = '__margin',
            layout = wibox.container.margin,
            left = 4,
            right = 4,              
        }
    }
end

return networkmanager
