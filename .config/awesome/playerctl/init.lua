local setmetatable = setmetatable
local table = table

local callback_handler = require('playerctl.callback_handler')

local lgi = require('lgi')
local Playerctl = lgi.Playerctl

local wibox = require('wibox')

local playerctl = {
    players = {},
    property_callbacks = setmetatable({}, { __mode = 'k' }),
    manager_signals = {
        on_name_appeared = callback_handler:new{
            function (self, name)
                self:manage_player(Playerctl.Player.new_from_name(name))
            end
        },
        on_name_vanished = callback_handler:new {},
        on_player_appeared = callback_handler:new {
            function (self, player)
                playerctl.property_callbacks[player] = callback_handler:new {}
                player.on_notify = playerctl.property_callbacks[player]
                table.insert(playerctl.players, player)
            end
        },
        on_player_vanished = callback_handler:new {
            function (self, player)
                for idx,p in ipairs(playerctl.players) do
                    if player == p then
                        table.remove(playerctl.players, idx)
                        return
                    end
                end
            end
        }
    }
}

playerctl.manager = Playerctl.PlayerManager(playerctl.manager_signals)
for idx,name in ipairs(playerctl.manager.player_names) do
    local player = Playerctl.Player.new_from_name(name)
    playerctl.manager:manage_player(player)
end

function playerctl.create_widget(self, args)
    local widget = wibox.widget(args.template)
    if widget:create_callback(args.player) then
        widget:update_callback(args.player)
        self.property_callbacks[args.player]:add( function (...)
            widget:update_callback(...)
        end )
        return widget
    end
end

function playerctl.players_widget(self, args)
    local container_widget = wibox.widget(args.container_template)
    container_widget:create_callback()
    for _,player in ipairs(self.players) do
        -- this loop never runs
        local player_widget = self:create_widget { template = args.player_template, player = player }
        if player_widget then
            container_widget:add_player_widget(player, player_widget)
        end
    end
    self.manager_signals.on_player_appeared:add( function (manager, player)
        local player_widget = self:create_widget { template = args.player_template, player = player }
        if player_widget then
            container_widget:add_player_widget(player, player_widget)
        end
    end )
    self.manager_signals.on_player_vanished:add( function (manager, player)
        container_widget:remove_player_widget(player)
    end )
    return container_widget
end

return playerctl
