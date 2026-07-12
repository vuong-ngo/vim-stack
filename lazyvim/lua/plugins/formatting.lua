-- ================================================
--   _   ____  ______  _  _______  _  ___________
--  | | / / / / / __ \/ |/ / ___/ / |/ / ___/ __ \
--  | |/ / /_/ / /_/ /    / (_ / /    / (_ / /_/ /
--  |___/\____/\____/_/|_/\___/ /_/|_/\___/\____/
-- ================================================

return {
	-- Setup format on save
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				python = { "isort", "black" },
				sh = { "shfmt" },
				lua = { "stylua" },
				json = { "prettier" },
				yaml = { "prettier" },
				javascript = { "prettier", stop_after_first = true },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},
}
