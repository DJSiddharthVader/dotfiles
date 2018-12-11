#!/bin/bash
# $1 is the display, $2 is the image to set as background
if [ $1 = 'vga' ]
then
    if [ $2 -eq 1 ];
    then
        xrandr --output eDP-1 --output DP-2 --mode 1360x768 --right-of eDP-1
        feh --bg-scale /home/sidreed/dotfiles/.config/i3/bordered_background.png &
        i3-msg restart
    else
        xrandr --output DP-2 --off
        pactl set-card-profile 0 output:hdmi-stereo
        pactl set-card-profile 0 output:analog-stereo
    fi
elif [ $1 = 'hdmi' ]
then
    if [ $2 -eq 1 ];
    then
        xrandr --output eDP-1 --output HDMI-1 --mode 1920x1080 --right-of eDP-1
        pactl set-card-profile 0 output:hdmi-stereo
        feh --bg-scale /home/sidreed/dotfiles/.config/i3/bordered_background.png &
        i3-msg restart
    else
        xrandr --output HDMI-1 --off
        pactl set-card-profile 0 output:hdmi-stereo
        pactl set-card-profile 0 output:analog-stereo
    fi
elif [ $1 = 'both' ]
then
    if [ $2 -eq 1 ];
    then
        xrandr --output eDP-1 --output HDMI-1 --mode 1920x1080 --right-of eDP-1
        xrandr --output eDP-1 --output DP-2 --mode 1360x768 --above eDP-1
        ~/.fehbg &
        i3-msg restart
    else
        xrandr --output HDMI-1 --off
        xrandr --output DP-2 --off
        pactl set-card-profile 0 output:hdmi-stereo
        pactl set-card-profile 0 output:analog-stereo
    fi
fi
