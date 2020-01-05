local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')
local awful = require('awful')

local menu = {
    items = {}
}

function amenu.add_item(self, item)
    table.insert(self.items, item)
    
end

function amenu.new(sekf, args)
    local m = {}
    m.container_widget = wibox.widget {
        layout = wibox.container.background,
        {
            id = 'background_role',
            fg = beautiful.amenu_menu_fg or beautiful.fg_normal,
            bg = beautiful.amenu_menu_bg or beautiful.bg_normal,
            {
                id = 'margin_role',
                layout = wibox.container.margin,
                left = beautiful.amenu_menu_margin_left or 4,
                right = beautiful.amenu_menu_margin_right or 4,
                top = beautiful.amenu_menu_margin_top or 4,
                bottom = beautiful.amenu_menu_margin_bottom or 4,
                {
                    id = 'container_role',
                    layout = wibox.layout.fixed[args.axis or 'vertical'],
                    spacing = args.spacing or beautiful.amenu_menu_spacing or 0,
                }
            }
        }
    }

end
