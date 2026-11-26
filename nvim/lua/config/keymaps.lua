-- ================================================
-- Script: keymaps.lua
-- Description: Essential keymaps for Neovim (pure Vim motions preserved; special plugins mapped cleanly under <leader> and Ctrl).
-- ================================================

local set = vim.keymap.set

local function map(mode, lhs, rhs, desc)
	set(mode, lhs, rhs, { desc = desc, noremap = true, silent = true })
end

-- Clear Search Highlights (<esc>)
map("n", "<esc>", "<cmd>nohlsearch<CR>", "Clear Search Highlight")

-- Buffer Switching (H / L)
map("n", "H", function()
	if not pcall(vim.cmd, "BufferLineCyclePrev") then
		vim.cmd("bprevious")
	end
end, "Previous Buffer")
map("n", "L", function()
	if not pcall(vim.cmd, "BufferLineCycleNext") then
		vim.cmd("bnext")
	end
end, "Next Buffer")

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
-- Toggle Floating Terminal (Ctrl+/, <C-_> fallback, or <leader>ft)
map({ "n", "t" }, "<C-/>", function()
	Snacks.terminal()
end, "Toggle Integrated Terminal")
map({ "n", "t" }, "<C-_>", function()
	Snacks.terminal()
end, "which_key_ignore")
map("n", "<leader>ft", function()
	Snacks.terminal()
end, "Toggle Integrated Terminal")

-- ------------------------------------------------------------
-- 4. LSP, DIAGNOSTICS & FORMATTING
-- ------------------------------------------------------------
map("n", "gd", function()
	vim.lsp.buf.definition()
end, "Goto Definition")
map("n", "gr", function()
	Snacks.picker.lsp_references()
end, "Find References")
map("n", "gI", function()
	vim.lsp.buf.implementation()
end, "Goto Implementation")
map("n", "K", function()
	vim.lsp.buf.hover()
end, "Hover Documentation")
map("n", "<leader>ca", function()
	vim.lsp.buf.code_action()
end, "Code Action")
map("n", "<leader>rn", function()
	vim.lsp.buf.rename()
end, "Rename Symbol")

local function format_document()
	local ok, conform = pcall(require, "conform")
	if ok then
		conform.format({ async = true, lsp_format = "fallback" })
	else
		vim.lsp.buf.format({ async = true })
	end
end

map({ "n", "v" }, "<leader>cf", format_document, "Format Document")
map("n", "<leader>uf", function()
	vim.g.autoformat = not vim.g.autoformat
	vim.notify(
		"Format on save: " .. (vim.g.autoformat and "ON" or "OFF"),
		vim.log.levels.INFO,
		{ title = "Formatting" }
	)
end, "Toggle Format on Save")
