#!/bin/bash
togglefile="$HOME/dotfiles/.config/.bartoggle"
function fullbar() {
    feh --bg-scale /home/sidreed/dotfiles/.config/i3/bordered_background.png
    ~/.scripts/polybar_launch 'full'
}
function minibar() {
    feh --bg-scale /home/sidreed/dotfiles/.config/i3/unbordered_background.png
    ~/.scripts/polybar_launch 'mini'
}
function nobar() {
    feh --bg-scale /home/sidreed/dotfiles/.config/i3/unbordered_background.png
    ~/.scripts/polybar_launch 'none'
}
function main() {
    #toggle or explicit
    if [ "$1" = 'toggle' ]; then
        option=$(tail -1 "$togglefile")
    else
        option="$1"
    fi
    #set bar
    case "$option" in
        full)
            fullbar
            echo -e "full\nmini" >| "$togglefile"
            ;;
        mini)
            minibar
            echo -e "mini\nnone" >| "$togglefile"
            ;;
        none)
            nobar
            echo -e "none\nfull" >| "$togglefile"
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
