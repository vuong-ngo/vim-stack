-- ============================================================
-- LSP, Auto-completion, Treesitter, Formatting & Diagnostics
-- ============================================================

return {
	-- 1. Neovim Lua API Autocompletion for editing configs
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

	-- 3. Auto Close & Rename HTML/JSX Tags
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},

	-- 3. Mason (Automatic LSP & Tools Installer)
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
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
				ensure_installed = {
					"lua_ls",
					"pyright",
					"ts_ls",
					"html",
					"cssls",
					"jsonls",
					"bashls",
				},
				automatic_installation = true,
				handlers = {
					function(server_name)
						lspconfig[server_name].setup({
							capabilities = capabilities,
						})
					end,
					["lua_ls"] = function()
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
					end,
				},
			})

			-- Custom LSP keybindings when attached
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
					end

					map("gd", vim.lsp.buf.definition, "Go to Definition")
					map("gr", function() Snacks.picker.lsp_references() end, "Go to References")
					map("gI", vim.lsp.buf.implementation, "Go to Implementation")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
					map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
				end,
			})
		end,
	},

	-- 5. Blink.cmp (Ultra-fast Autocomplete Engine)
	{
		"saghen/blink.cmp",
		version = "*",
		dependencies = "rafamadriz/friendly-snippets",
		opts = {
			keymap = { preset = "default" },
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 200 },
				menu = { border = "rounded" },
			},
		},
	},

	-- 6. Conform Auto-formatting (VSCode Save Format)
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				sh = { "shfmt" },
				bash = { "shfmt" },
			},
			format_on_save = {
				timeout_ms = 1000,
				lsp_fallback = true,
			},
		},
	},
}
