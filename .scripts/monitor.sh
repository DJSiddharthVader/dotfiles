#!/bin/bash
LAPTOP_SCREEN="eDP-1"
LAPTOP_RESOLUTION="1920x1080"
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
            move_left=(1 2 4)
            move_right=()
            ;;
        work)
            move_right=(3 5 6)
            move_left=()
            ;;
        proj) 
            move_left=(2 5 6)
            move_right=(1)
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
            xrandr --verbose --output eDP-1 --off \
                   --output DP-3-6-6 --mode 1920x1080 --pos 0x0 \
                   --output DP-3-5-5 --mode 1920x1200 --rotate right --right-of DP-3-6-6
            # connectAudio hdmi
            organizeWorkspaces home
            ;;
        work)
            xrandr --output $LAPTOP_SCREEN --mode $LAPTOP_RESOLUTION --primary \
                   --output DP-2 --auto \
                   --right-of $LAPTOP_SCREEN --rotate left
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
            xrandr --output "$LAPTOP_SCREEN" --off 
            ;;
        mirror)
            while IFS= read -r monitor; do
                resolution="$(resolution "$monitor")"
                xrandr --output $monitor --mode "$resolution" --same-as $LAPTOP_SCREEN
            done <<< "$(listMonitors)"
            ;;
        laptop)
            xrandr --output "$LAPTOP_SCREEN" --mode "$LAPTOP_RESOLUTION" --primary
            disconnect
            connectAudio laptop
            ;;
        *) echo "invalid mode" && help && exit 1 ;;
    esac
    sleep 3 && killall -q compton && sleep 1 && compton &
    ~/.scripts/wallpaper.sh stay back
}
main() {
    mode="$1"
    if [[ "$mode" = 'auto' ]]; then
        if isConnected ; then # if already connected then disconnect
            connect laptop
        else
            wifi="$(iwgetid | sed 's/^.*"\(.*\)"$/\1/')"
            case $wifi in 
                phswifi3) connect work ;;
                NewTokyo03) connect home ;;
                *) connect hybrid ;;
            esac
            # numMonitors="$(echo "$monitors" | wc -l)"
            # case $numMonitors in
            #     3) connect home
            #        ;;
            #     2) [[ "$(echo "$monitors" | grep -c HDMI)" -eq 0 ]] && connect work || connect hybrid
            #        ;;
            #     1) echo 'No monitors connected' && exit 0 ;;
            #     *) echo 'Error detecting monitors' && exit 1 ;;
            # esac
        fi
    elif [[ $mode = 'organize' ]]; then
        organizeWorkspaces "$2"
    else
        connect "$mode"
    fi
    $HOME/dotfiles/.scripts/wallpaper.sh stay back  # set wallpaper on all screens
    $BAR_MANAGER_SCRIPT style stay
}
main $@
