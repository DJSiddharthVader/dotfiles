#!/bin/bash

# Set up dotfiles on remote server

# simlink dots 
for thing in ~/dotfiles/.*; do
    ln -sf "$thing" ~/
done
rm -rf ~/.git*

# download neovim and put in in path
# NVIM_BINARY="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz"
# if [[ -f ~/bin/nvim ]]; then
#     cd && mkdir -p bin
#     wget "$NVIM_BINARY"
#     cp ~/nvim-linux64/bin/nvim ~/bin/
# fi
sudo yum -y install ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch gettext curl
git clone https://github.com/neovim/neovim
cd neovim/ && make
sudo make install

# install neovim plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c 'PlugInstall'
