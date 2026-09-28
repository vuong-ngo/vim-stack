# Modernized Neovim IDE Configuration

A lean, high-performance, and modular Neovim configuration built on top of **LazyVim**, tailored for productivity, code intelligence, and specialized data visualization.

---

## 📑 Table of Contents

- [Key Highlights](#-key-highlights)
- [Architecture &amp; Directory Structure](#-architecture--directory-structure)
- [Plugin Ecosystem &amp; Roles](#-plugin-ecosystem--roles)
- [Specialized Features](#-specialized-features)
  - [1. Office/Excel-Style CSV &amp; TSV Visualizer](#1-officeexcel-style-csv--tsv-visualizer)
  - [2. Visual Markdown Decorator &amp; Tables](#2-visual-markdown-decorator--tables)
  - [3. Code &amp; Document Formatting](#3-code--document-formatting)
  - [4. Seamless Terminal Transparency](#4-seamless-terminal-transparency)
- [Keybindings Reference](#-keybindings-reference)
- [System Requirements &amp; Installation](#-system-requirements--installation)
- [Eliminated Redundancies &amp; Design Rationale](#-eliminated-redundancies--design-rationale)

---

## 🌟 Key Highlights

- **Domain-Driven Architecture:** Clean separation of concerns across 6 functional domains (`ui`, `editor`, `coding`, `lsp`, `formatting`, `viewers`), plus a dedicated `disabled.lua` module.
- **Office/Excel-Style Data Viewing:** High-performance CSV/TSV table grid with frozen sticky headers, cell padding, and `<Tab>`/`<Enter>` cell navigation.
- **Rich Markdown Formatting:** Aesthetic rounded table borders, syntax callouts, and inline task checkboxes.
- **Zero Redundant Bloat:** Eliminated duplicate commenting engines, unused themes, and background disk writers.
- **Safe Big File Handling:** Integrated size guards prevent Neovim from freezing when opening massive dataset files (100MB+).
- **Global Spell Check Disabled:** Clean, distraction-free editing without red squiggly underlines.

---

## 🗂️ Architecture & Directory Structure

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
    │   ├── options.lua      # Global settings (2-space indent, absolute line numbers, clipboard)
    │   ├── keymaps.lua      # Core shortcuts (tabs, buffers, splits, terminal)
    │   └── autocmds.lua     # Automated event handlers (auto-reload, cursor restore, no-spell)
    └── plugins/             # Domain-specific plugin modules
        ├── ui.lua           # Theme (Catppuccin Mocha), Lualine statusline, Bufferline tabs, Noice
        ├── editor.lua       # Snacks suite, Explorer, Pickers, Grug-Far search, Trouble, GitSigns
        ├── coding.lua       # Blink.cmp autocompletion, Mini.pairs, Mini.surround, Mini.ai
        ├── lsp.lua          # Treesitter syntax (20 languages), Mason package manager, LSPConfig
        ├── formatting.lua   # Conform.nvim (Prettier, Stylua, Black, Isort, Shfmt)
        ├── viewers.lua      # CSV/TSV spreadsheet table viewer & Markdown visual decorator
        └── disabled.lua     # Explicitly disabled overlapping/unused default plugins
```

---

## 🧩 Plugin Ecosystem & Roles

| Domain                 | Plugin                        | Purpose                                                                       |
| :--------------------- | :---------------------------- | :---------------------------------------------------------------------------- |
| **Theme & UI**   | `catppuccin/nvim`           | Pastel colorscheme with 100% transparent terminal background                  |
|                        | `nvim-lualine/lualine.nvim` | Bottom status bar with graphite powerline styling                             |
|                        | `akinsho/bufferline.nvim`   | Top tab bar with flat VS Code-style buffer tabs                               |
|                        | `folke/noice.nvim`          | Floating commandline, popup menus, and notification router                    |
| **Workspace**    | `folke/snacks.nvim`         | Dashboard, file explorer, fuzzy pickers, floating terminal, bigfile optimizer |
|                        | `folke/which-key.nvim`      | Keyboard shortcut popup guide                                                 |
|                        | `MagicDuck/grug-far.nvim`   | Project-wide interactive search-and-replace editor buffer                     |
|                        | `folke/trouble.nvim`        | Diagnostics, references, and symbols panel                                    |
|                        | `folke/todo-comments.nvim`  | Highlights and indexes`TODO`, `FIXME`, `NOTE` tags                      |
|                        | `lewis6991/gitsigns.nvim`   | In-editor Git gutter status indicators, line blame, and hunk preview          |
| **Coding**       | `saghen/blink.cmp`          | Blazing-fast Rust-backed autocomplete engine with ghost text                  |
|                        | `nvim-mini/mini.pairs`      | Automatic bracket and quote auto-closing                                      |
|                        | `nvim-mini/mini.surround`   | Fast surrounding operator (`sa`, `sd`, `sr`)                            |
|                        | `nvim-mini/mini.ai`         | Extended text objects for functions, parameters, and blocks                   |
|                        | `windwp/nvim-ts-autotag`    | Auto-close and rename HTML/JSX tags                                           |
| **LSP & Syntax** | `nvim-treesitter`           | Abstract Syntax Tree highlighting for 20+ languages                           |
|                        | `mason.nvim`                | In-editor package manager for language servers and tools                      |
|                        | `neovim/nvim-lspconfig`     | LSP server configurations (Python, TypeScript, Lua, HTML, CSS, JSON, Bash)    |
|                        | `folke/lazydev.nvim`        | Lua API type definitions and completion for Neovim config editing             |
| **Formatting**   | `stevearc/conform.nvim`     | Format-on-save runner for Prettier, Stylua, Black, Isort, Shfmt               |
| **Viewers**      | `hat0uma/csvview.nvim`      | Interactive Excel-style tabular spreadsheet viewer for CSV/TSV                |
|                        | `render-markdown.nvim`      | Visual table borders, callouts, and checkboxes for Markdown                   |

---

## 🔍 Specialized Features

### 1. Office/Excel-Style CSV & TSV Visualizer

Configured in `lua/plugins/viewers.lua` via `hat0uma/csvview.nvim`:

- **Spreadsheet Grid:** Replaces raw comma delimiters with vertical borders (`│`) and cell padding.
- **Sticky Top Row (Freeze Header):** Line 1 is styled with a distinct background and remains pinned at the top of the viewport when scrolling down.
- **Excel Cell Navigation:**
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

Configured in `lua/plugins/formatting.lua` via `stevearc/conform.nvim`:

- **Prettier:** Formats Markdown tables, JavaScript, TypeScript, HTML, CSS, JSON, and YAML.
- **Python:** Formats with `black` and organizes imports with `isort`.
- **Lua:** Formats with `stylua`.
- **Shell:** Formats with `shfmt`.
- **Shortcut:** Press `<leader>cf` or save the buffer (`format_on_save` enabled).

### 4. Seamless Terminal Transparency

Configured in `lua/plugins/ui.lua` via `catppuccin/nvim`:

- `transparent_background = true` ensures Neovim inherits your terminal emulator's true background and opacity settings.
- Custom highlights normalize floating windows, popup menus, and statuslines to match the terminal palette.

---

## ⌨️ Keybindings Reference

Leader key: **`Space`**

### Tab & Buffer Management

| Shortcut       | Action                                            |
| :------------- | :------------------------------------------------ |
| `<leader>q`  | Close current tab / buffer (does not exit Neovim) |
| `<leader>Q`  | Confirm and quit all windows                      |
| `H` / `L`  | Navigate to previous / next buffer tab            |
| `Alt + 1..9` | Jump directly to tab 1 through 9                  |

### File Navigation & Search

| Shortcut                   | Action                                                   |
| :------------------------- | :------------------------------------------------------- |
| `<leader>e`              | Toggle sidebar File Explorer (`Snacks.explorer`)       |
| `<C-p>` / `<leader>ff` | Quick open / search files (`Snacks.picker.files`)      |
| `<C-f>` / `<leader>fg` | Project-wide text search (`Snacks.picker.grep`)        |
| `<leader>fr`             | Browse recently opened files                             |
| `<leader>fb`             | List and switch open buffers                             |
| `<leader>sr`             | Interactive project-wide Search & Replace (`Grug-Far`) |
| `<Esc>`                  | Clear search highlight                                   |

### Code Intelligence & LSP

| Shortcut       | Action                                    |
| :------------- | :---------------------------------------- |
| `gd`         | Go to definition                          |
| `gr`         | Find references (picker list)             |
| `gI`         | Go to implementation                      |
| `K`          | Display hover documentation               |
| `<leader>ca` | Code Actions                              |
| `<leader>rn` | Rename symbol across workspace            |
| `<leader>xx` | Workspace diagnostics panel (`Trouble`) |
| `<leader>xd` | Document diagnostics panel (`Trouble`)  |
| `<leader>cs` | Document symbols panel (`Trouble`)      |
| `<leader>cf` | Format current document                   |

### Editing Motions & Comments

| Shortcut                  | Action                           |
| :------------------------ | :------------------------------- |
| `gcc`                   | Toggle line comment              |
| `gc` *(visual)*       | Toggle comment on selected block |
| `sa` *(motion)*       | Add surrounding quotes/brackets  |
| `sd` *(char)*         | Delete surrounding character     |
| `sr` *(old, new)*     | Replace surrounding character    |
| `Alt + j` / `Alt + k` | Move selected lines down / up    |

### Specialized Viewers & Terminal

| Shortcut                   | Action                                              |
| :------------------------- | :-------------------------------------------------- |
| `<leader>cv`             | Toggle CSV/TSV Office spreadsheet table view        |
| `<leader>cp`             | Open large CSV in fast floating pager (`less -S`) |
| `<leader>um`             | Toggle visual Markdown rendering                    |
| `<C-/>` / `<leader>ft` | Toggle floating integrated terminal                 |

---

## 📦 System Requirements & Installation

Run `./install-deps.sh` to install all underlying system runtimes automatically:

```bash
chmod +x install-deps.sh
./install-deps.sh
```

### Supported Operating Systems

- **Arch Linux** (`pacman`)
- **Debian / Ubuntu** (`apt-get`)
- **Fedora** (`dnf`)
- **macOS** (`brew`)

### Runtimes Installed

- **Neovim >= 0.10**
- **Git**
- **C Compiler (`gcc`/`clang`) + Make** (for compiling Tree-sitter parsers)
- **ripgrep** & **fd** (for high-speed file and grep pickers)
- **Node.js & npm** (runtime for Prettier, Pyright, BashLS, JsonLS, etc.)
- **Python 3 & venv** (runtime for Black, Isort, Pyright)
- **Clipboard Utility** (`wl-clipboard` for Wayland / `xclip` for X11)
- **JetBrainsMono Nerd Font** (for icons)

---

## 🚫 Eliminated Redundancies & Design Rationale

During the modernization audit, the following redundant components were cleanly decommissioned in `lua/plugins/disabled.lua`:

1. **`mini.comment`:** Removed to avoid duplication with Neovim 0.10's native `gcc`/`gc` operator and LazyVim's `ts-comments.nvim`.
2. **`tokyonight.nvim`:** Disabled to prevent unused background downloads (Catppuccin Mocha is the active theme).
3. **`persistence.nvim`:** Disabled because session restoration keymaps were replaced with per-tab buffer closing (`Snacks.bufdelete`), eliminating unnecessary disk writes.
4. **`nvim-lint`:** Disabled because diagnostics are provided directly by LSP servers and formatting is handled by `conform.nvim`.
5. **`flash.nvim`:** Disabled to preserve standard Neovim `s`/`S` editing motions without unexpected search hijacking.
6. **`lazygit` integration:** Removed from in-editor bindings so Git operations remain isolated in dedicated terminal tabs per user preference.
