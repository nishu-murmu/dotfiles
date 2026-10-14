# Arch Linux + i3 Dotfiles

My personal dotfiles for Arch Linux with i3 window manager.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/nishu-murmu/dotfiles/main/install.sh | bash
```

Or clone and run manually:

```bash
git clone https://github.com/nishu-murmu/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && chmod +x install.sh && ./install.sh
```

## What Gets Installed

**Packages:** i3-wm, alacritty, tmux, neovim, picom, rofi, feh, zsh, fzf, ripgrep, lazygit, docker, go, flameshot, copyq, and more.

**AUR (via yay):** betterlockscreen, i3lock-color

**Extras:** Oh My Zsh + zsh-autosuggestions, TPM (tmux plugin manager), Hack Nerd Font, Neovim config

## What Gets Configured

| Config | Location |
|--------|----------|
| i3 | `~/.config/i3/config` |
| Alacritty | `~/.config/alacritty/alacritty.toml` |
| Picom | `~/.config/picom/picom.conf` |
| Rofi | `~/.config/rofi/config.rasi` |
| Betterlockscreen | `~/.config/betterlockscreen/betterlockscreenrc` |
| Zsh | `~/.zshrc` |
| Tmux | `~/.tmux.conf` |
| Xinit | `~/.xinitrc` |
| Neovim | `~/.config/nvim/` |
| Scripts | `~/.local/Scripts/` |

## Keybindings

### i3

| Key | Action |
|-----|--------|
| `Mod+Enter` | Open Alacritty (zsh) |
| `Mod+d` | Rofi launcher |
| `Mod+Shift+q` | Kill window |
| `Mod+Shift+s` | Flameshot screenshot |
| `Mod+c` | CopyQ clipboard |
| `Mod+x` | Lock screen |
| `Mod+1-0` | Switch workspace |

### Zsh

| Key | Action |
|-----|--------|
| `Ctrl+f` | Tardis - fzf tmux session launcher |
| `Ctrl+s` | Infobank - cheat.sh lookup |
| `Ctrl+e` | Detach tmux session |

### Tmux (prefix: Ctrl+a)

| Key | Action |
|-----|--------|
| `v` | Split vertical |
| `h` | Split horizontal |
| `r` | Reload config |
| `Ctrl+h/j/k/l` | Navigate panes |

## Post-Install

1. Log out and back in (zsh becomes default shell)
2. Select **i3** at the login screen
3. In tmux, press `Ctrl+a` then `I` to install plugins

## Structure

```
configs/         # ~/.config/ files (i3, alacritty, picom, rofi, betterlockscreen)
home/            # Home directory dotfiles (.zshrc, .tmux.conf, .xinitrc)
scripts/         # Utility scripts deployed to ~/.local/Scripts/
install.sh       # One-command setup script
```
