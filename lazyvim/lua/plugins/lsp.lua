-- ================================================
--   _   ____  ______  _  _______  _  ___________
--  | | / / / / / __ \/ |/ / ___/ / |/ / ___/ __ \
--  | |/ / /_/ / /_/ /    / (_ / /    / (_ / /_/ /
--  |___/\____/\____/_/|_/\___/ /_/|_/\___/\____/
-- ================================================
-- Scoped down to a focused IDE for: Python, Java, Rust, Bash, YAML, XML,
-- JSON, and Markdown (README.md) - plus Lua, kept because this Neovim
-- config itself is written in Lua and lua_ls makes editing it much nicer.
--
-- Everything else that used to be registered here (clangd, ts_ls, eslint,
-- zls, gopls, nil_ls, buf_ls, docker-compose, cobol_ls, svelte,
-- tailwindcss, asm_lsp, a macOS/Swift-only sourcekit block, and a
-- proto/buf_language_server autocmd) has been removed: none of those
-- languages are in scope, and keeping their config around just adds
-- startup work and noise for servers that will never be used.

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mfussenegger/nvim-jdtls", -- powers the Java (jdtls) server
		},
		opts = {
			-- Mason installs these; mason-lspconfig (see plugins/coding.lua)
			-- auto-enables them once installed, so this `servers` table is
			-- mostly documentation of what's in scope for this IDE.
			servers = {
				pyright = {}, -- Python
				jdtls = {}, -- Java
				rust_analyzer = {}, -- Rust
				bashls = {}, -- Bash
				yamlls = {}, -- YAML
				lemminx = {}, -- XML
				jsonls = {}, -- JSON
				marksman = {}, -- Markdown / README.md
				lua_ls = {}, -- Lua (for editing this config)
			},
		},

		config = function()
			-- NOTE ON THIS FIX: this config's actual completion engine is
			-- blink.cmp (see lazy-lock.json - only "blink.cmp" is locked,
			-- there is no "nvim-cmp" or "cmp-nvim-lsp" entry). The line
			-- that used to be here, `require("cmp_nvim_lsp")`, assumed the
			-- nvim-cmp ecosystem instead and crashed with "module
			-- 'cmp_nvim_lsp' not found" because that plugin was never
			-- actually installed. Get LSP capabilities from blink.cmp,
			-- which matches what's really in use.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local ok, blink = pcall(require, "blink.cmp")
			if ok then
				capabilities = blink.get_lsp_capabilities(capabilities)
			end

			-- lua_ls needs a bit of custom `settings` (globals, workspace
			-- library) so it understands the Neovim API; every other server
			-- below just needs `capabilities`, so it's handled in a loop
			-- instead of repeating the same three lines nine times.
			vim.lsp.config["lua_ls"] = {
				cmd = { "lua-language-server" },
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			}

			-- Suppress a known noisy inlay-hint error some servers emit on
			-- files with no hints available - not a real problem, just a
			-- harmless log spam source.
			local default_inlay_hint_handler = vim.lsp.handlers["textDocument/inlayHint"]
			vim.lsp.handlers["textDocument/inlayHint"] = function(err, result, ctx, config)
				if err then
					local msg = err.message or ""
					if string.match(msg, "inlay hints failed") or err.code == -32802 or err.code == -32001 then
						return
					end
				end
				if default_inlay_hint_handler then
					return default_inlay_hint_handler(err, result, ctx, config)
				end
			end

			local simple_servers = {
				"pyright", -- Python
				"jdtls", -- Java
				"rust_analyzer", -- Rust
				"bashls", -- Bash
				"yamlls", -- YAML
				"lemminx", -- XML
				"jsonls", -- JSON
				"marksman", -- Markdown / README.md
			}
			for _, server in ipairs(simple_servers) do
				vim.lsp.config[server] = { capabilities = capabilities }
			end

			vim.lsp.enable(simple_servers)
			vim.lsp.enable("lua_ls")

			-- LSP keymaps (buffer-agnostic; Neovim only actually triggers
			-- these when an LSP client is attached to the current buffer)
			--
			-- NOTE: gd / gD / gr / "goto implementation" are intentionally
			-- NOT bound here anymore. lua/plugins/ui.lua's Snacks picker
			-- already binds gd, gD, gr, and gI to the picker-backed
			-- equivalents (nicer list UI, jumps straight through when
			-- there's a single result) - having both meant two competing
			-- keymaps on the exact same keys, with whichever plugin
			-- finished loading last silently winning. Snacks wins on
			-- purpose now; this file only keeps the keys that are NOT
			-- defined anywhere else.
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
			-- NOTE: a `<leader>fm` mapping used to live here, calling
			-- `require("fzf-lua").lsp_document_symbols(...)` - but fzf-lua was
			-- never actually added as a plugin anywhere in this config, so
			-- pressing it would have errored with "module 'fzf-lua' not
			-- found". Removed as broken/dead code; the equivalent, working
			-- functionality already exists at <leader>ss (Snacks LSP Symbols,
			-- see lua/plugins/ui.lua).
		end,
	},
}
