local string = string

local utils = {}

function utils.split(self, sep)
    local sep, fields = assert(sep), {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

function utils.basename(path)
    return string.match(path, '/*([%w-]+)$')
end

function utils.contains(tab, element)
    for _, value in pairs(tab) do
        if value == element then
            return true
        end
    end
    return false
end

return utils
