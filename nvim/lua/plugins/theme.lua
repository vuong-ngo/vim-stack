-- ============================================================
-- Theme & Colorscheme (100% Transparent Terminal Background)
-- ============================================================

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "mocha",
			transparent_background = true,
			integrations = {
				blink_cmp = true,
				bufferline = true,
				mason = true,
				gitsigns = true,
				treesitter = true,
				which_key = true,
				noice = true,
				trouble = true,
				native_lsp = { enabled = true },
			},
			custom_highlights = function(colors)
				return {
					-- Transparent editor surfaces to match terminal background
					Normal = { bg = "NONE" },
					NormalNC = { bg = "NONE" },
					NormalFloat = { bg = "NONE", fg = colors.text },
					FloatBorder = { bg = "NONE", fg = colors.overlay0 },
					FloatTitle = { bg = "NONE", fg = colors.blue, bold = true },

					WhichKeyNormal = { bg = "NONE" },

					SnacksPicker = { bg = "NONE" },
					SnacksPickerBorder = { fg = colors.overlay0, bg = "NONE" },
					SnacksPickerTitle = { fg = colors.blue, bg = "NONE", bold = true },
					SnacksNormal = { bg = "NONE" },

					CursorLine = { bg = "#27272a" },
					PmenuSel = { bg = "#3f3f46", fg = colors.text, bold = true },
				}
			end,
		},
	},

	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin-mocha",
		},
	},
}
