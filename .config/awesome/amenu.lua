local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')
local awful = require('awful')

local item = {}

local menu = {}

function menu.add(self, itm)
end

function menu.remove(self, itm)
end

function menu.filter(self, str_to_match)

end

function menu.focus_next(self)
end

function menu.focus_previous(self)
end

function menu.exec(self)
end

function menu.new(self, args)
    
end

function menu.run(self, args)
    if menu == self then
        self = menu(args)
    end

end


local prompt = {}
local amenu = {}
