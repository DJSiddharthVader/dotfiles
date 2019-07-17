#!/bin/bash

togglefile="$HOME/dotfiles/.bartoggle"
declare -A modes_idxs
modes_idxs=([float]=1 [full]=2 [mini]=3 [none]=4)
modes_fwd=('padding' 'float' 'full' 'mini' 'none')
modes_rev=('padding' 'mini' 'none' 'float' 'full')
function launchBar() {
    mode="$1"
    killall -q polybar # Terminate already running bar instances
    for m in $(xrandr | grep ' connected' | cut -d' ' -f1); do
        case "$mode" in
            float)
                MONITOR=$m polybar lapf -q &
                MONITOR=$m polybar schedulef -q &
                ;;
            full)
                MONITOR=$m polybar lap -q &
                MONITOR=$m polybar schedule -q &
                ;;
            mini)
                MONITOR=$m polybar minimal -q &
                ;;
            none)
                sleep 1
                ;;
            *)
                echo "usage $0 {float|full|mini|none}"
                exit 1
                ;;
        esac
    done
}
function setWallPaper() {
    case "$1" in
        float)
            feh --bg-scale /home/sidreed/dotfiles/.config/i3/unbordered_background.png
            ;;
        full)
            feh --bg-scale /home/sidreed/dotfiles/.config/i3/bordered_background.png
            ;;
        mini)
            feh --bg-scale /home/sidreed/dotfiles/.config/i3/unbordered_background.png
            ;;
        none)
            feh --bg-scale /home/sidreed/dotfiles/.config/i3/unbordered_background.png
            ;;
        *)
            echo "usage $0 {float|full|mini|none}"
            exit 1
            ;;
    esac
}
function barWrapper() {
    if [ $# -eq 0 ]; then #no args given
        option='auto'
    else
        option="$1"
    fi
    case "$option" in
        ftoggle)
            mode="$(head -2 $togglefile | tail -1)"
            ;;
        rtoggle)
            mode="$(head -3 $togglefile | tail -1)"
            ;;
        auto)
            mode="$(head -1 $togglefile)"
            ;;
        float)
            mode="float"
            ;;
        full)
            mode="full"
            ;;
        mini)
            mode="mini"
            ;;
        none)
            mode="none"
            ;;
        *)
            echo "Usage: $0 {ftoggle|rtoggle|auto|float|full||mini|none}"
            exit 1
            ;;
    esac
    launchBar "$mode"
    setWallPaper "$mode"
    nextidx="$(( ${modes_idxs[$mode]} % ${#modes_idxs[@]} + 1 ))"
    fmode="${modes_fwd[$nextidx]}"
    rmode="${modes_rev[$nextidx]}"
    echo -e "$mode\n$fmode\n$rmode" >| "$togglefile"
}

barWrapper "$1"
