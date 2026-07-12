-- ================================================
--   _   ____  ______  _  _______  _  ___________
--  | | / / / / / __ \/ |/ / ___/ / |/ / ___/ __ \
--  | |/ / /_/ / /_/ /    / (_ / /    / (_ / /_/ /
--  |___/\____/\____/_/|_/\___/ /_/|_/\___/\____/
-- ================================================

-- Leader key
vim.g.mapleader = " "

-- Move between windows using Ctrl + h/j/k/l
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Move selected lines up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- =========================================================
-- 1. SPACE + e  => FILE EXPLORER
-- =========================================================
-- Already bound to the Snacks explorer in lua/plugins/ui.lua (Snacks'
-- own `keys` table sets <leader>e). Nothing to add here - this note is
-- just so the numbering below stays aligned with vimrc's section 1.
-- The old netrw-based `<leader>pv` mapping was removed: Snacks explorer
-- fully replaces it and having two different "open explorer" keys was
-- confusing.

-- =========================================================
-- 2. SPACE + t  => OPEN A NEW TAB
-- =========================================================
vim.keymap.set("n", "<leader>t", "<cmd>tabnew<CR>", { desc = "New tab" })

-- =========================================================
-- 3. SPACE + q  => QUIT the current window/file
-- =========================================================
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit window" })
-- NOTE: LazyVim's own defaults also bind <leader>qq ("Quit All"). Since
-- that's a different two-key sequence than our single <leader>q, both
-- can coexist, but Neovim will briefly wait (per 'timeoutlen') to see if
-- a second 'q' is coming before firing <leader>q alone. This is a minor,
-- cosmetic delay and not a functional conflict.

-- =========================================================
-- 4. SPACE + |  AND  SPACE + -  => CREATE SPLITS
-- =========================================================
-- Space + |  -> vertical split (side by side)
-- Space + -  -> horizontal split (stacked)
-- (Unlike Vimscript, Lua keymap strings don't need the "|" escaped.)
vim.keymap.set("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>-", "<cmd>split<CR>", { desc = "Horizontal split" })

-- Close current window (kept from the original config; doesn't collide
-- with anything above)
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current window" })

-- =========================================================
-- 5. CTRL + i  /  CTRL + o  => SWITCH BETWEEN OPEN FILES (BUFFERS)
-- =========================================================
-- Same caveat as vimrc: this overrides Neovim's default jumplist
-- navigation (normally on Ctrl-I / Ctrl-O), and some terminals send the
-- same code for <Tab> and <C-i>.
vim.keymap.set("n", "<C-i>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<C-o>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- =========================================================
-- 6. SPACE + p  => FUZZY FILE FINDER
-- =========================================================
-- vimrc uses the built-in :find command since it has no plugins. Neovim
-- already ships a much better fuzzy finder via Snacks (already used
-- everywhere else in this config), so <leader>p is wired to that instead
-- of reinventing :find here - same key, strictly better result.
vim.keymap.set("n", "<leader>p", function()
	Snacks.picker.files()
end, { desc = "Find files (fuzzy)" })

-- =========================================================
-- 7. COMMENT / UNCOMMENT CODE
-- =========================================================
-- No custom keymap needed: Neovim 0.10+ already ships `gc`/`gcc` out of
-- the box, reading 'commentstring' (set per-language by Treesitter), so
-- it's correct for every target language in this IDE with zero config.
-- A Ctrl+/ alias used to duplicate this - removed as dead weight, and
-- freed up so Ctrl+` alone owns the terminal (see below).

-- =========================================================
-- 8. SHIFT + H  /  SHIFT + L  => SWITCH BETWEEN TABS
-- =========================================================
-- Same override note as vimrc: this replaces the default H/L cursor
-- motions (top/bottom of visible screen). Use gg/G or zt/zb instead if
-- you still need those occasionally.
vim.keymap.set("n", "H", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "L", "<cmd>tabnext<CR>", { desc = "Next tab" })

-- =========================================================
-- 9. QUICK CONFIG EDITING
-- =========================================================
local config_dir = vim.fn.stdpath("config")

-- Space + r + c -> edit init.lua (the entry point) in a vertical split
vim.keymap.set("n", "<leader>rc", function()
	vim.cmd("vsplit " .. config_dir .. "/init.lua")
end, { desc = "Edit init.lua" })

-- Space + r + o -> open the whole config folder in a new tab via the
-- fuzzy finder, scoped to the config directory
vim.keymap.set("n", "<leader>ro", function()
	vim.cmd("tabnew")
	Snacks.picker.files({ cwd = config_dir })
end, { desc = "Open config folder in new tab" })

-- Space + r + s -> reload options/keymaps/autocmds without restarting
-- Neovim. NOTE: unlike vimrc's `:source $MYVIMRC`, this can't safely
-- re-run lazy.nvim's plugin bootstrapping, so changes to plugin specs
-- still need a restart (or `:Lazy reload <plugin>`). Changes to options,
-- keymaps, and autocmds apply immediately.
local function reload_config()
	for name, _ in pairs(package.loaded) do
		if name:match("^config") then
			package.loaded[name] = nil
		end
	end
	require("config.options")
	require("config.keymaps")
	require("config.autocmds")
	vim.notify("Config reloaded (options/keymaps/autocmds)", vim.log.levels.INFO)
end
vim.keymap.set("n", "<leader>rs", reload_config, { desc = "Reload config" })

-- =========================================================
-- AUTO-CLOSE BRACKETS/QUOTES, MATCHIT, CLIPBOARD, STATUSLINE,
-- INDENT GUIDES: already covered by existing plugins/options and need
-- no keymap changes here - see README.md for the full equivalence table.
-- =========================================================

-- =========================================================
-- INTEGRATED TERMINAL  (Ctrl + `)
-- =========================================================
-- A single, unified terminal shortcut (VS Code-style Ctrl+`), replacing
-- three overlapping ways to open a terminal that existed before
-- (Space+s+h, Space+s+v, and toggleterm.nvim's own Ctrl+t float).
-- toggleterm.nvim has been removed from lua/plugins/ui.lua entirely so
-- there is exactly one terminal implementation (Snacks.terminal) and
-- exactly one key to reach it.
--
-- LazyVim itself ALSO ships a default terminal shortcut on <C-/> (and its
-- terminal-translation <C-_>), bound in normal+terminal mode to the same
-- Snacks.terminal. That default is what was still duplicating Ctrl+`
-- (removing our own <C-/> comment-toggle mapping earlier wasn't enough,
-- since this one comes from LazyVim's defaults, loaded before this file).
-- Delete it here so Ctrl+` is the only terminal shortcut left.
pcall(vim.keymap.del, "n", "<C-/>")
pcall(vim.keymap.del, "t", "<C-/>")
pcall(vim.keymap.del, "n", "<C-_>")
pcall(vim.keymap.del, "t", "<C-_>")

vim.keymap.set({ "n", "t" }, "<C-`>", function()
	Snacks.terminal(nil, { win = { position = "bottom", height = 0.3 } })
end, { desc = "Toggle terminal" })

-- Leave terminal-insert mode with Esc twice, for any terminal buffer
-- (Snacks' own terminal windows already close on <Esc>, this just keeps
-- the same muscle memory for plain :terminal buffers too).
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- =========================================================
-- MISC (kept from the original config, no sync conflicts)
-- =========================================================
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
vim.keymap.set("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
