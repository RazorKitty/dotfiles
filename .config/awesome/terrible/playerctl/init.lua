local setmetatable = setmetatable
local assert = assert
local callback_handler = require('terrible.callback_handler')

local lgi = require('lgi')
local Playerctl = lgi.Playerctl

local wibox = require('wibox')


local manager_sginals = {
    on_name_appeared = callback_handler:new {
        function (self, name)
            self:manager_player(Playerctl.Player.new_from_name(name))
        end
    },
    on_name_vanished = callback_handler:new(),
    on_player_appeared = callback_handler:new(),
    on_player_vanished = callback_handler:new()
}

local manager = Playerctl.PlayerManager(manager_sginals)

for i,name in ipairs(Playerctl.list_players()) do
    manager:manager_player(Playerctl.Player.new_from_name(name))
end

local function make_from_player(player, template)
    local widget = wibox.widget(template)
end

local function new_from_name(self, args)
    local name = assert(type(args.name) == 'string' and args.name,
                        'must provide a stirng name to connect on')

    local template  = assert(type(args.template) == 'table' and table,
                             'must provide a template widget')

    local container_template  = assert(type(args.container_template) == 'table' and table,
                             'must provide a template widget')

    
    for i,player in ipairs(manager.players) do
        if player.player_name == name then

        end
    end

    local container = wibox.widget(container_template)
    

end



