
echo 'Updating the local packages'
yes | sudo pacman -Syyu

echo 'installing rust and cargo'
rust_version = $(rustup --version)
echo "$rust_version"
# yes | curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

