local awful = require('awful')
local naughty = require('naughty')
local gears = require('gears')
 
--vi = awful.keygrabber {
--    keybindings = {
--        {{'Mod1'         }, 'Tab', awful.client.focus.history.previous},
----        {{'Mod1', 'Shift'}, 'Tab', awful.client.focus.history.next    },
--    },
--    -- Note that it is using the key name and not the modifier name.
--    stop_key           = 'Mod1',
--    stop_event         = 'release',
--    start_callback     = awful.client.focus.history.disable_tracking,
--    stop_callback      = awful.client.focus.history.enable_tracking,
--    export_keybindings = true,
--}

directions = {
    Escape = 'cancel',
    h = 'left',
    j = 'down',
    k = 'up',
    l = 'right'
}

verbs = {
    f = function (dir)
        awful.client.focus.global_bydirection(dir)
    end,
    s = function (dir)
    end,
    m = function (dir)
        local c = client.focus
        if dir == 'left' then c.x = c.x-16
        elseif dir == 'right' then c.x = c.x+16
        elseif dir == 'down' then c.y = c.y+16
        elseif dir == 'up' then c.y = c.y-16
        end
    end,
    r = function (dir)
        local c = client.focus
        if dir == 'left' then c:relative_move(0,0,-1,0)
        elseif dir == 'right' then c:relative_move(0,0,1,0)
        elseif dir == 'down' then c:relative_move(0,0,0,1)
        elseif dir == 'up' then c:relative_move(0,0,0,-1)
        end
    end
}

local vi_parse = function (kg, stop_key, stop_mods, sequence)
    if stop_key == 'Escape' then return end
    sequence = sequence .. stop_key
    local count = ''
    local verb
    local direction
    for i=1,#sequence do
        char = sequence:sub(i,i)
        if '0' <= char and char <= '9' then
            count = count..char
        end
        if verbs[char] then
            verb = char
        end
        if directions[char] then
            direction = char
        end
    end
    verb = verb or 'f'
    for i=1, count == '' and 1 or tonumber(count) do
        verbs[verb](directions[direction])
    end
end

vi = awful.keygrabber {
    stop_callback = vi_parse,
    stop_key = gears.table.keys(directions),
    root_keybindings = {
        {{'Mod4'}, 'c', function ()
        end}
    },
}

return vi
