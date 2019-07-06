local lgi = require('lgi')
local wibox = require('wibox')
local beautiful = require('beautiful')
local naughty = require('naughty')

local NM = lgi.NM
 
local make_active_connection_widget = function (args)
    
end

local networkmanager = {}

networkmanager.client_widget = function (args)
    local container_widget = wibox.widget(args.container_template)
    for _,wdg in ipairs(container_widget:get_children_by_id('active_connections_container_role')) do
        wdg.Client = NM.Client.new()
        wdg.active_connections = wdg.Client:get_active_connections()
        wdg.active_connections_templates = args.active_connections_templates
        for _,conn in ipairs(wdg.active_connections) do
            if wdg.active_connections_templates[conn.type] then
                wdg:networkmanager_active_connection_added(
                    make_active_connection_widget {
                        template = wdg.active_connections_templates[conn.type],
                        active_connection = conn
                    },
                    conn.uuid
                )
            end
            wdg.Client.on_active_connection_added = function (self, conn) 
                if wdg.active_connections_templates[conn.type] then
                    wdg:networkmanager_active_connection_added(
                        make_active_connection_widget {
                            template = wdg.active_connections_templates[conn.type],
                            active_connection = conn
                        },
                        conn.uuid
                    )
                end
            end
            wdg.Client.on_active_connection_removed = function (self, conn)
                wdg:networkmanager_active_connection_added(conn)
            end
        end
    end
end

return networkmanager
