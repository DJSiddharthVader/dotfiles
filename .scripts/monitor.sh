#!/bin/bash
LAPTOP_SCREEN="eDP-1"
LAPTOP_RESOLUTION="1920x1080"
BAR_MANAGER_SCRIPT="$HOME/dotfiles/.scripts/bar-manager.sh"
help() {
    echo "Usage: $0 {auto|home|proj|ext|hybrid|laptop|mirror|organize}"
}
is_connected() {
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
list_monitors() {
    # xrandr | grep ' connected' | sort -r | cut -d' ' -f1 | tr -d ' ' 
    # xrandr --listmonitors | tail -n+2 | grep -o '+\*[^ ]* ' | tr -d '*+ '
    xrandr --listmonitors | tail -n+2 | rev | cut -d' ' -f1 | rev
}
connect_audio() {
    mode="$1"
    case "$mode" in
        laptop) pacmd set-card-profile 0 output:analog-stereo+input:analog-stereo ;;
        hdmi) pacmd set-card-profile 0 output:hdmi-stereo+input:analog-stereo  ;;
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
    done <<< "$(list_monitors)"
}
connect() {
    case "$1" in
        home)
            m3="$(xrandr | grep 'DP-[2,3]-5-5 con' | cut -d' ' -f1)"
            m2="${m1//5/6}"
            m1="$(xrandr | grep 'DP-[2,3] con' | cut -d' ' -f1)"
            echo $m1 $m2 $m
            xrandr --verbose \
                   --output eDP-1 --off \
                   --output $m1 --mode 1920x1080 --rate 60\
                   --output $m2 --mode 1920x1080 --right-of $m1 \
                   --output $m3 --mode 1920x1200 --rotate right --right-of $m2
            # connect_audio hdmi
            organize_workspaces home
            ;;
        hmon)
            xrandr --verbose --output eDP-1 --off \
                   --output DP-3 --mode 1920x1080 \
                   --output DP-2 --mode 1920x1200 --rotate right --right-of DP-3 
            # connect_audio hdmi
            organize_workspaces hmon
            ;;
        work)
            m1="$(xrandr | grep -v $LAPTOP_SCREEN | grep 'DP-.* con' | cut -d' ' -f1)"
            echo $m1
            xrandr --output $LAPTOP_SCREEN --mode $LAPTOP_RESOLUTION --primary \
                   --output $m1 --auto --right-of $LAPTOP_SCREEN --rotate left
            organize_workspaces work
            ;;
        hybrid)
            prev=$LAPTOP_SCREEN
            while IFS= read -r monitor; do
                if [[ $monitor != $LAPTOP_SCREEN ]]; then
                    resolution="$(resolution "$monitor")"
                    xrandr --output $monitor --mode "$resolution" --right-of $prev
                    prev="$monitor"
                fi
            done <<< "$(list_monitors)"
            ;;
        ext)
            connect hybrid
            xrandr --output "$LAPTOP_SCREEN" --off 
            ;;
        mirror)
            while IFS= read -r monitor; do
                resolution="$(resolution "$monitor")"
                xrandr --output $monitor --mode "$resolution" --same-as $LAPTOP_SCREEN
            done <<< "$(list_monitors)"
            ;;
        laptop)
            xrandr --output "$LAPTOP_SCREEN" --mode "$LAPTOP_RESOLUTION" --primary
            disconnect
            connect_audio laptop
            ;;
        *) echo "invalid mode" && help && exit 1 ;;
    esac
    sleep 3 && killall -q compton && sleep 1 && compton &
    ~/.scripts/wallpaper.sh stay back >& /dev/null
}
organize_workspaces() {
    mode="$1"
    case "$mode" in
        home) 
            move_left=(3 5 6)
            move_right=(2 4)
            ;;
        work)
            move_right=(3 5 6)
            move_left=()
            ;;
        hmon)
            move_right=(3 5 6)
            move_left=()
            ;;
        proj) 
            move_left=(2 3 5 6 0)
            move_right=()
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
    if [[ $mode = 'discon' ]]; then
        disconnect
        killall -q compton && compton &
    elif [[ "$mode" = 'auto' ]]; then
        if is_connected ; then # if already connected then disconnect
            connect laptop
        else
            wifi="$(iwgetid | sed 's/^.*"\(.*\)"$/\1/')"
            n_monitors="$(xrandr | grep -v "$LAPTOP_SCREEN" | grep ' connected' | wc -l)"
            echo $wifi $n_monitors
            case $wifi in 
                phswifi3) connect work ;;
                NewTokyo03) 
                    case $n_monitors in
                        3) connect home ;;
                        2) connect proj ;;
                        *) echo 'Error detecting monitors' && exit 1 ;;
                    esac
                    ;;
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
        organize_workspaces "$2"
    else
        connect "$mode"
    fi
    $HOME/dotfiles/.scripts/wallpaper.sh stay back >& /dev/null  # set wallpaper on all screens
    $BAR_MANAGER_SCRIPT style stay >& /dev/null
}
main $@
