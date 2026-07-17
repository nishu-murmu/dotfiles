cd ..
SCRIPT_DIR=$(pwd)
PACKAGE_LIST_FILE="$SCRIPT_DIR/core/arch-packages.txt"
cd scripts

if [[ ! -f "$PACKAGE_LIST_FILE" ]]; then
    echo "Package list file '$PACKAGE_LIST_FILE' not found!"
    exit 1
else
    echo "Updating package lists..."
    sudo pacman -Sy

    echo "Installing core utilities..."
    sudo pacman -S --needed "${PACKAGE_LIST_FILE[@]}"
fi
