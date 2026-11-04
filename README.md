# <p align="center">⚡ Vim Stack</p>

<p align="center">
  <img src="assets/banner.svg" alt="Vim Stack Banner" width="900" style="max-width: 100%; border-radius: 12px; box-shadow: 0 12px 24px rgba(0,0,0,0.4);" />
</p>

<p align="center">
  <strong>Dual terminal text editor configurations sharing a unified muscle memory.</strong>
</p>

![Neovim v0.10+](https://img.shields.io/badge/Neovim-v0.10+-green?logo=neovim)
![Vim 8.2+](https://img.shields.io/badge/Vim-v8.2+-green?logo=vim)
![Theme-Catppuccin_Mocha-purple](https://img.shields.io/badge/Theme-Catppuccin_Mocha-purple)
![License-MIT-yellow](https://img.shields.io/badge/License-MIT-yellow)

---

**Vim Stack** is a curated collection of dual editor configurations designed to optimize terminal text editing. It consists of a zero-plugin **Minimal Vim** setup ([`vim-editor/`](vim-editor/)) and a feature-rich, modernized **Neovim (LazyVim)** IDE ([`nvim/`](nvim/)). Both configurations are carefully synchronized so that identical keybindings trigger equivalent actions.

This dual setup allows you to switch seamlessly between:
1. **Remote Servers, SSH Sessions & Containers**: Using the lightweight, zero-plugin Vim config (`vim-editor`) which boots instantly with pure stock Vimscript.
2. **Local Machine & Heavy Development Work**: Using the modern Neovim IDE configuration (`nvim`) equipped with Rust-backed `blink.cmp` autocompletion, Mason LSPs, Treesitter syntax highlighting, `conform.nvim` formatters, `snacks.nvim`, and Excel-style CSV data visualization.

---

## 📂 Repository Structure

The project is split into two specialized workspaces:

* **[`vim-editor/`](vim-editor/)**: Classic, zero-plugin Vim setup.
  * **[`.vimrc`](vim-editor/.vimrc)**: Single-file, zero-plugin configuration using pure Vimscript (native commenting, absolute line numbers, transparent background, persistent undo auto-dir).
  * **[`README.md`](vim-editor/README.md)**: Feature list and installation details for minimal Vim.
* **[`nvim/`](nvim/)**: Modern Neovim IDE setup (Domain-Driven architecture).
  * **[`init.lua`](nvim/init.lua)**: Standardized entry point orchestrating startup.
  * **[`lua/config/`](nvim/lua/config/)**: Core options, synchronized keymaps, and event autocmds.
  * **[`lua/plugins/`](nvim/lua/plugins/)**: 6 clean domain modules (`ui`, `editor`, `coding`, `lsp`, `formatting`, `viewers`) + `disabled.lua`.
  * **[`install-deps.sh`](nvim/install-deps.sh)**: Comprehensive bash script installing OS runtimes (`ripgrep`, `fd`, compilers, node, python).
  * **[`README.md`](nvim/README.md)**: Deep dive into the Neovim setup, viewers, and keybindings.
* **[`ideavim/`](ideavim/)**: JetBrains IDEs IdeaVim integration.
  * **[`.ideavimrc`](ideavim/.ideavimrc)**: Production-ready configuration synchronized with Neovim & Vim keybindings for IntelliJ IDEA, Rider, DataGrip, PyCharm, WebStorm, and CLion.
  * **[`README.md`](ideavim/README.md)**: JetBrains action mappings and installation guide.
* **[`assets/`](assets/)**: Stores design assets, including the custom banner SVG.

---

## 🔄 Synchronized Keyboard & Behavior Parity

The leader key is set to **`Space`** across all editors (Minimal Vim, Neovim, and JetBrains IdeaVim).

| Key combination | Mode | Minimal Vim (`vim-editor`) | Neovim (`nvim`) | IdeaVim (`ideavim`) | Behavior Description |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **`H` / `L`** | Normal | `SmartBufferPrev/Next()` | `bprevious` / `bnext` | `PreviousTab` / `NextTab` | Switches to Previous / Next Tab |
| **`Alt + 1..9`** | Normal | `SmartBufferGoto(1..9)` | `bufferline.go_to(1..9)` | `GoToTab1..9` | Jumps directly to Tab 1 through 9 |
| **`<leader>e`** | Normal | `:Lexplore` (netrw) | `Snacks.explorer()` | `ActivateProjectToolWindow` | Toggles the sidebar file explorer |
| **`Ctrl + P` / `<leader>ff`** | Normal | *Via terminal / :find* | `Snacks.picker.files()` | `GotoFile` | Opens fuzzy file finder |
| **`Ctrl + F` / `<leader>fg`** | Normal | *Via terminal / grep* | `Snacks.picker.grep()` | `FindInPath` | Searches text in project (Live Grep) |
| **`<leader>sr`** | Normal | *Via substitute* | `grug-far.open()` | `ReplaceInPath` | Global workspace search & replace UI |
| **`<leader>\|`** | Normal | `:vsplit` | `:vsplit` | `SplitVertically` | Creates vertical split (side-by-side) |
| **`<leader>-`** | Normal | `:split` | `:split` | `SplitHorizontally` | Creates horizontal split (stacked) |
| **`Ctrl + h/j/k/l`** | Normal | `<C-w>h/j/k/l` | `<C-w>h/j/k/l` | `<C-w>h/j/k/l` | Navigate between split windows |
| **`Alt + j` / `Alt + k`** | Normal/Visual | Move line(s) down / up | Move line(s) down / up | `MoveLineDown` / `Up` | Move selected lines up or down |
| **`<` / `>`** | Visual | Continuous visual indent (`<gv` / `>gv`) | Continuous visual indent (`<gv` / `>gv`) | Continuous visual indent (`<gv` / `>gv`) | Indent lines while keeping selection active |
| **`gcc` / `gc`** | Normal/Visual | Native `ToggleCommentNative()` | Native `gc` / `gcc` (Treesitter) | `set commentary` | Toggles comments with language syntax |
| **`<leader>cf`** | Normal | `gg=G` | `conform.format()` | `ReformatCode` | Format current document |
| **`<leader>ca`** | Normal | *Not bound* | `vim.lsp.buf.code_action()` | `ShowIntentionActions` | Show code actions / intentions |
| **`<leader>rn`** | Normal | *Not bound* | `vim.lsp.buf.rename()` | `RenameElement` | Rename symbol across workspace |
| **`gd`** | Normal | *Via tags (:tag)* | `vim.lsp.buf.definition()` | `GotoDeclaration` | Jump to definition / declaration |
| **`gr`** | Normal | *Via search* | `Snacks.picker.lsp_references()` | `FindUsages` | Find references / usages |
| **`gi`** | Normal | *Not bound* | `vim.lsp.buf.implementation()` | `GotoImplementation` | Jump to implementation |
| **`K`** | Normal | Keywordprg (`:help`) | `vim.lsp.buf.hover()` | `QuickJavaDoc` | Quick documentation hover |
| **`<leader>cv`** | Normal | *Not bound* | `csvview.toggle()` | *Not bound* | Toggle CSV/TSV Office spreadsheet grid |
| **`<leader>cp`** | Normal | *Not bound* | Floating `less -S` | *Not bound* | Open massive CSV in fast Pager |
| **`<leader>um`** | Normal | *Not bound* | `render-markdown.toggle()` | *Not bound* | Toggle Markdown rounded tables & callouts |
| **`Ctrl + /` / `<leader>ft`** | Normal/Term | *Not bound* | `Snacks.terminal()` | `ActivateTerminalToolWindow` | Toggles integrated terminal |
| **`Esc`** | Normal | `:nohlsearch` | `:nohlsearch` | `:nohlsearch` | Clears search highlights |

---

## ⚙️ Shared Sensible Defaults

In addition to keymaps, both configurations establish consistent behaviors:
* **Absolute Line Numbers**: Native 1-to-1 line numbers enabled (`number=true`, `relativenumber=false`) matching VS Code and system editors.
* **System Clipboard Integration**: Copy, cut, and paste actions automatically synchronize with system clipboard (`clipboard=unnamedplus`) with Wayland `wl-clipboard` support.
* **Smart Tab Indentation**: Sensible indentation width, expanding tabs to spaces, with auto/smart alignment.
* **Case-Sensitive Searching**: Searches are case-insensitive by default (`ignorecase`) but switch to case-sensitive if uppercase letters are included (`smartcase`).
* **100% Terminal Transparency**: Inherits background and opacity directly from your terminal emulator across all terminal apps (Foot, Kitty, Alacritty, WezTerm, etc.).
* **Translucent Gray CursorLine**: Subtle active line highlighting using a soft gray wash (`#222222` / `ctermbg=235`) that blends gently into dark terminal themes without harsh solid blocks.
* **Transparent Buffer Tabline**: Seamless top file switching bar with zero reverse styling, matching the terminal background.
* **Zero Distraction**: Spell checking is disabled globally across all buffers.

---

## 📥 Installation & Deployment

### 1. Minimal Vim Configuration
To install the minimal zero-plugin configuration:
```bash
cp vim-editor/.vimrc ~/.vimrc
```
Launch Vim (`vim`), and it will run instantly with zero third-party plugin dependencies.

### 2. Neovim Configuration
To install the Neovim IDE configuration:

1. **Backup existing config (if any)**:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null || true
   ```

2. **Symlink or Clone repository**:
   ```bash
   git clone https://github.com/vuong-ngo/vim-stack.git /tmp/vim-stack
   cp -r /tmp/vim-stack/nvim ~/.config/nvim
   ```
   *Alternatively, if managing dotfiles locally:*
   ```bash
   ln -s "$(pwd)/nvim" ~/.config/nvim
   ```

3. **Install System Dependencies**:
   Install external tools (`ripgrep`, `fd`, compilers, node, python) using the provided script:
   ```bash
   cd ~/.config/nvim
   chmod +x install-deps.sh
   ./install-deps.sh
   ```

4. **Launch Neovim**:
   ```bash
   nvim
   ```
   On first launch, Neovim will automatically bootstrap `lazy.nvim` and initialize `blink.cmp`, LSPs, formatters, and Treesitter parsers.

### 3. JetBrains IdeaVim Configuration
To install the synchronized IdeaVim configuration for JetBrains IDEs:
```bash
ln -sf "$(pwd)/ideavim/.ideavimrc" ~/.ideavimrc
```
Or directly copy:
```bash
cp ideavim/.ideavimrc ~/.ideavimrc
```
Reload config inside IntelliJ, Rider, DataGrip, or PyCharm with `:source ~/.ideavimrc` or restart the IDE.

---

## 🛠️ System Requirements

* **Vim**: Requires Vim version `8.2+` compiled with `+termguicolors` and `+clipboard`.
* **Neovim**: Requires Neovim `v0.10+` for modern picker support and Treesitter parsers.
* **Font**: A [Nerd Font](https://www.nerdfonts.com/) (e.g. JetBrainsMono Nerd Font) is recommended for icons.
