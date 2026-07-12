# Minimal Vim Config (No Plugins)

A lightweight `vimrc` built entirely from Vim's built-in features — no plugin manager, no third-party plugins required. Just drop it in and go.

## Installation

Copy the config to your Vim config file:

```bash
cp .vimrc ~/.vimrc
```

## Leader Key

The **Space** bar is set as the leader key. Any shortcut written as `<leader>x` below means: press `Space`, then `x`.

## Keybindings

| Shortcut                          | Mode            | Action                                                                                                           |
| --------------------------------- | --------------- | ---------------------------------------------------------------------------------------------------------------- |
| `Space e`                       | Normal          | Toggle the file explorer (built-in`netrw`) open/closed on the left side                                        |
| `Space t`                       | Normal          | Open a new empty tab                                                                                             |
| `Space q`                       | Normal          | Quit the current window/file                                                                                     |
| `Space \|`                       | Normal          | Create a**vertical** split (side by side)                                                                  |
| `Space -`                       | Normal          | Create a**horizontal** split (stacked)                                                                     |
| `Ctrl i`                        | Normal          | Switch to the**next** open buffer/file                                                                     |
| `Ctrl o`                        | Normal          | Switch to the**previous** open buffer/file                                                                 |
| `Space p`                       | Normal          | Open a fuzzy-style file finder (`:find `) — start typing and press `Tab` to cycle through matches           |
| `Ctrl /`, `gcc`                 | Normal / Visual | Toggle line comment for the current line (or selected lines), using the correct comment syntax for the file type |
| `Space /`                       | Normal          | Fallback for`Ctrl /` in terminals that can't send that key combo                                               |
| `Shift H`                       | Normal          | Switch to the**previous** tab                                                                              |
| `Shift L`                       | Normal          | Switch to the**next** tab                                                                                  |
| `Space r c`                     | Normal          | Open`$MYVIMRC` in a vertical split for quick editing                                                           |
| `Space r o`                     | Normal          | Open`$MYVIMRC` in a new tab for quick editing                                                                  |
| `Space r s`                     | Normal          | Reload (`:source`) `$MYVIMRC` to apply changes immediately                                                   |
| `(`, `[`, `{`, `"`, `'` | Insert          | Auto-insert the matching closing character                                                                       |
| `)`, `]`, `}`, `"`, `'` | Insert          | Skip over the character instead of duplicating it, if it's already there                                         |
| `Backspace`                     | Insert          | Deletes an empty bracket/quote pair together (e.g.`(\|)` → nothing)                                            |
| `%`                             | Normal          | Jump between matching brackets,`if`/`end`, HTML tags, etc. (extended via built-in `matchit`)               |
| `Space s h`                     | Normal          | Open an integrated terminal in a horizontal split                                                                |
| `Space s v`                     | Normal          | Open an integrated terminal in a vertical split                                                                  |
| `Esc Esc`                       | Terminal        | Leave terminal-insert mode and return to Normal mode                                                             |

## Feature Details

### 1. File Explorer — `Space e`

Uses Vim's built-in `netrw` plugin (bundled with Vim, no install needed) in tree-view mode. `Space e` toggles it open and closed. Selecting a file opens it in the main editing window on the right.

### 2. New Tab — `Space t`

Opens a brand-new, empty tab page — similar to `Ctrl+T` in a web browser. Use `Shift H` / `Shift L` (or `gt` / `gT`) to cycle between tabs.

### 3. Quit — `Space q`

Closes the current window. If it's the last window/tab, this exits Vim. If you have unsaved changes, Vim will warn you before closing.

### 4. Splits — `Space |` and `Space -`

- `Space |` creates a **vertical** split (`:vsplit`) — two windows side by side.
- `Space -` creates a **horizontal** split (`:split`) — two windows stacked.

Move between split windows using the standard Vim window commands: `Ctrl+w` followed by `h`/`j`/`k`/`l`.

### 5. Switch Files — `Ctrl i` / `Ctrl o`

Cycles through the buffers (files) you currently have open, without needing to reopen them from the file tree:

- `Ctrl i` → next buffer
- `Ctrl o` → previous buffer

**Note:** these mappings override Vim's default jumplist navigation (which is normally bound to `Ctrl-I` / `Ctrl-O`). Also, some terminal emulators send the exact same code for `Tab` and `Ctrl-I`, so behavior may vary depending on your terminal.

### 6. Fuzzy File Finder — `Space p`

There's no fuzzy-finder plugin installed, so this uses Vim's built-in `:find` command combined with a recursive search path (`path=**`) and `wildmenu`/`wildmode` settings. Pressing `Space p` drops you into the command line pre-filled with `:find `, ready for you to type part of a filename and press `Tab` to autocomplete/cycle through matches.

Common project folders (`node_modules`, `.git`, `dist`, `build`) are excluded from the search via `wildignore` to keep results relevant.

> Tip: for large projects this can be slow since it scans the filesystem. If needed, run `:cd` to your project root first so the search path is smaller.

### 7. Comment Toggle — `Ctrl /`

A hand-written function (`ToggleComment`) that comments or uncomments the current line (Normal mode) or the selected lines (Visual mode), automatically choosing the right comment syntax based on the file type:

| File type                                                      | Comment style                              |
| -------------------------------------------------------------- | ------------------------------------------ |
| Vim script                                                     | `"`                                      |
| JavaScript, TypeScript, Java, C, C++, Go, Rust, PHP, CSS, SCSS | `//`                                     |
| Python, Shell, Bash, Ruby, YAML, Dockerfile                    | `#`                                      |
| Lua                                                            | `--`                                     |
| HTML                                                           | `<!-- -->` (opening and closing markers) |
| Any other file type                                            | `#` (default fallback)                   |

Blank/whitespace-only lines are skipped so they don't get commented out. If a line is already commented, running the shortcut again uncomments it.

If your terminal can't send `Ctrl+/` (some terminals don't support it), use `Space /` instead — it does exactly the same thing.

### 8. Tab Navigation — `Shift H` / `Shift L`

Quickly switch between open tabs without typing `gt`/`gT`:

- `Shift H` → previous tab
- `Shift L` → next tab

**Note:** this overrides Vim's default `H`/`L` cursor motions (jump to the top/bottom of the visible screen). If you still need that behavior occasionally, use `gg`/`G` (jump to start/end of file) or `zt`/`zb` (scroll cursor line to top/bottom) instead.

### 9. Quick Config Editing — `Space r c` / `Space r o` / `Space r s`

A small set of shortcuts to make tweaking this config itself fast and painless:

- `Space r c` — opens `$MYVIMRC` (this file) in a vertical split, so you can edit it while still seeing your current buffer.
- `Space r o` — opens `$MYVIMRC` in a new tab instead, if you'd rather edit it full-screen.
- `Space r s` — re-sources `$MYVIMRC`, applying any changes immediately without restarting Vim.

On top of that, an autocommand automatically reloads the config **every time you save** `$MYVIMRC` (`BufWritePost`), so most of the time you won't even need `Space r s` — just save and your changes take effect right away.

`$MYVIMRC` is a built-in Vim variable that always points to whichever config file Vim loaded on startup, so these mappings work regardless of where the file is stored on disk (`~/.vimrc`, `~/.config/vim/vimrc`, etc.).

### 10. Auto-Close Brackets & Quotes

Typing `(`, `[`, `{`, `"`, or `'` in Insert mode automatically inserts the matching closing character and places the cursor between them. Typing the closing character yourself right where it's already sitting just moves the cursor past it instead of inserting a duplicate — so you can type `foo(bar)` naturally without ending up with `foo(bar))`.

`Backspace` is also smart: pressing it between an empty pair like `(|)` deletes both characters together in one keystroke, instead of leaving a dangling, unmatched bracket.

### 11. Extended `%` Matching (matchit)

Enables Vim's built-in `matchit` runtime feature (it ships with Vim itself — this isn't a downloaded plugin). It upgrades the `%` motion so it can jump between `if`/`elseif`/`else`/`end`, opening/closing HTML/XML tags, and other language-aware matching pairs, not just single brackets.

### 12. System Clipboard Sync

Sets `clipboard=unnamedplus`, so all your yanks (`y`), deletes (`d`), and pastes (`p`) automatically go through the system clipboard. Copy something in Vim and paste it in your browser, or vice versa, with no extra register prefix needed.

> Requires Vim to be compiled with the `+clipboard` feature. Check with `:echo has('clipboard')` — if it returns `0`, you may need a build like `vim-gtk3` (Linux) or standard `MacVim` (macOS) instead of a minimal Vim build.

### 13. Auto-Reload Changed Files + Restore Cursor Position

- `autoread` + a `checktime` autocommand means that if a file is modified outside of Vim (git checkout, another editor, a build script), Vim automatically reloads it instead of showing stale content.
- Reopening any file automatically jumps your cursor back to the exact line and column you were on the last time you edited it, instead of always starting at line 1.

### 14. Custom Statusline

A statusline is always visible (`laststatus=2`) and shows, from left to right:

- Current mode (`NORMAL`, `INSERT`, `VISUAL`, `TERMINAL`, etc.)
- Filename, plus modified/readonly/help/preview flags
- Current git branch, if the file is inside a git repository (detected via `git rev-parse`, no plugin needed)
- Filetype
- Cursor's line:column position and percentage through the file

### 15. Integrated Terminal — `Space s h` / `Space s v`

Opens Vim's built-in `:terminal` in a split, so you can run build commands, tests, or scripts without leaving Vim:

- `Space s h` → terminal in a horizontal split at the bottom (15 rows tall)
- `Space s v` → terminal in a vertical split

While inside the terminal, press `Esc` twice to leave terminal-insert mode and return to Normal mode (so you can navigate around the window like any other buffer).

> Requires Vim to be compiled with the `+terminal` feature.

### 16. Indent / Whitespace Guides

Invisible characters are made visible via `listchars`:

- Tabs are shown as `▸` followed by a space
- Trailing spaces are shown as `·`
- Wrapped lines show `❯` / `❮` at the point where content continues off-screen
- Non-breaking spaces are shown as `␣`

This makes it easy to spot accidental tabs-vs-spaces mixing or stray whitespace at a glance.

## General Editor Settings

Beyond the keybindings above, this config also sets up sensible defaults:

- Line numbers, cursor line highlight, and always-visible sign column
- 4-space indentation using spaces (not tabs), with auto/smart indent
- Case-insensitive search that becomes case-sensitive when you type an uppercase letter, with live incremental search and highlighted matches
- No hardcoded color scheme — the background is transparent so Vim automatically matches whatever theme your terminal is using (Dracula, Nord, Gruvbox, Solarized, etc.)

## Requirements

- Vim compiled with the `+termguicolors` feature (optional, for true-color themes)
- Vim compiled with `+clipboard` (optional, for system clipboard sync — feature 12)
- Vim compiled with `+terminal` (optional, for the integrated terminal — feature 15)
- A terminal emulator that supports true color (`$COLORTERM` set to `truecolor` or `24bit`) if you want full-color syntax highlighting
- `git` installed and available on your `$PATH` (optional, for the git branch shown in the statusline)

No plugin manager (vim-plug, Vundle, packer, etc.) is required — everything here runs on stock Vim.
