
local function terrible_require(module)
    local cached_module,fresh_module = package.loaded[module], require(module)
    package.loaded[module] = cached_module
    return fresh_module
end

local lower_case_letters = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' }
local upper_case_letters = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' }

local symbol_characters = { '!', '"', '£', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+', '[', '{', ']', '}', ';', ':', '\'', '@', '#',  '~', '\\', ',', '<', '.', '>', '/', '?' }

local numberpad_characters = { 'KP_Divide', 'KP_Multiply', 'KP_Subtract', 'KP_Add', 'KP_Enter', 'KP_Decimal', 'KP_0', 'KP_1', 'KP_2', 'KP_3', 'KP_4', 'KP_5', 'KP_6', 'KP_7', 'KP_8', 'KP_9' }

return {
    lib_path = '/usr/share/awesome/lib', 
    character_sets = {
        lower_case_letters = lower_case_letters,
        upper_case_letters = upper_case_letters,
        symbol_characters = symbol_characters,
        numberpad_characters = numberpad_characters
    },
    require = terrible_require
}
