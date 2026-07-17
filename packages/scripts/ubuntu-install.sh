PACKAGE_LIST_FILE="../core/ubuntu-packages.txt"

if [[ ! -f "$PACKAGE_LIST_FILE" ]]; then
    echo "Package list file '$PACKAGE_LIST_FILE' not found!"
    exit 1
else
    echo "Updating package lists..."
    sudo apt-get update

    echo "Installing core utilities..."
    xargs -a "$PACKAGE_LIST_FILE" sudo apt-get install -y
fi
