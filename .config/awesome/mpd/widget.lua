local mpc = require('mpd/mpc')
local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')
local naughty = require('naughty')
local unpack = unpack or table.unpack

local widget = function (args)
    local status_hook = args.status_hook or function ()  end
    local currentsong_hook = args.currentsong_hook or function () end
    local wdg = wibox.widget(args.widget_template)
    -- config settings
    wdg.client = mpc.new (
    args.host or nil,
    args.port or nil,
    args.password or nil,
    -- error handler
    function (err)
        naughty.notify {
            title = 'MPD ERROR:',
            text = tostring(err)
        }
        gears.timer {
            timeout = 10,
            autostart = true,
            call_now = false,
            callback = function ()
                wdg.client:send('ping')
            end
        }
    end,
    -- status handler
    'status', function (success, status)
        if success then
            if status.state == 'stop' then
                wdg.visible = false
            else
                wdg.visible = true
            end
            for _, w in pairs(wdg:get_children_by_id('status_volume_text_role')) do
                w.text = status.volume..'%'
            end
            for _, w in pairs(wdg:get_children_by_id('status_volume_progressbar_role')) do
                w.value = status.volume
            end
            status_hook(status)
        end
    end,
    -- current song handler
    'currentsong', function (success, currentsong)
        if success then
            for _, w in ipairs(wdg:get_children_by_id('currentsong_title_role')) do
                w.text = currentsong.title
            end
            for _, w in ipairs(wdg:get_children_by_id('currentsong_artist_role')) do
                w.text = currentsong.artist
            end
            for _, w in ipairs(wdg:get_children_by_id('currentsong_album_role')) do
                w.text = currentsong.album
            end
            currentsong_hook(currentsong)
        end 
    end
    )
    return wdg
end

return widget
