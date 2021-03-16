#!/bin/bash

help() { echo "Usage $(basename $0) {status|location|toggle|connect|disconnect}" ; }
status() {
    [[ "$(protonvpn-cli s)" =~ 'No active' ]] && msg="not connected" || msg="connected"
    echo "$msg"
}
connect() {
    #protonvpn-cli ks --on
    if [[ -z "$1" ]]; then
        protonvpn-cli connect -p tcp -f
    else
        protonvpn-cli connect -p tcp "$1"
    fi
}
disconnect() {
    #protonvpn-cli ks --off
    protonvpn-cli disconnect
}
toggle() {
    [[ "$(status)" == "not connected" ]] && connect "$1" || disconnect
}
reload() {
    disconnect && connect
}
pick_location() {
    st -n protonvpn -e protonvpn-cli -c
}
display() {
    case "$(status)" in
        'not connected') output="Not Connected" ;;
        'connected'    ) output="$(protonvpn-cli s | grep 'Country:\|Server:' | cut -d':' -f2 | tr '\n' ' ' | tr -s ' \t' ' ')" ;;
    esac
    echo "$output"
}
main() {
    mode="$1"
    case $mode in
        'status'    ) status        ;;
        'display'   ) display       ;;
        'reload'    ) reload        ;;
        'toggle'    ) toggle        ;;
        'connect'   ) connect       ;;
        'disconnect') disconnect    ;;
        'location'  ) pick_location ;;
        *) help && exit 1 ;;
    esac
}

main "$1"

