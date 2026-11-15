# Minimal Vim Configuration (Zero Plugins)

A lightweight, distraction-free `.vimrc` built entirely from Vim's built-in features — zero plugin manager, zero third-party plugins. Designed for instant boot times on remote servers, SSH sessions, containers, and minimal environments, while sharing identical muscle memory with our Neovim configuration.

---

## 🚀 Quick Installation

Copy `.vimrc` to your user home directory:

```bash
cp .vimrc ~/.vimrc
```

Or symlink it:

```bash
ln -sf "$(pwd)/.vimrc" ~/.vimrc
```

Then simply launch Vim:

```bash
vim
```

---

## ⌨️ Leader Key

The **Space** bar is configured as the leader key (`let mapleader = " "`).
Any shortcut formatted as `<leader>x` means: press `Space`, then `x`.

---

## 📋 Keybindings Reference

Pure Vim motions and editing keys (`j`, `k`, `H`, `M`, `L`, `dd`, `x`, `p`, `<`, `>`, etc.) retain their 100% vanilla behavior. Only essential utilities are mapped cleanly under `<leader>` and `Ctrl`.

### File Explorer & Windows
| Shortcut | Mode | Action |
| :--- | :---: | :--- |
| `<leader>e` | Normal | Toggle Netrw file explorer tree (`:Lexplore`) |
| `<leader>\|` | Normal | Vertical split (`:vsplit`) |
| `<leader>-` | Normal | Horizontal split (`:split`) |
| `Ctrl + h/j/k/l` | Normal | Navigate between window splits |

### Code Formatting & Commenting
| Shortcut | Mode | Action |
| :--- | :---: | :--- |
| `<leader>cf` | Normal | Format whole document (`gg=G`) and return cursor |
| `gcc` | Normal | Toggle comment on current line |
| `gc` | Visual | Toggle comment on selected block |

*Supports language-aware syntax for: C, C++, Java, JS, TS, Python, Go, Rust, PHP, CSS, HTML, XML, Bash, and Vimscript.*

### Search & Highlights
| Shortcut | Mode | Action |
| :--- | :---: | :--- |
| `<Esc>` | Normal | Clear search highlight (`:nohlsearch`) |

---

## ⚙️ Built-In Features & Settings

- **Native Buffer Tabline:** Zero-plugin buffer bar displayed at top with clean active/modified indicators, clickable with mouse, matching Neovim Bufferline.
- **Native Netrw & Motion Parity:** Netrw file explorer and navigation keys (`H`, `L`) adhere strictly to Vim defaults without intrusive key remappings.
- **100% Terminal Transparency:** Inherits terminal background color and opacity across all terminal emulators (`guibg=NONE ctermbg=NONE`, with explicit reset of all reverse attributes).
- **Soft Translucent Gray CursorLine:** Active line is highlighted with a delicate gray wash (`#222222` / `ctermbg=235`) that blends smoothly into dark backgrounds without harsh solid stripes.
- **Persistent Undo:** Automatically creates `~/.vim/undodir` and preserves undo history across restarts.
- **System Clipboard:** Seamless synchronization with system clipboard (`clipboard^=unnamed,unnamedplus`).
- **Absolute Line Numbers:** Clean 1-to-1 line numbers matching modern code editors.
- **Smart Indentation:** 4-space indentation with automatic expansion (`expandtab`, `shiftwidth=4`).
- **Smart Search:** Case-insensitive search unless capital letters are typed (`ignorecase`, `smartcase`).
- **Custom Statusline:** Clean lightweight status bar displaying mode, file name, modified status, encoding, line/column, and percentage.
