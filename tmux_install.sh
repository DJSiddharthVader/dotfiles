#!/bin/bash

# Script for installing tmux and dependencies.
# tmux will be installed in /usr/local/lib by default.

# Prerequisites: - gcc
#                - wget

# define versions


# set the installation directory

target_dir="/scratch/tmux"
mkdir -p $target_dir

# libevent installation
libevent_version="2.0.21"
libevent_name="libevent-$libevent_version-stable"
cd $target_dir
wget -O $libevent_name.tar.gz https://github.com/downloads/libevent/libevent/$libevent_name.tar.gz
tar xvzf $libevent_name.tar.gz
cd $libevent_name
./configure --prefix=$target_dir --disable-shared
make
make install
echo 'libevent install correctly'


# ncurses installation
ncurses_version="5.9"
ncurses_name="ncurses-$ncurses_version"
cd $target_dir
wget -O $ncurses_name.tar.gz ftp://ftp.gnu.org/gnu/ncurses/$ncurses_name.tar.gz
tar xvzf $ncurses_name.tar.gz
cd $ncurses_name
./configure --prefix=$target_dir
make
make install
echo 'ncurses install correctly'

# tmux installation
tmux_version="2.7"
tmux_patch_version="" # leave empty for stable releases
tmux_name="tmux-$tmux_version"
tmux_relative_url="$tmux_name/$tmux_name$tmux_patch_version"
cd $target_dir
wget -O $tmux_name.tar.gz https://github.com/tmux/tmux/releases/download/$tmux_version/$tmux_name.tar.gz
tar xvzf ${tmux_name}*.tar.gz
cd ${tmux_name}*/
./configure CFLAGS="-I$target_dir/include -I$target_dir/include/ncurses" LDFLAGS="-L$target_dir/lib -L$target_dir/include/ncurses -L$target_dir/include"
CPPFLAGS="-I$target_dir/include -I$target_dir/include/ncurses" LDFLAGS="-static -L$target_dir/include -L$target_dir/include/ncurses -L$target_dir/lib" make
echo "alias tmux='$target_dir/$tmux_name/tmux -2'" >> ~/.bash_aliases

version=`tmux -V | cut -d ' ' -f 2`
if [ "$version" != "$tmux_version" ]; then
  echo
  echo "[error] failed to install tmux - check for errors in the above output"
  exit 1
fi
