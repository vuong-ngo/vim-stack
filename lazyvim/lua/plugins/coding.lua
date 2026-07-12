-- ================================================
--   _   ____  ______  _  _______  _  ___________
--  | | / / / / / __ \/ |/ / ___/ / |/ / ___/ __ \
--  | |/ / /_/ / /_/ /    / (_ / /    / (_ / /_/ /
--  |___/\____/\____/_/|_/\___/ /_/|_/\___/\____/
-- ================================================

return {
	-- Setup autocompletion
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			local cmp = require("cmp")
			opts.mapping = vim.tbl_deep_extend("force", opts.mapping, {
				-- Trigger completion with Tab (only when there are suggestions)
				["<Tab>"] = cmp.mapping.confirm({ select = true }),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-k>"] = cmp.mapping.select_prev_item(),
			})
		end,
	},

	-- Auto-close brackets, quotes, etc. with smart behavior in Insert mode
	{
		"nvim-mini/mini.pairs",
		event = "InsertEnter", -- Just download
		opts = {
			modes = { insert = true, command = false, terminal = false },
		},
	},

	-- Improve file icons with a modern, consistent set of icons that integrate well with the rest of the UI
	{
		"nvim-mini/mini.icons",
		lazy = true,
		opts = {
			preset = "nerd", -- Sử dụng bộ icon Nerd Font để có nhiều biểu tượng hơn
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},

	-- Set up nvim-treesitter for enhanced syntax highlighting, indentation, and folding.
	-- (Previously split across two separate specs for the same plugin -
	-- one setting `ensure_installed` directly, one appending "tsx"/
	-- "typescript" to it with vim.list_extend because plain
	-- `vim.tbl_deep_extend` can't merge lists. Both parsers were already
	-- in the first list, so the second spec was pure duplication. Merged
	-- into a single spec.)
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"caddy",
				"bash",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			},
		},
	},

	-- Mason: install LSP servers and formatters.
	-- (Previously split across four separate specs for two plugins, with
	-- version pins overwritten by later un-pinned specs for the same
	-- plugin - version = "1.11.0" for mason.nvim was immediately
	-- shadowed by another mason.nvim spec below it with no version at
	-- all, so the pin never actually applied. Merged into one spec per
	-- plugin so config intent matches what actually happens.)
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"pyright", -- LSP for Python
				"gdscript", -- LSP for GDScript
				"bash-language-server", -- LSP for Bash
				"black", -- Formatter for Python
				"isort", -- Import sorter for Python
				"shfmt", -- Formatter for Bash
			})
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			auto_install = true,
			-- manually install packages that do not exist in this list please
			ensure_installed = { "zls", "gopls", "ts_ls" },
		},
	},
}
