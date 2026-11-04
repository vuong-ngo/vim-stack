-- ================================================
-- Script: keymaps.lua
-- Description: This file contains custom key mappings for Neovim, including tab and buffer management, file explorer and quick search, window splits and navigation, integrated terminal, code actions, and formatting.
-- ================================================

local set = vim.keymap.set

-- Set Leader Keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function map(mode, lhs, rhs, desc)
	set(mode, lhs, rhs, { desc = desc, noremap = true, silent = true })
end

-- ------------------------------------------------------------
-- 1. TAB & BUFFER MANAGEMENT
-- ------------------------------------------------------------
-- Buffer Tab Navigation (H / L & Alt+1..9)
map("n", "H", "<cmd>bprevious<CR>", "Previous Tab")
map("n", "L", "<cmd>bnext<CR>", "Next Tab")

-- Alt + Number to jump directly to tabs 1-9
for i = 1, 9 do
	map("n", "<A-" .. i .. ">", function()
		require("bufferline").go_to(i, true)
	end, "Go to Tab " .. i)
end

-- Clear Search Highlights (<esc>)
map("n", "<esc>", "<cmd>nohlsearch<CR>", "Clear Search Highlight")

-- Unmap unused save/quit shortcuts
pcall(vim.keymap.del, "n", "<leader>w")
pcall(vim.keymap.del, "n", "<leader>q")
pcall(vim.keymap.del, "n", "<leader>Q")

-- ------------------------------------------------------------
-- 2. FILE EXPLORER & QUICK SEARCH
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

-- Live Grep / Project Text Search (Ctrl+F or <leader>fg)
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

map("n", "<C-f>", safe_grep, "Search Text in Project")
map("n", "<leader>fg", safe_grep, "Search Text (Grep)")

-- Recent Files (<leader>fr)
map("n", "<leader>fr", function()
	Snacks.picker.recent()
end, "Recent Files")

-- Buffers List (<leader>fb)
map("n", "<leader>fb", function()
	Snacks.picker.buffers()
end, "Open Buffers")

-- Global Search & Replace (grug-far) (<leader>sr)
map("n", "<leader>sr", function()
	if vim.fn.executable("rg") == 1 then
		local grug = require("grug-far")
		grug.open()
	else
		vim.notify(
			"ripgrep ('rg') is required for workspace search & replace. Install via 'sudo pacman -S ripgrep'.",
			vim.log.levels.WARN,
			{ title = "ripgrep Missing" }
		)
	end
end, "Search & Replace (Workspace)")

-- ------------------------------------------------------------
-- 3. WINDOW SPLITS & NAVIGATION
-- ------------------------------------------------------------
map("n", "<C-h>", "<C-w>h", "Move Left Window")
map("n", "<C-j>", "<C-w>j", "Move Down Window")
map("n", "<C-k>", "<C-w>k", "Move Up Window")
map("n", "<C-l>", "<C-w>l", "Move Right Window")

-- Window Resize controls (Ctrl+Arrows)
map("n", "<C-Up>", "<cmd>resize +2<CR>", "Increase Height")
map("n", "<C-Down>", "<cmd>resize -2<CR>", "Decrease Height")
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", "Decrease Width")
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", "Increase Width")

map("n", "<leader>|", "<cmd>vsplit<CR>", "Split Vertically")
map("n", "<leader>-", "<cmd>split<CR>", "Split Horizontally")

-- Move Selected Lines Up/Down in Visual Mode (Alt+j / Alt+k)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", "Move Selection Down")
map("v", "<A-k>", ":m '<-2<CR>gv=gv", "Move Selection Up")

-- Continuous Visual Indentation (< and > keep selection active)
map("v", "<", "<gv", "Indent Left (Continuous)")
map("v", ">", ">gv", "Indent Right (Continuous)")

-- ------------------------------------------------------------
-- 4. INTEGRATED TERMINAL
-- ------------------------------------------------------------
-- Toggle Floating Terminal (Ctrl+/ or <leader>ft)
map({ "n", "t" }, "<C-/>", function()
	Snacks.terminal()
end, "Toggle Integrated Terminal")

-- ------------------------------------------------------------
-- 5. LSP & CODE ACTIONS
-- ------------------------------------------------------------

map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
map("n", "<leader>cf", function()
	local ok, conform = pcall(require, "conform")
	if ok then
		conform.format({ async = true, lsp_format = "fallback" })
	else
		vim.lsp.buf.format({ async = true })
	end
end, "Format Document")

-- Unmap any remaining conflicting LazyVim multi-key sequences
pcall(vim.keymap.del, "n", "<leader>qq")
pcall(vim.keymap.del, "n", "<leader>qs")
pcall(vim.keymap.del, "n", "<leader>ql")
pcall(vim.keymap.del, "n", "<leader>qd")
pcall(vim.keymap.del, "n", "<leader>qf")
