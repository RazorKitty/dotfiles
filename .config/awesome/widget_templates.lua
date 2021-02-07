local wibox = require('wibox')
local beautiful = require('beautiful')

local format_time = function(seconds)
    if seconds <= 0 then
	    return "0h 0m";
    end
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    return hours.."h "..mins.."m"
end

return {
    upower = {
        display_device = {
            battery = {
                on_init = function (self, device)
                    self.percentage_widget = self:get_children_by_id('percentage_bar')[1]
                    self.time_remaining_widget = self:get_children_by_id('time_remaining_text')[1]

                    self.percentage_bar = 50

                    self:on_percentage(device)
                    self:on_state(device)
                    self:on_time_to_empty(device)
                    self:on_time_to_full(device)
                end,
                on_percentage = function (self, device)
                    self.percentage_widget.value = device.percentage

                    self.percentage_widget.color = (device.percentage > 50)
                        and beautiful.power.progressbar.fg[4]
                        or (device.percentage > 25)
                            and beautiful.power.progressbar.fg[3]
                            or (device.percentage > 10)
                                and beautiful.power.progressbar.fg[2]
                                or beautiful.power.progressbar.fg[1]

                end,
                on_state = function (self, device) 
                    self.percentage_widget.border_color = (
                        device.state_to_string(device.state) == 'charging' or
                        device.state_to_string(device.state) == 'fully_charged'
                    )
                        and beautiful.power.progressbar.border_color[2]
                        or beautiful.power.progressbar.border_color[1]
                end,
                on_time_to_full = function (self, device)
                    if device.time_to_full > 0 then
                        self.time_remaining_widget.text = format_time(device.time_to_full)
                    end
                end,
                on_time_to_empty = function (self, device)
                    if device.time_to_empty > 0 then
                        self.time_remaining_widget.text = format_time(device.time_to_empty)
                    end
                end,
                layout = wibox.container.background,
                bg = beautiful.power.background.bg,
                fg = beautiful.power.background.fg,
                {
                    layout = wibox.container.margin,
                    left = beautiful.power.margin.left,
                    right = beautiful.power.margin.right,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = beautiful.power.layout.spacing,
                        {
                            widget = wibox.widget.textbox,
                            text = 'Bat'
                        },
                        {
                            id = 'percentage_bar',
                            widget = wibox.widget.progressbar,
                            max_value = 100,
                            background_color = beautiful.power.progressbar.bg,
                            color = beautiful.power.progressbar.fg[1],
                            border_color = beautiful.power.progressbar.border_color[1],
                            shape = beautiful.power.progressbar.shape,
                            bar_shape = beautiful.power.progressbar.bar_shape,
                            bar_border_width = beautiful.power.bar_border_width,
                            bar_border_color = beautiful.power.progressbar.bar_border_color,
                            margins = beautiful.power.progressbar.margins,
                            paddings = beautiful.power.progressbar.paddings,
                            forced_width = beautiful.power.progressbar.width
                        },
                        {
                            id = 'time_remaining_text',
                            widget = wibox.widget.textbox
                        }
                    }
                }
            }
        },
        devices = {
            battery = {
                on_init = function (self, device)
                    self.percentage_widget = self:get_children_by_id('percentage_bar')[1]
                    self.time_remaining_widget = self:get_children_by_id('time_remaining_text')[1]
                    self.native_path_widget = self:get_children_by_id('native_path_text')[1]
                    
                    self:on_native_path(device)
                    self:on_percentage(device)
                    self:on_state(device)
                    self:on_time_to_empty(device)
                    self:on_time_to_full(device)
                end,
                on_native_path = function (self, device)
                    self.native_path_widget.text = device.native_path
                end,
                on_percentage = function (self, device)
                    self.percentage_widget.value = device.percentage

                    self.percentage_widget.color = (device.percentage > 50)
                        and beautiful.power.progressbar.fg[4]
                        or (device.percentage > 25)
                            and beautiful.power.progressbar.fg[3]
                            or (device.percentage > 10)
                                and beautiful.power.progressbar.fg[2]
                                or beautiful.power.progressbar.fg[1]

                end,
                on_state = function (self, device) 
                    self.percentage_widget.border_color = (
                        device.state_to_string(device.state) == 'charging' or
                        device.state_to_string(device.state) == 'fully_charged'
                    )
                        and beautiful.power.progressbar.border_color[2]
                        or beautiful.power.progressbar.border_color[1]
                end,
                on_time_to_full = function (self, device)
                    if device.time_to_full > 0 then
                        self.time_remaining_widget.text = format_time(device.time_to_full)
                    end
                end,
                on_time_to_empty = function (self, device)
                    if device.time_to_empty > 0 then
                        self.time_remaining_widget.text = format_time(device.time_to_empty)
                    end
                end,
                layout = wibox.container.background,
                bg = beautiful.power.background.bg,
                fg = beautiful.power.background.fg,
                {
                    layout = wibox.container.margin,
                    left = beautiful.power.margin.left,
                    right = beautiful.power.margin.right,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = beautiful.power.layout.spacing,
                        {
                            id = 'native_path_text',
                            widget = wibox.widget.textbox,
                        },
                        {
                            id = 'percentage_bar',
                            widget = wibox.widget.progressbar,
                            max_value = 100,
                            background_color = beautiful.power.progressbar.bg,
                            color = beautiful.power.progressbar.fg[1],
                            border_color = beautiful.power.progressbar.border_color[1],
                            shape = beautiful.power.progressbar.shape,
                            bar_shape = beautiful.power.progressbar.bar_shape,
                            bar_border_width = beautiful.power.bar_border_width,
                            bar_border_color = beautiful.power.progressbar.bar_border_color,
                            margins = beautiful.power.progressbar.margins,
                            paddings = beautiful.power.progressbar.paddings,
                            forced_width = beautiful.power.progressbar.width
                        },
                        {
                            id = 'time_remaining_text',
                            widget = wibox.widget.textbox
                        }
                    }
                }
            },
            line_power = {
                on_init = function (self, device)
                    self.online_widget = self:get_children_by_id('online_checkbox')[1]
                    self.native_path_widget = self:get_children_by_id('native_path_text')[1]
                    
                    self:on_native_path(device)
                    self:on_online(device)
                end,
                on_native_path = function(self, device)
                    self.native_path_widget.text = device.native_path
                end,
                on_online = function (self, device)
                    self.online_widget.checked = device.online
                end,
                layout = wibox.container.background,
                bg = beautiful.power.background.bg,
                fg = beautiful.power.background.fg,
                {
                    layout = wibox.container.margin,
                    left = beautiful.power.margin.left,
                    right = beautiful.power.margin.right,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = beautiful.power.layout.spacing,
                        {
                            id = 'native_path_text',
                            widget = wibox.widget.textbox
                        },
                        {
                            layout = wibox.container.margin,
                            left = beautiful.power.checkbox_margins.left,
                            right = beautiful.power.checkbox_margins.right,
                            top = beautiful.power.checkbox_margins.top,
                            bottom = beautiful.power.checkbox_margins.bottom,
                            {
                                id = 'online_checkbox',
                                widget = wibox.widget.checkbox,
                                border_width = beautiful.power.checkbox.border_width,
                                bg = beautiful.power.checkbox.bg,
                                border_color = beautiful.power.checkbox.border_color,
                                check_border_color = beautiful.power.checkbox.check_border_color,
                                check_border_width = beautiful.power.checkbox.check_border_width,
                                check_color = beautiful.power.checkbox.check_color,
                                shape = beautiful.power.checkbox.shape,
                                check_shape = beautiful.power.checkbox.check_shape,
                                paddings = beautiful.power.checkbox.paddings,
                                color = beautiful.power.checkbox.color,
                                forced_height = beautiful.power.checkbox.height,
                                forced_width = beautiful.power.checkbox.width,
                                opacity = beautiful.power.checkbox.opacity
                            }
                        }
                    }
                }
            },
            mouse = {
                on_init = function (self, device)
                    self.kind_widget = self:get_children_by_id('kind_text')[1]
                    self.model_widget = self:get_children_by_id('model_text')[1]
                    self.warning_level_widget = self:get_children_by_id('warning_level_text')[1]
                    
                    self:on_kind(device)
                    self:on_model(device)
                    self:on_warning_level(device)
                end,
                on_kind = function (self, device)
                    self.kind_widget.text = device.kind_to_string(device.kind)
                end,
                on_model = function (self, device)
                    self.model_widget.text = device.model
                end,
                on_warning_level = function (self, device) 
                    self.fg = (device.warning_level < 3)
                        and beautiful.power.warning_level[1]
                        or (device.warning_level < 4)
                            and beautiful.power.warning_level[2]
                            or beautiful.power.warning_level[3]
                end,
                layout = wibox.container.background,
                bg = beautiful.power.background.bg,
                fg = beautiful.power.background.fg,
                {
                    layout = wibox.container.margin,
                    left = beautiful.power.margin.left,
                    right = beautiful.power.margin.right,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = beautiful.power.layout.spacing,
                        {
                            id = 'kind_text',
                            widget = wibox.widget.textbox,
                        },
                        {
                            widget = wibox.widget.textbox,
                            text = ':'
                        },
                        {
                            id = 'model_text',
                            widget = wibox.widget.textbox,
                        }
                    }
                }
            },
            keyboard = {
                on_init = function (self, device)
                    self.kind_widget = self:get_children_by_id('kind_text')[1]
                    self.model_widget = self:get_children_by_id('model_text')[1]
                    self.warning_level_widget = self:get_children_by_id('warning_level_text')[1]
                    
                    self:on_kind(device)
                    self:on_model(device)
                    self:on_warning_level(device)                    
                end,
                on_kind = function (self, device)
                    self.kind_widget.text = device.kind_to_string(device.kind)
                end,
                on_model = function (self, device)
                    self.model_widget.text = device.model
                end,
                on_warning_level = function (self, device) 
                    self.fg = (device.warning_level < 3)
                        and beautiful.power.warning_level[1]
                        or (device.warning_level < 4)
                            and beautiful.power.warning_level[2]
                            or beautiful.power.warning_level[3]
                end,
                layout = wibox.container.background,
                bg = beautiful.power.background.bg,
                fg = beautiful.power.background.fg,
                {
                    layout = wibox.container.margin,
                    left = beautiful.power.margin.left,
                    right = beautiful.power.margin.right,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = beautiful.power.layout.spacing,
                        {
                            id = 'kind_text',
                            widget = wibox.widget.textbox,
                        },
                        {
                            widget = wibox.widget.textbox,
                            text = ':'
                        },
                        {
                            id = 'model_text',
                            widget = wibox.widget.textbox,
                        }
                    }
                }
            }
        }
    }
}
