---------------------------------------------------------------------------
--- Collection of containers that can be used in widget boxes
--
-- @author RazorKitty
-- @classmod terrible.container
---------------------------------------------------------------------------
local base = require("wibox.widget.base")

return setmetatable({
    item = require('terrible.container.item'),
    menu = require('terrible.container.menu'),
    gobject = require('terrible.container.gobject')
}, {__call = function(_, args) return base.make_widget_declarative(args) end})

