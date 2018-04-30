#!/bin/bash
# $1 is the display, $2 is the image to set as background
if [ $1 = 'vga' ]
then
    if [ $2 -eq 1 ];
    then
        xrandr --output eDP-1 --output DP-2 --mode 1600x900 --right-of eDP-1
        ~/.fehbg &
        i3-msg restart
    else
        xrandr --output DP-2 --off
    fi
elif [ $1 = 'hdmi' ]
then
    if [ $2 -eq 1 ];
    then
        xrandr --output eDP-1 --output HDMI-1 --mode 1920x1080 --right-of eDP-1
        ~/.fehbg &
        i3-msg restart
    else
        xrandr --output HDMI-1 --off
    fi
fi
