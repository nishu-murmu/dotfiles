#!/usr/bin/env bash

set -euo pipefail

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/nvim-config.XXXXXX")"
trap 'rm -rf "$tmp_dir"' EXIT

git clone --depth 1 https://github.com/nishu-murmu/nvim.git "$tmp_dir/nvim"

mkdir -p "$HOME/.config"
rm -rf "$HOME/.config/nvim"
mv "$tmp_dir/nvim" "$HOME/.config/nvim"

echo "Neovim config installed at $HOME/.config/nvim"
