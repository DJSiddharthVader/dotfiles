#!/bin/bash
laptop_screen="eDP-1"
bar_manager_script="$HOME/dotfiles/.scripts/bar-manager.sh"

help() {
    echo "Usage: $0 {ext|hybrid|laptop}"
}
resolution() {
    monitor="$1"
    #xrandr | sed -ne "/$monitor/,/connected/p" | head -2 | tail -1 | grep -ao '[0-9]*x[0-9]*'
    xrandr | sed -ne "/$monitor/,/connected/p" | sort -n | tail -1 | grep -ao '[0-9]*x[0-9_\.]*'
}
listMonitors() {
    xrandr | grep ' connected' | cut -d' ' -f1 | tr -d ' '
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
        'hybrid')
            connectToAll "$laptop_screen"
            ;;
        'multi')
            connectToAll ""
            xrandr --output "$laptop_screen" --off
            pacmd set-card-profile 0 output:hdmi-stereo
            ;;
        'laptop')
            xrandr --output "$laptop_screen" --mode "$(resolution $laptop_screen)" --primary
            disconnect
            pacmd set-card-profile 0 output:analog-stereo+input:analog-stereo
            ;;
        *) help && exit 1 ;;
    esac
}
main() {
    connect "$1"
    case "$1" in
        ext)    $bar_manager_script restart ;;
        hybrid) $bar_manager_script restart ;;
        laptop) $bar_manager_script style laptop ;;
        *) help && exit 1 ;;
    esac
    $HOME/dotfiles/.scripts/wallpaper.sh stay back
}

main "$1"
