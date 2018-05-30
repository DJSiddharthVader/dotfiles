#!/bin/sh

walp=~/dotfiles/wallpapers/`ls  ~/dotfiles/wallpapers | shuf -n 1`
wal -i $walp
feh --bg-scale $walp --bg-scale $walp
