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

**File pickers:** `xdg-desktop-portal` with the GTK backend (`xdg-desktop-portal-gtk`) and `xdg-utils`. These power the "Open File" and "Choose Folder" dialogs.

**Audio:** ALSA drivers and firmware (`alsa-utils`, `alsa-firmware`, `alsa-ucm-conf`, `sof-firmware`) plus the PipeWire sound server (`pipewire`, `pipewire-alsa`, `pipewire-pulse`, `pipewire-jack`, `wireplumber`) and `pavucontrol`. PulseAudio is removed if present.

**Login screen:** `sddm` with `sddm-astronaut-theme`. Any other display manager or greeter (COSMIC Greeter, greetd, LightDM, GDM, Ly, …) is removed, so SDDM is the only one left.

**AUR (via yay):** betterlockscreen, i3lock-color, sddm-astronaut-theme

**Extras:** Oh My Zsh + zsh-autosuggestions, TPM (tmux plugin manager), Hack Nerd Font, Neovim config, PipeWire user services (`pipewire`, `pipewire-pulse`, `wireplumber`)

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
| Xinit | `~/.xinitrc` (also sets `GTK_USE_PORTAL=1`) |
| XDG Desktop Portal | `~/.config/xdg-desktop-portal/portals.conf` |
| Neovim | `~/.config/nvim/` |
| Scripts | `~/.local/Scripts/` |
| SDDM | `/etc/sddm.conf.d/10-dotfiles.conf` |
| SDDM theme | `/usr/share/sddm/themes/sddm-astronaut-theme/Themes/astronaut.conf.user` |

## Login Screen

SDDM uses `sddm-astronaut-theme`, styled to match the desktop: the `Arch-Black.jpg` wallpaper (same as the lock screen), Hack Nerd Font and Gruvbox dark colors. The session menu lists both i3 and Hyprland.

To set up only the login screen from a local checkout (installs SDDM, switches to it and removes other greeters):

```bash
./install.sh sddm
```

Then reboot. Don't start SDDM with `systemctl start` from inside a session, because that ends the session.

To change the look, edit `configs/sddm/astronaut.conf.user` and run `./install.sh sddm` again. Any key from the theme's `Themes/astronaut.conf` can be overridden there. To use a different wallpaper, change the `Arch-Black.jpg` path in `setup_sddm` in `install.sh`.

To preview the theme without logging out:

```bash
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sddm-astronaut-theme
```

## Audio

Audio is set up as two layers:

- **ALSA** (kernel drivers + firmware): `alsa-firmware` and `sof-firmware` cover most laptop and desktop sound chips.
- **PipeWire** (sound server): handles playback, Bluetooth, and volume routing. `pipewire-pulse` exposes the PulseAudio API, so `pactl` and the i3 volume keys keep working.

Manage volume with `pavucontrol` or `alsamixer`.

### ALSA only (no sound server)

If you don't want PipeWire, skip the audio services and use ALSA directly:

```bash
sudo pacman -S alsa-utils alsa-firmware
alsamixer   # F6 to pick the card, M to unmute
```

### Troubleshooting

| Problem | Fix |
|---------|-----|
| No sound / muted | Run `alsamixer`, press `F6` to pick the card, and `M` to unmute |
| No sound after install | `systemctl --user status pipewire wireplumber`, then restart them with `systemctl --user restart pipewire pipewire-pulse wireplumber` |
| File picker doesn't open ("Open File" / "Choose Folder") | Check that `xdg-desktop-portal` and `xdg-desktop-portal-gtk` are installed, then restart the portal with `/usr/lib/xdg-desktop-portal --replace &`. If it still fails, log out and back in so `.xinitrc` and the i3 startup line take effect. |
| Flatpak app file picker still broken | Install the backend that matches your toolkit, for example `xdg-desktop-portal-kde` for Qt apps |
| Popping on Intel HDA (`snd_hda_intel`) | Disable power saving in `/etc/modprobe.d/alsa-base.conf`: `options snd_hda_intel power_save=0 power_save_controller=N`, then reboot. This uses more power on battery. |

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
4. Audio: the install enables PipeWire for your user. If that step warned, run `systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service` after logging in.

## Structure

```
configs/         # ~/.config/ files (i3, alacritty, picom, rofi, betterlockscreen)
home/            # Home directory dotfiles (.zshrc, .tmux.conf, .xinitrc)
scripts/         # Utility scripts deployed to ~/.local/Scripts/
install.sh       # One-command setup script
```
