local beautiful = require('beautiful')
local wibox = require('wibox')
local terrible = require('terrible')
local lgi = require('lgi')

local NM = lgi.NM

local devices_widget = terrible.netowrkmanager.devices_widget {
    container_template = {
        '_background',
        wibox.container.background,
        fg = beautiful.widget_normal_fg,
        bg = beautiful.widget_normal_bg,
        {
            '_margin',
            wibox.container.margin,
            left = 8,
            right = 8,
            {
                'container_role',
                layout = wibox.layout.fixed.horizontal,
                spacing = 0,
                devices = {},
                device_added = function (self, device, wdg)
                    self.devices[device] = wdg
                    self:add(wdg)
                end,
                device_removed = function (self, device)
                    self:remove_widgets(self.devices[device])
                    self.devices[device] = nil
                end
            }
        }
    },
    device_templates = {
        ETHERNET = {
            'ip4_connectivity_role',
            layout = wibox.container.background,
            fg = beautiful.widget_normal_fg,
            bg = beautiful.widget_normal_bg,
            update_widget = function (self, dev)
                self.visible = not dev.ip4_connectivity == 'UNKNOWN'
                if dev.ip4_connectivity == 'FULL' then
                    self.fg = beautiful.widget_normal_fg
                    self.bg = beautiful.widget_normal_bg
                else 
                    if dev.ip4_connectivity == 'LIMITED' then
                        self.fg = beautiful.widget_important_fg
                        self.bg = beautiful.widget_important_bg
                    else 
                        if dev.ip4_connectivity == 'PORTAL' then
                        self.fg = beautiful.widget_warning_fg
                        self.bg = beautiful.widget_warning_bg
                        end
                    end
                end
            end,
            {
                layout = wibox.container.margin,
                left = 4,
                right = 4,
                {
                    '_layout',
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 4,
                    {
                        'interface_role',
                        widget = wibox.widget.textbox,
                        update_widget = function (self, dev)
                            self.text = dev.interface
                        end
                    },
                    {
                        'speed_role',
                        widget = wibox.widget.textbox,
                        update_widget = function (self, dev)
                            self.text = dev.speed..'Mbits/s'
                        end
                    },
                    {
                        'ip4_config_role',
                        layout = wibox.container.background,
                        update_widget = function (self, dev, wdg)
                            self.widget = wdg
                        end
                    }
                }
            }

        },
        WIFI = {
            device_template = {
                'ip4_connectivity_role',
                layout.container.background,
                fg = beautiful.widget_normal_fg,
                bg = beautiful.widget_normal_bg,
                update_widget = function (self, dev)
                    self.visible = not dev.ip4_connectivity == 'UNKNOWN'
                    if dev.ip4_connectivity == 'FULL' then
                        self.fg = beautiful.widget_normal_fg
                        self.bg = beautiful.widget_normal_bg
                    else 
                        if dev.ip4_connectivity == 'LIMITED' then
                            self.fg = beautiful.widget_important_fg
                            self.bg = beautiful.widget_important_bg
                        else 
                            if dev.ip4_connectivity == 'PORTAL' then
                            self.fg = beautiful.widget_warning_fg
                            self.bg = beautiful.widget_warning_bg
                            end
                        end
                    end
                end,
                {
                    '_margin',
                    layout = wibox.container.margin,
                    left = 4,
                    right = 4,
                    {
                        '_layout',
                        layout = wibox.layout.fixed.horizontal,
                        spacing = 4,
                        {
                            'interface_role',
                            widget = wibox.widget.textbox,
                            update_widget = function (self, dev)
                                self.text = dev.interface
                            end
                        },
                        {
                            'active_access_point_role',
                            layout = wibox.container.background,
                            update_widget = function (self, dev, wdg)
                                self.widget = wdg
                            end
                        },
                        {
                            'ip4_config_role',
                            layout = wibox.container.background,
                            update_widget = function (self, dev, wdg)
                                self.widget = wdg
                            end
                        }
                    }
                }
            },
            active_access_point_template {
                '_layout',
                layout = wibox.layout.horizontal,
                spacing = 2,
                {
                    'ssid_role',
                    widget = wibox.widget.textbox,
                    update_widget = function (self, ap)
                        self.text = NM.utils_ssid_to_utf8(ap.ssid)
                    end
                },
                {
                    '_strength_container',
                    layout = wibox.container.constraint,
                    height = 18,
                    width = 64,
                    {
                        'strength_role',
                        widget = wibox.widget.progressbar,
                        max_value = 100,
                        update_widget = function (self, ap)
                            self.value = ap.strength
                        end
                    }
                }
            },
            access_points_template = {
                
            }

        }
    },
    

    ip_config_template = {
        'addresses_role',
        wibox.widget.textbox,
        function (self, config)
            local addresses = {}
            for _,addr in ipairs(config:get_addresses()) do
                table.insert(addresses, addr)
            end
            self.text = table.concat(addresses, ',')
        end
    }
}
