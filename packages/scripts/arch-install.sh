SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_LIST_FILE="$SCRIPT_DIR/../core/arch-packages.txt"

if [[ ! -f "$PACKAGE_LIST_FILE" ]]; then
    echo "Package list file '$PACKAGE_LIST_FILE' not found!"
    exit 1
fi

echo "Updating package lists..."
sudo pacman -Sy

echo "Installing core utilities..."
mapfile -t packages < "$PACKAGE_LIST_FILE"
sudo pacman -S --needed "${packages[@]}"
