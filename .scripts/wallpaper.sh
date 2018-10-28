#!/bin/sh

walp=~/dotfiles/wallpapers/`ls  ~/dotfiles/wallpapers | shuf -n 1`

case "$1" in
    'font')
        wal -e -n -i $walp #font only
        ;;
    'background')
        feh --bg-scale $walp --bg-scale $walp #background only
        ;;
    'both')
        wal -e -i $walp #set both
        ;;
    *)
        echo "Usage: $0 {font|background|both}"
        exit 1
esac


