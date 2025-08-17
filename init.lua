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
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { desc = "LSP Format" })
vim.keymap.set('n', '<leader>lr', vim.lsp.buf.references, { desc = "LSP References" })
vim.keymap.set('n', '<leader>ls', vim.lsp.buf.document_symbol, { desc = "LSP SDocument Symbols" })
vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition, { desc = "LSP Definition" })
vim.keymap.set('n', '<leader>lD', vim.diagnostic.open_float, { desc = "LSP Open Diagnostic" })
vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = "LSP Rename" })
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>', { desc = "Yank on clipboard" })
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>', { desc = "Cut on clipboard" })
vim.keymap.set('n', '<leader>bb', '<CMD>b#<CR>', { desc = "Previously opened buffer" })
vim.keymap.set('n', '<C-TAB>', '<CMD>b#<CR>', { desc = "Previously opened buffer" })

vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/echasnovski/mini.icons" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/ms-jpq/coq_nvim" },
	{ src = "https://github.com/ms-jpq/coq.artifacts" },
	-- colorscheme
	{ src = "https://github.com/EdenEast/nightfox.nvim" },
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

require("mason").setup()
-- automatically enable all lsp loaded with mason
-- no need vim.lsp.enable({ "lua_ls", ... })
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
		{ "]q",        desc = "Next quickfix" },
		{ "[q",        desc = "Previous quickfix" },
	}
})
require('mini.pick').setup({
	mappings = {
		-- choose_marked     = '<M-CR>', NOT WORKING ON MAC
		choose_marked = '<D-CR>', -- cmd+enter on mac
	}
})
vim.keymap.set('n', '<leader>ff', '<CMD>Pick files<CR>', { desc = "Pick files" })
vim.keymap.set('n', '<leader><leader>', '<CMD>Pick files<CR>', { desc = "Pick files" })
vim.keymap.set('n', '<leader>fb', '<CMD>Pick buffers<CR>', { desc = "Pick buffers" })
vim.keymap.set('n', '<leader>ft', '<CMD>Pick grep_live<CR>', { desc = "Pick grep" })
require('mini.icons').setup()
require('gitsigns').setup()

vim.cmd("colorscheme dawnfox")
