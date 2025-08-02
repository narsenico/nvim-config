vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.g.mapleader = " "
		
vim.keymap.set('n', '<leader>so', '<CMD>update<CR> <CMD>source<CR>')
vim.keymap.set('n', '<C-s>', '<CMD>write<CR>')
-- hide highlight
vim.keymap.set('n', '<esc>', '<CMD>noh<CR>')

vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

-- oil: file explorer
vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.lsp.enable({ "lua_ls" })

-- TODO: non funziona perché non trova lua-language-server
-- require('lspconfig').lua_ls.setup({})

vim.cmd("colorscheme vague")

require("oil").setup()

require('mini.pick').setup({
	vim.keymap.set('n', '<leader>ff', '<CMD>Pick files<CR>'),
	vim.keymap.set('n', '<leader>fb', '<CMD>Pick buffers<CR>'),
	vim.keymap.set('n', '<leader>ft', '<CMD>Pick grep_live<CR>')
})
