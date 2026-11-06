# IdeaVim Configuration (JetBrains IDEs)

A production-ready `.ideavimrc` configuration file designed to bring the exact muscle memory, synchronized keybindings, and smooth workflow of **Vim Stack** to the JetBrains IDE family (IntelliJ IDEA, WebStorm, PyCharm, Rider, DataGrip, GoLand, CLion, Android Studio).

---

## 🚀 Quick Installation

Copy or symlink `.ideavimrc` to your home directory:

### Symlink (Recommended)
```bash
ln -sf "$(pwd)/.ideavimrc" ~/.ideavimrc
```

### Direct Copy
```bash
cp .ideavimrc ~/.ideavimrc
```

Then in your JetBrains IDE:
1. Ensure the **IdeaVim** plugin is installed and enabled (Settings -> Plugins -> IdeaVim).
2. Reload IdeaVim config via `:source ~/.ideavimrc` or simply restart the IDE.

---

## ⌨️ Leader Key

The **Space** bar is configured as the leader key (`let mapleader = " "`).
Any shortcut formatted as `<leader>x` means: press `Space`, then `x`.

---

## 📋 Synchronized Keybindings Reference

### Tab & Buffer Navigation
| Shortcut | Mode | Action | JetBrains Action ID |
| :--- | :---: | :--- | :--- |
| `H` / `L` | Normal | Switch to previous / next editor tab | `PreviousTab` / `NextTab` |
| `Alt + 1..9` | Normal | Jump directly to tab 1 through 9 | `GoToTab1` .. `GoToTab9` |

### File Explorer, Search & Navigation
| Shortcut | Mode | Action | JetBrains Action ID |
| :--- | :---: | :--- | :--- |
| `<leader>e` | Normal | Toggle Project / Files sidebar | `:NERDTreeToggle` |
| `l` (in explorer) | Normal | Expand directory / Open file & focus editor | `NERDTree` |
| `h` (in explorer) | Normal | Jump to parent directory | `NERDTree` |
| `Ctrl + P` / `<leader>ff` | Normal | Find files across project | `GotoFile` |
| `Ctrl + F` / `<leader>fg` | Normal | Live Grep / Find in path | `FindInPath` |
| `<leader>fr` | Normal | Recent files popup | `RecentFiles` |
| `<leader>fb` | Normal | Switcher / open tabs | `Switcher` |
| `<leader>sr` | Normal | Replace in project | `ReplaceInPath` |
| `<Esc>` | Normal | Clear search highlight | `:nohlsearch` |

### Splits & Window Management
| Shortcut | Mode | Action | JetBrains Action ID |
| :--- | :---: | :--- | :--- |
| `<leader>\|` | Normal | Vertical split | `SplitVertically` |
| `<leader>-` | Normal | Horizontal split | `SplitHorizontally` |
| `Ctrl + h` / `Ctrl + l` | Normal | Navigate between Explorer & Code / splits | `VimEverywhere` / `<C-w>h/l` |
| `Ctrl + j` / `Ctrl + k` | Normal | Navigate splits / bottom tool windows | `VimEverywhere` / `<C-w>j/k` |
| `Ctrl + w w` | Normal | Cycle between windows / explorer | `<C-w>w` |
| `Ctrl + Arrows` | Normal | Resize active split window | `ResizeToolWindow*` |

### Code Actions, Formatting & Navigation
| Shortcut | Mode | Action | JetBrains Action ID |
| :--- | :---: | :--- | :--- |
| `<leader>ca` | Normal | Show Intentions / Quick Fixes | `ShowIntentionActions` |
| `<leader>rn` | Normal | Rename symbol across project | `RenameElement` |
| `<leader>cf` | Normal | Reformat code | `ReformatCode` |
| `Alt + j` / `Alt + k` | Normal / Visual | Move active line(s) down / up | `MoveLineDown` / `MoveLineUp` |
| `gcc` / `gc` | Normal / Visual | Toggle comment line / block | `set commentary` |
| `<` / `>` | Visual | Continuous visual indentation | Native `<gv` / `>gv` |
| `Ctrl + /` / `<leader>ft` | Normal | Toggle Integrated Terminal | `ActivateTerminalToolWindow` |
| `gd` | Normal | Go to Declaration / Definition | `GotoDeclaration` |
| `gr` | Normal | Find Usages / References | `FindUsages` |
| `gi` | Normal | Go to Implementation | `GotoImplementation` |
| `K` | Normal | Quick Documentation preview | `QuickJavaDoc` |
| `[d` / `]d` | Normal | Previous / Next inspection error | `GotoPreviousError` / `GotoNextError` |
