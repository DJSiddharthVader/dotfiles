#!/bin/bash
LAPTOP_SCREEN="eDP-1"
# LAPTOP_RESOLUTION="1920x1080"
LAPTOP_RESOLUTION="1920x1200"
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
list_monitors() {
    # xrandr | grep ' connected' | sort -r | cut -d' ' -f1 | tr -d ' ' 
    # xrandr --listmonitors | tail -n+2 | grep -o '+\*[^ ]* ' | tr -d '*+ '
    xrandr --listmonitors | tail -n+2 | rev | cut -d' ' -f1 | rev
}
connect_audio() {
    mode="$1"
    case "$mode" in
        laptop) pacmd set-card-profile 0 output:analog-stereo+input:analog-stereo ;;
        hdmi  ) pacmd set-card-profile 0 output:hdmi-stereo+input:analog-stereo  ;;
        home  ) pacmd set-card-profile 0 output:hdmi-stereo-extra2+input:analog-stereo ;;
        *) echo "Invalid mode use {laptop|hdmi|home}" && exit 1 ;;
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
    echo "mode: $1"
    case "$1" in
        home)
            m1="$(xrandr | grep 'DP-[2,3]-5-5 con' | cut -d' ' -f1)"
            m2="${m1//5/6}"
            m3="$(xrandr | grep 'DP-[2,3] con' | cut -d' ' -f1)"
            echo $m1 $m2 $m3
                   # --output $m3 --mode 1920x1080 --right-of $m2 \
            xrandr --verbose \
                   --output $m1 --mode 1920x1080 \
                   --output $m2 --mode 1920x1080 --right-of $m1 --rotate left \
                   --output $m3 --mode 1920x1080 --right-of $m2 --rate 60.00 \
                   --output eDP-1 --off
            connect_audio home
            organize_workspaces home
            ;;
        shome)
            m2="$(xrandr | grep 'DP-[2,3,4]-5-5 con' | cut -d' ' -f1)"
            m1="${m2//5/6}"
            echo $m1 $m2
                   # --output $m3 --mode 1920x1080 --right-of $m2 \
            xrandr --verbose \
                   --output $m2 --mode 1920x1080 \
                   --output $m1 --mode 1920x1080 --right-of $m2 --rotate left \
                   --output eDP-1 --off
            organize_workspaces work
            ;;
        work)
            m1="$(xrandr | grep -v $LAPTOP_SCREEN | grep 'DP-.* con' | cut -d' ' -f1)"
            xrandr --output $LAPTOP_SCREEN --mode $LAPTOP_RESOLUTION --primary \
                   --output $m1 --mode 1920x1080 --right-of $LAPTOP_SCREEN --rotate left
            organize_workspaces work
            ;;
        hybrid)
            prev="$LAPTOP_SCREEN"
            while IFS= read -r monitor; do
                if [[ $monitor != $LAPTOP_SCREEN ]]; then
                    # xrandr --output "$monitor" --auto --right-of "$prev"
                    echo "xrandr --output $monitor --auto --right-of $prev"
                    prev="$monitor"
                fi
            done <<< "$(list_monitors)"
            exit 0
            ;;
        ext)
            connect hybrid
            xrandr --output "$LAPTOP_SCREEN" --off 
            ;;
        mirror)
            while IFS= read -r monitor; do
                xrandr --output $monitor --same-as $LAPTOP_SCREEN
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
            move_left=(1)
            move_right=(2 3 5 6)
            # move_right=(4 7 8 9 0)
            ;;
        shome)
            move_left=(1 4 7)
            move_right=()
            ;;
        work)
            move_right=(3 5 6 8)
            move_left=()
            ;;
        hmon)
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
main() {
    # params used to deciede output behaviour automatically
    wifi="$(iwgetid | sed 's/^.*"\(.*\)"$/\1/')"
    n_monitors="$(xrandr | grep -v "$LAPTOP_SCREEN" | grep ' connected' | wc -l)"
    # How to connect tot external monitors
    mode="$1"
    case "$mode" in
        discon)
            disconnect
            killall -q compton && compton &
            ;;
        auto)
            if is_connected ; then # if already connected then disconnect
                connect laptop
            else
                echo $wifi $n_monitors
                case $wifi in 
                    phswifi3) 
                        connect work 
                        ;;
                    NewTokyo03) 
                        case $n_monitors in
                            3) connect home ;;
                            2) connect shome ;;
                            *) echo 'Error detecting monitors' && exit 1 ;; esac
                        ;;
                    *) 
                        connect hybrid 
                        ;;
                esac
            fi
            ;;
        organize) 
            organize_workspaces "$2"
            ;;
        *)  
            connect "$mode" 
            ;;
    esac
    # Set wallpaper on all screens
    $HOME/dotfiles/.scripts/wallpaper.sh stay back >& /dev/null  
    # Launch status bars
    $BAR_MANAGER_SCRIPT style stay >& /dev/null
}
main $@
