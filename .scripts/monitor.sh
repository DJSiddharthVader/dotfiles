#!/bin/bash

connectToMonitor() {
    monitor=`xrandr | grep ' connected' | tail -1 | cut -d' ' -f1`
    resolution=`xrandr | grep -v 'primary' | pcregrep -M ' connected.*\n[0-9x ]' | grep -o '[0-9]\{3,4\}x[0-9]\{3,4\}'`
    ishdmi=`xrandr | grep ' connected' | tail -1`
    if [[ $ishdmi =~ 'HDMI' ]]; then
        xrandr --output eDP-1 --output "$monitor" --mode "$resolution" --right-of eDP-1
        pactl set-card-profile 0 output:hdmi-stereo
        sleep 1
    else
        xrandr --output eDP-1 --output "$monitor" --mode "$resolution" --left-of eDP-1
    fi
    i3-msg restart
    ~/.scripts/togglebar.sh "$(head -1 $HOME/dotfiles/.config/.bartoggle)"
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

function main() {
    case "$1" in
        on)
            connected=`xrandr | grep ' connected' | wc -l | cut -d' ' -f1`
            if [ "$connected" -gt 1 ]; then #connected to a monitor
                connectToMonitor
            fi
            ;;
        off)
            disconnectMonitor
            ;;
        *)
            echo "usage {on|off}"
            exit 1
            ;;
    esac
}

main "$1"
