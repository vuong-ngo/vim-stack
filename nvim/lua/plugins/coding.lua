-- ================================================
-- Script: coding.lua
-- Description: Configures in-buffer editing mechanics and autocompletion, including Blink.cmp completion engine, Mini.pairs auto-closing, Mini.surround motions, Mini.ai text objects, and Nvim-ts-autotag tag closing.
-- ================================================


return {
	-- 1. Blink.cmp (Ultra-fast Rust-backed Autocomplete Engine)
	{
		"saghen/blink.cmp",
		version = "*",
		dependencies = "rafamadriz/friendly-snippets",
		opts = {
			keymap = {
				preset = "super-tab",
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback_to_mappings" },
				["<C-n>"] = { "select_next", "fallback_to_mappings" },
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 200 },
				menu = { border = "rounded" },
				ghost_text = { enabled = true },
				list = {
					selection = {
						preselect = true,
						auto_insert = false,
					},
				},
			},
		},
	},

	-- 2. Auto Pairs (VS Code Style Quote/Bracket Auto-closing)
	{
		"nvim-mini/mini.pairs",
		event = "VeryLazy",
		opts = {},
	},

	-- 3. Surround Motions (sa to add, sd to delete, sr to replace)
	{
		"nvim-mini/mini.surround",
		event = "VeryLazy",
		opts = {
			mappings = {
				add = "sa",
				delete = "sd",
				find = "sf",
				find_left = "sF",
				highlight = "sh",
				replace = "sr",
				update_n_lines = "sn",
			},
		},
	},

	-- 4. Enhanced Text Objects (mini.ai)
	{
		"nvim-mini/mini.ai",
		event = "VeryLazy",
		opts = {},
	},

	-- 5. Auto Close & Rename HTML/JSX Tags
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},
}
