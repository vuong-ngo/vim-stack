-- ================================================
-- Script: viewers.lua
-- Description: Configures specialized data and document visualizers, including CsvView.nvim for Excel-style CSV/TSV spreadsheet grids with sticky headers and safe size guards, and Render-Markdown.nvim for formatted tables and callouts.
-- ================================================


local MAX_SAFE_CSV_SIZE = 2 * 1024 * 1024 -- 2.0 MB limit to prevent freezing on massive datasets

local function get_buf_size()
	local file = vim.api.nvim_buf_get_name(0)
	if file and file ~= "" then
		local size = vim.fn.getfsize(file)
		if size > 0 then
			return size
		end
	end
	return 0
end

return {
	-- 1. CSV / TSV Interactive Spreadsheet Grid (Excel / Office Style)
	{
		"hat0uma/csvview.nvim",
		cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
		ft = { "csv", "tsv" },
		opts = {
			parser = {
				async_chunksize = 1000,
				comments = { "#", "//" },
			},
			view = {
				-- Visual spreadsheet style like Microsoft Excel / Office
				display_mode = "border", -- Render thin vertical '│' borders between columns
				min_column_width = 8, -- Minimum column width for comfortable viewing
				spacing = { left = 1, right = 1 }, -- Cell padding on left and right borders
				header_lnum = 1, -- Treat line 1 as table header row
				sticky_header = {
					enabled = true, -- Freeze top row when scrolling down
					separator = "─", -- Horizontal divider line beneath header
				},
				sticky_columns = {
					enabled = false,
					count = 1,
					separator = "│",
				},
			},
			keymaps = {
				-- Cell-by-cell navigation matching Excel / Google Sheets
				jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
				jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
				jump_next_row = { "<Enter>", mode = { "n", "v" } },
				jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
			},
		},
		config = function(_, opts)
			require("csvview").setup(opts)

			-- Office / Spreadsheet UI styling:
			-- Highlight header row with bold font and distinct background
			vim.api.nvim_set_hl(0, "CsvViewHeaderLine", { bold = true, bg = "#2a2e3f", fg = "#89b4fa" })
			vim.api.nvim_set_hl(0, "CsvViewStickyHeaderSeparator", { fg = "#89b4fa", bold = true })
			vim.api.nvim_set_hl(0, "CsvViewDelimiter", { fg = "#6c7086" }) -- Subtle grid border lines

			-- User command to format and switch to Office table view
			vim.api.nvim_create_user_command("CsvFormat", function()
				vim.cmd("CsvViewEnable display_mode=border")
				vim.notify("Formatted CSV view as an Office spreadsheet table.", vim.log.levels.INFO, { title = "CSV Office Format" })
			end, { desc = "Format and display CSV as Office spreadsheet" })
		end,
		init = function()
			-- Auto-enable visual table view ONLY for small/medium CSV files (< 2MB).
			-- For massive dataset files, auto-enable is skipped to keep Neovim fast and responsive.
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "csv", "tsv" },
				callback = function()
					local size = get_buf_size()
					if size > MAX_SAFE_CSV_SIZE then
						vim.schedule(function()
							local mb = string.format("%.1f", size / (1024 * 1024))
							vim.notify(
								"Large CSV file (" .. mb .. "MB). Auto table rendering skipped to keep Neovim fast.\nUse <leader>cv to toggle manually or <leader>cp to inspect via fast Pager.",
								vim.log.levels.WARN,
								{ title = "CSV Office View" }
							)
						end)
					else
						-- Safe file size: auto-enable visual spreadsheet grid
						vim.schedule(function()
							pcall(vim.cmd, "CsvViewEnable")
						end)
					end
				end,
			})
		end,
		keys = {
			{
				"<leader>cv",
				function()
					local size = get_buf_size()
					if size > 5 * 1024 * 1024 then
						local mb = string.format("%.1f", size / (1024 * 1024))
						vim.notify(
							"Very large CSV file (" .. mb .. "MB). Parsing table may take a few seconds...",
							vim.log.levels.WARN,
							{ title = "CSV Office View" }
						)
					end
					vim.cmd("CsvViewToggle")
				end,
				desc = "Toggle CSV Office View (Excel Grid)",
			},
			{
				"<leader>cp",
				ft = { "csv", "tsv" },
				function()
					-- Open large CSV in floating terminal using less -S pager (smooth scrolling, zero RAM overhead)
					local file = vim.api.nvim_buf_get_name(0)
					if file and file ~= "" then
						Snacks.terminal({ "less", "-S", file }, { win = { position = "float", width = 0.9, height = 0.9 } })
					end
				end,
				desc = "Open Large CSV in Fast Pager",
			},
		},
	},

	-- 2. Markdown Visual Decorator (Tables with rounded borders, Callouts, Checkboxes)
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = { "markdown" },
		opts = {
			file_types = { "markdown" },
			pipe_table = {
				enabled = true,
				preset = "round",
				style = "full",
				cell = "padded",
				padding = 1,
			},
		},
		keys = {
			{ "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Render" },
		},
	},
}
