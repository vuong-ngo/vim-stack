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
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
					globalstatus = true,
					disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(str)
								return " " .. str
							end,
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
						{ "fileformat", symbols = { unix = "LF ", dos = "CRLF ", mac = "CR " } },
					},
					lualine_y = { "progress" },
					lualine_z = {
						{ "location", icon = "󰍹" },
					},
				},
			}
		end,
	},

	-- 3. Bufferline Top Tab Bar (VS Code Flat Square Tabs)
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
