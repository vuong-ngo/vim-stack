-- ============================================================
-- Statusline & Top Tab Bar (Lualine & Bufferline)
-- Theme: Transparent Powerline Graphite Matching Terminal
-- ============================================================

return {
	-- 1. Lualine Statusline (Bottom Bar)
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

	-- 2. Bufferline Top Tabs (Sleek IDE Tab Bar)
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			options = {
				mode = "buffers",
				separator_style = "slant",
				diagnostics = "nvim_lsp",
				always_show_bufferline = true,
				show_buffer_close_icons = true,
				show_close_icon = true,
				color_icons = true,
				buffer_close_icon = "󰅖",
				modified_icon = "●",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 18,
				max_prefix_length = 15,
				tab_size = 18,
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
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
}
