<h1 align="center">My Dotfiles</h1>

<h2>Tables of Contents</h2>
<div>

**No.**|**Application**|**Source**
-----|-----|-----
|1. | **OS** | [**Arch Linux**](https://archlinux.org/download/)|
|2. | **WM** | [**i3**](https://i3wm.org/)|
|3. | **Editor** | [**NeoVim**](https://neovim.io/)|
|4. | **Terminal** | [**alacritty**](https://github.com/alacritty/alacritty)|
|5. | **Multiplexer** | [**tmux**](https://github.com/tmux/tmux)|
|6. | **Audio** | [**pulseaudio**](https://www.freedesktop.org/wiki/Software/PulseAudio/)|  
|7. | **Monitor** | [**gtop**](https://github.com/aksakalli/gtop)|
|8. | **File Manager** | [**ranger**](https://github.com/ranger/ranger)|
</div>

## Installation

From the repository root:

```bash
chmod +x install.sh
./install.sh
```

The script:

1. Detects the distro with `packages/utils/find-os.sh`
2. Installs packages from `packages/core/<distro>-packages.txt` via the matching script under `packages/scripts/`
3. Copies `.tmux.conf`, `.xinitrc`, and `.zshrc` into your home directory
4. Installs the Neovim config with `packages/utils/install-neovim.sh` (clones [nvim](https://github.com/nishu-murmu/nvim) into `~/.config/nvim`)

Additional configs (for example `i3/`, `alacritty/`, `picom/`, `rofi/`, `betterlockscreen/`) live in this repo but are not deployed by `install.sh`; link or copy them into `~/.config` (or the paths your tools expect) as needed.

## Installer support

The desktop setup is primarily built around Arch Linux and i3. Package installation is handled with native shell scripts (Ansible playbooks were removed in favor of bash).

Supported distro families:

- Arch-based systems via `pacman` (`packages/scripts/arch-install.sh`)
- Debian and Ubuntu-based systems via `apt` (`packages/scripts/ubuntu-install.sh`)
- Fedora-based systems via `dnf` (`packages/scripts/fedora-install.sh`)

Package names differ between distros, so the Ubuntu and Fedora lists in `packages/core/` are trimmed where a package is Arch- or AUR-specific (for example `google-chrome` and `gtop` on non-Arch lists).
