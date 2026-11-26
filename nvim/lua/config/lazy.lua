-- ================================================
-- Script: lazy.lua
-- Description: This file contains the configuration for lazy.nvim, a plugin manager for Neovim
-- ================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim" -- Adjust the path as needed

-- Bootstrap lazy.nvim if it's not already installed
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

-- Prepend lazy.nvim to the runtime path
vim.opt.rtp:prepend(lazypath)

-- Set leader and localleader keys before loading lazy.nvim (safe fallback if required directly)
vim.g.mapleader = vim.g.mapleader or " "
vim.g.maplocalleader = vim.g.maplocalleader or "\\"

require("lazy").setup({
	spec = {
		-- Load lightweight domain plugin modules directly (no LazyVim distro overhead)
		{ import = "plugins" },
	},
	defaults = {
		-- Keep user plugin specs lazy unless explicitly marked lazy = false
		lazy = false,
		version = false, -- always use the latest git commit
	},
	checker = {
		enabled = false, -- Disabled: prevents background git network polling that can hang or error offline
		notify = false,
	},
	change_detection = {
		notify = false,
	},
	performance = {
		rtp = {
			-- disable unused built-in runtime plugins
			disabled_plugins = {
				"gzip",
				"matchit",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
