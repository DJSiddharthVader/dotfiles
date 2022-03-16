#!/bin/bash
LAPTOP_SCREEN="eDP-1"
BAR_MANAGER_SCRIPT="$HOME/dotfiles/.scripts/bar-manager.sh"

help() {
    echo "Usage: $0 {auto|ext|hybrid|laptop|organize}"
}
resolution() {
    monitor="$1"
    xrandr | sed -ne "/$monitor/,/connected/p" | sort -n | tail -1 | grep -ao '[0-9]*x[0-9_\.]*'
}
listMonitors() {
    xrandr | grep ' connected' | sort -r | cut -d' ' -f1 | tr -d ' '
}
connectAudio() {
    mode="$1"
    case "$mode" in
        laptop) pacmd set-card-profile 1 output:analog-stereo+input:analog-stereo ;;
        hdmi) pacmd set-card-profile 1 output:hdmi-stereo+input:analog-stereo ;;
        *) echo "Invalid mode use {laptop|hdmi}" && exit 1 ;;
    esac
}
disconnect(){
    # disconnect all external monitors except laptop screen
    while IFS= read -r monitor; do
        if [[ $monitor != $LAPTOP_SCREEN ]]; then
            echo "disconnecting $monitor"
            xrandr --output $monitor --off
        fi
    done <<< "$(listMonitors)"
}
connectToAll() {
    primary="$1"
    prev=""
    echo "$(listMonitors)"
    while IFS= read -r monitor; do
        resolution="$(resolution "$monitor")"
        echo "$monitor $resolution"
        if [[ $monitor = $primary ]]; then
            xrandr --output $monitor --mode "$resolution" --primary
        else
            if [[ -z "$prev" ]]; then
                xrandr --output $monitor --mode "$resolution" --primary
            else
                xrandr --output $monitor --mode "$resolution" --right-of "$prev"
            fi
        fi
        prev=$monitor
    done <<< "$(listMonitors)"
}
connect() {
    setup="$1"
    case "$setup" in
        hybrid)
            connectToAll "$LAPTOP_SCREEN"
            ;;
        ext)
            connectToAll ""
            xrandr --output "$LAPTOP_SCREEN" --off
            ;;
        laptop)
            xrandr --output "$LAPTOP_SCREEN" --mode "$(resolution $LAPTOP_SCREEN)" --primary
            disconnect
            ;;
        mirror)
            while IFS= read -r monitor; do
                resolution="$(resolution "$monitor")"
                xrandr --output $monitor --mode "$resolution" --same-as $LAPTOP_SCREEN
            done <<< "$(listMonitors)"
            ;;
        *) help && exit 1 ;;
    esac
}
isConnected() {
    monitors="$(xrandr --listmonitors | head -1 | cut -d' ' -f2)"
    laptop_connected="$(xrandr --listmonitors | grep -c $LAPTOP_SCREEN)"
    if [[ $monitors -eq 1 ]] && [[ $laptop_connected -eq 1 ]]; then
        echo 'false'
    else
        echo 'true'
    fi
}
organizeWorkspaces() {
    mode="$1"
    case "$mode" in
        home) 
            move_left=(1)
            move_right=(2 3 6)
            ;;
        present)
            move_left=()
            move_right=(3 6)
            ;;
        *) help && exit 1 ;;
    esac
    for ws in "${move_left[@]}"; do
        i3-msg workspace "$ws"
        i3-msg move workspace to output left
    done
    for ws in "${move_right[@]}"; do
        i3-msg workspace "$ws"
        i3-msg move workspace to output right
    done
}
main() {
    mode="$1"
    if [[ "$mode" = 'auto' ]]; then
        if [[ $(isConnected) = 'true' ]]; then # if already connected then disconnect
            connect laptop
            $BAR_MANAGER_SCRIPT style laptop
        else
            monitors="$(listMonitors | wc -l)" #external and laptop
            case $monitors in
                4) connect ext # at home
                   $BAR_MANAGER_SCRIPT style cross
                   organizeWorkspaces 'home'
                   ;;
                3) connect ext # some 2 monitor setup
                   $BAR_MANAGER_SCRIPT style float
                   ;;
                2) connect hybrid # presenting
                   $BAR_MANAGER_SCRIPT style full
                   connectAudio hdmi
                   organizeWorkspaces 'present'
                   ;;
                1) echo 'No monitors connected' && exit 0 ;;
                *) echo 'Error detecting monitors' && exit 1 ;;
            esac
        fi
    elif [[ $mode = 'organize' ]]; then
        organizeWorkspaces 'home'
    else
        connect "$mode"
        case "$mode" in
            ext|hybrid) $BAR_MANAGER_SCRIPT restart ;;
            laptop) $BAR_MANAGER_SCRIPT style laptop ;;
            *) help && exit 1 ;;
        esac
    fi
    $HOME/dotfiles/.scripts/wallpaper.sh stay back # set wallpaper on all screens
}

main "$1"
