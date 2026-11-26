-- ================================================
-- Script: lsp.lua
-- Description: Configures Treesitter, Mason, native/lspconfig LSP servers, and Conform formatting directly via lazy.nvim (no LazyVim distro overhead).
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
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			ensure_installed = {
				"lua",
				"luadoc",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"bash",
			},
			auto_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		},
		config = function(_, opts)
			local ok_configs, configs = pcall(require, "nvim-treesitter.configs")
			if ok_configs then
				configs.setup(opts)
			else
				local ok_ts, ts = pcall(require, "nvim-treesitter")
				if ok_ts and ts.setup then
					ts.setup(opts)
				end
			end
		end,
	},

	-- 3. Mason (Install LSP servers, formatters, and tools on demand)
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason Info" } },
		opts = {
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},

	-- 4. Mason-LSPConfig (Bridges Mason packages to Neovim LSP)
	{
		"mason-org/mason-lspconfig.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			automatic_enable = true,
		},
	},

	-- 5. Nvim-LSPConfig (Server configurations + Blink.cmp capabilities)
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
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
		config = function(_, opts)
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local ok_blink, blink = pcall(require, "blink.cmp")
			if ok_blink and blink.get_lsp_capabilities then
				capabilities = blink.get_lsp_capabilities(capabilities)
			end

			if vim.lsp and vim.lsp.config then
				vim.lsp.config("*", { capabilities = capabilities })
				for server, server_opts in pairs(opts.servers or {}) do
					server_opts.capabilities = vim.tbl_deep_extend("force", capabilities, server_opts.capabilities or {})
					vim.lsp.config(server, server_opts)
					vim.lsp.enable(server)
				end
			else
				local lspconfig = require("lspconfig")
				for server, server_opts in pairs(opts.servers or {}) do
					server_opts.capabilities = vim.tbl_deep_extend("force", capabilities, server_opts.capabilities or {})
					lspconfig[server].setup(server_opts)
				end
			end
		end,
	},

	-- 6. Conform (On-demand formatting via <leader>cf, optional format-on-save via <leader>uf)
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {},
			format_on_save = function()
				if vim.g.autoformat then
					return { timeout_ms = 500, lsp_format = "fallback" }
				end
			end,
		},
	},
}
