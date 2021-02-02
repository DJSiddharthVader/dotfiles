#!/bin/bash

function get_secondary_resolution() {
    monitor="$1"
    resolution="$(xrandr | sed -ne "/$monitor/,/connected/ p" |
                  grep -v 'connected' |
                  head -1 |
                  grep -ao '[0-9]*x[0-9]*')"
    echo $resolution
}
connectToMonitor() {
    connected=$(xrandr | grep -c ' connected')
    if [ "$connected" -gt 1 ]; then #connected to a monitor
        monitor="$(xrandr | grep ' connected' | tail -1 | cut -d' ' -f1)"
        resolution="$(get_secondary_resolution "$monitor")"
        #echo "$resolution"
        #pactl set-card-profile 0 output:hdmi-stereo
        xrandr --output eDP-1       \
               --output "$monitor"  \
               --mode "$resolution" \
               --right-of eDP-1
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
            connectToMonitor
            ~/dotfiles/.scripts/bar-manager.sh restart
            ;;
        off)
            disconnectMonitor
            ~/dotfiles/.scripts/bar-manager.sh restart
            ;;
        *)
            echo "usage {on|off}"
            exit 1
            ;;
    esac
}

main "$1"

#DEPRECIATED
#function get_secondary_resolution() {
#    # get the  largest resolution of the first conncted monitor
#    ishdmi="$(xrandr | grep ' connected' | tail -1)"
#    if [[ $ishdmi =~ 'HDMI' ]]; then
#        #resolution="$(xrandr | grep -v 'primary' | grep -Pzo '.* connected(.*\n)*' | grep -a '^ ' | sort -rn | grep -v '[0-9]i' | grep -v '\*' | grep -v i | head -2 | tail -1 | grep -ao '[0-9]*x[0-9]*')"
#        resolution="$(xrandr | grep -v 'primary' |
#                      grep -Pzo '^ .* connected(.*\n)*' |
#                      grep -a '^ ' |
#                      sort -rn |
#                      grep -v '[0-9]i' |
#                      grep -v '\*' |
#                      head -2 | tail -1 |
#                      grep -ao '[0-9]*x[0-9]*')"
#    else
#        #resolution="$(xrandr | grep -v 'primary' | grep -Pzo '.* connected(.*\n)*' | grep -a '^ ' | sort -rn | grep -v '[0-9]i'  | grep -v '\*' | head -1 | grep -ao '[0-9]*x[0-9]*')"
#        resolution="$(xrandr | grep -v 'primary' |
#                      grep -Pzo '.* connected(.*\n)*' |
#                      grep -a '^ ' |
#                      sort -rn |
#                      grep -v '[0-9]i'  |
#                      grep -v '\*' |
#                      head -1 |
#                      grep -ao '[0-9]*x[0-9]*')"
#    fi
#    echo $resolution
#}
