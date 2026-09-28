-- ================================================
-- Script: disabled.lua
-- Description: Explicitly disables redundant, duplicate, or unused plugins (mini.comment, tokyonight, persistence, nvim-lint, flash) to optimize resource usage and prevent feature overlap.
-- ================================================


return {
	-- 1. Disable mini.comment (Duplicate: Neovim 0.10+ native gc/gcc + ts-comments.nvim handles commenting)
	{ "nvim-mini/mini.comment", enabled = false },

	-- 2. Disable Tokyonight theme (Unused: Catppuccin Mocha is the active transparent theme)
	{ "folke/tokyonight.nvim", enabled = false },

	-- 3. Disable Persistence session saver (Unused: user manages buffers directly; prevents redundant disk writes)
	{ "folke/persistence.nvim", enabled = false },

	-- 4. Disable nvim-lint (Unused: Diagnostics are provided by LSP servers; formatting by Conform)
	{ "mfussenegger/nvim-lint", enabled = false },

	-- 5. Disable Flash.nvim (Prevents key-hijacking; maintains standard editor s/S behavior)
	{ "folke/flash.nvim", enabled = false },
}
