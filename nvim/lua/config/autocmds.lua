-- ================================================
-- Script: autocmds.lua
-- Description: This file contains autocommands for Neovim, including auto-reloading files changed outside Neovim, restoring the last cursor position, and globally disabling spell checking.
-- ================================================

-- Kept in sync with the "auto-reload changed files + restore cursor
-- position" feature in vimrc.

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ---------- AUTO-RELOAD FILES CHANGED OUTSIDE NEOVIM ----------
-- vim.opt.autoread = true (set in config/options.lua) only reloads on
-- certain events by default; force a check whenever focus returns to
-- Neovim or you move to a different buffer, so external changes (git
-- checkout, another editor, a build script) are picked up immediately.
local reload_group = augroup("AutoReloadOnFocus", { clear = true })
autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = reload_group,
  pattern = "*",
  command = "checktime",
})

-- ---------- RESTORE LAST CURSOR POSITION ----------
-- Reopening a file jumps back to the line/column you were last editing,
-- instead of always starting at line 1.
local restore_cursor_group = augroup("RestoreCursorPosition", { clear = true })
autocmd("BufReadPost", {
  group = restore_cursor_group,
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ---------- GLOBALLY DISABLE SPELL CHECKING ----------
-- Overwrite LazyVim's default wrap_spell autocommand which turns spell on
-- for markdown, text, gitcommit, etc. (removing annoying red squiggles)
local no_spell_group = augroup("lazyvim_wrap_spell", { clear = true })
autocmd("FileType", {
  group = no_spell_group,
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = false
  end,
})

-- Force spell off globally across all buffers
autocmd({ "BufEnter", "BufReadPost" }, {
  group = augroup("DisableSpellGlobally", { clear = true }),
  pattern = "*",
  callback = function()
    vim.opt_local.spell = false
  end,
})

