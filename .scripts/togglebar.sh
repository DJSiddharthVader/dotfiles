#!/bin/bash
togglefile="$HOME/.config/.bartoggle"
function fullbar() {
    feh --bg-scale /home/sidreed/dotfiles/.config/i3/bordered_background.png
    ~/.scripts/polybar_launch
}
function minibar() {
    killall -q polybar
    feh --bg-scale /home/sidreed/dotfiles/.config/i3/unbordered_background.png
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar minimal &
    done
}
function nobar() {
    killall -q polybar
    feh --bg-scale /home/sidreed/dotfiles/.config/i3/unbordered_background.png
}
function main() {
    #toggle or explicit
    if [ "$1" = 'toggle' ]; then
        option=$(cat "$togglefile")
    else
        option="$1"
    fi
    #set bar
    case "$option" in
        full)
            fullbar
            echo "mini" >| "$togglefile"
            ;;
        mini)
            minibar
            echo "none" >| "$togglefile"
            ;;
        none)
            nobar
            echo "full" >| "$togglefile"
            ;;
        *)
            echo "Usage: $0 {toggle|full||mini|none}"
            exit 1
    esac
}
main "$1"

#DEPRECIATED
#elif [ "$1" = 'on' ]; then
#    killall -q polybar
#    feh --bg-scale /home/sidreed/dotfiles/.config/i3/bordered_background.png
#    ~/.scripts/polybar_launch
#elif [ "$1" = 'off' ]; then
#    killall -q polybar
#    feh --bg-scale /home/sidreed/dotfiles/.config/i3/unbordered_background.png
#    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#        MONITOR=$m polybar minimal &
#    done
#elif [ "$1" = 'none' ]; then
#    killall -q polybar
#    feh --bg-scale /home/sidreed/dotfiles/.config/i3/unbordered_background.png
#
#else
#    echo "error: arg 1 is on or off"
#fi
#
