#!/bin/bash

if [ "$1" = 'on' ]; then
    killall -q polybar
    feh --bg-scale /home/sidreed/dotfiles/.config/i3/bordered_background.png
    ~/.scripts/polybar_launch
elif [ "$1" = 'off' ]; then
    killall -q polybar
    feh --bg-scale /home/sidreed/dotfiles/.config/i3/unbordered_background.png
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar minimal &
    done
else
    echo "error: arg 1 is on or off"
fi

