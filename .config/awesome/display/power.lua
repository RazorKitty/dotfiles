local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')
local naughty = require('naughty')
local terrible = require('terrible')

local format_time = function(seconds)
    if seconds <= 0 then
        return "0h 0m";
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        return hours.."h "..mins.."m"
    end
end

local attach_popup_on_hover = function (widget, popup)
    widget:connect_signal('mouse::enter', function (self, geo)
        popup.visible = true
        popup:move_next_to(geo)
    end)
    widget:connect_signal('mouse::leave', function (self, geo)
        popup.visible = false
    end)
end

local battery_graph_template = {
    id = '_background',
    layout = wibox.container.background,
    fg = beautiful.widget_normal_fg,
    bg = beautiful.widget_normal_bg,
    {
        id = '_margin',
        layout = wibox.container.margin,
        left = 4,
        right = 4,
        top = 2,
        bottom = 2,
        {
            id = '_layout',
            layout = wibox.layout.fixed.vertical,
            {
                id = 'native-path_role',
                widget = wibox.widget.textbox,
                update_widget = function (self, dev)
                    self.text = dev.native_path
                end
            },
            {
                id = 'percentage_container',
                layout = wibox.container.constraint,
                width = 64,
                height = 40,
                {
                    id = 'percentage_role',
                    widget = wibox.widget.graph,
                    max_value = 100,
                    min_value = 0,
                    color = beautiful.green,
                    update_widget = function (self, dev)
                        if not self.loaded then
                            
                            self.loaded = true
                        end
                        self.color = (dev.percentage < 10 and beautiful.widget_urgent_bg) or (dev.percentage < 25 and beautiful.widget_warning_bg) or beautiful.widget_online_bg
                        self:add_value(dev.percentage)
                    end
                }
            }
        }
    }
}

local battery_widget_template = {
    id = 'stat_role',
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
                id = 'native-path_role',
                widget = wibox.widget.textbox,
                update_widget = function (self, dev)
                    self.text = dev.native_path
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
                        self.color = (dev.percentage < 10 and beautiful.widget_urgent_bg) or (dev.percentage < 25 and beautiful.widget_warning_bg) or beautiful.widget_online_bg
                        self:set_value(dev.percentage)
                    end
                }
            }
        }
    }
}

local line_power_widget_template = {
    id = '_background',
    layout = wibox.container.background,
    fg = beautiful.widget_normal_fg,
    bg = beautiful.widget_normal_bg,
    update_widget = function (self, dev)
        self.fg = dev.online and beautiful.widget_normal_fg or beautiful.widget_important_fg
        self.bg = dev.online and beautiful.widget_normal_bg or beautiful.widget_important_bg
    end,
    {
        id = '_margin',
        layout = wibox.container.margin,
        left = 4,
        right = 4,
        {
            id = '_layout',
            layout = wibox.layout.align.horizontal,
            --spacing = 4,
            {
                id = 'native-path_role',
                widget = wibox.widget.textbox,
                update_widget = function (self, dev)
                    self.text = dev.native_path
                end
            },
            nil,
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
}

local mouse_widget_template = {
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
            }
        }
    }
}

local keyboard_widget_template = {
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
            } 
        }
    }
}

local display_device_widget = terrible.upower.display_device_widget {
    templates = {
        battery = {
            id = 'warning-level_role',
            layout = wibox.container.background,
            fg = beautiful.widget_normal_fg,
            bg = beautiful.widget_normal_bg,
            update_widget = function (self, dev)
                if dev.warning_level == 1 then
                    self.fg = beautiful.widget_normal_fg
                    self.bg = beautiful.widget_normal_bg
                else if dev.warning_level == 2 then
                        self.fg = beautiful.widget_important_fg
                        self.bg = beautiful.widget_important_bg
                    else if dev.warning_level == 3 then
                            self.fg = beautiful.widget_warning_fg
                            self.bg = beautiful.widget_warning_bg
                        else
                            self.fg = beautiful.widget_urgent_fg
                            self.bg = beautiful.widget_urgent_bg
                        end
                    end
                end
            end,
            {
                id = '_margin',
                layout = wibox.container.margin,
                left = 8,
                right = 8,
                {
                    id = '_layout',
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 0,
                    {
                        id = '_lable',
                        widget = wibox.widget.textbox,
                        text = 'BAT:'
                    },
                    {
                        id = 'time-to-empty_role',
                        widget = wibox.widget.textbox,
                        update_widget = function (self, dev)                              
                            self.visible = dev.time_to_empty > 0 and true or false
                            self.text = format_time(dev.time_to_empty) .. ' '
                        end
                    },
                    {
                        id = 'time-to-full_role',
                        widget = wibox.widget.textbox,
                        update_widget = function (self, dev)
                            self.visible = dev.time_to_full > 0 and true or false
                            self.text = format_time(dev.time_to_full) .. ' '
                        end
                    },
                    {
                        id = 'state_role',
                        widget = wibox.widget.textbox,
                        update_widget = function (self, dev)
                            self.text = dev.state_to_string(dev.state)
                        end
                    }
                }
            }
        }
    }
}

local devices_widget = terrible.upower.devices_widget {
    device_templates = {
        battery = battery_widget_template,
        ['line-power'] = line_power_widget_template,
        mouse = mouse_widget_template,
        keyboard = keyboard_widget_template,
    },
    container_template = {
        id = '_backround',
        layout = wibox.container.background,
        fg = beautiful.widget_normal_fg,
        bg = beautiful.widget_normal_bg,
        {
            id = '_margin',
            layout = wibox.container.margin,
            margins = 0,
            {
                id = 'container_role',
                layout = display_device_widget and wibox.layout.fixed.vertical or wibox.layout.fixed.horizontal,
                spacing = 0,
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

if display_device_widget then
    upower_popup = awful.popup {
        widget = devices_widget,
        border_width = 1,
        preferred_positions = 'bottom',
        preferred_anchors = 'middle',
        offset = {
            y = 2,
    },
    visible = false,
    ontop = true
    }

    attach_popup_on_hover(display_device_widget, upower_popup)
end

return {
    panel_widget = display_device_widget or devices_widget
}
