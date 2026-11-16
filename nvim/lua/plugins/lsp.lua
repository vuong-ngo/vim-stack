-- ================================================
-- Script: lsp.lua
-- Description: Configures Language Server Protocol and Treesitter syntax highlighting via LazyVim & LazyExtras.
-- ================================================

return {
	-- 1. Neovim Lua API Autocompletion & Types for config editing
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "Snacks", words = { "Snacks" } },
			},
		},
	},

	-- 2. Treesitter Syntax Highlighting
	-- Language parsers are synced dynamically via :LazyExtras (no hardcoded language defaults)
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			-- Only maintain core parsers needed for Neovim runtime and config editing
			vim.list_extend(opts.ensure_installed, {
				"lua",
				"luadoc",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"bash",
			})
		end,
	},

	-- 3. Mason (Syncs LSP servers, linters, and formatters dynamically via :LazyExtras)
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason Info" } },
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			opts.ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			}
		end,
	},

	-- 4. Nvim-LSPConfig
	-- Integrates natively with LazyVim's spec so :LazyExtras automatically manages servers
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
						},
					},
				},
			},
		},
	},
}
