# 🌌 Neovim Configuration Stack

A clean, modular, and lightweight Neovim setup built directly on **Neovim 0.10+** and **`lazy.nvim`** (without LazyVim distribution overhead). Designed with domain-driven plugin isolation, instant responsiveness, and zero bloated defaults.

---

## 📑 Table of Contents

- [Architecture &amp; Directory Structure](#-architecture--directory-structure)
- [Plugin Ecosystem &amp; Roles](#-plugin-ecosystem--roles)
- [Specialized Features](#-specialized-features)
  - [1. Tabular CSV &amp; TSV Grid Visualizer](#1-tabular-csv--tsv-grid-visualizer)
  - [2. Visual Markdown Decorator &amp; Tables](#2-visual-markdown-decorator--tables)
  - [3. Code &amp; Document Formatting](#3-code--document-formatting)
  - [4. Seamless Terminal Transparency](#4-seamless-terminal-transparency)
- [Keybindings Reference](#-keybindings-reference)
- [System Requirements &amp; Installation](#-system-requirements--installation)
- [Lightweight Design Rationale](#-lightweight-design-rationale)

---

## 🌟 Key Highlights

- **Domain-Driven Architecture:** Clean separation of concerns across 5 functional domains (`ui`, `editor`, `coding`, `lsp`, `viewers`).
- **Zero Distribution Overhead:** Loads only explicitly declared plugins directly via `lazy.nvim`, eliminating dozens of unused default plugins.
- **Tabular Data Viewing:** High-performance CSV/TSV table grid with frozen sticky headers, cell padding, and grid cell navigation.
- **Rich Markdown Formatting:** Aesthetic rounded table borders, syntax callouts, and inline task checkboxes.
- **Safe Big File Handling:** Integrated size guards prevent Neovim from freezing when opening massive dataset files (100MB+).
- **Global Spell Check Disabled:** Clean, distraction-free editing without red squiggly underlines.

---

## 🏗️ Architecture & Directory Structure

All plugin specifications reside strictly within `lua/plugins/` for automatic discovery by `lazy.nvim`. Core editor defaults and key mappings are segregated under `lua/config/`.

```text
~/.config/nvim/
├── init.lua                 # Main startup entry point (loads options, lazy.nvim, autocmds, keymaps)
├── install-deps.sh          # Idempotent dependency installer for Linux/macOS
├── README.md                # Comprehensive documentation
└── lua/
    ├── config/              # Core Neovim configuration
    │   ├── lazy.lua         # Plugin manager bootstrap (lazy.nvim)
    │   ├── options.lua      # Global settings (4-space indent, absolute line numbers, clipboard)
    │   ├── keymaps.lua      # Core shortcuts (explorer, pickers, splits, terminal, LSP, format)
    │   └── autocmds.lua     # Automated event handlers (auto-reload, cursor restore, no-spell)
    └── plugins/             # Domain-specific plugin modules
        ├── ui.lua           # Theme (Catppuccin Mocha), Lualine statusline, Bufferline tabs
        ├── editor.lua       # Snacks suite (Explorer, Pickers, Terminal, Dashboard), Which-Key, GitSigns
        ├── coding.lua       # Blink.cmp autocompletion
        ├── lsp.lua          # Treesitter, Mason + Mason-LSPConfig, LSPConfig, Conform
        └── viewers.lua      # CSV/TSV spreadsheet table viewer & Markdown visual decorator
```

---

## 🧩 Plugin Ecosystem & Roles

| Domain           | Plugin                      | Architectural Role & Capabilities                                             |
| :--------------- | :-------------------------- | :---------------------------------------------------------------------------- |
| **Theme & UI**   | `catppuccin/nvim`           | Pastel colorscheme with 100% transparent terminal background                  |
|                  | `nvim-lualine/lualine.nvim` | Bottom status bar with graphite powerline styling                             |
|                  | `akinsho/bufferline.nvim`   | Top tab bar with flat buffer tabs                                             |
| **Workspace**    | `folke/snacks.nvim`         | Dashboard, file explorer, fuzzy pickers, floating terminal, bigfile optimizer |
|                  | `folke/which-key.nvim`      | Keyboard shortcut popup guide                                                 |
|                  | `lewis6991/gitsigns.nvim`   | In-editor Git gutter status indicators, line blame, and hunk preview          |
| **Coding**       | `saghen/blink.cmp`          | Blazing-fast Rust-backed autocomplete engine with ghost text                  |
| **LSP & Syntax** | `nvim-treesitter`           | Abstract Syntax Tree highlighting (core parsers + on-demand install)         |
|                  | `mason.nvim`                | In-editor package manager for language servers and tools                      |
|                  | `mason-lspconfig.nvim`      | Bridges installed Mason language servers directly to Neovim LSP               |
|                  | `neovim/nvim-lspconfig`     | Native LSP server configurations with `blink.cmp` capabilities                |
|                  | `folke/lazydev.nvim`        | Lua API type definitions and completion for Neovim config editing             |
| **Formatting**   | `stevearc/conform.nvim`     | Format-on-demand via `<leader>cf` with LSP fallback                           |
| **Viewers**      | `hat0uma/csvview.nvim`      | Interactive tabular spreadsheet viewer for CSV/TSV                            |
|                  | `render-markdown.nvim`      | Visual table borders, callouts, and checkboxes for Markdown                   |

---

## 🔍 Specialized Features

### 1. Tabular CSV & TSV Grid Visualizer

Configured in `lua/plugins/viewers.lua` via `hat0uma/csvview.nvim`:

- **Spreadsheet Grid:** Replaces raw comma delimiters with vertical borders (`│`) and cell padding.
- **Sticky Top Row (Freeze Header):** Line 1 is styled with a distinct background and remains pinned at the top of the viewport when scrolling down.
- **Cell Navigation:**
  - `<Tab>`: Jump to the next cell horizontally.
  - `<Shift + Tab>`: Jump to the previous cell horizontally.
  - `<Enter>`: Jump to the next row vertically.
  - `<Shift + Enter>`: Jump to the previous row vertically.
- **Massive Dataset Safety Guard:** Files larger than 2.0 MB automatically skip heavy rendering to preserve instant Neovim load speeds. Press `<leader>cp` to inspect large files in a fast terminal pager (`less -S`) without RAM overhead.

### 2. Visual Markdown Decorator & Tables

Configured in `lua/plugins/viewers.lua` via `MeanderingProgrammer/render-markdown.nvim`:

- **Rounded Table Borders:** Automatically converts raw Markdown pipe tables (`| col1 | col2 |`) into formatted graphical tables with rounded corners (`╭`, `┬`, `╮`, `╰`, `┴`, `╯`).
- **Callouts & Alerts:** Renders GitHub-style alerts (`[!NOTE]`, `[!TIP]`, `[!WARNING]`, `[!CAUTION]`) with custom icons and borders.
- **Inline Checkboxes:** Interactive visual checkboxes for task lists (`[ ]` → `󰄱`, `[x]` → `󰄵`).
- **Toggle Command:** Press `<leader>um` to toggle Markdown rendering on/off.

### 3. Code & Document Formatting

Formatting is managed by `stevearc/conform.nvim` configured directly in `lua/plugins/lsp.lua`:

- **Format-on-Save OFF by Default (`vim.g.autoformat = false`):** Saving files (`:w`) writes content as-is without altering indentation or causing unintended Git diff churn.
- **On-Demand Formatting:** Press `<leader>cf` in normal or visual mode to format explicitly (falls back to LSP formatting when no external formatter is configured). Toggle autoformat on save anytime with `<leader>uf`.
- **Project Consistency (.editorconfig):** Strictly respects `.editorconfig` and project configuration files (`.prettierrc`, `pyproject.toml`, etc.) to guarantee formatting parity across repositories.
- **Zero Language Hardcoding:** No bloat by default; add language-specific formatters to `formatters_by_ft` in `lua/plugins/lsp.lua` only when needed.

### 4. Seamless Terminal Transparency

Configured in `lua/plugins/ui.lua` via `catppuccin/nvim`:

- `transparent_background = true` ensures Neovim inherits your terminal emulator's true background and opacity settings.
- Custom highlights normalize floating windows, popup menus, and statuslines to match the terminal palette.
- Eliminates visual banding between file explorer sidebar, active editor buffers, and popups.

---

## ⌨️ Keybindings Reference

All custom shortcuts use `<Space>` as `<leader>`.

### Navigation & Explorer

| Shortcut     | Action                                      |
| :----------- | :------------------------------------------ |
| `H` / `L`    | Switch to previous / next buffer            |
| `<leader>e`  | Toggle sidebar file explorer                |
| `<C-p>`      | Fuzzy find files (Ctrl+P)                   |
| `<leader>ff` | Fuzzy find files                            |
| `<leader>fg` | Live text search across workspace (ripgrep) |
| `<leader>fr` | Browse recent files                         |
| `<leader>fb` | Browse open buffers                         |

### Window Splits & Movement

| Shortcut      | Action                           |
| :------------ | :------------------------------- |
| `<leader>\|`  | Split window vertically          |
| `<leader>-`   | Split window horizontally        |
| `<C-h>`       | Focus window to the left         |
| `<C-j>`       | Focus window below               |
| `<C-k>`       | Focus window above               |
| `<C-l>`       | Focus window to the right        |

### Code Intelligence (LSP) & Formatting

| Shortcut     | Action                                    |
| :----------- | :---------------------------------------- |
| `gd`         | Jump to definition                        |
| `gr`         | Find references across project            |
| `gI`         | Jump to implementation                    |
| `K`          | Hover documentation / signature help      |
| `<leader>ca` | Trigger code actions                      |
| `<leader>rn` | Rename symbol workspace-wide              |
| `<leader>cf` | Format current document                   |


### Comments (Built-in)

| Shortcut        | Action                           |
| :-------------- | :------------------------------- |
| `gcc`           | Toggle line comment              |
| `gc` *(visual)* | Toggle comment on selected block |

### Specialized Viewers & Terminal

| Shortcut               | Action                                            |
| :--------------------- | :------------------------------------------------ |
| `<leader>cv`           | Toggle CSV/TSV tabular grid view                  |
| `<leader>cp`           | Open large CSV in fast floating pager (`less -S`) |
| `<leader>um`           | Toggle visual Markdown rendering                  |
| `<C-/>` / `<leader>ft` | Toggle floating integrated terminal               |

---

## 📦 System Requirements & Installation

Run `./install-deps.sh` to install all underlying system runtimes automatically:

```bash
chmod +x install-deps.sh
./install-deps.sh
```

**Required packages:**
- `neovim` (0.10.0 or higher)
- `git` (for Lazy.nvim plugin cloning)
- `ripgrep` (for ultra-fast file/text searching)
- `fd` (for directory/file discovery)
- `curl` (for plugin and release downloads)
- `unzip` (for Mason archive extraction)
- `base-devel` / `build-essential` (C compiler for Treesitter parser compilation)
- `wl-clipboard` / `xclip` (for system clipboard synchronization)
- `nodejs` / `npm` (runtime for Mason language servers)
- `python` / `python3` (runtime for Python language tools)

---

## 🛡️ Lightweight Design Rationale

1. **No LazyVim Distro Bloat:** Uses pure `lazy.nvim` directly instead of importing `LazyVim/LazyVim`, eliminating unused defaults (`tokyonight`, `persistence`, `nvim-lint`, `flash`, `mini.comment`, etc.) without needing a `disabled.lua` override file.
2. **Native Neovim Features First:** Relies on Neovim 0.10+ built-in `gc`/`gcc` commenting, built-in `[d`/`]d` diagnostic navigation, and native `vim.lsp.config` on Neovim 0.11+.
3. **Pure Vim Motions Preserved:** Standard motions (`j`, `k`, `H`, `M`, `L`, `s`, `S`, `f`, `F`, `t`, `T`, `gi`) remain untouched across Vim, Neovim, and IdeaVim.
