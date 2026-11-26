-- ================================================
-- Script: editor.lua
-- Description: Configures workspace navigation and editor utilities, including Snacks dashboard/explorer/pickers/terminal/bigfile, Which-Key popup, and GitSigns gutter integration.
-- ================================================

return {
	-- 1. Snacks Suite (Dashboard, Explorer, Pickers, Terminal, Bigfile)
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			dashboard = {
				enabled = true,
				preset = {
					header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
----= (づ｡◕‿‿◕｡)づ =----
                    ]],
					keys = {
						{
							icon = " ",
							key = "f",
							desc = "Find File (Ctrl+P)",
							action = ":lua Snacks.dashboard.pick('files')",
						},
						{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{
							icon = " ",
							key = "g",
							desc = "Find Text (Grep)",
							action = ":lua Snacks.dashboard.pick('live_grep')",
						},
						{
							icon = " ",
							key = "r",
							desc = "Recent Files",
							action = ":lua Snacks.dashboard.pick('oldfiles')",
						},
						{
							icon = " ",
							key = "c",
							desc = "Config",
							action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
						},
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
			},
			bigfile = { enabled = true },
			explorer = { enabled = true, replace_netrw = true },
			indent = { enabled = true },
			input = { enabled = true },
			lazygit = { enabled = false }, -- Disabled: Git is managed in external terminal
			picker = {
				enabled = true,
				sources = {
					explorer = {
						hidden = true, -- Show dotfiles (.env, .gitignore, etc.)
						ignored = true, -- Show files ignored by .gitignore / .ignore
					},
					files = {
						hidden = true, -- Show dotfiles in file search
					},
				},
			},
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = false }, -- Instant scrolling
			terminal = { enabled = true },
			words = { enabled = true },
			notifier = { enabled = true, timeout = 3000 },
		},
	},

	-- 2. Which-Key (Compact Right-Corner Keybinding Popup Guide)
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
			delay = 200,
			win = {
				wo = {
					winblend = 0,
				},
			},
			defer = function(ctx)
				if vim.list_contains({ "d", "y" }, ctx.operator) then
					return true
				end
				return vim.list_contains({ "<C-V>", "V", "v" }, ctx.mode)
			end,
		},
	},

	-- 3. Git Signs (Gutter status indicators, line blame, hunk navigation)
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				map("n", "]h", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Next Git Hunk" })

				map("n", "[h", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Previous Git Hunk" })

				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, { desc = "Git Line Blame" })
				map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview Git Hunk" })
			end,
		},
	},
}
