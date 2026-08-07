-- ============================================================
-- Neovim Keymaps (Ultimate IDE Keybindings & Fast Ergonomics)
-- ============================================================

local set = vim.keymap.set

-- Set Leader Keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function map(mode, lhs, rhs, desc)
	set(mode, lhs, rhs, { desc = desc, noremap = true, silent = true })
end

-- ------------------------------------------------------------
-- 1. TAB & BUFFER MANAGEMENT (<leader>q closes 1 tab only!)
-- ------------------------------------------------------------
-- <leader>q closes current buffer/tab ONLY (without closing window/Neovim)
map("n", "<leader>q", function()
	Snacks.bufdelete()
end, "Close Current Tab/Buffer")

-- <leader>Q quits Neovim completely
map("n", "<leader>Q", "<cmd>confirm qa<CR>", "Quit Neovim All")

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

-- Unmap save keybindings
pcall(vim.keymap.del, "n", "<leader>w")
pcall(vim.keymap.del, { "n", "i", "v" }, "<C-s>")

-- ------------------------------------------------------------
-- 2. FILE EXPLORER & QUICK SEARCH
-- ------------------------------------------------------------
-- Toggle Sidebar Explorer (<leader>e)
map("n", "<leader>e", function()
	Snacks.explorer()
end, "Toggle Sidebar Explorer")

-- Quick File Search (Ctrl+P or <leader>ff)
map("n", "<C-p>", function()
	Snacks.picker.files()
end, "Find Files (Ctrl+P)")

map("n", "<leader>ff", function()
	Snacks.picker.files()
end, "Find Files")

-- Live Grep / Project Text Search (Ctrl+Shift+F or <leader>fg)
map("n", "<C-f>", function()
	Snacks.picker.grep()
end, "Search Text in Project")

map("n", "<leader>fg", function()
	Snacks.picker.grep()
end, "Search Text (Grep)")

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
	local grug = require("grug-far")
	grug.open()
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

-- ------------------------------------------------------------
-- 4. INTEGRATED TERMINAL & GIT UI
-- ------------------------------------------------------------
-- Toggle Floating Terminal (Ctrl+/ or <leader>ft)
map({ "n", "t" }, "<C-/>", function()
	Snacks.terminal()
end, "Toggle Integrated Terminal")

map({ "n", "t" }, "<leader>ft", function()
	Snacks.terminal()
end, "Toggle Integrated Terminal")

-- LazyGit Floating Window (<leader>gg)
map("n", "<leader>gg", function()
	Snacks.lazygit()
end, "Open LazyGit")

-- ------------------------------------------------------------
-- 5. LSP & CODE ACTIONS
-- ------------------------------------------------------------
map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
map("n", "<leader>cf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, "Format Document")

-- Unmap any remaining conflicting LazyVim multi-key sequences
pcall(vim.keymap.del, "n", "<leader>qq")
pcall(vim.keymap.del, "n", "<leader>qs")
pcall(vim.keymap.del, "n", "<leader>ql")
pcall(vim.keymap.del, "n", "<leader>qd")
pcall(vim.keymap.del, "n", "<leader>qf")
