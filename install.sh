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

# Hyprland (Wayland) session and the tools its config uses
HYPRLAND_PACKAGES=(
    hyprland hyprlock hypridle hyprpolkitagent hyprshutdown
    xdg-desktop-portal-hyprland qt5-wayland qt6-wayland
    swaybg dunst libnotify
    grim slurp wl-clipboard cliphist jq
    brightnessctl playerctl
)

# Waybar from its main branch: the 0.15.0 release can't switch workspaces on
# click under Hyprland's Lua config (Alexays/Waybar#5008). Go back to the
# `waybar` package once a release includes the fix.
HYPRLAND_AUR_PACKAGES=(waybar-git)

AUR_PACKAGES=(betterlockscreen i3lock-color sddm-astronaut-theme)

# pacman_install pkg... — installs what's in the repos, skips the rest
pacman_install() {
    local available=()
    local missing=()
    local provided=()

    for pkg in "$@"; do
        # Skip packages another installed package already provides, e.g.
        # docker-desktop provides (and conflicts with) docker-compose.
        # --needed doesn't catch this, and --noconfirm would refuse the
        # removal prompt and abort the whole transaction.
        local provider
        provider=$(pacman -Qq "$pkg" 2>/dev/null || true)
        if [[ -n "$provider" && "$provider" != "$pkg" ]]; then
            provided+=("$pkg (by $provider)")
        elif pacman -Si "$pkg" &>/dev/null; then
            available+=("$pkg")
        else
            missing+=("$pkg")
        fi
    done

    if (( ${#provided[@]} > 0 )); then
        info "Already provided by installed packages (skipping): ${provided[*]}"
    fi

    if (( ${#missing[@]} > 0 )); then
        warn "Not in repos (skipping): ${missing[*]}"
    fi

    if (( ${#available[@]} > 0 )); then
        info "Installing ${#available[@]} packages..."
        sudo pacman -S --needed --noconfirm "${available[@]}"
        success "Packages installed"
    fi
}

install_packages() {
    # Full upgrade: -Sy alone followed by -S is a partial upgrade and can break deps
    info "Upgrading system..."
    sudo pacman -Syu --noconfirm

    local packages=(
        # WM & desktop
        i3-wm i3status i3lock
        picom rofi feh copyq dmenu
        flameshot xdotool xclip
        xorg-server xorg-xinit

        # Login screen (themed with sddm-astronaut-theme from the AUR)
        sddm

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
        # gvfs gives Thunar its Trash (Delete moves files there)
        ranger thunar gvfs baobab

        # Utilities
        htop lsof tar unzip zip unrar p7zip
        which neofetch lazygit
        dbus

        # Hyprland session
        "${HYPRLAND_PACKAGES[@]}"
    )

    pacman_install "${packages[@]}"
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

# install_aur_packages pkg... — installs each from the AUR unless already there
install_aur_packages() {
    local pkg release
    for pkg in "$@"; do
        if pacman -Qi "$pkg" &>/dev/null; then
            success "$pkg already installed"
        else
            # foo-git conflicts with foo, and --noconfirm answers "no" to the
            # removal prompt, so take the release package out first
            release="${pkg%-git}"
            if [[ "$release" != "$pkg" && "$(pacman -Qq "$release" 2>/dev/null)" == "$release" ]]; then
                info "Replacing $release with $pkg..."
                sudo pacman -Rdd --noconfirm "$release"
            fi
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

deploy_config_dir() {
    local dir="$1"
    if [[ -d "$DOTFILES_DIR/configs/$dir" ]]; then
        # Already a symlink to the repo: edits are live, nothing to copy
        if [[ "$HOME/.config/$dir" -ef "$DOTFILES_DIR/configs/$dir" ]]; then
            success "  $dir -> ~/.config/$dir (linked)"
            return
        fi
        mkdir -p "$HOME/.config/$dir"
        cp -r "$DOTFILES_DIR/configs/$dir/." "$HOME/.config/$dir/"
        success "  $dir -> ~/.config/$dir"
    fi
}

# Only what the Hyprland session needs (used by `./install.sh hyprland`)
deploy_hyprland_configs() {
    info "Deploying Hyprland configs..."
    local dir
    for dir in hypr waybar dunst rofi alacritty xdg-desktop-portal; do
        deploy_config_dir "$dir"
    done

    # Wallpapers live with the i3 config and are shared by both sessions
    if [[ ! "$HOME/.config/i3/Wallpapers" -ef "$DOTFILES_DIR/configs/i3/Wallpapers" ]]; then
        mkdir -p "$HOME/.config/i3/Wallpapers"
        cp -r "$DOTFILES_DIR/configs/i3/Wallpapers/." "$HOME/.config/i3/Wallpapers/"
    fi
    success "  wallpapers -> ~/.config/i3/Wallpapers"

    # Check the config against the installed Hyprland version
    if command -v Hyprland &>/dev/null; then
        local result
        result=$(Hyprland --verify-config -c "$HOME/.config/hypr/hyprland.lua" 2>&1 || true)
        if grep -q '^config ok' <<< "$result"; then
            success "Hyprland config verified"
        else
            warn "Hyprland reports config errors. See: Hyprland --verify-config"
        fi
    fi
}

deploy_configs() {
    info "Deploying configs..."
    mkdir -p "$HOME/.config"

    local config_dirs=(alacritty i3 picom rofi betterlockscreen xdg-desktop-portal hypr waybar dunst)
    for dir in "${config_dirs[@]}"; do
        deploy_config_dir "$dir"
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

SDDM_THEME_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"

setup_sddm() {
    if ! pacman -Qi sddm &>/dev/null; then
        warn "sddm is not installed, skipping login screen setup"
        return
    fi

    info "Configuring SDDM login screen..."
    sudo install -Dm644 "$DOTFILES_DIR/configs/sddm/sddm.conf" /etc/sddm.conf.d/10-dotfiles.conf
    success "  sddm.conf -> /etc/sddm.conf.d/10-dotfiles.conf"

    if [[ -d "$SDDM_THEME_DIR" ]]; then
        # SDDM runs as its own user and can't read ~, so the wallpaper lives in the theme dir
        sudo install -Dm644 "$DOTFILES_DIR/configs/i3/Wallpapers/Arch-Black.jpg" \
            "$SDDM_THEME_DIR/Backgrounds/dotfiles.jpg"
        # "<ConfigFile>.user" overrides the theme's config and survives package updates
        sudo install -Dm644 "$DOTFILES_DIR/configs/sddm/astronaut.conf.user" \
            "$SDDM_THEME_DIR/Themes/astronaut.conf.user"
        success "  sddm-astronaut-theme configured"
    else
        warn "sddm-astronaut-theme not found; SDDM will use its default theme"
    fi

    # -f takes over the display-manager.service alias from any other DM.
    # No --now: starting SDDM here would end the current graphical session.
    sudo systemctl enable -f sddm.service
    success "SDDM enabled (takes over on next boot)"
}

remove_other_greeters() {
    # Never leave the system without a login screen
    if [[ "$(readlink -f /etc/systemd/system/display-manager.service 2>/dev/null)" != */sddm.service ]]; then
        warn "SDDM is not the active display manager; keeping other greeters"
        return
    fi

    local candidates=(
        cosmic-greeter
        greetd greetd-agreety greetd-tuigreet greetd-regreet greetd-gtkgreet nwg-hello
        lightdm lightdm-gtk-greeter lightdm-slick-greeter lightdm-webkit2-greeter
        web-greeter nody-greeter
        gdm ly lxdm xorg-xdm
    )
    local installed=()
    for pkg in "${candidates[@]}"; do
        if pacman -Qi "$pkg" &>/dev/null; then
            installed+=("$pkg")
        fi
    done

    if (( ${#installed[@]} == 0 )); then
        success "No other display managers or greeters installed"
        return
    fi

    info "Removing other display managers and greeters: ${installed[*]}"
    if sudo pacman -Rns --noconfirm "${installed[@]}"; then
        success "Only SDDM is left"
    else
        warn "Could not remove them (another package may depend on one). Try manually:"
        warn "  sudo pacman -Rns ${installed[*]}"
    fi
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
    # ./install.sh sddm — only set up the login screen, using this checkout
    if [[ "${1:-}" == "sddm" ]]; then
        DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        check_arch
        sudo pacman -S --needed --noconfirm sddm
        install_yay
        install_aur_packages "${AUR_PACKAGES[@]}"
        setup_sddm
        remove_other_greeters
        echo ""
        success "Reboot to see the new login screen"
        return
    fi

    # ./install.sh hyprland — only set up the Hyprland session, using this checkout
    if [[ "${1:-}" == "hyprland" ]]; then
        DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        check_arch
        info "Upgrading system..."
        sudo pacman -Syu --noconfirm
        pacman_install "${HYPRLAND_PACKAGES[@]}" rofi alacritty thunar gvfs pavucontrol network-manager-applet ttf-hack-nerd
        install_yay
        install_aur_packages "${HYPRLAND_AUR_PACKAGES[@]}"
        deploy_hyprland_configs
        echo ""
        success "Log out, pick \"Hyprland\" at the login screen, then press SUPER + / for all keybinds"
        return
    fi

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
    install_aur_packages "${AUR_PACKAGES[@]}" "${HYPRLAND_AUR_PACKAGES[@]}"
    install_oh_my_zsh
    install_tpm
    install_neovim_config
    deploy_configs
    setup_sddm
    remove_other_greeters
    set_default_shell
    enable_services
    enable_audio

    echo ""
    echo -e "${GREEN}==============================${NC}"
    echo -e "${GREEN}  Setup complete!             ${NC}"
    echo -e "${GREEN}==============================${NC}"
    echo ""
    echo "  1. Log out and back in (zsh will be your default shell)"
    echo "  2. Select i3 or Hyprland at the login screen (in Hyprland, SUPER + / lists all keybinds)"
    echo "  3. In tmux, press Ctrl+a then I to install plugins"
    echo ""
}

main "$@"
