#!/usr/bin/env bash
# Core Neovim runtime and package dependencies installer (Arch, Debian/Ubuntu, Fedora, macOS)
set -euo pipefail

SUDO=""
[ "$(id -u)" -ne 0 ] && command -v sudo >/dev/null 2>&1 && SUDO="sudo"

if command -v pacman >/dev/null 2>&1; then
	echo "==> Installing core Neovim dependencies via pacman..."
	$SUDO pacman -S --needed --noconfirm \
		neovim git ripgrep fd curl unzip base-devel \
		wl-clipboard xclip nodejs npm python python-pip

elif command -v apt-get >/dev/null 2>&1; then
	echo "==> Installing core Neovim dependencies via apt..."
	$SUDO apt-get update -y
	$SUDO apt-get install -y \
		neovim git ripgrep fd-find curl unzip build-essential \
		wl-clipboard xclip nodejs npm python3 python3-pip python3-venv

elif command -v dnf >/dev/null 2>&1; then
	echo "==> Installing core Neovim dependencies via dnf..."
	$SUDO dnf install -y \
		neovim git ripgrep fd-find curl unzip @development-tools \
		wl-clipboard xclip nodejs npm python3 python3-pip

elif [ "$(uname -s)" = "Darwin" ] && command -v brew >/dev/null 2>&1; then
	echo "==> Installing core Neovim dependencies via Homebrew..."
	brew install neovim git ripgrep fd curl unzip node python3

else
	echo "Error: Unsupported package manager. Please install core dependencies manually:" >&2
	echo "neovim, git, ripgrep, fd, curl, unzip, gcc/make, wl-clipboard/xclip, nodejs, npm, python3" >&2
	exit 1
fi

# Ensure 'fd' command is available if distro installed it as 'fdfind' (Debian/Ubuntu/Fedora)
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
	mkdir -p "$HOME/.local/bin"
	ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
	echo "==> Linked $(command -v fdfind) to $HOME/.local/bin/fd"
fi

echo "==> Core dependencies installed successfully!"
