#!/bin/bash
shopt -s extglob
mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
modes=(ip location) #no spaces in mode titles
icon=""

help() {
    echo "Usage $(basename $0) {restart||toggle|connect|disconnect|display|next|prev|$(echo ${modes[*]} | tr ' ' '|')}"
}
getMode() {
    grep '^mullvad:' "$mode_file" | cut -d':' -f2
}
setMode() {
    sed -i "/^mullvad:/s/:.*/:$1/" "$mode_file"
}

status() {
    mullvad status | sed -e 's/^.*: \(\S*\)\b.*$/\1/'
}
connect() {
    mullvad connect
}
disconnect() {
    mullvad disconnect
}

toggle() {
    [[ "$(status)" =~ "Disconnected" ]] && connect || disconnect
}
restart() {
   disconnect && connect
}
display() {
    mode="$1"
    case "$(status)" in
        'Connected')
            info="$(curl -s ipinfo.io)"
            case "$1" in
                'ip') output="$(echo "$info" | jq .ip)" ;;
                'location') output="$(echo "$info" | jq .country)" ;;
            esac
            ;;
        'Disconnected') output="None" ;;
        *) sleep 1 && display ;;
    esac
    echo "$output" | tr -d '"'
}
main() {
    mode="$1"
    case $mode in
        'status'    ) status        ;;
        'restart'   ) restart       ;;
        'toggle'    ) toggle        ;;
        'connect'   ) connect       ;;
        'disconnect') disconnect    ;;
        'display') # display vpn data
            [[ -z "$2" ]] && dmode="$(getMode)" || dmode="$2"
            display "$dmode"
            ;;
        *) # change/set display mode
            tmp="@($(echo ${modes[*]} | sed -e 's/ /|/g'))"
            case "$mode" in
                'next'  ) dmode="$(cycle 'next')" ;;
                'prev'  ) dmode="$(cycle 'prev')" ;;
                $tmp    ) dmode="$mode" ;; #capture any valid mode
                *       ) help && exit 1 ;;
            esac
            setMode "$dmode"
            ;;
    esac
    case $mode in
        toggle|connect|disconnect) polybar-msg hook mullvad 1 >| /dev/null ;;
    esac
}

main "$1"
