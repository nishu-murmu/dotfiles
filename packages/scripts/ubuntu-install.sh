cd ..
SCRIPT_DIR=$(pwd)
PACKAGE_LIST_FILE="$SCRIPT_DIR/core/ubuntu-packages.txt"
cd scripts

if [[ ! -f "$PACKAGE_LIST_FILE" ]]; then
    echo "Package list file '$PACKAGE_LIST_FILE' not found!"
    exit 1
else
    echo "Updating package lists..."
    sudo apt-get update

    echo "Installing core utilities..."
    xargs -a "$PACKAGE_LIST_FILE" sudo apt-get install -y
fi
