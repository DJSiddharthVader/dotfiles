#!/bin/bash

# Set up dotfiles on remote server

# simlink files to home dir
for thing in ~/dotfiles/.*; do
    ln -sf "$thing" ~/
done
rm -rf ~/.git*

## GLIB C ##
# for installing glib C version that allows nvim and tmux
# https://stackoverflow.com/questions/50564999/lib64-libc-so-6-version-glibc-2-14-not-found-why-am-i-getting-this-error

## TMUX ##
# download latests appimage of tmux 
curl -s https://api.github.com/repos/nelsonenzo/tmux-appimage/releases/latest \
    | grep "browser_download_url.*appimage" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi - \
    && chmod +x tmux.appimage
tmux.appimage --appimage-extract
## optionaly, move it into your $PATH
ln -s ./squashfs-root/usr/bin/tmux $HOME/.local/tmux
# mv tmux.appimage $HOME/.local/tmux

## NEOVIM ##
# download neovim and put in in path
NVIM_BINARY="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz"
if [[ -f ~/bin/nvim ]]; then
    cd && mkdir -p bin
    wget "$NVIM_BINARY"
    cp ~/nvim-linux64/bin/nvim ~/bin/
fi
# install neovim plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c 'PlugInstall'
