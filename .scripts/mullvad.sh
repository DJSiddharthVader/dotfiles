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
    # mullvad status | grep -o '[^ ]*onnect[^ ]*' | tr -d ' '
    mullvad status | head -1
}
display() {
    mode="$1"
    case "$(status)" in
        Connected|Connecting)
            case "$mode" in
                'ip') 
                    output="$(mullvad status | head -2 | rev | cut -d' ' -f1 | rev)" 
                    ;;
                'location') 
                    output="$(mullvad status | head -2 | cut -d':' -f2 | grep -o '^[^ ].*[\.]')"
                    ;;
            esac
            ;;
        Disconnected|Disconnecting) output="None" ;;
    esac
    echo " $output" | tr -d '"'
}

connect() {
    location=$1
    if [[ -n $location ]]; then
        mullvad relay set location $location
    fi
    mullvad connect
    transmission.sh resume > /dev/null 2>&1
}
disconnect() {
    transmission.sh pause > /dev/null 2>&1
    mullvad disconnect
}
toggle() {
    [[ "$(status)" =~ "Disconnected" ]] && connect || disconnect
}
restart() {
   disconnect && connect
}

main() {
    mode="$1"
    location="$2"
    case $mode in
        'status'    ) status        ;;
        'restart'   ) restart       ;;
        'toggle'    ) toggle        ;;
        'connect'   ) connect "$2"  ;;
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
    sleep 1
    case $mode in
        toggle    ) polybar-msg action "#mullvad.hook.0" ;;
        connect   ) polybar-msg action "#mullvad.hook.0" ;;
        disconnect) polybar-msg action "#mullvad.hook.0" ;;
    esac
}

main "$@"
