mkdir tmp
cd tmp
git clone https://github.com/nishu-murmu/nvim.git
mv nvim/ "/home/$USER.config/nvim"
cd .. && rm -rf tmp
nvim .