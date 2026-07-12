#!/usr/bin/env bash
#
# install-deps.sh — installs everything this LazyVim config needs to run
# well, based on what's actually referenced in lua/plugins/*.lua and
# lazy-lock.json (not a generic "nice to have" list).
#
# What gets installed and why:
#   - Neovim >= 0.10        required for built-in gc/gcc commenting (see README)
#   - git                    lazy.nvim clones plugins with it
#   - a C compiler + make    nvim-treesitter compiles parsers on install
#   - ripgrep, fd            used by every Snacks picker (find/grep files)
#   - Node.js + npm          runtime for the npm-based LSP servers/formatters
#                            Mason installs (pyright, bashls, jsonls, yamlls,
#                            prettier)
#   - Python3 + pip + venv   Mason builds a venv for Python-based tools
#                            (black, isort) and for pyright itself
#   - a JDK (Java 17+)       needed by jdtls (Java LSP) and lemminx (XML LSP)
#   - unzip                  Mason needs it to unpack some downloaded tools
#   - xclip / wl-clipboard   system clipboard integration (X11 / Wayland)
#   - lazygit                bound to <leader>gg via Snacks.lazygit()
#   - a Nerd Font            icons used by Snacks, lualine, mini.icons, etc.
#
# Everything else (pyright, jdtls, rust_analyzer, bashls, yamlls, lemminx,
# jsonls, marksman, lua_ls, black, isort, shfmt, stylua, prettier) is
# installed automatically by Mason the first time you launch `nvim` - this
# script only provides the underlying runtimes Mason needs to do that.
#
# Supports: Debian/Ubuntu (apt), Fedora (dnf), Arch (pacman), macOS (brew).
# Safe to re-run - every step checks whether its target already exists.

set -euo pipefail

# ---------- output helpers ----------
c_reset='\033[0m'; c_bold='\033[1m'; c_green='\033[32m'; c_yellow='\033[33m'; c_red='\033[31m'
info()  { printf "${c_bold}==>${c_reset} %s\n" "$1"; }
ok()    { printf "  ${c_green}✓${c_reset} %s\n" "$1"; }
skip()  { printf "  ${c_yellow}·${c_reset} %s (already present)\n" "$1"; }
fail()  { printf "  ${c_red}✗${c_reset} %s\n" "$1"; }
has()   { command -v "$1" >/dev/null 2>&1; }

# ---------- sudo helper (no-op if already root) ----------
SUDO=""
if [ "$(id -u)" != "0" ]; then
	if has sudo; then SUDO="sudo"; else
		echo "This script needs root privileges for package installs (no 'sudo' found)." >&2
		exit 1
	fi
fi

# ---------- OS / package manager detection ----------
OS="$(uname -s)"
PKG_MGR=""
if [ "$OS" = "Linux" ]; then
	if has apt-get; then PKG_MGR="apt"
	elif has dnf; then PKG_MGR="dnf"
	elif has pacman; then PKG_MGR="pacman"
	fi
elif [ "$OS" = "Darwin" ]; then
	if has brew; then PKG_MGR="brew"
	else
		echo "Homebrew not found. Install it from https://brew.sh first, then re-run this script." >&2
		exit 1
	fi
fi

if [ -z "$PKG_MGR" ]; then
	echo "Could not detect a supported package manager (apt/dnf/pacman/brew)." >&2
	echo "Install the dependencies listed at the top of this script manually." >&2
	exit 1
fi

info "Detected OS: $OS, package manager: $PKG_MGR"

APT_UPDATED=0
apt_update_once() {
	if [ "$APT_UPDATED" = "0" ]; then
		info "Refreshing apt package lists"
		$SUDO apt-get update -y
		APT_UPDATED=1
	fi
}

# install_pkg <check-cmd> <label> <apt-pkg> <dnf-pkg> <pacman-pkg> <brew-pkg>
install_pkg() {
	local check="$1" label="$2" apt_pkg="$3" dnf_pkg="$4" pacman_pkg="$5" brew_pkg="$6"
	if has "$check"; then
		skip "$label"
		return
	fi
	info "Installing $label"
	case "$PKG_MGR" in
	apt)
		apt_update_once
		$SUDO apt-get install -y "$apt_pkg"
		;;
	dnf) $SUDO dnf install -y "$dnf_pkg" ;;
	pacman) $SUDO pacman -S --noconfirm "$pacman_pkg" ;;
	brew) brew install "$brew_pkg" ;;
	esac
	ok "$label installed"
}

# =========================================================
# 1. Base build tools + git + curl/unzip/tar
# =========================================================
install_pkg git "git" git git git git
install_pkg curl "curl" curl curl curl curl
install_pkg unzip "unzip" unzip unzip unzip unzip
if [ "$PKG_MGR" = "apt" ]; then
	install_pkg gcc "C compiler + make (build-essential)" build-essential "" "" ""
elif [ "$PKG_MGR" = "dnf" ]; then
	install_pkg gcc "C compiler + make" "" "@development-tools" "" ""
elif [ "$PKG_MGR" = "pacman" ]; then
	install_pkg gcc "C compiler + make (base-devel)" "" "" base-devel ""
elif [ "$PKG_MGR" = "brew" ]; then
	# Xcode Command Line Tools provide clang/make on macOS
	if ! xcode-select -p >/dev/null 2>&1; then
		info "Installing Xcode Command Line Tools (compiler + make)"
		xcode-select --install || true
		ok "Requested Xcode Command Line Tools (finish the GUI prompt if one appeared)"
	else
		skip "C compiler + make (Xcode Command Line Tools)"
	fi
fi

# =========================================================
# 2. Neovim >= 0.10
# =========================================================
need_nvim_install=1
if has nvim; then
	nvim_ver="$(nvim --version | head -n1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)"
	major="$(echo "$nvim_ver" | cut -d. -f1)"
	minor="$(echo "$nvim_ver" | cut -d. -f2)"
	if [ "${major:-0}" -gt 0 ] || [ "${minor:-0}" -ge 10 ]; then
		skip "Neovim $nvim_ver (>= 0.10 required)"
		need_nvim_install=0
	else
		info "Neovim $nvim_ver found, but this config needs >= 0.10 - upgrading"
	fi
else
	info "Neovim not found - installing"
fi

if [ "$need_nvim_install" = "1" ]; then
	if [ "$OS" = "Linux" ]; then
		# Distro package repos are often behind on Neovim releases, so this
		# config needs (built-in gc/gcc commenting requires 0.10+). Install
		# the official prebuilt release straight from GitHub instead of
		# relying on apt/dnf/pacman's version.
		arch="$(uname -m)"
		case "$arch" in
		x86_64) nvim_asset="nvim-linux-x86_64.tar.gz" ;;
		aarch64 | arm64) nvim_asset="nvim-linux-arm64.tar.gz" ;;
		*)
			fail "Unsupported architecture '$arch' for the official Neovim tarball; install Neovim >= 0.10 manually."
			nvim_asset=""
			;;
		esac
		if [ -n "$nvim_asset" ]; then
			tmp_dir="$(mktemp -d)"
			info "Downloading official Neovim release ($nvim_asset)"
			curl -fsSL -o "$tmp_dir/nvim.tar.gz" \
				"https://github.com/neovim/neovim/releases/latest/download/$nvim_asset"
			$SUDO rm -rf /opt/nvim
			$SUDO tar -C /opt -xzf "$tmp_dir/nvim.tar.gz"
			$SUDO mv "/opt/${nvim_asset%.tar.gz}" /opt/nvim
			$SUDO ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
			rm -rf "$tmp_dir"
			ok "Neovim installed to /opt/nvim (symlinked at /usr/local/bin/nvim)"
		fi
	elif [ "$OS" = "Darwin" ]; then
		brew install neovim
		ok "Neovim installed via Homebrew"
	fi
fi

# =========================================================
# 3. ripgrep + fd  (Snacks pickers: find files / grep project)
# =========================================================
install_pkg rg "ripgrep" ripgrep ripgrep ripgrep ripgrep

if has fd; then
	skip "fd"
elif has fdfind; then
	# Debian/Ubuntu package the binary as "fdfind" to avoid a name clash
	skip "fd (installed as 'fdfind')"
	mkdir -p "$HOME/.local/bin"
	ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
	info "Linked fdfind -> ~/.local/bin/fd (make sure ~/.local/bin is on your PATH)"
else
	info "Installing fd"
	case "$PKG_MGR" in
	apt)
		apt_update_once
		$SUDO apt-get install -y fd-find
		mkdir -p "$HOME/.local/bin"
		ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
		info "Linked fdfind -> ~/.local/bin/fd (make sure ~/.local/bin is on your PATH)"
		;;
	dnf) $SUDO dnf install -y fd-find ;;
	pacman) $SUDO pacman -S --noconfirm fd ;;
	brew) brew install fd ;;
	esac
	ok "fd installed"
fi

# =========================================================
# 4. Node.js + npm  (pyright, bashls, jsonls, yamlls, prettier via Mason)
# =========================================================
if has node && has npm; then
	skip "Node.js + npm ($(node --version))"
else
	info "Installing Node.js + npm"
	case "$PKG_MGR" in
	apt)
		apt_update_once
		$SUDO apt-get install -y nodejs npm
		;;
	dnf) $SUDO dnf install -y nodejs npm ;;
	pacman) $SUDO pacman -S --noconfirm nodejs npm ;;
	brew) brew install node ;;
	esac
	ok "Node.js + npm installed"
fi

# =========================================================
# 5. Python3 + pip + venv  (black, isort, and Mason's Python venvs)
# =========================================================
install_pkg python3 "Python 3" python3 python3 python3 python3
if [ "$PKG_MGR" = "apt" ]; then
	install_pkg pip3 "pip" python3-pip python3-pip python-pip python3
	# venv module ships separately on Debian/Ubuntu
	if ! python3 -c "import venv" >/dev/null 2>&1; then
		info "Installing python3-venv"
		apt_update_once
		$SUDO apt-get install -y python3-venv
		ok "python3-venv installed"
	else
		skip "python3 venv module"
	fi
else
	install_pkg pip3 "pip" python3-pip python3-pip python-pip python3
fi

# =========================================================
# 6. JDK (jdtls, lemminx)
# =========================================================
if has java; then
	skip "Java ($(java -version 2>&1 | head -n1))"
else
	info "Installing a JDK (needed for the Java and XML language servers)"
	case "$PKG_MGR" in
	apt)
		apt_update_once
		$SUDO apt-get install -y default-jdk
		;;
	dnf) $SUDO dnf install -y java-17-openjdk ;;
	pacman) $SUDO pacman -S --noconfirm jdk-openjdk ;;
	brew) brew install openjdk ;;
	esac
	ok "JDK installed"
fi

# =========================================================
# 7. Clipboard integration
# =========================================================
if [ "$OS" = "Linux" ]; then
	if [ -n "${WAYLAND_DISPLAY:-}" ]; then
		install_pkg wl-copy "wl-clipboard (Wayland clipboard)" wl-clipboard wl-clipboard wl-clipboard ""
	else
		install_pkg xclip "xclip (X11 clipboard)" xclip xclip xclip ""
	fi
fi

# =========================================================
# 8. lazygit  (<leader>gg via Snacks.lazygit())
# =========================================================
if has lazygit; then
	skip "lazygit"
else
	info "Installing lazygit"
	case "$PKG_MGR" in
	brew) brew install lazygit ;;
	pacman) $SUDO pacman -S --noconfirm lazygit ;;
	*)
		# Not reliably in apt/dnf repos - install the prebuilt release.
		lg_arch="$(uname -m)"
		case "$lg_arch" in
		x86_64) lg_asset="Linux_x86_64" ;;
		aarch64 | arm64) lg_asset="Linux_arm64" ;;
		*)
			fail "Unsupported architecture '$lg_arch' for the lazygit release; install it manually."
			lg_asset=""
			;;
		esac
		if [ -n "$lg_asset" ]; then
			lg_ver="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest |
				grep -oE '"tag_name":\s*"v[0-9.]+"' | grep -oE '[0-9.]+' | head -n1)"
			tmp_dir="$(mktemp -d)"
			curl -fsSL -o "$tmp_dir/lazygit.tar.gz" \
				"https://github.com/jesseduffield/lazygit/releases/download/v${lg_ver}/lazygit_${lg_ver}_${lg_asset}.tar.gz"
			tar -C "$tmp_dir" -xzf "$tmp_dir/lazygit.tar.gz" lazygit
			$SUDO install "$tmp_dir/lazygit" /usr/local/bin/lazygit
			rm -rf "$tmp_dir"
		fi
		;;
	esac
	ok "lazygit installed"
fi

# =========================================================
# 9. Nerd Font (icons for Snacks / lualine / mini.icons)
# =========================================================
if [ "$OS" = "Linux" ]; then
	font_dir="$HOME/.local/share/fonts"
	if compgen -G "$font_dir/JetBrainsMonoNerdFont-*" >/dev/null 2>&1; then
		skip "JetBrainsMono Nerd Font"
	else
		info "Installing JetBrainsMono Nerd Font"
		mkdir -p "$font_dir"
		tmp_dir="$(mktemp -d)"
		curl -fsSL -o "$tmp_dir/font.zip" \
			"https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
		unzip -oq "$tmp_dir/font.zip" -d "$font_dir" "*.ttf" "*.otf" 2>/dev/null || unzip -oq "$tmp_dir/font.zip" -d "$font_dir"
		rm -rf "$tmp_dir"
		if has fc-cache; then fc-cache -f "$font_dir" >/dev/null 2>&1; fi
		ok "JetBrainsMono Nerd Font installed to $font_dir"
		echo "    (Set your terminal's font to \"JetBrainsMono Nerd Font\" to see icons correctly.)"
	fi
elif [ "$OS" = "Darwin" ]; then
	if brew list --cask font-jetbrains-mono-nerd-font >/dev/null 2>&1; then
		skip "JetBrainsMono Nerd Font"
	else
		info "Installing JetBrainsMono Nerd Font"
		brew tap homebrew/cask-fonts >/dev/null 2>&1 || true
		brew install --cask font-jetbrains-mono-nerd-font
		ok "JetBrainsMono Nerd Font installed"
		echo "    (Set your terminal's font to \"JetBrainsMono Nerd Font\" to see icons correctly.)"
	fi
fi

# =========================================================
# Summary
# =========================================================
echo
info "Done. Versions installed:"
for tool in nvim git rg node npm python3 java lazygit; do
	if has "$tool"; then
		ver="$("$tool" --version 2>&1 | head -n1)"
		printf "  ${c_green}✓${c_reset} %-8s %s\n" "$tool" "$ver"
	else
		printf "  ${c_red}✗${c_reset} %-8s not found\n" "$tool"
	fi
done
if has fd; then printf "  ${c_green}✓${c_reset} %-8s %s\n" "fd" "$(fd --version)"; fi

echo
info "Next step: launch nvim. Mason will automatically install the LSP"
echo "servers and formatters (pyright, jdtls, rust_analyzer, bashls, yamlls,"
echo "lemminx, jsonls, marksman, lua_ls, black, isort, shfmt, stylua,"
echo "prettier) the first time it starts - that requires the runtimes"
echo "installed above (Node, Python, Java) and an internet connection."
