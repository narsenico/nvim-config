local openScratch = function(opts)
	opts = vim.tbl_extend("keep", opts or {}, { auto_save = true })

	assert(opts.path, "Must specify 'path' for scratch file")

	local buf = vim.api.nvim_create_buf(false, false)
	vim.api.nvim_buf_set_name(buf, opts.path)
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

	local width = vim.o.columns
	local height = vim.o.lines
	local win_width = math.ceil(width * 0.8)
	local win_height = math.ceil(height * 0.8)
	local col = math.ceil((width - win_width) / 2)
	local row = math.ceil((height - win_height) / 2 - 1)

	local win_opts = {
		relative = "editor",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = string.format("Scratch [%s]", opts.auto_save and "auto save" or "no auto save"),
		footer = opts.path,
	}

	local win = vim.api.nvim_open_win(buf, true, win_opts)

	vim.api.nvim_buf_call(buf, function()
		vim.cmd("edit!") -- Force reload
	end)

	vim.keymap.set("n", "<ESC><ESC>", function()
		if opts.auto_save then
			vim.api.nvim_buf_call(buf, function()
				vim.cmd("w")
			end)
		end
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, false)
		else
			error("win is no more valid")
		end
	end, { buffer = buf, nowait = true })

	return { buffer = buf, window = win }
end

local findProjectFolder = function(path)
	local res = vim.fs.find({ ".git", "node_modules" }, {
		type = "directory",
		path = path,
		upward = true,
	})

	if res[1] then
		return vim.fs.dirname(res[1])
	end

	return nil
end

FOLDER_NAME = "myscratch"

vim.keymap.set("n", "<leader>xt", function()
	local scratchPath = vim.fs.joinpath(vim.fn.stdpath("data"), FOLDER_NAME)
	local projectPath = findProjectFolder(vim.fn.expand("%:p"))
	local projectName = (projectPath and string.gsub(projectPath, "/", "__") or "project")

	if not vim.uv.fs_stat(scratchPath) then
		vim.fn.mkdir(scratchPath)
	end

	local path = vim.fs.joinpath(scratchPath, projectName .. ".md")
	openScratch({ path = path, auto_save = true })
end, { desc = "Open scratch file for current project" })
