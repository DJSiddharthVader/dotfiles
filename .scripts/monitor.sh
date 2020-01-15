#!/bin/bash

connectToMonitor() {
    monitor="$(xrandr | grep ' connected' | tail -1 | cut -d' ' -f1)"
    ishdmi="$(xrandr | grep ' connected' | tail -1)"
    if [[ $ishdmi =~ 'HDMI' ]]; then
        resolution="$(xrandr | grep -v 'primary' | grep -Pzo '.* connected(.*\n)*' | grep -a '^ ' | sort -rn | grep -v '[0-9]i'  | grep -v '\*' | grep -v i | head -2 | tail -1 | grep -ao '[0-9]*x[0-9]*')"
        #pactl set-card-profile 0 output:hdmi-stereo
        sleep 1
    else
        resolution="$(xrandr | grep -v 'primary' | grep -Pzo '.* connected(.*\n)*' | grep -a '^ ' | sort -rn | grep -v '[0-9]i'  | grep -v '\*' | head -1 | grep -ao '[0-9]*x[0-9]*')"
    fi
    echo "$monitor $resolution"
    xrandr --output eDP-1 --output "$monitor" --mode "$resolution" --right-of eDP-1
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
    ~/dotfiles/.scripts/bar_manager.sh auto
}

main "$1"
