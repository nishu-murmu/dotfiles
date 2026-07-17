#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_LIST_FILE="$SCRIPT_DIR/../core/fedora-packages.txt"

if [[ ! -f "$PACKAGE_LIST_FILE" ]]; then
    echo "Package list file '$PACKAGE_LIST_FILE' not found!"
    exit 1
fi

echo "Updating package lists..."
dnf check-update || true

echo "Installing core utilities..."
mapfile -t packages < "$PACKAGE_LIST_FILE"
available_packages=()
missing_packages=()

for package in "${packages[@]}"; do
    [[ -n "$package" ]] || continue

    if dnf info "$package" >/dev/null 2>&1; then
        available_packages+=("$package")
    else
        missing_packages+=("$package")
    fi
done

if (( ${#missing_packages[@]} > 0 )); then
    echo "Skipping unavailable Fedora packages: ${missing_packages[*]}"
fi

if (( ${#available_packages[@]} == 0 )); then
    echo "No installable Fedora packages found."
    exit 1
fi

dnf install -y "${available_packages[@]}"
