<div align="center">

<h1 align="center">My Dotfiles</h1>

</div>

<h2 align="center">Tables of Contents</h2>
<div align="center">

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

## Installer support

The desktop setup in this repository is still primarily built around Arch Linux and BSPWM, but the Ansible package installation now supports these distro families as well:

- Arch-based systems via `pacman`
- Debian and Ubuntu-based systems via `apt`
- Fedora-based systems via `dnf`

Package names are not identical across distros, so the non-Arch package lists are slightly trimmed where a package is Arch or AUR-specific, such as `google-chrome` and `gtop`.
