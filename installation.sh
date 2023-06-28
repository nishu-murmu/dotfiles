# This installation script is only for ArchLinux
# printf 'Updating the local packages'
# yes | sudo pacman -Syyu

printf '====>>Installing rust and cargo<<====\n'

printf '\n'
printf '====>>Installing Rust on the system<<====\n'
rust_version=$(rustup --version)
if [[ -z "$rust_version" ]]; then
  yes | curl --proto '=ht; s' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else 
  printf '====>>Rust is already installed.<<====\n'
fi

printf '\n'
printf '====>>Installing snap on the system<<====\n'
snap_version=$(snap --version)
if [[ -z "$rust_version" ]]; then
  git clone https://aur.archlinux.org/snapd.git
else 
  printf '====>>Snap is already installed.<<====\n'
fi

printf '\n'
printf '====>>Installing Neovim<<====\n'
neovim_version=$(nvim --version)
if [[ -z "$neovim_version" ]]; then
  sudo snap install neovim
else
  printf "====>>Neovim is already installed.<<===="
fi

for i in `cat packages.txt`
do
  yes | sudo pacman -S $i
done
