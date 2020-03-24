---------------------------------------------------------------------------
--- Collection of containers that can be used in widget boxes
--
-- @author RazorKitty
-- @classmod terrible.container
---------------------------------------------------------------------------
local base = require("wibox.widget.base")

return setmetatable({
    item = require('terrible.container.item'),
    menu = require('terrible.container.menu')
}, {__call = function(_, args) return base.make_widget_declarative(args) end})

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80

