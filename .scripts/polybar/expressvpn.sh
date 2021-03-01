#!/bin/bash

downloadpage='https://www.expressvpn.com/latest?utm_source=linux_app#linux'

help() { echo "Usage $0 {status|pick|toggle|connect|disconnect|update}" ; }
update() {
    if [ "$(expressvpn status | grep -c 'A new version is available')" -eq 1 ]; then
        deb_url="$(wget -O - "$downloadpage" | grep 'name=\"linux-download\"' | grep -oP '(?<=value=\")https.*(?=\">Ubuntu)')"
        cd ~/Downloads && wget "$deb_url"
        sudo dpkg -i expressvpn*.deb
        rm -f expressvpn*.deb && cd -
        echo "Finished"
    else
        echo "No update available" && exit 0
    fi
}
status() { expressvpn status | head -1 ; }
connect() { expressvpn connect ; }
disconnect() { expressvpn disconnect ; }
toggle() { [[ "$(status)" =~ "Not connected" ]] && connect || disconnect ; }
pick_location() {
    location="$(expressvpn list all | tail -n+3  |\
                sed -e 's/ - /-/g' -e 's/[ Y]\+$//' |\
                grep -o '  [A-Za-z\-]*[^\s]$' | cut -f3 -d' ' |\
                rofi -m -3 -width 20 -lines 5 -dmenu
                )"
    code="$(expressvpn list all | grep "$(echo "$location" | sed -e 's/-/ - /g')" | head -1 | cut -f1 -d' ')"
    [[ "$(status)" == "Not connected" ]] || disconnect
    expressvpn connect "$code"
}
display() {
    case "$(status)" in
        'Not Connected') output="N/A" ;;
        *) output="$(expressvpn status | grep 'onnect' | head -1 | cut -d'-' -f2 | tr -d '\[\;[0-9]m?' )" ;;
    esac
    echo "$output"
}
main() {
    mode="$1"
    case $mode in
        'status'    ) display       ;;
        'pick'      ) pick_location ;;
        'toggle'    ) toggle        ;;
        'connect'   ) connect       ;;
        'disconnect') disconnect    ;;
        'update'    ) update        ;;
        *) help && exit 1 ;;
    esac
}

main "$1"
