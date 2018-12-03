#!/bin/bash

# $1 is 'on' or 'off'

connectToMonitor() {
    ishdmi=`xrandr | grep ' connected' | tail -1`
    monitor=`xrandr | grep ' connected' | tail -1 | cut -d' ' -f1`
    #resolution=`xrandr | grep ' connected' | tail -1 | cut -d' ' -f3 | cut -d'+' -f1`
    resolution=`xrandr | grep -v 'primary' | pcregrep -M ' connected.*\n[0-9x ]' | grep -o '[0-9]\{3,4\}x[0-9]\{3,4\}'`
    xrandr --output eDP-1 --output "$monitor" --mode "$resolution" --right-of eDP-1
    ishdmi=`xrandr | grep ' connected' | tail -1`
    if [[ $ishdmi =~ 'HDMI' ]]; then
        pactl set-card-profile 0 output:hdmi-stereo
    fi
    feh --bg-scale /home/sidreed/dotfiles/.config/i3/bordered_background.png &
    i3-msg restart
}

disconnectMonitor() {
    monitor=`xrandr | grep ' connected' | tail -1 | cut -d' ' -f1`
    xrandr --output "$monitor" --off
    ishdmi=`xrandr | grep ' connected' | tail -1`
    if [[ $ishdmi =~ 'HDMI' ]]; then
        pactl set-card-profile 0 output:hdmi-stereo
        pactl set-card-profile 0 output:analog-stereo
    fi
}

if [ "$1" = 'on' ]; then
    connected=`xrandr | grep ' connected' | wc -l | cut -d' ' -f1`
    if [ "$connected" -gt 1 ]; then #connected to a monitor
        connectToMonitor
    fi
elif [ "$1" = 'off' ]; then
    disconnectMonitor
else
    echo "invalid option, either on or off"
fi
