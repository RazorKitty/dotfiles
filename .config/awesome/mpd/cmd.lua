local mpc = require('mpc')
local lgi = require('lgi')
local GLib = lgi.GLib
-- Example on how to use this (standalone)
local host, port, password = nil, nil, nil
local m = mpc.new(host, port, password, error,
	"status", function(success, status)
        print('status\n')
        for k,v in pairs(status) do
	        print(k,v)
        end
        print('\nstatus')
    end,
    'currentsong', function (success, currentsong)
        print('\ncurrentsong')
        for k,v in pairs(currentsong) do
            print(k,v)
        end
        print('currentsong\n')
    end
    )
--GLib.timeout_add(GLib.PRIORITY_DEFAULT, 1000, function()
--	-- Test command submission
--	m:send("status", function(_, s) print(s.state) end,
--		"currentsong", function(_, s) print(s.title) end)
--	m:send("status", function(_, s) print(s.state) end)
--	-- Force a reconnect
--	GLib.timeout_add(GLib.PRIORITY_DEFAULT, 10000, function()
--		m:send("ping")
--	end)
--end)
GLib.MainLoop():run()
