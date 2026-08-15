# LazyVim Config — Synced with the Minimal Vim Config

This LazyVim setup has been aligned with the built-in-only `vimrc` so the
same physical keys do the same thing in both editors. Where Neovim already
has a plugin that does the job better than vimrc's hand-rolled version
(fuzzy finding, commenting, statusline, auto-pairing...), the **key stays
the same** but points at the better implementation instead of duplicating
vimrc's simpler logic.

This document is kept in sync with the config as it evolves — the sections
below describe what the files in this repo actually do *right now*, not a
snapshot from when the sync work started.

## Bugs and duplication fixed so far

1. **`init.lua` double-loaded plugins.** It manually `require()`'d every
   file in `lua/plugins/`, but `lua/config/lazy.lua` already auto-imports
   that whole folder via `{ import = "plugins" }`. The manual requires were
   dead weight and have been removed.

2. **`<leader>sh` was bound twice** — once in `config/keymaps.lua` (split
   window horizontally) and once in `plugins/ui.lua` (Snacks Help Pages).
   Because `ui.lua` loaded last, the split-window version never actually
   fired. `<leader>sh` is now reserved for the terminal area only; splits
   moved to `Space |` / `Space -`.

3. **Telescope removed entirely.** It duplicated Snacks on `<leader>ff` /
   `<leader>fb` / `<leader>fg` (Snacks, loaded later, silently won every
   time — the Telescope bindings were dead code), and it pulled in its own
   fuzzy-matching/`fd`/`ripgrep` machinery on top of what Snacks already
   uses, for zero functional gain. `telescope.nvim` and
   `telescope-ui-select.nvim` (`lua/plugins/editor.lua`) were deleted.
   The one thing Telescope did that wasn't shadowed — help pages
   (`<leader>fh`) — was re-bound to `Snacks.picker.help()` in
   `lua/plugins/ui.lua` so nothing was lost. The leftover
   `catppuccin` → `telescope` theme-integration option (now pointing at a
   plugin that no longer exists) was also removed from `plugins/ui.lua`.

4. **`Ctrl+/` still opened a terminal after "removing" it.** The
   config's own `<C-/>` comment-toggle alias had already been deleted, but
   LazyVim ships its *own* default `<C-/>` / `<C-_>` keymap (normal **and**
   terminal mode) that opens the same `Snacks.terminal` — and since that
   default loads before this config's `config/keymaps.lua`, it kept
   working even though nothing here defined it. Fixed in
   `config/keymaps.lua` by explicitly deleting LazyVim's default
   (`vim.keymap.del` for `n`/`t`, `<C-/>`/`<C-_>`) right before (re)binding
   `Ctrl+\`` as the one and only terminal shortcut.

5. **`gd` / `gD` / `gr` bound twice, racing each other.** `plugins/lsp.lua`
   bound them to plain `vim.lsp.buf.*` calls; `plugins/ui.lua` bound the
   *same keys* to the Snacks-picker equivalents. Whichever plugin finished
   loading last silently won, so the actual behavior depended on load
   order rather than on anything declared. Resolved by keeping only the
   Snacks-picker versions (nicer list UI, jumps straight through on a
   single result) and removing the duplicate native binds — along with the
   never-standard lowercase `gi` — from `lsp.lua`. `K` (hover),
   `<leader>rn` (rename), and `<leader>ca` (code action) stay in `lsp.lua`
   since nothing else defines them.

6. **`lua/plugins/system-integration.lua` was dead code.** It wrapped the
   OS-clipboard/Wayland setup in an `"AstroNvim/astrocore"` plugin spec
   with `optional = true` — but this config doesn't use AstroNvim, so that
   spec's `opts` function never ran, and the Wayland `wl-copy`/`wl-paste`
   clipboard detection silently did nothing. It also duplicated the
   `clipboard = "unnamedplus"` line that was already set for real in
   `config/options.lua`. The file was deleted; the Wayland clipboard
   detection was folded into `config/options.lua`, where it actually
   executes.

7. **`nvim-treesitter` and `mason.nvim`/`mason-lspconfig.nvim` were each
   declared across 3–4 separate, scattered specs** in `plugins/coding.lua`
   (leftover from copy-pasted snippets). One `mason.nvim` version pin
   (`"1.11.0"`) was silently overwritten by an un-pinned spec for the same
   plugin listed right after it, so the pin never actually applied.
   Consolidated into one spec per plugin so the file says what it means.

8. **LSP capabilities crashed with `module 'cmp_nvim_lsp' not found'`.**
   `plugins/lsp.lua` called `require("cmp_nvim_lsp").default_capabilities(...)`,
   which assumes the `nvim-cmp` completion stack. This config's actual
   completion engine is **`blink.cmp`** (confirmed via `lazy-lock.json`,
   which locks `blink.cmp` and has no `nvim-cmp`/`cmp-nvim-lsp` entry at
   all), so that plugin was never installed and the `require` failed,
   taking `nvim-lspconfig` down with it. Fixed by getting capabilities
   from `blink.cmp` instead (`blink.get_lsp_capabilities(...)`, guarded
   with `pcall` so a slow/missing blink load degrades gracefully instead
   of crashing).

9. **`Ctrl+Space` (show completion menu) unreliable under tmux.** It's
   blink.cmp's correct default trigger and needs no config normally, but
   under tmux it can be swallowed entirely — either because tmux's
   `prefix` key is itself set to `<C-Space>`, or (on tmux < 3.2) because
   `Ctrl+Space` and plain `Space` aren't reliably distinguished over the
   pty unless `extended-keys` is turned on in `tmux.conf`. Rather than
   depend on the user's tmux setup, `lua/plugins/completion.lua` adds a
   second, tmux-safe trigger on `<C-l>` (unmapped by Neovim in insert mode
   by default; the `<C-l>` in `config/keymaps.lua` is normal-mode-only, so
   there's no collision).

### Known inconsistency, not yet fixed

`plugins/coding.lua` still has an `opts` block for `hrsh7th/nvim-cmp`.
Since the completion engine actually in use is `blink.cmp` (see fix #8
above), that block currently configures a plugin that isn't the one doing
the work — it's likely inert. Left alone for now since removing/replacing
it means writing an equivalent `blink.cmp` config block, which is a real
change rather than a dedup, but flagging it here so it doesn't get
mistaken for working config.

## Keymap Sync Table

| Key | vimrc | Neovim (this config) | Notes |
|---|---|---|---|
| `Space e` | Toggle netrw file tree | Toggle Snacks explorer | Already matched before syncing; removed the old redundant `<leader>pv` (netrw) mapping |
| `Space t` | `:tabnew` | `:tabnew` | Added, direct match |
| `Space q` | `:q` | `:q` | Added, direct match. LazyVim's own `<leader>qq` ("quit all") still exists as a separate sequence |
| `Space \|` | Vertical split | Vertical split | Added, direct match. Moved off `<leader>sv` to make room for terminal |
| `Space -` | Horizontal split | Horizontal split | Added, direct match. Moved off `<leader>sh` to make room for terminal |
| `Ctrl i` / `Ctrl o` | Next/previous buffer | Next/previous buffer | Added, direct match, same jumplist-override caveat |
| `Space p` | Built-in `:find` fuzzy finder | `Snacks.picker.files()` | Same key, upgraded implementation (real fuzzy matching, previews) |
| `gc` / `gcc` | Hand-written filetype-aware comment toggle | Neovim's built-in `gc`/`gcc` (Treesitter-aware `commentstring`) | Same intent, upgraded implementation — correct for far more languages than vimrc's lookup table. No dedicated key alias (see next row) |
| `Ctrl /` / `Ctrl _` | Used to alias the comment toggle above | **Nothing** — both are explicitly deleted | These duplicated `Ctrl+\`` (LazyVim binds its own terminal toggle here by default). Deleted in `config/keymaps.lua` so `Ctrl+\`` is the only terminal key. Use `gc`/`gcc` for commenting |
| `Ctrl \`` | *(not in vimrc)* | `Snacks.terminal()`, bottom split | The **one** terminal shortcut in this config — see bug #4 above |
| `Shift H` / `Shift L` | Previous/next tab | Previous/next tab | Added, direct match, same H/L-motion-override caveat |
| `Space r c` | Open `$MYVIMRC` in a vsplit | Open `init.lua` in a vsplit | Same intent, adapted to Neovim's multi-file config layout |
| `Space r o` | Open `$MYVIMRC` in a new tab | Open config folder (fuzzy-searchable) in a new tab | Same intent |
| `Space r s` | `:source $MYVIMRC` | Reloads `options`/`keymaps`/`autocmds` in place | Plugin **spec** changes still need a restart or `:Lazy reload <plugin>` — Neovim can't safely re-run lazy.nvim's bootstrap on the fly the way `:source` can for a single vimscript file |
| `(`/`[`/`{`/`"`/`'` auto-close | Hand-written insert-mode mappings | `mini.pairs` plugin | Already matched before syncing, no change needed |
| `%` extended matching | Built-in `matchit` via `packadd!` | Built-in `matchit` (never disabled in `lazy.lua`) | Already matched before syncing, no change needed |
| System clipboard sync | `clipboard=unnamedplus` | `clipboard=unnamedplus` (+ Wayland `wl-copy`/`wl-paste` detection) | Already matched before syncing. Wayland detection moved from dead code into `config/options.lua` — see bug #6 |
| Auto-reload changed files | `autoread` + `checktime` autocmd | Same, added in `config/options.lua` + `config/autocmds.lua` | Added to match |
| Restore cursor position | `BufReadPost` autocmd | Same, added in `config/autocmds.lua` | Added to match |
| Custom statusline | Hand-written mode/git-branch/filetype statusline | LazyVim's built-in `lualine` | Already present before syncing (richer than vimrc's version), no change needed |
| `gd` / `gD` / `gr` / `gI` | *(not in vimrc)* | `Snacks.picker.lsp_definitions/declarations/references/implementations()` | LSP navigation, picker-backed. Previously also bound in `plugins/lsp.lua` with plain `vim.lsp.buf.*` — that duplicate was removed (see bug #5) |
| Indent/whitespace guides (`listchars`) | `tab`, `trail`, `extends`, `precedes`, `nbsp` glyphs | Same `listchars` values, added in `config/options.lua` | Added to match. Kept alongside Snacks' `indent` module (vertical indent guides) — the two are complementary, not duplicates |

## Deliberate differences (not synced on purpose)

- **Colorscheme.** vimrc inherits whatever theme your terminal is using
  (transparent background, no fixed palette). This Neovim config keeps its
  fixed Catppuccin theme with `transparent_background = true` — a
  deliberate upgrade, not something worth giving up.
- **Persistent undo.** Your vimrc explicitly does *not* include this
  (you didn't approve it earlier). LazyVim enables `undofile` by default
  as part of its own opinionated defaults; this wasn't turned off, since
  it's a core LazyVim convention and disabling it fights the framework
  for very little benefit. If you want strict parity, add
  `vim.opt.undofile = false` to `config/options.lua`.
- **Code folding / trailing-whitespace auto-trim.** Not in your approved
  vimrc feature set, so nothing was added for these in Neovim either.
- **`relativenumber`.** The original Neovim config had this `true`; it's
  now `false` to match vimrc's absolute-only line numbers. Flip it back
  if you'd rather keep hybrid relative numbers.

## Plugin scope (what's actually installed, and why)

Kept intentionally small — one plugin per job, no overlapping tools doing
the same thing:

- **Picker / fuzzy-find / grep / explorer:** `folke/snacks.nvim` only.
  (Telescope was removed — see bug #3.)
- **Completion:** `blink.cmp` (confirmed via `lazy-lock.json` — see bug #8).
  `plugins/completion.lua` adds one extra keybind on top of its defaults —
  see bug #9.
- **LSP:** `neovim/nvim-lspconfig` + `mason-org/mason.nvim` +
  `mason-org/mason-lspconfig.nvim`, scoped to Python, Java, Rust, Bash,
  YAML, XML, JSON, Markdown, and Lua (for editing this config itself). See
  the header comment in `plugins/lsp.lua` for the full list of language
  servers that were previously configured and deliberately dropped as
  out of scope.
- **Formatting:** `stevearc/conform.nvim`, format-on-save.
- **Terminal:** `Snacks.terminal()` only, on `Ctrl+\`` (see bug #4).
  `toggleterm.nvim` was removed so there's exactly one terminal
  implementation.
- **Syntax/indent:** `nvim-treesitter`.
- **Auto-pairs:** `nvim-mini/mini.pairs`.
- **Icons:** `nvim-mini/mini.icons` (mocks `nvim-web-devicons` for plugins
  that expect it, so nothing needs both).
- **Database UI:** `kristijanhusak/vim-dadbod-ui` (+ `vim-dadbod`,
  `vim-dadbod-completion`), lazy-loaded on its `DBUI*` commands. This is
  the one extra, special-purpose feature in the config (not part of the
  vimrc sync) — remove `plugins/database.lua` if you don't work with SQL.
- **UI polish:** `catppuccin`, `folke/noice.nvim`, LazyVim's built-in
  `lualine`.

## Requirements

Run `./install-deps.sh` (Debian/Ubuntu, Fedora, Arch, and macOS/Homebrew are
supported) to install everything below in one go. It's idempotent — safe to
re-run any time, it skips whatever's already installed.

- Neovim 0.10+ (for built-in `gc`/`gcc` commenting)
- `git`, and a [Nerd Font](https://www.nerdfonts.com/) for the icons used
  throughout (Snacks, lualine, mini.icons, etc.)
- `ripgrep` and `fd` on your `$PATH` for Snacks' file/grep pickers
- Node.js + npm, Python 3 + pip/venv, and a JDK — runtimes Mason needs to
  install the LSP servers/formatters below
- `lazygit` for `<leader>gg`
- A C compiler + `make`, so `nvim-treesitter` can compile parsers
- Everything else (LSP servers, formatters) installs automatically via
  Mason on first launch, using the runtimes above
