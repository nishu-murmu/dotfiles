OS=./packages/utils/find-os.sh

echo "$OS"

# Core Utils installation, OS wise.
case "$OS" in
    arch)
        echo "OS Found: Arch Linux"
        echo "Installing Arch Packages..."
        ./arch-install.sh
        ;;
    ubuntu)
        echo "OS Found: Ubuntu/Debian"
        echo "Installing Ubuntu/Debian Packages..."
        ./ubuntu-install.sh
        ;;
    fedora)
        echo "OS Found: Fedora"
        echo "Installing Fedora Packages..."
        ./fedora-install.sh
        ;;
esac

# Post Installation scripts

echo "Moving config files..."
cp .tmux.conf .xinitrc .zshrc ~/

echo "Installing Neovim..."
./packages/utils/install-neovim.sh