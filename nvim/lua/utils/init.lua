local U = {}
U.mysplit = function(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

U.reload_module = function(name)
	require("plenary.reload").reload_module(name)
end

U.replace_string = function(str, replace_string, replace_with)
	return str:gsub("%" .. replace_string, replace_with)
end

U.clean_regex_from_string = function(str)
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
		str = U.replace_string(str, sym, "")
	end
	return str
end
U.starts_with = function(str, start)
	return str:sub(1, #start) == start
end

U.ends_with = function(str, ending)
	return ending == "" or str:sub(-#ending) == ending
end

U.remove_duplicate_from_table = function(data_table)
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

return U
