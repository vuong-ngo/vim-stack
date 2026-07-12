-- ================================================
--   _   ____  ______  _  _______  _  ___________
--  | | / / / / / __ \/ |/ / ___/ / |/ / ___/ __ \
--  | |/ / /_/ / /_/ /    / (_ / /    / (_ / /_/ /
--  |___/\____/\____/_/|_/\___/ /_/|_/\___/\____/
-- ================================================
-- blink.cmp (this config's completion engine, see lua/plugins/lsp.lua's
-- notes) is otherwise pure LazyVim default - no spec for it existed
-- anywhere in this repo before. Adding one here only to patch one thing:
--
-- The default keymap preset already binds <C-Space> to "show completion
-- menu", which is correct and needs no config. But under tmux, <C-Space>
-- is unreliable:
--   - If tmux's prefix key is set to <C-Space>, tmux consumes every
--     press as the prefix and Neovim never sees it at all.
--   - Even with a different prefix, tmux versions before 3.2 don't
--     reliably distinguish Ctrl+Space from plain Space over the pty
--     unless `extended-keys` is turned on (a tmux.conf change, outside
--     this repo).
--
-- Rather than depend on the user's tmux config/version, add a second,
-- tmux-safe trigger: <C-l> is unmapped by Vim/Neovim in insert mode by
-- default, and the <C-l> bound in config/keymaps.lua is normal-mode-only
-- (window navigation), so there's no collision.
return {
	{
		"saghen/blink.cmp",
		opts = function(_, opts)
			opts.keymap = opts.keymap or {}
			opts.keymap["<C-l>"] = { "show", "show_documentation", "hide_documentation" }
		end,
	},
}
