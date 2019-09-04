local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')
local terrible = require('terrible')

local format_time = function(seconds)
    if seconds <= 0 then
	    return "00:00:00";
	else
		hours = string.format("%02.f", math.floor(seconds/3600));
		mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
		secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
		return hours..":"..mins..":"..secs
	end
end

local upower_display_device_widget = terrible.upower.display_device_widget {
    templates = {
        battery = {
            id = '_background',
            layout = wibox.container.background,
            fg = beautiful.widget_normal_fg,
            bg = beautiful.widget_normal_bg,
            {
                id = '_margin',
                layout = wibox.container.margin,
                left = 4,
                right = 4,
                {
                    id = '_layout',
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 4,
                    {
                        id = 'kind_role',
                        widget = wibox.widget.textbox,
                        update_widget = function (self, dev)
                            self:set_text(dev.kind_to_string(dev.kind))
                        end
                    },
                    {
                        id = 'percentage_container',
                        layout = wibox.container.constraint,
                        width = 64,
                        hieght = 18,
                        {
                            id = 'percentage_role',
                            widget = wibox.widget.progressbar,
                            max_value = 100,
                            color = beautiful.green,
                            update_widget = function (self, dev)
                                self.color = (dev.percentage < 10 and beautiful.red) or (dev.percentage < 25 and beautiful.yellow) or beautiful.green
                                self:set_value(dev.percentage)
                            end
                        }
                    },
                    {
                        id = 'time-to-empty_role',
                        widget = wibox.widget.textbox,
                        update_widget = function (self, dev)
                            self.text = format_time(dev.time_to_empty)
                        end
                    }
                }
            }
        }
    }
}

local upower_devices_widget = terrible.upower.devices_widget {
    device_templates = {
        battery = {
            id = '_background',
            layout = wibox.container.background,
            fg = beautiful.widget_normal_fg,
            bg = beautiful.widget_normal_bg,
            {
                id = '_margin',
                layout = wibox.container.margin,
                left = 4,
                right = 4,
                {
                    id = '_layout',
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 4,
                    {
                        id = 'kind_role',
                        widget = wibox.widget.textbox,
                        update_widget = function (self, dev)
                            self:set_text(dev.kind_to_string(dev.kind))
                        end
                    },
                    {
                        id = 'percentage_container',
                        layout = wibox.container.constraint,
                        width = 64,
                        height = 18,
                        {
                            id = 'percentage_role',
                            widget = wibox.widget.progressbar,
                            max_value = 100,
                            color = beautiful.green,
                            update_widget = function (self, dev)
                                self.color = dev.percentage < 10 and beautiful.red or dev.percentage < 25 and beautiful.yellow or beautiful.green
                                self:set_value(dev.percentage)
                            end
                        }
                    },
                    {
                        id = 'time-to-empty_role',
                        widget = wibox.widget.textbox,
                        update_widget = function (self, dev)
                            self.text = format_time(dev.time_to_empty)
                        end
                    }
--                    {
--                        id = 'state_role',
--                        widget = wibox.widget.textbox,
--                        update_widget = function (self, dev)
--                            self:set_text(dev.state_to_string(dev.state))
--                        end
--                    }
                }
            }
        },
        ['line-power'] = {
            id = '_background',
            layout = wibox.container.background,
            fg = beautiful.widget_normal_fg,
            bg = beautiful.widget_normal_bg,
            {
                id = '_margin',
                layout = wibox.container.margin,
                left = 4,
                right = 4,
                {
                    id = '_layout',
                    layout = wibox.layout.align.horizontal,
                    spacing = 4,
                    {
                        id = 'kind_role',
                        widget = wibox.widget.textbox,
                        update_widget = function (self, dev)
                            self:set_text(dev.kind_to_string(dev.kind))
                        end
                    },
                    {
                        id = '_place_holder',
                        layout = wibox.layout.fixed.horizontal
                    },
                    {
                        id = 'online_constraint',
                        layout = wibox.container.constraint,
                        width = 18,
                        height = 18,
                        {
                            id = 'online_container',
                            layout = wibox.container.margin,
                            top = 4,
                            bottom = 4,
                            {
                                id = 'online_role',
                                widget = wibox.widget.checkbox,
                                update_widget = function (self, dev)
                                    self.checked = dev.online
                                end

                            }
                        }
                    }
                }
            }
        },
        mouse = {
            id = '_background',
            layout = wibox.container.background,
            fg = beautiful.widget_normal_fg,
            bg = beautiful.widget_normal_bg,
            {
                id = '_margin',
                layout = wibox.container.margin,
                left = 4,
                right = 4,
                {
                    id = '_layout',
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 4,
                    {
                        id = 'kind_role',
                        widget = wibox.widget.textbox,
                        update_widget = function (self, dev)
                            self:set_text(dev.kind_to_string(dev.kind))
                        end
                    },
                    {
                        id = 'percentage_container',
                        layout = wibox.container.constraint,
                        width = 64,
                        height = 18,
                        {
                            id = 'percentage_role',
                            widget = wibox.widget.progressbar,
                            max_value = 100,
                            color = beautiful.green,
                            update_widget = function (self, dev)
                                self:set_value(dev.percentage)
                            end
                        }
                    },
                    {
                        id = 'state_role',
                        widget = wibox.widget.textbox,
                        update_widget = function (self, dev)
                            self:set_text(dev.state_to_string(dev.state))
                        end
                    }
                
                }
            }
        },
        keyboard = {
            id = '_background',
            layout = wibox.container.background,
            fg = beautiful.widget_normal_fg,
            bg = beautiful.widget_normal_bg,
            {
                id = '_margin',
                layout = wibox.container.margin,
                left = 4,
                right = 4,
                {
                    id = '_layout',
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 4,
                    {
                        id = 'kind_role',
                        widget = wibox.widget.textbox,
                        update_widget = function (self, dev)
                            self:set_text(dev.kind_to_string(dev.kind))
                        end
                    },
                    {
                        id = 'percentage_container',
                        layout = wibox.container.constraint,
                        width = 64,
                        height = 18,
                        {
                            id = 'percentage_role',
                            widget = wibox.widget.progressbar,
                            max_value = 100,
                            color = beautiful.cyan,
                            update_widget = function (self, dev)
                                self:set_value(dev.percentage)
                            end
                        }
                    },
                    {
                        id = 'state_role',
                        widget = wibox.widget.textbox,
                        update_widget = function (self, dev)
                            self:set_text(dev.state_to_string(dev.state))
                        end
                    }
                
                }
            }
        }
    },
    container_template = {
        id = '_backround',
        layout = wibox.container.background,
        fg = beautiful.widget_normal_fg,
        bg = beautiful.widget_normal_bg,
        {
            id = '_margin',
            layout = wibox.container.margin,
            left = upower_display_device_widget and 4 or 16,
            right = upower_display_device_widget and 4 or 16,
            top = upower_display_device_widget and 4,
            bottom = upower_display_device_widget and 4,
            {
                id = 'container_role',
                layout = upower_display_device_widget and wibox.layout.fixed.vertical or wibox.layout.fixed.horizontal,
                spacing = 4,
                device_added = function (self, dev, wdg)
                    self[dev:get_object_path()] = wdg
                    self:add(wdg)
                end,
                device_removed = function (self, dev_path)
                    self:remove_widgets(self[dev_path])
                    self[dev_path] = nil
                end
            }
        }
    }
}

local upower_client_widget = terrible.upower.client_widget {
    template = {
        id = '_background',
        layout = wibox.container.background,
        fg = beautiful.widget_normal_fg,
        bg = beautiful.widget_normal_bg,
        {
            id = '_margin',
            layout = wibox.container.margin,
            left = 16,
            right = 16,
            {
                id = '_layout',
                layout = wibox.layout.fixed.horizontal,
                upower_display_device_widget and {
                    id = 'on-battery_role',
                    layout = wibox.layout.fixed.horizontal,
                    upower_display_device_widget,
                    update_widget = function (self, dev)
                        self.visible = dev.on_battery
                    end
                } or upower_devices_widget
            }
        }
    }
}

if upower_display_device_widget then
    upower_popup = awful.popup {
        widget = upower_devices_widget,
        border_width = 1,
        preferred_positions = 'bottom',
        preferred_anchors = 'middle',
        offset = {
            y = 2,
    },
    visible = false,
    ontop = true
    }

    upower_display_device_widget:connect_signal('button::press', function (self, _,_, button, _, geo)
        if not upower_popup.visible then
            upower_popup:move_next_to(geo)
        else
            upower_popup.visible = false
        end
    end)
end

return upower_client_widget
