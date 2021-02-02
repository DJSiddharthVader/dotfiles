#!/bin/bash

togglefile="$HOME/dotfiles/.varfiles/bartoggle"
declare -A modes_idxs
modes_idxs=([float]=1 [full]=2 [mini]=3 [none]=4)
modes_fwd=('padding' 'float' 'full' 'mini' 'none')
modes_rev=('padding' 'mini' 'none' 'float' 'full')
bgfile="$HOME/dotfiles/.varfiles/bordered_background.png"
unbgfile="$HOME/dotfiles/.varfiles/unbordered_background.png"

function launchBar() {
    mode="$1"
    killall -q polybar && sleep 0.00001 # Terminate already running bar instances
    for m in $(xrandr | grep ' connected' | cut -d' ' -f1); do
        case "$mode" in
            float)
                MONITOR=$m polybar floating_top &
                MONITOR=$m polybar floating_bot &
                ;;
            full)
                MONITOR=$m polybar bordered_top &
                MONITOR=$m polybar bordered_bot &
                ;;
            mini)
                MONITOR=$m polybar minimal &
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
            feh --bg-scale "$unbgfile"
            ;;
        full)
            feh --bg-scale "$bgfile"
            ;;
        mini)
            feh --bg-scale "$unbgfile"
            ;;
        none)
            feh --bg-scale "$unbgfile"
            ;;
        *)
            echo "usage $0 {float|full|mini|none}"
            exit 1
            ;;
    esac
}
function writeToggleFile() {
    mode="$1"
    nextidx="$(( ${modes_idxs[$mode]} % ${#modes_idxs[@]} + 1 ))"
    fmode="${modes_fwd[$nextidx]}"
    rmode="${modes_rev[$nextidx]}"
    echo -e "$mode\n$fmode\n$rmode" >| "$togglefile"
}
function updateBar() {
    mode="$1"
    launchBar "$mode"
    setWallPaper "$mode"
    writeToggleFile "$mode"
}
function barWrapper() {
    option="$1"
    case "$option" in
        next) mode="$(head -2 $togglefile | tail -1)" ;;
        prev) mode="$(head -3 $togglefile | tail -1)" ;;
        stay) mode="reload" ;;
        restart) mode="$(head -1 $togglefile | tail -1)" ;;
        float) mode="float" ;;
        full) mode="full" ;;
        mini) mode="mini" ;;
        none) mode="none" ;;
        *) echo "Usage: $0 {next|prev|stay|float|full||mini|none}"
           exit 1
          ;;
    esac
    if [ "$mode" = "reload" ]; then
        if ! [ -z "$(pgrep 'polybar')" ]; then
            # launch bar if not already launched
            polybar-msg cmd restart
            exit 0 #exit
        else
            mode="$(head -1 $togglefile)" # current mode, kill an restart bar
        fi
    fi
    updateBar "$mode"
}

barWrapper "$1"
