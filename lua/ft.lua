---@param str? string
---@return     string|nil trimmed string or nil if empty
local trim_or_nil = function(str)
	if not str then
		return nil
	end

	str = vim.fn.trim(str)

	if vim.fn.empty(str) == 1 then
		return nil
	end

	return str
end

---@param str?    string
---@param default string
---@return        string
local not_empty_or_default = function(str, default)
	if not str then
		return default or ""
	end

	if string.match(str, "^%s*$") then
		return default or ""
	end

	return str
end

---@param path       string
---@return table|nil pattern
---@return any       error
local load_pattern_from_file = function(path)
	local file = io.open(path, "rb")
	if not file then
		-- return nil, "file not exsists:" .. path
		return {}, nil
	end

	local content = file:read("a")
	local status, pattern_or_err = pcall(vim.json.decode, not_empty_or_default(content, "{}"))

	file:close()

	if not status then
		return nil, pattern_or_err
	end

	return pattern_or_err, nil
end

---@param path     string
---@param pattern  table
---@return boolean success
---@return any     error
local save_pattern_to_file = function(path, pattern)
	local file = io.open(path, "wb")
	if not file then
		return false, "cannot open file:" .. path
	end

	local json = vim.json.encode(pattern)
	local _, err = file:write(json)

	file:close()

	if err then
		return false, "cannot write to file:" .. err
	end

	return true, nil
end

---@param pattern table
local add_pattern = function(pattern)
	if not pattern or next(pattern) == nil then
		return
	end

	vim.filetype.add({
		pattern = pattern,
	})
end

---@param fargs       table
---@return string|nil filetype pattern
---@return string|nil filetype
local parse_ft_add_fargs = function(fargs)
	local arg1 = trim_or_nil(fargs[1])
	local arg2 = trim_or_nil(fargs[2])

	if not arg2 then
		return nil, arg1
	end

	return arg1, arg2
end

---@return string|nil current buffer file extension
local get_pattern_from_current_buffer = function()
	local ext = vim.fn.expand("%:e")

	if ext == "" then
		return nil
	end

	return ".*." .. ext
end

local to_indexed_table = function(data)
	local t = {}
	for k, v in next, data do
		table.insert(t, { k, v })
	end
	return t
end

---@param pattern     table
---@param title       string
---@return string|nil pattern key selected or nill if no selection occurs
local select_pattern = function(pattern, title)
	local indexed_pattern = to_indexed_table(pattern)
	local lines = { title }
	for i, e in ipairs(indexed_pattern) do
		table.insert(lines, i .. ". " .. e[1] .. " = " .. e[2])
	end

	local selection = vim.fn.inputlist(lines)
	if selection == 0 then
		return nil
	end

	return indexed_pattern[selection][1]
end

---@param pattern    table
---@param file_path  string
---@param auto_save? boolean
local setup_commands = function(pattern, file_path, auto_save)
	local save = function()
		local ok, err = save_pattern_to_file(file_path, pattern)
		if err then
			error(err)
		end
		print(ok and "Custom filetypes saved" or "Cannot save custom filetypes")
	end

	vim.api.nvim_create_user_command("FtAdd", function(args)
		local key, filetype = parse_ft_add_fargs(args.fargs)

		if filetype then
			key = key or get_pattern_from_current_buffer()
			vim.cmd("set filetype=" .. filetype)
		end
		assert(key and filetype, "Ft command requires at least 1 argument (:FT [pattern] <filetype>)")

		pattern = vim.tbl_extend("keep", pattern, { [key] = filetype })
		add_pattern(pattern)

		if auto_save then
			save()
		end
	end, { desc = "Add custom filetype", nargs = "*" })

	vim.api.nvim_create_user_command("FtSave", function()
		save()
	end, { desc = "Save custom filetypes" })

	vim.api.nvim_create_user_command("FtList", function()
		print(vim.inspect(pattern))
	end, { desc = "List custom filetypes" })

	vim.api.nvim_create_user_command("FtDel", function(args)
		-- TODO: se args allora 1. eliminare il pattern specificato oppure 2. eliminare il pattern del file corrente
		local key = select_pattern(pattern, "Select filetype pattern to delete (need restart):")
		if not key then
			return
		end

		pattern[key] = nil
		if auto_save then
			save()
		end
	end, { desc = "Delete custom filetype" })
end

local M = {}

function M.setup(opts)
	opts = opts or {}

	local file_path = vim.fn.expand(opts.ft_file_path)
	assert(file_path, "Must specify 'ft_file_path' to load filtype")

	local pattern, err = load_pattern_from_file(file_path)
	if err or not pattern then
		error(err or "Unknown error")
	end

	add_pattern(pattern)
	setup_commands(pattern, file_path, opts.auto_save)
end

return M
