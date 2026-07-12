-- ================================================
--   _   ____  ______  _  _______  _  ___________ 
--  | | / / / / / __ \/ |/ / ___/ / |/ / ___/ __ \
--  | |/ / /_/ / /_/ /    / (_ / /    / (_ / /_/ /
--  |___/\____/\____/_/|_/\___/ /_/|_/\___/\____/ 
-- ================================================

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

-- On Wayland, point Neovim at wl-clipboard explicitly instead of letting
-- it guess. (This used to live in lua/plugins/system-integration.lua as
-- an "AstroNvim/astrocore" plugin spec with optional = true - but this
-- config doesn't use AstroNvim, so that spec never actually loaded and
-- the clipboard setup silently did nothing. Moved here where it reliably
-- runs, and de-duplicated against the `clipboard` line above.)
if vim.fn.executable("wl-copy") == 1 then
	vim.g.clipboard = {
		name = "wl-clipboard",
		copy = { ["+"] = "wl-copy", ["*"] = "wl-copy" },
		paste = { ["+"] = "wl-paste", ["*"] = "wl-paste" },
		cache_enabled = 1,
	}
end

vim.opt.number = true -- Show line numbers
-- Kept OFF to match vimrc, which only uses absolute line numbers.
-- Set to `true` again if you'd rather have Neovim's hybrid relative numbers.
vim.opt.relativenumber = false
vim.opt.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
vim.opt.tabstop = 4 -- Use spaces instead of tabs
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.autoindent = true
vim.opt.smartindent = true -- matches vimrc; Treesitter indent still takes over for filetypes it supports

vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Enable smart case search
vim.opt.incsearch = true -- Jump to matches as you type (Neovim default is already on, set explicitly to match vimrc)
vim.opt.hlsearch = true -- Highlight all search matches (Neovim defaults this OFF, vimrc has it ON)
vim.opt.wrap = true -- Enable line wrapping
vim.opt.scrolloff = 8 -- Keep 8 lines of context above/below cursor when scrolling
vim.opt.cursorline = true -- Highlight the current line
vim.opt.termguicolors = true -- Enable true color support
vim.opt.signcolumn = "yes" -- Always show the sign column

-- Auto-reload files changed outside Neovim (paired with the FocusGained/
-- BufEnter "checktime" autocmd in config/autocmds.lua).
vim.opt.autoread = true

-- ---------- INDENT / WHITESPACE GUIDES (matches vimrc's listchars) ----------
vim.opt.list = true
vim.opt.listchars = {
	tab = "▸ ",
	trail = "·",
	extends = "❯",
	precedes = "❮",
	nbsp = "␣",
}
