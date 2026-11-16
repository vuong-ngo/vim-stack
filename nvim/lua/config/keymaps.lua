-- ================================================
-- Script: keymaps.lua
-- Description: Essential keymaps for Neovim (pure Vim motions preserved; special plugins mapped cleanly under <leader> and Ctrl).
-- ================================================

local set = vim.keymap.set

-- Leader keys (initialized in lazy.lua before loading plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local function map(mode, lhs, rhs, desc)
	set(mode, lhs, rhs, { desc = desc, noremap = true, silent = true })
end

-- Clear Search Highlights (<esc>)
map("n", "<esc>", "<cmd>nohlsearch<CR>", "Clear Search Highlight")

-- Unmap unused save/quit shortcuts to eliminate leader key delay
pcall(vim.keymap.del, "n", "<leader>w")
pcall(vim.keymap.del, "n", "<leader>q")
pcall(vim.keymap.del, "n", "<leader>Q")

-- ------------------------------------------------------------
-- 1. FILE EXPLORER & QUICK SEARCH (SPECIAL UTILITIES)
-- ------------------------------------------------------------
-- Toggle Sidebar Explorer (<leader>e)
map("n", "<leader>e", function()
	Snacks.explorer({ hidden = true, ignored = true })
end, "Toggle Sidebar Explorer")

-- Quick File Search (Ctrl+P or <leader>ff)
map("n", "<C-p>", function()
	Snacks.picker.files({ hidden = true })
end, "Find Files (Ctrl+P)")

map("n", "<leader>ff", function()
	Snacks.picker.files({ hidden = true })
end, "Find Files")

-- Live Grep / Project Text Search (<leader>fg)
local function safe_grep()
	if vim.fn.executable("rg") == 1 then
		Snacks.picker.grep()
	else
		vim.notify(
			"ripgrep ('rg') is not installed. Run 'sudo pacman -S ripgrep' or ./install-deps.sh to enable live grep.",
			vim.log.levels.WARN,
			{ title = "ripgrep Missing" }
		)
	end
end
map("n", "<leader>fg", safe_grep, "Search Text (Grep)")

-- Recent Files (<leader>fr)
map("n", "<leader>fr", function()
	Snacks.picker.recent()
end, "Recent Files")

-- Open Buffers List (<leader>fb)
map("n", "<leader>fb", function()
	Snacks.picker.buffers()
end, "Open Buffers")

-- Global Search & Replace (grug-far) (<leader>sr)
map("n", "<leader>sr", function()
	if vim.fn.executable("rg") == 1 then
		require("grug-far").open()
	else
		vim.notify(
			"ripgrep ('rg') is required for workspace search & replace. Install via 'sudo pacman -S ripgrep'.",
			vim.log.levels.WARN,
			{ title = "ripgrep Missing" }
		)
	end
end, "Search & Replace (Workspace)")

-- ------------------------------------------------------------
-- 2. WINDOW SPLITS & NAVIGATION
-- ------------------------------------------------------------
map("n", "<C-h>", "<C-w>h", "Move Left Window")
map("n", "<C-j>", "<C-w>j", "Move Down Window")
map("n", "<C-k>", "<C-w>k", "Move Up Window")
map("n", "<C-l>", "<C-w>l", "Move Right Window")

map("n", "<leader>|", "<cmd>vsplit<CR>", "Split Vertically")
map("n", "<leader>-", "<cmd>split<CR>", "Split Horizontally")

-- ------------------------------------------------------------
-- 3. INTEGRATED TERMINAL
-- ------------------------------------------------------------
-- Toggle Floating Terminal (Ctrl+/ or <leader>ft)
map({ "n", "t" }, "<C-/>", function()
	Snacks.terminal()
end, "Toggle Integrated Terminal")

-- ------------------------------------------------------------
-- 4. LSP & CODE ACTIONS
-- ------------------------------------------------------------
map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")

local function format_document()
	local ok, conform = pcall(require, "conform")
	if ok then
		conform.format({ async = true, lsp_format = "fallback" })
	else
		vim.lsp.buf.format({ async = true })
	end
end

map({ "n", "v" }, "<leader>cf", format_document, "Format Document")

-- Unmap any remaining conflicting LazyVim multi-key sequences
pcall(vim.keymap.del, "n", "<leader>qq")
pcall(vim.keymap.del, "n", "<leader>qs")
pcall(vim.keymap.del, "n", "<leader>ql")
pcall(vim.keymap.del, "n", "<leader>qd")
pcall(vim.keymap.del, "n", "<leader>qf")
