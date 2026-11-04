# dotfiles

Arch Linux with i3 (X11) and Hyprland (Wayland), Gruvbox dark.

```bash
curl -fsSL https://raw.githubusercontent.com/nishu-murmu/dotfiles/main/install.sh | bash
```

| Desktop | Docs | Install only this |
|---------|------|-------------------|
| i3 | [docs/i3.md](docs/i3.md) | default install |
| Hyprland | [docs/hyprland.md](docs/hyprland.md) | `./install.sh hyprland` |

## Shared

- **Login screen:** SDDM with `sddm-astronaut-theme`. Redo with `./install.sh sddm`. Theme settings: `configs/sddm/astronaut.conf.user`.
- **Audio:** PipeWire. No sound: `alsamixer` (`F6` card, `M` unmute) or `systemctl --user restart pipewire pipewire-pulse wireplumber`.
- **tmux:** prefix `Ctrl+a`. Install plugins with prefix then `I`.
- **zsh:** `Ctrl+f` tmux sessions, `Ctrl+s` cheat.sh, `Ctrl+e` detach tmux.

## Layout

```
configs/   ~/.config/*
home/      ~/.zshrc, ~/.tmux.conf, ~/.xinitrc
scripts/   ~/.local/Scripts/
docs/      per-desktop docs
```
