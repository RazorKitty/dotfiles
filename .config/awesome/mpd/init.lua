local mpc = require('mpd/mpc')
local gears = require('gears')
local wibox = require('wibox')
local naughty = require('naughty')
--local widget = require('mpd/widget')

local error_handler = function (client)
    return function(err)
        naughty {
            title = 'MPC ERROR!!!',
            text = err
        }
        gears.timer {
            timeout = 10,
            autostart = true,
            call_now = false,
            callback = function ()
                client:send('ping')
            end
        }
    end
end

local widget = function (args)
    local mpd_widget = wibox.widget(args.template)
    mpd_widget.client = mpc.new (
        args.host or nil,
        args.port or nil,
        args.password or nil,
        args.error_handler or error_handler(mpd_widget.client),
        'status', function (success, status)
            if success then
                for k,v in pairs(status) do
                    for _,wdg in ipairs(mpd_widget:get_children_by_id('status_'..k..'_role')) do
                        wdg:update_mpd_widget(v)
                    end
                end
            end
        end,
        'currentsong', function (success, currentsong)
            if success then
                for k,v in pairs(currentsong) do
                    for _,wdg in ipairs(mpd_widget:get_children_by_id('currentsong_'..k..'_role')) do
                        wdg:update_mpd_widget(v)
                    end
                end
            end
        end
    )
    return mpd_widget
end


return {
    mpc = mpc,
    widget = widget
}
