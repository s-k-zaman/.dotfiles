local M = {}

M.augroup = function(name)
    return vim.api.nvim_create_augroup("zaman_nvim" .. name, { clear = true })
end

M.mysplit = function(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

M.reload_module = function(name)
    require("plenary.reload").reload_module(name)
end

M.replace_string = function(str, replace_string, replace_with)
    return str:gsub("%" .. replace_string, replace_with)
end

M.clean_regex_from_string = function(str)
    local regex_strings = {
        "^",
        "$",
        "(",
        ")",
        "%",
        ".",
        "[",
        "]",
        "*",
        "+",
        "-",
        "?",
        ")",
    }
    for _, sym in ipairs(regex_strings) do
        str = M.replace_string(str, sym, "")
    end
    return str
end
M.starts_with = function(str, start)
    return str:sub(1, #start) == start
end

M.ends_with = function(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

M.remove_duplicate_from_table = function(data_table)
    local hash = {}
    local res = {}

    for _, v in ipairs(data_table) do
        if not hash[v] then
            res[#res + 1] = v
            hash[v] = "have data"
        end
    end

    return res
end

M.has_value = function(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

M.tableConcat = function(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end
M.print_table = function(t, indent)
    -- Check if the variable is a table
    if type(t) ~= "table" then
        print("Not a table")
        return
    end

    -- If no indentation is provided, start with an empty string
    indent = indent or ""

    -- Loop through the table and print its key-value pairs
    for key, value in pairs(t) do
        -- If the value is a table, recursively print its contents
        if type(value) == "table" then
            print(indent .. tostring(key) .. ": {")
            M.print_table(value, indent .. "  ") -- increase the indent for nested tables
            print(indent .. "}")
        else
            print(indent .. tostring(key) .. ": " .. tostring(value))
        end
    end
end

M.is_git_repository = function()
    local is_git_repo = os.execute("git rev-parse --is-inside-work-tree > /dev/null 2>&1")
    return is_git_repo == 0
end

return M
