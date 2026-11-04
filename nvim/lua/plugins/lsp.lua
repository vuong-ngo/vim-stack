-- ================================================
-- Script: lsp.lua
-- Description: Configures Language Server Protocol and Treesitter syntax highlighting, including Mason package installer, Mason-Lspconfig, Nvim-Lspconfig with keymaps, and LazyDev for Neovim Lua API types.
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

	-- 2. Treesitter Syntax Highlighting & AST Indentation
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			sync_install = false,
			auto_install = false, -- Don't trigger background network downloads on unknown filetypes
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"lua",
				"python",
				"javascript",
				"typescript",
				"tsx",
				"html",
				"css",
				"json",
				"jsonc",
				"yaml",
				"bash",
				"markdown",
				"markdown_inline",
				"vim",
				"vimdoc",
				"c",
				"cpp",
				"rust",
				"go",
			},
		},
	},

	-- 3. Mason (Portable Package Manager for LSP Servers & Formatters)
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason Info" } },
		opts = function(_, opts)
			opts.ensure_installed = {} -- Prevent auto-downloading packages in background when external tools (unzip, npm) are missing
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

	-- 4. Mason LSPConfig & Nvim-LSPConfig
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = false, -- Prevent background network installs failing without npm/unzip
				handlers = {
					function(server_name)
						pcall(function()
							lspconfig[server_name].setup({
								capabilities = capabilities,
							})
						end)
					end,
					["lua_ls"] = function()
						pcall(function()
							lspconfig.lua_ls.setup({
								capabilities = capabilities,
								settings = {
									Lua = {
										diagnostics = { globals = { "vim" } },
										workspace = { checkThirdParty = false },
										telemetry = { enable = false },
									},
								},
							})
						end)
					end,
				},
			})

			-- Custom LSP keybindings when attached
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc, silent = true })
					end

					map("gd", vim.lsp.buf.definition, "Go to Definition")
					map("gr", function()
						Snacks.picker.lsp_references()
					end, "Go to References")
					map("gI", vim.lsp.buf.implementation, "Go to Implementation")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
					map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
				end,
			})
		end,
	},
}
