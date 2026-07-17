# Giving scripts permissions
chmod +x ./packages/utils/find-os.sh
chmod +x ./packages/utils/install-neovim.sh
chmod +x ./packages/arch-install.sh
chmod +x ./packages/ubuntu-install.sh
chmod +x ./packages/fedora-install.sh

OS=$(./packages/utils/find-os.sh)

echo "$OS"

# Core Utils installation, OS wise.
case "$OS" in
    arch)
        echo "OS Found: Arch Linux"
        echo "Installing Arch Packages..."
        ./packages/arch-install.sh
        ;;
    ubuntu)
        echo "OS Found: Ubuntu/Debian"
        echo "Installing Ubuntu/Debian Packages..."
        ./packages/ubuntu-install.sh
        ;;
    fedora)
        echo "OS Found: Fedora"
        echo "Installing Fedora Packages..."
        ./packages/fedora-install.sh
        ;;
esac

# Post Installation scripts

echo "Moving config files..."
cp .tmux.conf .xinitrc .zshrc ~/

echo "Installing Neovim..."
./packages/utils/install-neovim.sh