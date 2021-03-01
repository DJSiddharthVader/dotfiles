#!/bin/bash
primary="eDP-1"

resolution() {
    monitor="$1"
    xrandr | sed -ne "/$monitor/,/connected/ p"  \
           | grep -v 'connected'  \
           | head -1  \
           | grep -ao '[0-9]*x[0-9]*'
}
connect() {
    #for monitor in $(xrandr | grep ' connected'); do
    first=""
    while IFS= read -r monitor; do
        if [[ "$monitor" != "$primary" ]]; then
            resolution="$(resolution "$monitor")"
            echo $monitor $resolution $first
            if [[ -z "$first" ]]; then
                xrandr --output "$monitor" --mode "$resolution" --primary
                #pactl set-card-profile 0 output:hdmi-stereo
                first="$monitor"
            else
                xrandr --output "$monitor" --mode "$resolution" --right-of "$first"
            fi
        fi
    done <<< "$(xrandr | grep ' connected' | cut -f1 -d' ')"
    xrandr --output "$primary" --off #turn off main monitor
}
disconnect() {
    xrandr --output "$primary" --mode "$(resolution $primary)" --primary
    while IFS= read -r monitor; do
        echo "$monitor"
        if [[ $monitor != $primary ]]; then
            xrandr --output "$monitor" --off
        fi
    done <<< "$(xrandr | grep ' connected' | cut -d' ' -f1)"
}
function main() {
    case "$1" in
        on) connect; ~/dotfiles/.scripts/bar-manager.sh restart ;;
        off) disconnect; ~/dotfiles/.scripts/bar-manager.sh restart ;;
        *) echo "usage {on|off}" && exit 1 ;;
    esac
}

main "$1"

