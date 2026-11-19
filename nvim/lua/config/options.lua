-- ================================================
-- Script: options.lua
-- Description: This file contains Neovim options and settings, including clipboard synchronization, line numbering, indentation, search behavior, split window direction, performance optimizations, and whitespace display.
-- ================================================

-- Sync clipboard between OS and Neovim (safe for local and SSH sessions)
vim.opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
vim.opt.mouse = "a"

-- Line numbers: Absolute numbering (1, 2, 3...)
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.termguicolors = true
-- Inherit terminal opacity; nonzero blend makes Catppuccin use a solid popup background.
vim.opt.pumblend = 0
vim.opt.winblend = 0
vim.opt.wrap = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Spell checking: Disabled globally to prevent underline noise
vim.opt.spell = false
vim.opt.spelllang = { "en" }

-- Force relativenumber = false on buffer open (overriding LazyVim default)
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	group = vim.api.nvim_create_augroup("DisableRelativeNumbers", { clear = true }),
	callback = function()
		vim.opt.relativenumber = false
	end,
})

-- Indentation: 4 spaces default fallback
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftround = true

-- Code Formatting:
-- 1. Format-on-save is OFF by default (saves without altering spacing)
--    Use <leader>cf to format explicitly; toggle autoformat on save with <leader>uf when desired.
vim.g.autoformat = false

-- 2. Respect project .editorconfig rules (indent_size, tab_width, end_of_line)
vim.g.editorconfig = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Split window placement: new windows open right and below
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Performance & History
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.undofile = true -- Persistent undo history across restarts
vim.opt.autoread = true
vim.opt.confirm = true -- Confirm dialog before closing modified files

-- Enable Neovim global statusline
vim.opt.laststatus = 3

-- Whitespace display
vim.opt.list = true
vim.opt.listchars = {
	tab = "▸ ",
	trail = "·",
	extends = "❯",
	precedes = "❮",
	nbsp = "␣",
}
