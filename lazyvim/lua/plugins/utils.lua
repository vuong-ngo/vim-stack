-- ============================================================
-- Utility Plugins (Which-Key, Auto-pairs, Surround, Git, Diagnostics)
-- ============================================================

return {
	-- 1. Which-Key (Keybinding Popup Guide)
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "classic",
			delay = 200,
		},
	},

	-- 2. Auto Pairs (VS Code Style Quote/Bracket Auto-closing)
	{
		"nvim-mini/mini.pairs",
		event = "VeryLazy",
		opts = {},
	},

	-- 3. Surround Motions (ysw", cs"', ds")
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

	-- 5. Code Commenting (gcc, gc in visual mode)
	{
		"nvim-mini/mini.comment",
		event = "VeryLazy",
		opts = {},
	},

	-- 6. Git Signs (Gutter status indicators, line blame)
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
					if vim.wo.diff then return "]c" end
					vim.schedule(function() gs.next_hunk() end)
					return "<Ignore>"
				end, { expr = true, desc = "Next Git Hunk" })

				map("n", "[h", function()
					if vim.wo.diff then return "[c" end
					vim.schedule(function() gs.prev_hunk() end)
					return "<Ignore>"
				end, { expr = true, desc = "Previous Git Hunk" })

				map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, { desc = "Git Line Blame" })
				map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview Git Hunk" })
			end,
		},
	},

	-- 7. Global Workspace Search & Replace (grug-far)
	{
		"MagicDuck/grug-far.nvim",
		cmd = "GrugFar",
		opts = { headerMaxWidth = 80 },
	},

	-- 8. Flash (Lightning-fast 2-character motion jump)
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
			{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
		},
	},

	-- 9. Trouble (VS Code Problems Panel)
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = {},
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace Diagnostics (Trouble)" },
			{ "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Document Diagnostics (Trouble)" },
			{ "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
		},
	},

	-- 10. TODO Comments (Highlight & Search TODO/FIXME/HACK)
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		keys = {
			{ "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Search TODOs" },
			{ "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
			{ "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
		},
	},
}
