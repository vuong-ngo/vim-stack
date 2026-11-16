# 🌌 Neovim Configuration Stack

A clean, modular, and high-performance Neovim setup built on top of **Neovim 0.10+** and the **LazyVim** framework. Designed with domain-driven plugin isolation, instant responsiveness, and zero bloated configurations.

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
- [Eliminated Redundancies &amp; Design Rationale](#-eliminated-redundancies--design-rationale)

---

## 🌟 Key Highlights

- **Domain-Driven Architecture:** Clean separation of concerns across 6 functional domains (`ui`, `editor`, `coding`, `lsp`, `viewers`), plus a dedicated `disabled.lua` module.
- **Tabular Data Viewing:** High-performance CSV/TSV table grid with frozen sticky headers, cell padding, and grid cell navigation.
- **Rich Markdown Formatting:** Aesthetic rounded table borders, syntax callouts, and inline task checkboxes.
- **Zero Redundant Bloat:** Eliminated duplicate commenting engines, unused themes, and background disk writers.
- **Safe Big File Handling:** Integrated size guards prevent Neovim from freezing when opening massive dataset files (100MB+).
- **Global Spell Check Disabled:** Clean, distraction-free editing without red squiggly underlines.

---

## 🏗️ Architecture & Directory Structure

All custom plugin specifications reside strictly within `lua/plugins/` to take advantage of LazyVim's automated plugin discovery. Core editor defaults and key mappings are segregated under `lua/config/`.

```text
~/.config/nvim/
├── init.lua                 # Main startup entry point (orchestrates config loading)
├── lazy-lock.json           # Pinned Git commit hashes for reproducible plugin setups
├── lazyvim.json             # LazyVim framework state and version tracker
├── install-deps.sh          # Idempotent dependency installer for Linux/macOS
├── README.md                # Comprehensive documentation
└── lua/
    ├── config/              # Core Neovim configuration
    │   ├── lazy.lua         # Plugin manager bootstrap (lazy.nvim)
    │   ├── options.lua      # Global settings (4-space indent, absolute line numbers, clipboard)
    │   ├── keymaps.lua      # Core shortcuts (tabs, buffers, splits, terminal)
    │   └── autocmds.lua     # Automated event handlers (auto-reload, cursor restore, no-spell)
    └── plugins/             # Domain-specific plugin modules
        ├── ui.lua           # Theme (Catppuccin Mocha), Lualine statusline, Bufferline tabs, Noice
        ├── editor.lua       # Snacks suite, Explorer, Pickers, Grug-Far search, Trouble, GitSigns
        ├── coding.lua       # Blink.cmp autocompletion, Mini.pairs, Mini.surround, Mini.ai
        ├── lsp.lua          # Treesitter syntax (core + :LazyExtras), Mason package manager, LSPConfig
        ├── viewers.lua      # CSV/TSV spreadsheet table viewer & Markdown visual decorator
        └── disabled.lua     # Explicitly disabled overlapping/unused default plugins
```

---

## 🧩 Plugin Ecosystem & Roles

| Domain           | Plugin                      | Architectural Role & Capabilities                                             |
| :--------------- | :-------------------------- | :---------------------------------------------------------------------------- |
| **Theme & UI**   | `catppuccin/nvim`           | Pastel colorscheme with 100% transparent terminal background                  |
|                  | `nvim-lualine/lualine.nvim` | Bottom status bar with graphite powerline styling                             |
|                  | `akinsho/bufferline.nvim`   | Top tab bar with flat buffer tabs                                             |
|                  | `folke/noice.nvim`          | Floating commandline, popup menus, and notification router                    |
| **Workspace**    | `folke/snacks.nvim`         | Dashboard, file explorer, fuzzy pickers, floating terminal, bigfile optimizer |
|                  | `folke/which-key.nvim`      | Keyboard shortcut popup guide                                                 |
|                  | `MagicDuck/grug-far.nvim`   | Project-wide interactive search-and-replace editor buffer                     |
|                  | `folke/trouble.nvim`        | Diagnostics, references, and symbols panel                                    |
|                  | `folke/todo-comments.nvim`  | Highlights and indexes`TODO`, `FIXME`, `NOTE` tags                            |
|                  | `lewis6991/gitsigns.nvim`   | In-editor Git gutter status indicators, line blame, and hunk preview          |
| **Coding**       | `saghen/blink.cmp`          | Blazing-fast Rust-backed autocomplete engine with ghost text                  |
|                  | `nvim-mini/mini.pairs`      | Automatic bracket and quote auto-closing                                      |
|                  | `nvim-mini/mini.surround`   | Fast surrounding operator (`gza`, `gzd`, `gzr`)                               |
|                  | `nvim-mini/mini.ai`         | Extended text objects for functions, parameters, and blocks                   |
|                  | `windwp/nvim-ts-autotag`    | Auto-close and rename HTML/JSX tags                                           |
| **LSP & Syntax** | `nvim-treesitter`           | Abstract Syntax Tree highlighting (core + synced via `:LazyExtras`)          |
|                  | `mason.nvim`                | In-editor package manager for language servers and tools                      |
|                  | `neovim/nvim-lspconfig`     | Native LSP server configurations synced dynamically via `:LazyExtras`         |
|                  | `folke/lazydev.nvim`        | Lua API type definitions and completion for Neovim config editing             |
| **Formatting**   | `stevearc/conform.nvim`     | Format-on-demand via `<leader>cf` and formatters synced via `:LazyExtras`     |
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

Formatting is managed dynamically by LazyVim core via `stevearc/conform.nvim` and `:LazyExtras`:

- **Format-on-Save OFF by Default (`vim.g.autoformat = false`):** Saving files (`:w`) writes content as-is without altering indentation or causing unintended Git diff churn.
- **On-Demand Formatting:** Press `<leader>cf` in normal or visual mode to format explicitly. Toggle autoformat on save anytime with `<leader>uf`.
- **Project Consistency (.editorconfig):** Strictly respects `.editorconfig` and project configuration files (`.prettierrc`, `pyproject.toml`, etc.) to guarantee formatting parity across repositories.
- **Zero Language Hardcoding:** Pure editor by default; formatters for Python (`black`/`ruff`), JS/TS/Web (`prettier`), Rust (`rustfmt`), etc., are enabled dynamically via `:LazyExtras`.

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
| `<leader>e`  | Toggle sidebar file explorer                |
| `<C-p>`      | Fuzzy find files (Ctrl+P)                   |
| `<leader>ff` | Fuzzy find files                            |
| `<leader>fg` | Live text search across workspace (ripgrep) |
| `<leader>fr` | Browse recent files                         |
| `<leader>fb` | Browse open buffers                         |
| `<leader>sr` | Project-wide interactive search-and-replace |

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


### Editing Motions & Comments

| Shortcut              | Action                           |
| :-------------------- | :------------------------------- |
| `gcc`                 | Toggle line comment              |
| `gc` *(visual)*       | Toggle comment on selected block |
| `gza` *(motion)*      | Add surrounding quotes/brackets  |
| `gzd` *(char)*        | Delete surrounding character     |
| `gzr` *(old, new)*    | Replace surrounding character    |

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
- `nodejs` / `npm` (runtime for Mason language servers installed via `:LazyExtras`)
- `python` / `python3` (runtime for Python tools installed via `:LazyExtras`)

---

## 🛡️ Eliminated Redundancies & Design Rationale

1. **Removed `mini.comment`:** Neovim 0.10+ includes native `gc`/`gcc` commenting logic alongside `ts-comments.nvim`. Maintaining `mini.comment` caused duplicate plugin overhead.
2. **Removed Tokyonight Theme:** Catppuccin Mocha is configured as the single primary transparent theme, saving startup loading time.
3. **Removed `persistence.nvim`:** User manages active workspaces and buffers directly; prevents redundant session write I/O on disk.
4. **Removed `nvim-lint`:** Real-time diagnostics are delivered natively by LSP language servers; formatters are driven by Conform.
5. **Removed `flash.nvim`:** Preserves pure standard Vim search motions (`/`, `?`, `s`, `S`, `f`, `F`, `t`, `T`) without key-hijacking.
