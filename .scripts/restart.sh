#!/bin/bash
services=(compton pulse wifi)

help() {
    echo "Error: usage $0 \$SERVICE {stop|start|restart}"
}
stop() {
    service="$1"
    case "$service" in
        'compton') killall -q compton ;;
        'pulse'  ) mpc pause; pulseaudio --kill ;;
        'wifi'   ) sudo /etc/init.d/network-manager stop ;;
        *) help && exit 1 ;;
    esac
}
start() {
    service="$1"
    case "$service" in
        'compton') compton --config "$HOME"/.config/compton.conf > /dev/null 2>&1 & ;;
        'pulse'  ) pulseaudio --start; ~/dotfiles/.scripts/bar-manager.sh reload ;;
        'wifi'   ) sudo ln -sf /etc/resolv.conf /run/resolvconf/resolv.conf
                   sudo /etc/init.d/network-manager start
                   ;;
        *) help && exit 1 ;;
    esac
}
restart() {
    stop "$1" && start "$1"
}
rofi_menu() {
    service="$(echo $sevices | tr ' ' '\n' | rofi -m -3 -width 20 -lines 5 -dmenu)"
    [[ -n "$service" ]] && restart "$service"
}
main() {
    service="$1"
    mode="$2"
    if [[ "$service" == 'menu' ]]; then
        rofi_menu
    else
        case "$mode" in
            'stop') stop "$service" ;;
            'start') start "$service" ;;
            'restart') restart "$service" ;;
            *) help && exit 1 ;;
        esac
    fi
}

if (( $# == 1 )); then
    service="$1"
    mode="restart"
else
    service="$1"
    mode="$2"
fi

main "$service" "$mode"
