SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_LIST_FILE="$SCRIPT_DIR/../core/ubuntu-packages.txt"

if [[ ! -f "$PACKAGE_LIST_FILE" ]]; then
    echo "Package list file '$PACKAGE_LIST_FILE' not found!"
    exit 1
fi

echo "Updating package lists..."
apt-get update

echo "Installing core utilities..."
xargs -a "$PACKAGE_LIST_FILE" apt-get install -y
