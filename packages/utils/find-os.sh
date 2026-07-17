#!/usr/bin/env bash

set -euo pipefail

FILE="/etc/os-release"

if [[ ! -f "$FILE" ]]; then
    echo "$FILE does not exist!"
    exit 1
fi

source "$FILE"

case "$ID" in
    ubuntu|debian)
        echo "ubuntu"
        ;;
    arch|archlinux)
        echo "arch"
        ;;
    fedora)
        echo "fedora"
        ;;
    *)
        echo "$ID"
        exit 1
        ;;
esac
