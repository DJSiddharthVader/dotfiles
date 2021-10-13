#!/bin/bash
laptop_screen="eDP-1"
bar_manager_script="$HOME/dotfiles/.scripts/bar-manager.sh"

help() {
    echo "Usage: $0 {ext|hybrid|laptop}"
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
        if [[ $monitor != $laptop_screen ]]; then
            echo "disconnecting $monitor"
            xrandr --output $monitor --off
        fi
    done <<< "$(listMonitors)"
}
connectToAll() {
    primary="$1"
    prev=""
    while IFS= read -r monitor; do
        resolution="$(resolution "$monitor")"
        echo "$monitor $resolution"
        if [[ -z "$prev" ]]; then
            if [[ -z "$primary" ]]; then
                xrandr --output $monitor --mode "$resolution" --primary
            else
                xrandr --output $monitor --mode "$resolution" --right-of $primary
            fi
        else
            xrandr --output $monitor --mode "$resolution" --right-of $prev
        fi
        prev=$monitor
    done <<< "$(listMonitors)"
}
connect() {
    setup="$1"
    case "$setup" in
        hybrid)
            connectToAll "$laptop_screen"
            ;;
        ext)
            connectToAll ""
            xrandr --output "$laptop_screen" --off
            ;;
        laptop)
            xrandr --output "$laptop_screen" --mode "$(resolution $laptop_screen)" --primary
            disconnect
            ;;
        mirror)
            while IFS= read -r monitor; do
                resolution="$(resolution "$monitor")"
                xrandr --output $monitor --mode "$resolution" --same-as $laptop_screen
            done <<< "$(listMonitors)"
            ;;
        *) help && exit 1 ;;
    esac
}
isConnected() {
    monitors="$(xrandr --listmonitors | head -1 | cut -d' ' -f2)"
    laptop_connected="$(xrandr --listmonitors | grep -c $laptop_screen)"
    if [[ $monitors -eq 1 ]] && [[ $laptop_connected -eq 1 ]]; then
        echo 'false'
    else
        echo 'true'
    fi
}
main() {
    mode="$1"
    if [[ "$mode" = 'auto' ]]; then
        if [[ $(isConnected) = 'true' ]]; then # if already connected then disconnect
            connect laptop
            $bar_manager_script style laptop
        else
            monitors="$(listMonitors | wc -l)" #external and laptop
            case $monitors in
                4) connect ext # at home
                   $bar_manager_script style cross
                   ;;
                3) connect ext # some 2 monitor setup
                   $bar_manager_script style float
                   ;;
                2) connect hybrid # presenting
                   $bar_manager_script style press
                   connectAudio hdmi
                   ;;
                1) echo 'No monitors connected' && exit 0 ;;
                *) echo 'Error detecting monitors' && exit 1 ;;
            esac
        fi
    else
        connect "$mode"
        case "$mode" in
            ext|hybrid) $bar_manager_script restart ;;
            laptop) $bar_manager_script style laptop ;;
            *) help && exit 1 ;;
        esac
    fi
    $HOME/dotfiles/.scripts/wallpaper.sh stay back # set wallpaper on all screens
}

main "$1"
