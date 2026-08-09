-- ================================================
-- Neovim Global Options & Settings
-- ================================================

-- Sync clipboard between OS and Neovim
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

-- Wayland clipboard support
if vim.fn.executable("wl-copy") == 1 then
	vim.g.clipboard = {
		name = "wl-clipboard",
		copy = { ["+"] = "wl-copy", ["*"] = "wl-copy" },
		paste = { ["+"] = "wl-paste", ["*"] = "wl-paste" },
		cache_enabled = 1,
	}
end

-- Line numbers & UI (Absolute 1-to-1 Line Numbers like VS Code)
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.wrap = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Force relativenumber = false on buffer open (overriding LazyVim default)
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	group = vim.api.nvim_create_augroup("DisableRelativeNumbers", { clear = true }),
	callback = function()
		vim.opt.relativenumber = false
	end,
})

-- Indentation & Tabs (2 spaces standard, smart handling)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Split windows direction (VSCode style)
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Performance & History
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.undofile = true -- Persistent undo history across restarts
vim.opt.autoread = true
vim.opt.confirm = true -- Confirm dialog before closing modified files

-- Enable Neovim global statusline
vim.opt.laststatus = 3

-- Whitespace display
vim.opt.list = true
vim.opt.listchars = {
	tab = "▸ ",
	trail = "·",
	extends = "❯",
	precedes = "❮",
	nbsp = "␣",
}
