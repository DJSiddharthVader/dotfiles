#!/bin/bash

connectToMonitor() {
    monitor=`xrandr | grep ' connected' | tail -1 | cut -d' ' -f1`
    resolution=`xrandr | grep -v 'primary' | pcregrep -M ' connected.*\n[0-9x ]' | grep -o '[0-9]\{3,4\}x[0-9]\{3,4\}'`
    ishdmi=`xrandr | grep ' connected' | tail -1`
    echo "$monitor $resolution $ishdmi"
    if [[ $ishdmi =~ 'HDMI' ]]; then
        xrandr --output eDP-1 --output "$monitor" --mode "$resolution" --right-of eDP-1
        pactl set-card-profile 0 output:hdmi-stereo
    else
        xrandr --output eDP-1 --output "$monitor" --mode "$resolution" --left-of eDP-1
    fi
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
            connected=$(xrandr | grep -c ' connected')

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
    ~/.scripts/togglebar.sh auto
}

main "$1"
