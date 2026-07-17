# Giving scripts permissions
chmod +x ./packages/utils/find-os.sh
chmod +x ./packages/utils/install-neovim.sh
chmod +x ./packages/scripts/arch-install.sh
chmod +x ./packages/scripts/ubuntu-install.sh
chmod +x ./packages/scripts/fedora-install.sh

OS=$(./packages/utils/find-os.sh)

echo "$OS"

# Core Utils installation, OS wise.
case "$OS" in
    arch)
        echo "OS Found: Arch Linux"
        echo "Installing Arch Packages..."
        ./packages/scripts/arch-install.sh
        ;;
    ubuntu)
        echo "OS Found: Ubuntu/Debian"
        echo "Installing Ubuntu/Debian Packages..."
        ./packages/scripts/ubuntu-install.sh
        ;;
    fedora)
        echo "OS Found: Fedora"
        echo "Installing Fedora Packages..."
        ./packages/scripts/fedora-install.sh
        ;;
esac

# Post Installation scripts

echo "Moving config files..."
cp .tmux.conf .xinitrc .zshrc ~/

echo "Installing Neovim..."
./packages/utils/install-neovim.sh