#!/bin/bash
LAPTOP_SCREEN="eDP"
FPS=60
DPI=90
LAPTOP_RESOLUTION="2560x1600"
SCRIPT_DIR="${HOME}/dotfiles/.scripts"
# Get info
help() {
    echo "Automatically detect monitors available and what config to use
Usage: $0 \${CMD} [\${MODE}]
    CMDs:  {connect|disconnect|organize|audio|post_clean|info|list_av|list_ac}
    MODEs: {home|hybrid|ext|mirror|laptop}
    auto           Auto detect from the following list (hybrid > ext > mirror)
                   note that any mode can be explicitly specified by doing
                   \$ $0 connect ${mode}
        home   3:  home config, 2 monitors + projector
        hybrid *:  new workspaces per monitor, keep laptop screen on 
        ext    *:  new workspaces per monitor, turn off laptop screen
        mirror 1:  mirror laptop onto external display
        laptop 0:  No monitors connected, just laptop
    disconnect     disconnect all external monitors
    organize       Organize workspaces on monitors (config specific)
    audio          Switch audio output (config specific)
    post_clean     Run organize+audio (config specific)
    info           Print info used/relevant when handling monitor config
    list_av        List monitors detected by xrandr
    list_ac        List mointors actively displaying something
"
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
detect_mode() {
    if is_connected ; then # if already connected then disconnect
        wifi="$(iwgetid | sed 's/^.*"\(.*\)"$/\1/')"
        n_monitors="$(list_available_monitors | wc -l | tr -d ' ')"
        case $wifi in 
            phswifi3) mode="work" ;;
            NewTokyo03) 
                case $n_monitors in
                    3) mode="home" ;;
                    2) mode="shome" ;;
                    1) echo 'Error: detected 0 monitors' && exit 1 ;; 
                    *) echo 'Error detecting monitors' && exit 1 ;; 
                esac
                ;;
            *) mode="hybrid" ;;
        esac
    else
        mode="laptop"
    fi
    echo "${mode}"
}
info() {
    echo "Detected Mode:      $(detect_mode)
Monitors Detected:  $(list_available_monitors)
Is Connected:       $(is_connected && echo TRUE || echo FALSE)
Active Displays:    $(list_active_monitors | paste -sd',')
# of Monitors:      $(list_available_monitors | wc -l | tr -d ' ')
Audio:              $(pactl get-default-sink)
Wifi:               $(iwgetid | sed 's/^.*"\(.*\)"$/\1/')"
}
# Handle external devices
connect_audio() {
    mode="$1"
    case "$mode" in
        home)   
            sink="alsa_output.pci-0000_c1_00.1.hdmi-stereo-extra2" 
            ;;
        laptop|work) 
            sink="alsa_output.pci-0000_c1_00.6.analog-stereo" 
            ;;
        shome|hybrid|ext|mirror)
            sink="$(pactl list sinks short | cut -f2)"
            ;;
        *) 
            echo "invalid mode" && help && exit 1 
            ;;
    esac
    pactl set-default-sink ${sink}
}
organize_workspaces() {
    mode="$1"
    monitors="$(list_active_monitors)"
    case "$mode" in
        home) 
            m3="$(echo "$monitors" | head -1)"
            m2="$(echo "$monitors" | head -2 | tail -1)"
            m1="$(echo "$monitors" | head -3 | tail -1)"
            declare -A workspace_monitors=(
                ["0"]="${m1}"
                ["1"]="${m3}"
                ["2"]="${m1}"
                ["3"]="${m1}"
                ["4"]="${m1}"
                ["5"]="${m2}"
                ["6"]="${m2}"
                ["7"]="${m1}"
                ["8"]="${m1}"
                ["9"]="${m1}"
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
            m1="$(echo "$monitors" | head -1)"
            m2="$(echo "$monitors" | head -2 | tail -1)"
            declare -A workspace_monitors=(
                ["0"]="${m1}"
                ["1"]="${m1}"
                ["2"]="${m2}"
                ["3"]="${m1}"
                ["4"]="${m1}"
                ["5"]="${m2}"
                ["6"]="${m2}"
                ["7"]="${m1}"
                ["8"]="${m1}"
                ["9"]="${m1}"
            )
            for workspace in "${!workspace_monitors[@]}"; do
                monitor=${workspace_monitors[${workspace}]}
                echo "${workspace} ||| ${monitor}"
                i3-msg workspace ${workspace}
                i3-msg move workspace to output ${monitor}
            done
            i3-msg workspace 4
            i3-msg workspace 5
            return 
            ;;
        work)
            m1="$(echo "$monitors" | head -1)"
            m2="$(echo "$monitors" | head -2 | tail -1)"
            echo "${m1} || ${m2}"
            echo ${workspace_monitors[@]}
            declare -A workspace_monitors=(
                ["0"]="${m1}"
                ["1"]="${m1}"
                ["2"]="${m2}"
                ["3"]="${m1}"
                ["4"]="${m1}"
                ["5"]="${m2}"
                ["6"]="${m2}"
                ["7"]="${m1}"
                ["8"]="${m1}"
                ["9"]="${m1}"
            )
            for workspace in "${!workspace_monitors[@]}"; do
                monitor=${workspace_monitors[${workspace}]}
                echo "${workspace} ||| ${monitor}"
                i3-msg workspace ${workspace}
                i3-msg move workspace to output ${monitor}
            done
            i3-msg workspace 4
            i3-msg workspace 5
            return 
            ;;
        hybrid|ext|mirror)
            return ;;
        *) help && return 1 ;;
    esac
}
clean_up() {
    mode="${1}"
    # Set wallpaper on all screens
    ${SCRIPT_DIR}/wallpaper.sh stay back >& /dev/null  
    ${SCRIPT_DIR}/bar-manager.sh restart >& /dev/null
    connect_audio ${mode}
    organize_workspaces ${mode}
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
add_modes() {
    x="${1}"
    y="${2}"
    fps="${3}"
    monitors=${@:4}
    modename="$(cvt ${x} ${y} ${fps} | tail -1 | cut -d ' ' -f2 | tr -d '"')"
    modeline="$(cvt ${x} ${y} ${fps} | tail -1 | cut -d ' ' -f3-)"
    xrandr --newmode ${modename} ${modeline}
    for monitor in ${monitors[@]}; do
        xrandr --addmode ${monitor} ${modename}
    done
    echo ${modename}
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
            modename="$(add_modes 2560 1600 60 ${m1} ${m2})"
            xrandr --verbose \
                   --output ${m1} --mode ${modename} --rate ${FPS} --dpi ${DPI} \
                   --output ${m2} --mode ${modename} --rate ${FPS} --dpi ${DPI} --right-of ${m1} --rotate left \
                   --output ${m3} --mode 3840x2160   --rate ${FPS}              --right-of ${m2} \
                   --output ${LAPTOP_SCREEN} --off
            ;;
        shome)
            modename="$(cvt 2560 1600 ${FPS} | tail -1 | cut -d ' ' -f2 | tr -d '"')"
            modeline="$(cvt 2560 1600 ${FPS} | tail -1 | cut -d ' ' -f3)"
            m2="$(echo "$monitors" | head -1)"
            m1="$(echo "$monitors" | head -2 | tail -1)"
            modename="$(add_modes 2560 1600 60 ${m1} ${m2})"
            xrandr --verbose \
                   --output ${m1} --mode ${modename} --rate ${FPS} --dpi ${DPI} \
                   --output ${m2} --mode ${modename} --rate ${FPS} --dpi ${DPI} --right-of ${m1} --rotate left \
                   --output ${LAPTOP_SCREEN} --off
            ;;
        work)
            m1="$(echo "$monitors" | head -1)"
            echo $m1
            xrandr \
                --verbose \
                --output "$LAPTOP_SCREEN" --mode "$LAPTOP_RESOLUTION" --primary \
                --output $m1 --mode 1920x1080 --scale 1.33x1.48 --right-of "$LAPTOP_SCREEN" --rotate left
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
            ;;
        *) echo "invalid mode" && help && exit 1 ;;
    esac
    # sleep 3 && killall -q picom && sleep 1 && picom &
    wait
    clean_up ${mode}
}
# Main
main() {
    cmd="${1}"
    [[ -z "${2}" ]] && mode="$(detect_mode)" || mode="${2}"
    case ${cmd} in 
        connect)    connect ${mode} ;;
        disconnect) disconnect ;;
        info)       info ;;
        "list_av")    list_available_monitors ;;
        "list_ac")    list_active_monitors ;;
        audio)      connect_audio ${mode} ;;
        organize)   organize_workspaces ${mode} ;;
        "post_clean") clean_up ${mode} ;;
        *)          connect ${mode} ;;
    esac
}
main ${@}
