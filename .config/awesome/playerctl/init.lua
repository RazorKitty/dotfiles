local setmetatable = setmetatable
local table = table

local callback_handler = require('playerctl.callback_handler')

local lgi = require('lgi')
local Playerctl = lgi.Platerctl

local wibox = require('wibox')

local playerctl = {
    players = {},
    property_callbacks = setmetatable({}, { __mode = 'k' }),
    manager_signals = {
        on_name_appeared = callback_handler:new{
            function (self, name)
                self:manage_player(Playerctl.Player(name))
            end
        },
        on_name_vanished = callback_handler:new {},
        on_player_apeared = callback_handler:new {
            function (self, player)
                playerctl.property_callbacks[player] = callback_handler:new {}
                player.on_notify = playerctl.property_callbacks[player]
                table.insert(playerctl.players, player)
            end
        },
        on_player_vanished:new {
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

playerctl.mamager = Playerctl.PlayerManager(playerctl.manager_signals)
for idx,name in ipairs(Playerctl.list_players()) do
    playerctl.manager:manage_player(Playerctl.Player.new(name))
end


