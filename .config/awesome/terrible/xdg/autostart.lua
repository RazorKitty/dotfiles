local lgi = require('lgi')
local Gio = lgi.Gio
local GLib = lgi.GLib
local File = Gio.File

local utils = require('terrible.utils')
local desktop_entry = require('terrible.xdg.desktop_entry')
local basedir = require('terrible.xdg.basedir')
local utils = require('terrible.utils')

local gfilesystem = require('gears.filesystem')
local spawn = require('awful.spawn')
local naughty = require('naughty')
local awesome = awesome

local autostart = {}

autostart.search_path = {}
autostart.pids = {}

for _,path in ipairs(basedir.config_dirs) do
    table.insert(autostart.search_path, path..'/autostart')
end
table.insert(autostart.search_path, basedir.config_home..'/autostart')

function autostart.close_callback(self, entry, pid, out, err, reason, code)
    if code ~= 0 then
        naughty.notify {
            title = 'Autostart Exit Error',
            text = entry.Name..':'..reason,
            timeout = 0
        }
    end
    self.pids[pid] = nil
end

function autostart.stop(self, reason)
    for pid in pairs(self.pids) do
        awesome.kill(pid, 15)
    end
end

autostart.start = Gio.Async.start( function (self)
    local entries = {}
    for _,dir in ipairs(self.search_path) do
        if gfilesystem.dir_readable(dir) then
            local dir_file = File.new_for_path(dir)
            local enumerator = dir_file:async_enumerate_children(Gio.FILE_ATTRIBUTE_STANDARD_NAME..','..Gio.FILE_ATTRIBUTE_STANDARD_TYPE,
                                                                 Gio.FileQueryInfoFlags.NONE)

            local file_info_list = enumerator:async_next_files(64)
            enumerator:async_close()

            for _,file_info in ipairs(file_info_list) do
                local entry_file = enumerator:get_child(file_info)
                local entry = desktop_entry(entry_file:get_path())
                entries[entry_file:get_basename()] = entry
            end
        end
    end

    for _,entry in pairs(entries) do
        if
            not entry.Hidden
            and entry:should_start()
        then
            local pid
            pid = spawn.easy_async(entry.Exec, function (out, err, reason, code)
                    self:close_callback(entry, pid, out, err, reason, code)
                end)
            self.pids[pid] = true
        end
    end
end)

awesome.connect_signal('exit', function (reason)
    autostart:stop(reason)
end)
return autostart

