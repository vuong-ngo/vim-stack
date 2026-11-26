-- ================================================
-- Script: init.lua
-- Description: Main entry point for Neovim (pure lazy.nvim setup without LazyVim distribution overhead).
-- ================================================

-- Set leader keys and core options before loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.lazy")
require("config.autocmds")
require("config.keymaps")
