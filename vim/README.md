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

### File Explorer & Windows
| Shortcut | Mode | Action |
| :--- | :---: | :--- |
| `<leader>e` | Normal | Toggle Netrw file explorer tree (`:Lexplore`) |
| `<leader>\|` | Normal | Vertical split (`:vsplit`) |
| `<leader>-` | Normal | Horizontal split (`:split`) |
| `Ctrl + h/j/k/l` | Normal | Navigate between window splits |
| `Ctrl + Arrows` | Normal | Resize active split window |
| `<leader>sc` | Normal | Close current split window |

### Buffer Management & Tabs
| Shortcut | Mode | Action |
| :--- | :---: | :--- |
| `H` / `L` | Normal | Switch to previous / next buffer |
| `Alt + 1..9` | Normal | Jump directly to buffer 1 through 9 |
| `<leader>q` | Normal | Quit current buffer/window (`:q`) |
| `<leader>Q` | Normal | Force quit all without saving (`:qa!`) |
| `<leader>w` | Normal | Save current buffer (`:w`) |
| `<leader>bd` | Normal | Delete current buffer (`:bdelete`) |
| `]b` / `[b` | Normal | Next / previous buffer |

### Editing, Moving Lines & Indentation
| Shortcut | Mode | Action |
| :--- | :---: | :--- |
| `Alt + j` / `Alt + k` | Normal / Visual | Move active line / selected block down / up |
| `<` / `>` | Visual | Continuous indent (keeps visual selection active) |
| `<leader>cf` | Normal | Format whole document (`gg=G`) and return cursor |
| `j` / `k` | Normal / Visual | Natural navigation through wrapped lines (`gj` / `gk`) |
| `p` | Visual | Paste without overwriting clipboard register |

### Native Code Commenting (Zero Plugins)
| Shortcut | Mode | Action |
| :--- | :---: | :--- |
| `gcc` | Normal | Toggle comment on current line |
| `gc` | Visual | Toggle comment on selected block |
| `<leader>/` | Normal / Visual | Alternative comment toggle (terminal friendly) |

*Supports language-aware syntax for: C, C++, Java, JS, TS, Python, Go, Rust, PHP, CSS, HTML, XML, Bash, and Vimscript.*

### Search & Highlights
| Shortcut | Mode | Action |
| :--- | :---: | :--- |
| `<Esc>` / `<leader>h` | Normal | Clear search highlight (`:nohlsearch`) |

---

## ⚙️ Built-In Features & Settings

- **100% Terminal Transparency:** Inherits terminal background color (`guibg=NONE ctermbg=NONE`).
- **Persistent Undo:** Automatically creates `~/.vim/undodir` and preserves undo history across restarts.
- **System Clipboard:** Seamless synchronization with system clipboard (`clipboard^=unnamed,unnamedplus`).
- **Absolute Line Numbers:** Clean 1-to-1 line numbers matching modern code editors.
- **Smart Indentation:** 4-space indentation with automatic expansion (`expandtab`, `shiftwidth=4`).
- **Smart Search:** Case-insensitive search unless capital letters are typed (`ignorecase`, `smartcase`).
- **Custom Statusline:** Clean lightweight status bar displaying mode, file name, modified status, encoding, line/column, and percentage.
