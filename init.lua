local DEFAULT_SCROLLOFF = 5

local showConfigFiles = function()
	local cwd = vim.fn.stdpath("config")
	require("fzf-lua").files({ cwd = cwd, winopts = { title = "Config" } })
end

local showCurrentFolder = function()
	local cwd = vim.fn.expand("%:p:h")
	require("fzf-lua").files({ cwd = cwd, winopts = { title = "Current folder" } })
end

local loadSession = function()
	require("persistence").load()
end

local selectSession = function()
	require("persistence").select()
end

local toggleLockCursorOnScreenMiddle = function()
	if vim.o.scrolloff == 999 then
		vim.o.scrolloff = DEFAULT_SCROLLOFF
		vim.o.cursorline = false
	else
		vim.o.scrolloff = 999
		vim.o.cursorline = true
	end
	print("scrolloff=" .. vim.o.scrolloff)
end

local format = function()
	require("conform").format({ async = true })
end

local copyFilePathToSystemClipboard = function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
end

local copyFileDirectoryToSystemClipboard = function()
	local path = vim.fn.expand("%:p:h")
	vim.fn.setreg("+", path)
end

local openFile = function()
	vim.ui.open(vim.fn.expand("%:p"))
end

local openFileDirectory = function()
	vim.ui.open(vim.fn.expand("%:p:h"))
end

local removeUnusedImports = function()
	vim.lsp.buf.code_action({
		context = {
			only = { "source.removeUnused" },
		},
		apply = true,
	})
end

local addMissingImports = function()
	vim.lsp.buf.code_action({
		context = {
			only = { "source.addMissingImports" },
		},
		apply = true,
	})
end

vim.pack.add({
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1.6.0" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
	{ src = "https://github.com/akinsho/bufferline.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/tpope/vim-sleuth" },
	{ src = "https://github.com/folke/persistence.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/chentoast/marks.nvim" },
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
	-- colorscheme
	{ src = "https://github.com/EdenEast/nightfox.nvim" },
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
})

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes:2"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.winborder = "rounded"
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.undofile = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.scrolloff = DEFAULT_SCROLLOFF

vim.g.mapleader = " "

vim.diagnostic.config({ virtual_lines = false, virtual_text = false }) -- tiny-inline-diagnostic takes care of diagnostic virtual text

vim.keymap.set("n", "<leader>so", "<CMD>update<CR> <CMD>source<CR>", { desc = "Source config" })
vim.keymap.set("n", "<leader>sl", loadSession, { desc = "Load session" })
vim.keymap.set("n", "<leader>ss", selectSession, { desc = "Select session" })
vim.keymap.set("n", "<leader>q", "<CMD>quit<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>w", "<CMD>write<CR>", { desc = "Save" })
vim.keymap.set("n", "<C-s>", "<CMD>write<CR>", { desc = "Save" })
vim.keymap.set("n", "<esc>", "<CMD>noh<CR>")
vim.keymap.set("n", "<leader>lf", format, { desc = "LSP Format" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, { desc = "LSP References" })
vim.keymap.set("n", "<leader>ls", "<CMD>FzfLua lsp_document_symbols<CR>", { desc = "LSP Document Symbols" })
vim.keymap.set("n", "<leader>lS", "<CMD>FzfLua lsp_live_workspace_symbols<CR>", { desc = "LSP Workspace Symbols" })
vim.keymap.set("n", "<leader>ld", "<CMD>FzfLua diagnostics_document<CR>", { desc = "LSP Document Diagnostics" })
vim.keymap.set("n", "<leader>lD", "<CMD>FzfLua diagnostics_workspace<CR>", { desc = "LSP Workspace Diagnostics" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
vim.keymap.set({ "n", "v" }, "<leader>cu", removeUnusedImports, { desc = "LSP Remove Unused Imports" })
vim.keymap.set({ "n", "v" }, "<leader>cm", addMissingImports, { desc = "LSP Add Missing Imports" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "LSP Rename" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show Diagnostics under cursor" })
vim.keymap.set("n", "<leader>co", "<CMD>copen<CR>", { desc = "Open quickfix" })
vim.keymap.set("n", "<leader>cq", "<CMD>cclose<CR>", { desc = "Close quickfix" })
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y<CR>', { desc = "Yank on clipboard" })
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d<CR>', { desc = "Cut on clipboard" })
vim.keymap.set("n", "<leader>bb", "<CMD>b#<CR>", { desc = "Previously opened buffer" })
vim.keymap.set("n", "<leader>bd", "<CMD>bdelete<CR>", { desc = "Close current buffer" })
vim.keymap.set("n", "<leader>bo", "<CMD>BufferLineCloseOthers<CR>", { desc = "Close other buffers" })
vim.keymap.set("n", "<leader>br", "<CMD>BufferLineCloseRight<CR>", { desc = "Close buffers at right" })
vim.keymap.set("n", "<leader>bl", "<CMD>BufferLineCloseLeft<CR>", { desc = "Close buffers at left" })
vim.keymap.set("n", "<C-TAB>", "<CMD>b#<CR>", { desc = "Previously opened buffer" })
vim.keymap.set("n", "<leader>gg", "<CMD>LazyGit<CR>", { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gc", "<CMD>FzfLua git_commits<CR>", { desc = "Git Commits" })
vim.keymap.set("n", "<leader>gC", "<CMD>FzfLua git_bcommits<CR>", { desc = "Git Buffer Commits" })
vim.keymap.set("n", "<leader>gb", "<CMD>FzfLua git_blame<CR>", { desc = "Git Blame" })
vim.keymap.set("n", "<S-h>", "<CMD>bprevious<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<S-l>", "<CMD>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>ff", "<CMD>FzfLua files<CR>", { desc = "Find files" })
-- vim.keymap.set("n", "<leader><leader>", "<CMD>FzfLua files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader><leader>", showCurrentFolder, { desc = "Find files" })
vim.keymap.set("n", "<leader>fb", "<CMD>FzfLua buffers<CR>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fc", "<CMD>FzfLua changes<CR>", { desc = "Find changes" })
vim.keymap.set("n", "<leader>ft", "<CMD>FzfLua live_grep<CR>", { desc = "Find text (grep)" })
vim.keymap.set("n", "<leader>fC", showConfigFiles, { desc = "Find config files" })
vim.keymap.set("n", "<leader>fh", "<CMD>FzfLua helptags<CR>", { desc = "Find help tags" })
vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Explorer" })
vim.keymap.set(
	"n",
	"<leader>zm",
	toggleLockCursorOnScreenMiddle,
	{ desc = "Toggle lock cursor on middle of the screen" }
)
vim.keymap.set("n", "<leader>zs", "<CMD>setlocal spell spelllang=en,it<CR>", { desc = "Enable spell checking (en,it)" })
vim.keymap.set("n", "<leader>zS", "<CMD>setlocal nospell<CR>", { desc = "Disable spell checking" })
vim.keymap.set("n", "<leader>xyf", copyFilePathToSystemClipboard, { desc = "Copy file path to system clipboard" })
vim.keymap.set(
	"n",
	"<leader>xyd",
	copyFileDirectoryToSystemClipboard,
	{ desc = "Copy file parent directory to system clipboard" }
)
vim.keymap.set("n", "<leader>xxf", openFile, { desc = "Open file" })
vim.keymap.set("n", "<leader>xxd", openFileDirectory, { desc = "Open directory" })
vim.keymap.set("n", "<leader>xt", "<CMD>Scratch<CR>", { desc = "Open scratch file for current project" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP Definition" })
vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "LSP Implementation" })
vim.keymap.set("n", "gr", "<CMD>FzfLua lsp_references<CR>", { desc = "LSP References", nowait = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

require("fidget").setup()
require("mason").setup()
-- automatically enable all lsp loaded with mason
-- no need vim.lsp.enable({ "lua_ls", ... })
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})
require("mason-lspconfig").setup()
-- INFO: remember to install parser for language manually
-- :TSInstall <language> (eg :TSInstall typescript)
require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<Tab>", -- set to `false` to disable one of the mappings
			node_incremental = "<Tab>",
			scope_incremental = false,
			node_decremental = "<S-Tab>",
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
			},
			selection_modes = {
				["@parameter.outer"] = "v", -- charwise
				["@function.outer"] = "V", -- linewise
				["@class.outer"] = "<c-v>", -- blockwise
			},
			include_surrounding_whitespace = true,
		},
	},
})
require("oil").setup()
-- key mapping description
require("which-key").setup({
	spec = {
		{ "<leader>f", group = "find" },
		{ "<leader>l", group = "lsp" },
		{ "<leader>c", group = "code" },
		{ "<leader>b", group = "buffers" },
		{ "<leader>g", group = "git" },
		{ "]q", desc = "Next quickfix" },
		{ "[q", desc = "Previous quickfix" },
	},
})
require("gitsigns").setup()
require("blink.cmp").setup({
	keymap = {
		preset = "super-tab",
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = { documentation = { auto_show = true } },
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = { implementation = "lua" },
})
require("bufferline").setup()
require("fzf-lua").setup()
require("lualine").setup({
	options = {
		-- theme = 'everforest',
		theme = "codedark",
		section_separators = "",
		component_separators = "",
	},
})
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua", stop_after_first = true },
		javascript = { "prettierd", stop_after_first = true },
		typescript = { "prettierd", stop_after_first = true },
		typescriptreact = { "prettierd", stop_after_first = true },
		json = { "prettierd", stop_after_first = true },
		html = { "prettierd", stop_after_first = true },
		css = { "prettierd", stop_after_first = true },
	},
	format_after_save = {
		timeout_ms = 1000,
		lsp_format = "fallback",
	},
})
require("nvim-autopairs").setup()
require("marks").setup({
	refresh_interval = 250,
})
require("persistence").setup()
-- show diagnostic virtual text only on line under the cursor
require("tiny-inline-diagnostic").setup()
require("kanagawa").setup({
	-- TODO: this is a todo
	-- INFO: this is an info
	-- FIX: this is a fix
	-- FIXME: this is a fixme
	overrides = function()
		return {
			-- INFO: use :Inspect to see what type highlight group is under the cursor
			Comment = { fg = "#bababa" },
		}
	end,
})

-- vim.cmd("colorscheme duskfox")
vim.cmd("colorscheme kanagawa-dragon")

require("lua.ft").setup({
	ft_file_path = vim.fn.stdpath("data") .. "/ft.json",
	auto_save = true,
})
