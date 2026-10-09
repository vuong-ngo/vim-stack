-- ================================================
-- Script: ui.lua
-- Description: Configures visual appearance, including Catppuccin Mocha theme with full transparency, Lualine statusline, Bufferline tabs, and Noice floating commandline/notifications.
-- ================================================


return {
	-- 1. Theme & Colorscheme (Catppuccin Mocha with 100% Terminal Transparency)
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "mocha",
			transparent_background = true,
			integrations = {
				blink_cmp = true,
				bufferline = false, -- Disabled so Bufferline inherits custom pure transparent highlights without opaque Mocha override
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
					-- 1. Pure Terminal Transparency (Matching Explorer)
					Normal = { bg = "NONE" },
					NormalNC = { bg = "NONE" },
					NormalFloat = { bg = "NONE", fg = "#f4f4f5" },
					FloatBorder = { bg = "NONE", fg = "#3f3f46" },
					FloatTitle = { bg = "NONE", fg = "#e4e4e7", bold = true },
					MsgArea = { bg = "NONE", fg = "#f4f4f5" },

					SignColumn = { bg = "NONE" },
					FoldColumn = { bg = "NONE" },
					LineNr = { bg = "NONE", fg = "#71717a" },
					CursorLineNr = { bg = "NONE", fg = "#e4e4e7", bold = true },
					EndOfBuffer = { bg = "NONE" },
					WinSeparator = { bg = "NONE", fg = "#27272a" },

					StatusLine = { bg = "NONE" },
					StatusLineNC = { bg = "NONE" },

					TabLine = { bg = "NONE" },
					TabLineFill = { bg = "NONE" },
					TabLineSel = { bg = "#27272a" },

					-- 2. Snacks Suite & Explorer Transparency
					SnacksPicker = { bg = "NONE" },
					SnacksPickerBorder = { fg = "#3f3f46", bg = "NONE" },
					SnacksPickerTitle = { fg = "#e4e4e7", bg = "NONE", bold = true },
					SnacksNormal = { bg = "NONE" },
					SnacksNormalNC = { bg = "NONE" },
					SnacksPickerList = { bg = "NONE" },
					SnacksPickerInput = { bg = "NONE" },
					SnacksPickerPreview = { bg = "NONE" },

					NeoTreeNormal = { bg = "NONE" },
					NeoTreeNormalNC = { bg = "NONE" },
					NeoTreeEndOfBuffer = { bg = "NONE" },

					TroubleNormal = { bg = "NONE" },
					TroubleNormalNC = { bg = "NONE" },

					-- 3. Unified Graphite Hints (LSP Inlay, Diagnostics & Ghost Text)
					DiagnosticHint = { fg = "#a1a1aa", bg = "NONE" },
					DiagnosticVirtualTextHint = { bg = "NONE", fg = "#71717a", italic = true },
					DiagnosticFloatingHint = { fg = "#a1a1aa", bg = "NONE" },
					DiagnosticSignHint = { fg = "#a1a1aa", bg = "NONE" },

					DiagnosticInfo = { fg = "#38bdf8", bg = "NONE" },
					DiagnosticVirtualTextInfo = { bg = "NONE", fg = "#71717a", italic = true },
					DiagnosticWarn = { fg = "#f59e0b", bg = "NONE" },
					DiagnosticVirtualTextWarn = { bg = "NONE", fg = "#f59e0b", italic = true },
					DiagnosticError = { fg = "#f43f5e", bg = "NONE" },
					DiagnosticVirtualTextError = { bg = "NONE", fg = "#f43f5e", italic = true },

					-- Inlay hints (type/parameter hints in code)
					LspInlayHint = { bg = "NONE", fg = "#71717a", italic = true },

					-- Completion ghost text hints (Blink.cmp)
					BlinkCmpGhostText = { fg = "#71717a", italic = true },

					-- Completion Menu & Documentation Popups
					BlinkCmpMenu = { bg = "NONE" },
					BlinkCmpMenuBorder = { bg = "NONE", fg = "#3f3f46" },
					BlinkCmpMenuSelection = { bg = "#27272a", fg = "#ffffff", bold = true },
					BlinkCmpDoc = { bg = "NONE" },
					BlinkCmpDocBorder = { bg = "NONE", fg = "#3f3f46" },
					BlinkCmpDocSeparator = { bg = "NONE", fg = "#27272a" },
					BlinkCmpLabel = { fg = "#f4f4f5" },
					BlinkCmpLabelMatch = { fg = "#ffffff", bold = true },
					BlinkCmpLabelDetail = { fg = "#71717a" },
					BlinkCmpLabelDescription = { fg = "#71717a" },
					BlinkCmpKind = { fg = "#a1a1aa" },

					-- Popup Menu (Pmenu)
					Pmenu = { bg = "NONE", fg = "#f4f4f5" },
					PmenuSel = { bg = "#27272a", fg = "#ffffff", bold = true },
					PmenuBorder = { bg = "NONE", fg = "#3f3f46" },
					PmenuSbar = { bg = "NONE" },
					PmenuThumb = { bg = "#3f3f46" },

					-- Which-Key Hints
					WhichKey = { fg = "#e4e4e7", bold = true },
					WhichKeyNormal = { bg = "NONE" },
					WhichKeyBorder = { bg = "NONE", fg = "#3f3f46" },
					WhichKeyDesc = { fg = "#f4f4f5" },
					WhichKeyGroup = { fg = "#a1a1aa" },
					WhichKeySeparator = { fg = "#52525b" },

					-- Noice Popups & Commandline
					NoiceCmdlinePopup = { bg = "NONE" },
					NoiceCmdlinePopupBorder = { bg = "NONE", fg = "#3f3f46" },
					NoiceCmdlinePopupTitle = { bg = "NONE", fg = "#e4e4e7" },
					NoicePopup = { bg = "NONE" },
					NoicePopupBorder = { bg = "NONE", fg = "#3f3f46" },
					NoiceConfirm = { bg = "NONE" },
					NoiceConfirmBorder = { bg = "NONE", fg = "#3f3f46" },

					-- 4. Bufferline Direct Pure Transparent Highlights
					BufferLineFill = { bg = "NONE" },
					BufferLineBackground = { bg = "NONE", fg = "#a1a1aa" },
					BufferLineBufferVisible = { bg = "NONE", fg = "#71717a" },
					BufferLineBufferSelected = { bg = "#27272a", fg = "#f4f4f5", bold = true },
					BufferLineSeparator = { fg = "#3f3f46", bg = "NONE" },
					BufferLineSeparatorVisible = { fg = "#3f3f46", bg = "NONE" },
					BufferLineSeparatorSelected = { fg = "#27272a", bg = "NONE" },
					BufferLineIndicatorSelected = { fg = "#e4e4e7", bg = "#27272a" },
					BufferLineIndicatorVisible = { fg = "NONE", bg = "NONE" },
					BufferLineModified = { fg = "#f59e0b", bg = "NONE" },
					BufferLineModifiedSelected = { fg = "#f59e0b", bg = "#27272a" },
					BufferLineModifiedVisible = { fg = "#f59e0b", bg = "NONE" },
					BufferLineCloseButton = { fg = "#71717a", bg = "NONE" },
					BufferLineCloseButtonSelected = { fg = "#a1a1aa", bg = "#27272a" },
					BufferLineCloseButtonVisible = { fg = "#71717a", bg = "NONE" },
					BufferLineTab = { bg = "NONE", fg = "#a1a1aa" },
					BufferLineTabSelected = { bg = "#27272a", fg = "#f4f4f5", bold = true },
					BufferLineTabSeparator = { fg = "#3f3f46", bg = "NONE" },
					BufferLineTabSeparatorSelected = { fg = "#3f3f46", bg = "NONE" },
					BufferLineOffsetSeparator = { fg = "#27272a", bg = "NONE" },

					CursorLine = { bg = "#27272a" },
					PmenuSel = { bg = "#3f3f46", fg = colors.text, bold = true },
				}
			end,
		},
	},

	-- Activate Catppuccin as LazyVim's default colorscheme
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin-mocha",
		},
	},

	-- 2. Lualine Statusline (Powerline Graphite Style)
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function()
			local graphite_theme = {
				normal = {
					a = { bg = "#e4e4e7", fg = "#18181b", gui = "bold" },
					b = { bg = "#27272a", fg = "#f4f4f5", gui = "bold" },
					c = { bg = "NONE", fg = "#a1a1aa" },
				},
				insert = {
					a = { bg = "#f59e0b", fg = "#18181b", gui = "bold" },
					b = { bg = "#27272a", fg = "#f4f4f5", gui = "bold" },
					c = { bg = "NONE", fg = "#a1a1aa" },
				},
				visual = {
					a = { bg = "#c084fc", fg = "#18181b", gui = "bold" },
					b = { bg = "#27272a", fg = "#f4f4f5", gui = "bold" },
					c = { bg = "NONE", fg = "#a1a1aa" },
				},
				replace = {
					a = { bg = "#f43f5e", fg = "#18181b", gui = "bold" },
					b = { bg = "#27272a", fg = "#f4f4f5", gui = "bold" },
					c = { bg = "NONE", fg = "#a1a1aa" },
				},
				command = {
					a = { bg = "#38bdf8", fg = "#18181b", gui = "bold" },
					b = { bg = "#27272a", fg = "#f4f4f5", gui = "bold" },
					c = { bg = "NONE", fg = "#a1a1aa" },
				},
				inactive = {
					a = { bg = "#27272a", fg = "#71717a" },
					b = { bg = "NONE", fg = "#71717a" },
					c = { bg = "NONE", fg = "#71717a" },
				},
			}

			return {
				options = {
					theme = graphite_theme,
					section_separators = { left = "", right = "" },
					component_separators = { left = "│", right = "│" },
					globalstatus = true,
					disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = string.upper,
						},
					},
					lualine_b = {
						{ "branch", icon = "󰘬" },
						{ "diff", symbols = { added = " ", modified = " ", removed = " " } },
					},
					lualine_c = {
						{ "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " } },
						{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
						{ "filename", path = 1 },
					},
					lualine_x = {
						{ "encoding", fmt = string.upper },
						{ "fileformat", symbols = { unix = "LF", dos = "CRLF", mac = "CR" } },
					},
					lualine_y = { "progress" },
					lualine_z = {
						{ "location" },
					},
				},
			}
		end,
	},

	-- 3. Bufferline Top Tab Bar (VS Code Flat Square Tabs - Pure Graphite Theme)
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			options = {
				mode = "buffers",
				separator_style = "thin",
				indicator = {
					icon = "▎",
					style = "icon",
				},
				diagnostics = "nvim_lsp",
				always_show_bufferline = true,
				show_buffer_close_icons = true,
				show_close_icon = false,
				color_icons = true,
				buffer_close_icon = "󰅖",
				modified_icon = "●",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 18,
				max_prefix_length = 15,
				tab_size = 18,
				diagnostics_indicator = function(count, level)
					local icon = level:match("error") and " " or " "
					return " " .. icon .. count
				end,
				offsets = {
					{
						filetype = "neo-tree",
						text = "󰙅 FILE EXPLORER",
						text_align = "left",
						highlight = "Directory",
					},
					{
						filetype = "snacks_layout_box",
						text = "󰙅 FILE EXPLORER",
						text_align = "left",
						highlight = "Directory",
					},
				},
			},
			highlights = {
				fill = { bg = "NONE" },
				background = { bg = "NONE", fg = "#a1a1aa" },
				buffer_selected = { bg = "#27272a", fg = "#f4f4f5", bold = true, italic = false },
				buffer_visible = { bg = "NONE", fg = "#71717a" },
				indicator_selected = { fg = "#e4e4e7", bg = "#27272a" },
				indicator_visible = { fg = "NONE", bg = "NONE" },
				separator = { fg = "#3f3f46", bg = "NONE" },
				separator_selected = { fg = "#27272a", bg = "NONE" },
				separator_visible = { fg = "#3f3f46", bg = "NONE" },
				modified = { fg = "#f59e0b", bg = "NONE" },
				modified_selected = { fg = "#f59e0b", bg = "#27272a" },
				modified_visible = { fg = "#f59e0b", bg = "NONE" },
				close_button = { fg = "#71717a", bg = "NONE" },
				close_button_selected = { fg = "#a1a1aa", bg = "#27272a" },
				close_button_visible = { fg = "#71717a", bg = "NONE" },
				tab = { bg = "NONE", fg = "#a1a1aa" },
				tab_selected = { bg = "#27272a", fg = "#f4f4f5", bold = true },
				tab_separator = { fg = "#3f3f46", bg = "NONE" },
				tab_separator_selected = { fg = "#3f3f46", bg = "NONE" },
			},
		},
	},

	-- 4. Noice UI (Floating Commandline & Notifications)
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = false,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = true,
			},
			routes = {
				{
					filter = { event = "msg_show", find = "written" },
					opts = { skip = true },
				},
			},
		},
	},
}
