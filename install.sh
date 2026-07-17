#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Giving scripts permissions
chmod +x "$REPO_DIR/packages/utils/find-os.sh"
chmod +x "$REPO_DIR/packages/utils/install-neovim.sh"
chmod +x "$REPO_DIR/packages/scripts/arch-install.sh"
chmod +x "$REPO_DIR/packages/scripts/ubuntu-install.sh"
chmod +x "$REPO_DIR/packages/scripts/fedora-install.sh"

OS="$("$REPO_DIR/packages/utils/find-os.sh")"

# Core Utils installation, OS wise.
case "$OS" in
    arch)
        echo "OS Found: Arch Linux"
        echo "Installing Arch Packages..."
        "$REPO_DIR/packages/scripts/arch-install.sh"
        ;;
    ubuntu)
        echo "OS Found: Ubuntu/Debian"
        echo "Installing Ubuntu/Debian Packages..."
        "$REPO_DIR/packages/scripts/ubuntu-install.sh"
        ;;
    fedora)
        echo "OS Found: Fedora"
        echo "Installing Fedora Packages..."
        "$REPO_DIR/packages/scripts/fedora-install.sh"
        ;;
    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Post Installation scripts

echo "Moving config files..."
cp "$REPO_DIR/.tmux.conf" "$REPO_DIR/.xinitrc" "$REPO_DIR/.zshrc" "$HOME/"

echo "Installing Neovim config..."
"$REPO_DIR/packages/utils/install-neovim.sh"
