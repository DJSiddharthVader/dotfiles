#!/bin/bash

function multiscreen() {
    case "$1" in
        full)
            for m in $(xrandr | grep ' connected' | cut -d' ' -f1)
            do
                MONITOR=$m polybar lap -q &
                MONITOR=$m polybar schedule -q &
            done
            ;;
        mini)
            for m in $(xrandr | grep ' connected' | cut -d' ' -f1)
            do
                MONITOR=$m polybar minimal -q &
            done
            ;;
        none)
            sleep 1
            ;;
        *)
            echo "usage $0 {full|mini|none}"
            exit 1
            ;;
    esac
}

function singelscreen() {
    MONITOR=$(xrandr --query | grep " connected" | cut -d" " -f1)
    case "$1" in
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
            echo "usage $0 {full|mini|none}"
            exit 1
            ;;
    esac
}

function launchbar_dep() {
    killall -q polybar # Terminate already running bar instances
    #while pgrep -x polybar >/dev/null; do sleep 1; done # Wait until the processes have been shut down
    if [ "$(xrandr | grep -c " connected")" -gt 1 ]; then #multi monitors
        case "$1" in
            full)
                multiscreen full
                ;;
            mini)
                multiscreen mini
                ;;
            none)
                multiscreen none
                ;;
            *)
                echo "usage $0 {full|mini|none}"
                exit 1
                ;;
        esac
    else #single monitor
        case "$1" in
            full)
                singlescreen full
                ;;
            mini)
                singlescreen mini
                ;;
            none)
                singlescreen none
                ;;
            *)
                echo "usage $0 {full|mini|none}"
                exit 1
                ;;
        esac
    fi
}

function setWallPaper() {
    bordered="$(head -1 $HOME/dotfiles/.bartoggle)"
    case "$bordered" in
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
            exit 1
            ;;
    esac
}

function launchbar() {
    killall -q polybar # Terminate already running bar instances
    #while pgrep -x polybar >/dev/null; do sleep 1; done # Wait until the processes have been shut down
    case "$1" in
        full)
            multiscreen full
            ;;
        mini)
            multiscreen mini
            ;;
        none)
            multiscreen none
            ;;
        *)
            echo "usage $0 {full|mini|none}"
            exit 1
            ;;
    esac
    setWallPaper
}

function main() {
    if [ -z "$1" ]; then #are args given
        launchbar "$(head -1 ~/dotfiles/.bartoggle)"
    else
        launchbar "$1"
    fi
}

main "$1"
