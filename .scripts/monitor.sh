#!/bin/bash
LAPTOP_SCREEN="eDP"
LAPTOP_RESOLUTION="2560x1600"
BAR_MANAGER_SCRIPT="$HOME/dotfiles/.scripts/bar-manager.sh"
# Get info
help() {
    echo "Usage: $0 {auto|home|proj|ext|hybrid|laptop|mirror|organize}"
}
list_available_monitors() {
    xrandr | grep '[^ ]\+ connected' | cut -d' ' -f1 | grep -v "$LAPTOP_SCREEN"
}
list_active_monitors() {
    xrandr --listmonitors | tail -n+2 | rev | cut -d' ' -f1 | rev
}
is_connected() {
    [[ "$(list_active_monitors | grep -v "$LAPTOP_SCREEN" | wc -l)" -ge 1 ]]
}
# Handle external devices
connect_audio() {
    mode="$1"
    case "$mode" in
        laptop) sink="alsa_output.pci-0000_c1_00.6.analog-stereo" ;;
        home)   sink="alsa_output.pci-0000_c1_00.1.hdmi-stereo-extra2" ;;
        hdmi)   sink="$(pactl list sinks | grep -E 'Name' | grep 'hdmi-' | cut -d':' -f2- | tr -d ' ')" ;;
        *)      echo "Invalid mode use {laptop|hdmi|home}" && exit 1 ;;
    esac
    pactl set-default-sink ${sink}
}
disconnect(){
    # disconnect all external monitors except laptop screen
    while IFS= read -r monitor; do
        if [[ $monitor != $LAPTOP_SCREEN ]]; then
            echo "disconnecting $monitor"
            xrandr --output $monitor --off
        fi
    done <<< "$(list_active_monitors)"
}
connect() {
    echo "mode: $1"
    monitors="$(list_available_monitors)"
    case "$1" in
        home)
            m3="$(echo "$monitors" | head -1)"
            m2="$(echo "$monitors" | head -2 | tail -1)"
            m1="$(echo "$monitors" | head -3 | tail -1)"
            echo "$m1 ||| $m2 ||| $m3"
            xrandr --verbose \
                   --output $m1 --mode 2560x1600_60.00 --rate 60 --dpi 96 \
                   --output $m2 --mode 2560x1600_60.00 --rate 60 --dpi 96 --right-of $m1 --rotate left \
                   --output $m3 --mode 3840x2160       --rate 60          --right-of $m2 \
                   --output $LAPTOP_SCREEN --off
            connect_audio home
            organize_workspaces home
            ;;
        shome)
            m2="$(echo "$monitors" | head -1)"
            m1="$(echo "$monitors" | head -2 | tail -1)"
            echo "$m1 ||| $m2"
            xrandr --verbose \
                   --output $m1 --mode 2560x1600_60.00 --rate 60 --dpi 96 \
                   --output $m2 --mode 2560x1600_60.00 --rate 60 --dpi 96 --right-of $m1 --rotate left \
                   --output $LAPTOP_SCREEN --off
            organize_workspaces work
            ;;
        work)
            m1="$(echo "$monitors" | head -1)"
            echo $m1
            xrandr \
                --verbose \
                --output "$LAPTOP_SCREEN" --mode "$LAPTOP_RESOLUTION" --primary \
                --output $m1 --mode 1920x1080 --scale 1.33x1.48 --right-of "$LAPTOP_SCREEN" --rotate left
            organize_workspaces work
            ;;
        hybrid)
            prev=$LAPTOP_SCREEN
            while IFS= read -r monitor; do
                if [[ $monitor != $LAPTOP_SCREEN ]]; then
                    xrandr --output $monitor --auto --right-of $prev
                    prev="$monitor"
                fi
            done <<< "$(list_available_monitors)"
            ;;
        ext)
            connect hybrid
            xrandr --output "$LAPTOP_SCREEN" --off 
            ;;
        mirror)
            while IFS= read -r monitor; do
                xrandr --output $monitor --same-as $LAPTOP_SCREEN
            done <<< "$(list_available_monitors)"
            ;;
        laptop)
            disconnect
            xrandr --output "$LAPTOP_SCREEN" --mode "$LAPTOP_RESOLUTION" --primary
            connect_audio laptop
            ;;
        *) echo "invalid mode" && help && exit 1 ;;
    esac
    # sleep 3 && killall -q picom && sleep 1 && picom &
    ~/.scripts/wallpaper.sh stay back >& /dev/null
}
organize_workspaces() {
    mode="$1"
    case "$mode" in
        home) 
            declare -A workspace_monitors=(
                ["0"]="DisplayPort-11"
                ["1"]="DisplayPort-1"
                ["2"]="DisplayPort-9"
                ["3"]="DisplayPort-9"
                ["4"]="DisplayPort-11"
                ["5"]="DisplayPort-9"
                ["6"]="DisplayPort-9"
                ["7"]="DisplayPort-11"
                ["8"]="DisplayPort-11"
                ["9"]="DisplayPort-11"
            )
            for workspace in "${!workspace_monitors[@]}"; do
                monitor=${workspace_monitors[${workspace}]}
                echo "${workspace} ||| ${monitor}"
                i3-msg workspace ${workspace}
                i3-msg move workspace to output ${monitor}
            done
            i3-msg workspace 1
            i3-msg workspace 4
            i3-msg workspace 2
            return 
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
# Main
main() {
    mode="$1"
    case ${mode} in 
        auto)
            if is_connected ; then # if already connected then disconnect
                echo 'thinks already connected'
                connect laptop
            else
                wifi="$(iwgetid | sed 's/^.*"\(.*\)"$/\1/')"
                n_monitors="$(list_available_monitors | wc -l | tr -d ' ')"
                echo "$wifi ||| $n_monitors"
                case $wifi in 
                    phswifi3) connect work ;;
                    NewTokyo03) 
                        case $n_monitors in
                            3) connect home ;;
                            2) connect shome ;;
                            *) echo 'Error detecting monitors' && exit 1 ;; esac
                        ;;
                    *) connect hybrid ;;
                esac
            fi
            ;;
        list_av)  list_available_monitors ;;
        list_ac)  list_active_monitors ;;
        audio)    connect_audio "${2}" ;;
        organize) organize_workspaces "$2" ;;
        discon)   disconnect ;;
        *)        connect "$mode" ;;
    esac
    # Set wallpaper on all screens
    $HOME/dotfiles/.scripts/wallpaper.sh stay back >& /dev/null  
    # Launch status bars
    $BAR_MANAGER_SCRIPT style stay >& /dev/null
}
main $@
