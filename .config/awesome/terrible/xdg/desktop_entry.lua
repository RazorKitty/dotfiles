local setmetatable = setmetatable
local string = string

local lgi = require('lgi')
local GLib = lgi.GLib
local KeyFile = GLib.KeyFile
local KeyFileFlags = GLib.KeyFileFlags

local utils = require('terrible.utils')

local gfilesystem = require('gears.filesystem')

local key_type_lookup = {
    Type = 'string',
    Version = 'string',
    Name = 'locale_string',
    GenericName = 'locale_string',
    NoDisplay = 'boolean',
    Comment = 'locale_string',
    Icon = 'string',
    Hidden = 'boolean',
    OnlyShowIn = 'locale_string_list',
    NotShowIn = 'locale_string_list',
    DBusActivatable = 'boolean',
    TryExec = 'string',
    Exec = 'string',
    Path = 'string',
    Terminal = 'boolean',
    Actions = 'string_list',
    MimeType = 'string_list',
    Categories = 'string_list',
    Implements = 'string_list',
    Keywords = 'locale_string_list',
    StartupNotify = 'boolean',
    StartupWMClass = 'string',
    URL = 'string'
}

local desktop_entry = { mt = {} }

function desktop_entry.should_start(self)
    if (self.OnlyShowIn and not utils.contains(self.OnlyShowIn, 'awesome'))
    or (self.NotShowIn and utils.contains(self.NotShowIn, 'awesome'))
    then
        return false
    end
    return true
end

function desktop_entry.can_start(self)
    local exe = string.match(self.Exec, '^([%w-]+)')
    -- if we have a checkable key
    if self.TryExec then
        -- it matches the command word
        if exe ~= utils.basename(self.TryExec) then
            return false
        end
        -- if it has a valid path check it exist and is executable
        if string.match(self.TryExec, '(/)') and gfilesystem.file_executable(self.TryExec) then
            return true
        end
    end
    -- search the default path for it
    for _,path in ipairs(utils.split(os.getenv('PATH'), ':')) do
        if gfilesystem.file_executable(path..'/'..exe) then
            return true
        end
    end
     -- got nothing
    return false
end

function desktop_entry.new(self, path)
    local kf = KeyFile()
    if not path or not kf:load_from_file(path, KeyFileFlags.NONE) or not kf:has_group('Desktop Entry') then
        return nil
    end

    local entry = {}

    for _,key in ipairs(kf:get_keys('Desktop Entry')) do
        entry[key] = kf['get_'..(key_type_lookup[key] or 'value')](kf, 'Desktop Entry', key)
    end

    if entry.Actions then
        for i,action in ipairs(entry.Actions) do
            if kf:has_group('Desktop Action '..action) then
                entry.Actions[action] = {}
                for _,key in pairs(kf:get_keys('Desktop Action '..action)) do
                    entry.Actions[action][key] = kf['get_'..(key_type_lookup[key] or 'value')](kf, 'Desktop Action '..action, key)
                end
            end
            if entry.TryExec and not entry.Actions.TryExec then
                entry.Actions.TryExec = entry.TryExec
            end
            entry.Actions[i] = nil
            setmetatable(entry.Actions[action], self)
        end
    end

    self.__index = self
    return setmetatable(entry, self)
end

desktop_entry.mt.__call = desktop_entry.new

return setmetatable(desktop_entry, desktop_entry.mt)
