#!/bin/bash
LAPTOP_SCREEN="eDP-1"
BAR_MANAGER_SCRIPT="$HOME/dotfiles/.scripts/bar-manager.sh"

help() {
    echo "Usage: $0 {auto|home|proj|ext|hybrid|laptop|mirror|organize}"
}
isConnected() {
    monitors="$(xrandr --listmonitors | head -1 | cut -d' ' -f2)"
    laptop_connected="$(xrandr --listmonitors | grep -c $LAPTOP_SCREEN)"
    if [[ $monitors -eq 1 ]] && [[ $laptop_connected -eq 1 ]]; then
        false
    else
        true
    fi
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
        laptop) pacmd set-card-profile 0 output:analog-stereo+input:analog-stereo ;;
        hdmi) pacmd set-card-profile 0 output:hdmi-stereo+input:analog-stereo  ;;
        *) echo "Invalid mode use {laptop|hdmi}" && exit 1 ;;
    esac
}
organizeWorkspaces() {
    mode="$1"
    case "$mode" in
        home) 
            move_left=(1 2 5 6)
            move_right=()
            ;;
        proj) 
            move_left=(2 5 6)
            move_right=(1)
            ;;
        work)
            move_right=(3 5 6)
            move_left=()
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
disconnect(){
    # disconnect all external monitors except laptop screen
    while IFS= read -r monitor; do
        if [[ $monitor != $LAPTOP_SCREEN ]]; then
            echo "disconnecting $monitor"
            xrandr --output $monitor --off
        fi
    done <<< "$(listMonitors)"
}
connect() {
    case "$1" in
        home)
            xrandr --output $LAPTOP_SCREEN --primary --mode 1366x768 \
                   --output DP-2 --left-of $LAPTOP_SCREEN --mode 1920x1080 
            # connectAudio hdmi
            organizeWorkspaces home
            ;;
        proj)
            xrandr --output $LAPTOP_SCREEN --primary --mode 1366x768 \
                   --output DP-2 --left-of $LAPTOP_SCREEN --mode 1920x1080 \
                   --output HDMI-1 --left-of DP-2 --mode 1024x768 --scale 1.001x1.301 --panning 1024x768 #1920x1080 #1368x768
            # connectAudio hdmi
            organizeWorkspaces proj
            ;;
        work)
            xrandr --output $LAPTOP_SCREEN --auto --primary 
            xrandr --output DP-2 --auto --right-of $LAPTOP_SCREEN --rotate left
            organizeWorkspaces work
            ;;
        hybrid)
            prev=$LAPTOP_SCREEN
            while IFS= read -r monitor; do
                if [[ $monitor != $LAPTOP_SCREEN ]]; then
                    resolution="$(resolution "$monitor")"
                    xrandr --output $monitor --mode "$resolution" --right-of $prev
                    prev="$monitor"
                fi
            done <<< "$(listMonitors)"
            ;;
        ext)
            connect hybrid
            xrandr --output "$LAPTOP_SCREEN" --off ;;
        mirror)
            while IFS= read -r monitor; do
                resolution="$(resolution "$monitor")"
                xrandr --output $monitor --mode "$resolution" --same-as $LAPTOP_SCREEN
            done <<< "$(listMonitors)"
            ;;
        laptop)
            xrandr --output "$LAPTOP_SCREEN" --mode "$(resolution $LAPTOP_SCREEN)" --primary
            disconnect
            connectAudio laptop
            ;;
        *) echo "invalid mode" && help && exit 1 ;;
    esac
}
main() {
    mode="$1"
    if [[ "$mode" = 'auto' ]]; then
        if isConnected ; then # if already connected then disconnect
            connect laptop
            $BAR_MANAGER_SCRIPT style laptop
        else
            monitors="$(listMonitors)" #external and laptop
            numMonitors="$(echo "$monitors" | wc -l)"
            case $numMonitors in
                3) connect home
                   $BAR_MANAGER_SCRIPT style laptop
                   ;;
                2) if [[ "$(echo "$monitors" | grep -c HDMI)" -eq 0 ]]; then
                        connect work  # at work setup
                        $BAR_MANAGER_SCRIPT style laptop
                   else
                        connect hybrid
                        $BAR_MANAGER_SCRIPT style laptop
                   fi
                   ;;
                1) echo 'No monitors connected' && exit 0 ;;
                *) echo 'Error detecting monitors' && exit 1 ;;
            esac
        fi
    elif [[ $mode = 'organize' ]]; then
        organizeWorkspaces "$2"
    else
        connect "$mode"
        case "$mode" in
            ext|hybrid) $BAR_MANAGER_SCRIPT restart ;;
            *) $BAR_MANAGER_SCRIPT style laptop ;;
        esac
    fi
    $HOME/dotfiles/.scripts/wallpaper.sh stay back  # set wallpaper on all screens
}

main $@
