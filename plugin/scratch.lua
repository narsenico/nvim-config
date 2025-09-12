SCRATCH_DATA_PATH = vim.fs.joinpath(vim.fn.stdpath("data"), "scratch")

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
			local buf_modified = vim.api.nvim_buf_get_option(buf, "modified")
			if buf_modified then
				vim.api.nvim_buf_call(buf, function()
					vim.cmd("w")
				end)
			end
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
	-- FIX: definire altri file/directory che possono indicative di un progetto

	local res = vim.fs.find({ ".git", "node_modules", "Cargo.toml" }, {
		path = path,
		upward = true,
	})

	if res[1] then
		local projectPath = vim.fs.dirname(res[1])
		if projectPath == "." then
			projectPath = vim.fn.getcwd(0)
		end
		return projectPath
	end

	return nil
end

vim.api.nvim_create_user_command("Scratch", function()
	-- FIX: verificare che funzioni anche su altri OS (come windows)

	local projectPath = findProjectFolder(vim.fn.expand("%:p"))
	if not projectPath then
		error("error opening scratch file: project not found")
	end
	local projectName = string.gsub(projectPath, "[\\/:]", "__")

	if not vim.uv.fs_stat(SCRATCH_DATA_PATH) then
		vim.fn.mkdir(SCRATCH_DATA_PATH)
	end

	local path = vim.fs.joinpath(SCRATCH_DATA_PATH, projectName .. ".md")
	openScratch({ path = path, auto_save = true })
end, { desc = "Open scratch file for current project" })
