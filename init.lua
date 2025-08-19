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
	-- colorscheme
	{ src = "https://github.com/EdenEast/nightfox.nvim" },
})

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "auto:4"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.winborder = "rounded"
vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.g.mapleader = " "

vim.keymap.set('n', '<leader>so', '<CMD>update<CR> <CMD>source<CR>', { desc = "Source config" })
vim.keymap.set('n', '<leader>q', '<CMD>quit<CR>', { desc = "Quit" })
vim.keymap.set('n', '<leader>w', '<CMD>write<CR>', { desc = "Save" })
vim.keymap.set('n', '<C-s>', '<CMD>write<CR>', { desc = "Save" })
vim.keymap.set('n', '<esc>', '<CMD>noh<CR>')
vim.keymap.set('n', '<leader>lf', require('conform').format, { desc = "LSP Format" })
vim.keymap.set('n', '<leader>lr', vim.lsp.buf.references, { desc = "LSP References" })
vim.keymap.set('n', '<leader>ls', vim.lsp.buf.document_symbol, { desc = "LSP SDocument Symbols" })
vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition, { desc = "LSP Definition" })
vim.keymap.set('n', '<leader>lD', '<CMD>FzfLua diagnostics_document<CR>', { desc = "LSP Open Diagnostic" })
vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = "LSP Rename" })
vim.keymap.set('n', '<leader>co', '<CMD>copen<CR>', { desc = "Open quickfix" })
vim.keymap.set('n', '<leader>cq', '<CMD>cclose<CR>', { desc = "Close quickfix" })
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>', { desc = "Yank on clipboard" })
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>', { desc = "Cut on clipboard" })
vim.keymap.set('n', '<leader>bb', '<CMD>b#<CR>', { desc = "Previously opened buffer" })
vim.keymap.set('n', '<leader>bd', '<CMD>bdelete<CR>', { desc = "Close current buffer" })
vim.keymap.set('n', '<C-TAB>', '<CMD>b#<CR>', { desc = "Previously opened buffer" })
vim.keymap.set('n', '<leader>gg', '<CMD>LazyGit<CR>', { desc = "Lazygit" })
vim.keymap.set('n', '<leader>gc', '<CMD>FzfLua git_commits<CR>', { desc = "Git Commits" })
vim.keymap.set('n', '<leader>gC', '<CMD>FzfLua git_bcommits<CR>', { desc = "Git Buffer Commits" })
vim.keymap.set('n', '<leader>gb', '<CMD>FzfLua git_blame<CR>', { desc = "Git Blame" })
vim.keymap.set('n', '<S-h>', '<CMD>bprevious<CR>', { desc = "Previous Buffer" })
vim.keymap.set('n', '<S-l>', '<CMD>bnext<CR>', { desc = "Next Buffer" })
vim.keymap.set('n', '<leader>ff', '<CMD>FzfLua files', { desc = "Find files" })
vim.keymap.set('n', '<leader><leader>', '<CMD>FzfLua files<CR>', { desc = "Find files" })
vim.keymap.set('n', '<leader>fb', '<CMD>FzfLua buffers<CR>', { desc = "Find buffers" })
vim.keymap.set('n', '<leader>fc', '<CMD>FzfLua changes<CR>', { desc = "Find changes" })

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

require("mason").setup()
-- automatically enable all lsp loaded with mason
-- no need vim.lsp.enable({ "lua_ls", ... })
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" } }
		}
	}
})
require("mason-lspconfig").setup()
require("nvim-treesitter.configs").setup({
	highlight = { enable = true }
})
-- file explorer
require("oil").setup({
	vim.keymap.set('n', '<leader>e', '<CMD>Oil --float<CR>', { desc = "Explorer" }),
})
-- key mapping description
require("which-key").setup({
	spec = {
		{ "<leader>f", group = "find" },
		{ "<leader>l", group = "lsp" },
		{ "<leader>c", group = "code" },
		{ "<leader>b", group = "buffers" },
		{ "<leader>g", group = "git" },
		{ "]q",        desc = "Next quickfix" },
		{ "[q",        desc = "Previous quickfix" },
	}
})
require('gitsigns').setup()
require('blink.cmp').setup({
	keymap = {
		preset = 'super-tab',
	},
	appearance = {
		nerd_font_variant = 'mono'
	},
	completion = { documentation = { auto_show = true } },
	sources = {
		default = { 'lsp', 'path', 'snippets', 'buffer' },
	},
	fuzzy = { implementation = "lua" }
})
require('bufferline').setup()
require('fzf-lua').setup()
require('lualine').setup({
	options = {
		-- theme = 'everforest',
		theme = 'codedark',
		section_separators = '', component_separators = ''
	}
})
require('conform').setup({
	formatters_by_ft = {
		javascript = { "prettier", stop_after_first = true },
		typescript = { "prettier", stop_after_first = true },
		typescriptreact = { "prettier", stop_after_first = true },
		json = { "prettier", stop_after_first = true },
		html = { "prettier", stop_after_first = true },
		css = { "prettier", stop_after_first = true },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

vim.cmd("colorscheme duskfox")
