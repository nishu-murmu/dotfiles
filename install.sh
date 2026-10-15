#!/usr/bin/env bash

set -euo pipefail

DOTFILES_REPO="https://github.com/nishu-murmu/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}::${NC} $1"; }
success() { echo -e "${GREEN}::${NC} $1"; }
warn()    { echo -e "${YELLOW}::${NC} $1"; }
error()   { echo -e "${RED}::${NC} $1"; }

check_arch() {
    if [[ ! -f /etc/os-release ]]; then
        error "/etc/os-release not found"
        exit 1
    fi
    source /etc/os-release
    if [[ "$ID" != "arch" && "$ID" != "archlinux" ]]; then
        error "This script is for Arch Linux. Detected: $ID"
        exit 1
    fi
    success "Arch Linux detected"
}

clone_dotfiles() {
    if [[ -d "$DOTFILES_DIR/.git" ]]; then
        info "Dotfiles repo exists, pulling latest..."
        git -C "$DOTFILES_DIR" pull --ff-only 2>/dev/null || warn "Could not pull (offline or conflicts)"
    else
        info "Cloning dotfiles..."
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    fi
    success "Dotfiles ready at $DOTFILES_DIR"
}

remove_pulseaudio() {
    # PipeWire's pipewire-pulse conflicts with PulseAudio, so drop it first
    local legacy=()
    for pkg in pulseaudio pulseaudio-alsa; do
        if pacman -Qi "$pkg" &>/dev/null; then
            legacy+=("$pkg")
        fi
    done

    if (( ${#legacy[@]} > 0 )); then
        info "Removing PulseAudio (replaced by PipeWire): ${legacy[*]}"
        sudo pacman -Rns --noconfirm "${legacy[@]}"
    fi
}

install_packages() {
    info "Updating package database..."
    sudo pacman -Sy --noconfirm

    local packages=(
        # WM & desktop
        i3-wm i3status i3lock
        picom rofi feh copyq dmenu
        flameshot xdotool xclip
        xorg-server xorg-xinit

        # Terminal & shell
        alacritty zsh tmux

        # Editor
        neovim

        # Fonts
        ttf-hack-nerd

        # Dev tools
        git curl wget fzf ripgrep
        docker docker-compose
        go rust-analyzer python
        tree-sitter-cli

        # Audio: ALSA drivers + firmware, PipeWire sound server (replaces PulseAudio)
        alsa-utils alsa-firmware alsa-ucm-conf sof-firmware
        pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
        pavucontrol

        # File pickers: XDG Desktop Portal with GTK backend (i3 has no portal by default)
        xdg-desktop-portal xdg-desktop-portal-gtk xdg-utils

        # Networking
        networkmanager network-manager-applet
        wpa_supplicant

        # File management
        ranger thunar baobab

        # Utilities
        htop lsof tar unzip zip unrar p7zip
        which neofetch lazygit
        dbus
    )

    local available=()
    local missing=()

    for pkg in "${packages[@]}"; do
        if pacman -Si "$pkg" &>/dev/null; then
            available+=("$pkg")
        else
            missing+=("$pkg")
        fi
    done

    if (( ${#missing[@]} > 0 )); then
        warn "Not in repos (skipping): ${missing[*]}"
    fi

    if (( ${#available[@]} > 0 )); then
        info "Installing ${#available[@]} packages..."
        sudo pacman -S --needed --noconfirm "${available[@]}"
        success "Packages installed"
    fi
}

install_yay() {
    if command -v yay &>/dev/null; then
        success "yay already installed"
        return
    fi
    info "Installing yay (AUR helper)..."
    local tmp_dir
    tmp_dir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay"
    (cd "$tmp_dir/yay" && makepkg -si --noconfirm)
    rm -rf "$tmp_dir"
    success "yay installed"
}

install_aur_packages() {
    local aur_packages=(betterlockscreen i3lock-color)
    for pkg in "${aur_packages[@]}"; do
        if pacman -Qi "$pkg" &>/dev/null; then
            success "$pkg already installed"
        else
            info "Installing $pkg from AUR..."
            yay -S --noconfirm "$pkg" || warn "Failed to install $pkg"
        fi
    done
}

install_oh_my_zsh() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        success "Oh My Zsh already installed"
    else
        info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        success "Oh My Zsh installed"
    fi

    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    if [[ -d "$zsh_custom/plugins/zsh-autosuggestions" ]]; then
        success "zsh-autosuggestions already installed"
    else
        info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
        success "zsh-autosuggestions installed"
    fi
}

install_tpm() {
    if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
        success "TPM already installed"
    else
        info "Installing Tmux Plugin Manager..."
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
        success "TPM installed"
    fi
}

install_neovim_config() {
    if [[ -d "$HOME/.config/nvim/.git" ]]; then
        info "Neovim config exists, pulling latest..."
        git -C "$HOME/.config/nvim" pull --ff-only 2>/dev/null || warn "Could not pull nvim config"
    else
        info "Installing Neovim config..."
        mkdir -p "$HOME/.config"
        rm -rf "$HOME/.config/nvim"
        git clone --depth 1 https://github.com/nishu-murmu/nvim.git "$HOME/.config/nvim"
        success "Neovim config installed"
    fi
}

deploy_configs() {
    info "Deploying configs..."
    mkdir -p "$HOME/.config"

    local config_dirs=(alacritty i3 picom rofi betterlockscreen xdg-desktop-portal)
    for dir in "${config_dirs[@]}"; do
        if [[ -d "$DOTFILES_DIR/configs/$dir" ]]; then
            mkdir -p "$HOME/.config/$dir"
            cp -r "$DOTFILES_DIR/configs/$dir/." "$HOME/.config/$dir/"
            success "  $dir -> ~/.config/$dir"
        fi
    done

    for file in .zshrc .tmux.conf .xinitrc; do
        cp "$DOTFILES_DIR/home/$file" "$HOME/$file"
        success "  $file -> ~/$file"
    done

    mkdir -p "$HOME/.local/Scripts"
    for script in "$DOTFILES_DIR/scripts/"*; do
        [[ -f "$script" ]] || continue
        cp "$script" "$HOME/.local/Scripts/"
        chmod +x "$HOME/.local/Scripts/$(basename "$script")"
    done
    success "  scripts -> ~/.local/Scripts/"
}

set_default_shell() {
    if [[ "$SHELL" == */zsh ]]; then
        success "zsh is already the default shell"
    else
        info "Setting zsh as default shell..."
        chsh -s "$(which zsh)"
        success "Default shell changed to zsh"
    fi
}

enable_services() {
    info "Enabling services..."
    sudo systemctl enable NetworkManager 2>/dev/null || true
    sudo systemctl enable docker 2>/dev/null || true
    sudo usermod -aG docker "$USER" 2>/dev/null || true
    success "Services configured"
}

enable_audio() {
    info "Enabling PipeWire audio services..."
    # User units need a running user session; warn instead of failing if there isn't one
    if systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service 2>/dev/null; then
        success "PipeWire audio services enabled"
    else
        warn "Could not enable PipeWire user services. Run this from your user session after login:"
        warn "  systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service"
    fi
}

main() {
    echo ""
    echo -e "${BLUE}==============================${NC}"
    echo -e "${BLUE}  Arch Linux + i3 Dotfiles    ${NC}"
    echo -e "${BLUE}==============================${NC}"
    echo ""

    check_arch
    clone_dotfiles
    remove_pulseaudio
    install_packages
    install_yay
    install_aur_packages
    install_oh_my_zsh
    install_tpm
    install_neovim_config
    deploy_configs
    set_default_shell
    enable_services
    enable_audio

    echo ""
    echo -e "${GREEN}==============================${NC}"
    echo -e "${GREEN}  Setup complete!             ${NC}"
    echo -e "${GREEN}==============================${NC}"
    echo ""
    echo "  1. Log out and back in (zsh will be your default shell)"
    echo "  2. Select i3 as your WM at the login screen"
    echo "  3. In tmux, press Ctrl+a then I to install plugins"
    echo ""
}

main "$@"
