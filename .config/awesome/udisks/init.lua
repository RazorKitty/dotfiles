local naughty = require('naughty')
local lgi = require('lgi')
local UDisks = lgi.UDisks
local Client = UDisks.Client.new_sync()



--Client.object_manager.on_interface_added = function (self, object, interface)
--    naughty.notify {
--        title = 'UDisks',
--        text = 'Interface added'
--    }
--end
--
--
--Client.object_manager.on_interface_removed = function (self, object, interface)
--    naughty.notify {
--        title = 'UDisks',
--        text = 'Interface removed'
--    }
--end

Client.object_manager.on_object_added = function (self, object)
    local block = object:get_block()
    local drive = object:get_drive()
    local drive_ata = object:get_drive_ata()
    local encrypted = object:get_encrypted()
    local filesystem = object:get_filesystem()
    local job = object:get_job()
    local loop = object:get_loop()
    local manager = object:get_manager()
    local mdraid = object:get_mdraid()
    local partition = object:get_partition()
    local partition_table = object:get_partition_table()
    local swapspace = object:get_swapspace()
    
    local txt = "object is: "
    if block then
        txt = txt..'block'
    end
    if drive then
        txt = txt..'drive'
    end
    if drive_ata then
        txt = txt..'drive_ata'
    end
    if encrypted then
        txt = txt..'encrypted'
    end
    if filesystem then
        txt = txt..'filesystem'
    end
    if job then
        txt = txt..'job'
    end
    if loop then
        txt = txt..'loop'
    end
    if manager then
        txt = txt..'manager'
    end
    if mdraid then
        txt = txt..'mdraid'
    end
    if partition then
        txt = txt..'partition'
    end
    if partition_table then
        txt = txt..'partition_table'
    end
    if swapspace then
        txt = txt..'swapspace'
    end

    naughty.notify {
        title = 'UDisks, object added',
        text = txt,
        timeout = 0
    }
end


Client.object_manager.on_object_removed = function (self, object)
    local block = object:get_block()
    local drive = object:get_drive()
    local drive_ata = object:get_drive_ata()
    local encrypted = object:get_encrypted()
    local filesystem = object:get_filesystem()
    local job = object:get_job()
    local loop = object:get_loop()
    local manager = object:get_manager()
    local mdraid = object:get_mdraid()
    local partition = object:get_partition()
    local partition_table = object:get_partition_table()
    local swapspace = object:get_swapspace()
    
    local txt = "object is: "
    if block then
        txt = txt..'block'
    end
    if drive then
        txt = txt..'drive'
    end
    if drive_ata then
        txt = txt..'drive_ata'
    end
    if encrypted then
        txt = txt..'encrypted'
    end
    if filesystem then
        txt = txt..'filesystem'
    end
    if job then
        txt = txt..'job'
    end
    if loop then
        txt = txt..'loop'
    end
    if manager then
        txt = txt..'manager'
    end
    if mdraid then
        txt = txt..'mdraid'
    end
    if partition then
        txt = txt..'partition'
    end
    if partition_table then
        txt = txt..'partition_table'
    end
    if swapspace then
        txt = txt..'swapspace'
    end

    naughty.notify {
        title = 'UDisks, object removed',
        text = txt,
        timeout = 0
    }
end

return Client
