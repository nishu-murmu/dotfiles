cd ..
SCRIPT_DIR=$(pwd)
PACKAGE_LIST_FILE="$SCRIPT_DIR/core/fedora-packages.txt"
cd scripts

if [[ ! -f "$PACKAGE_LIST_FILE" ]]; then
    echo "Package list file '$PACKAGE_LIST_FILE' not found!"
    exit 1
else
    echo "Updating package lists..."
    sudo dnf check-update

    echo "Installing core utilities..."
    xargs -a "$PACKAGE_LIST_FILE" sudo dnf install -y
fi
