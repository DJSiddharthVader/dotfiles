#!/bin/bash

downloadpage='https://www.expressvpn.com/latest?utm_source=linux_app#linux'

update() {
    if [ "$(expressvpn status | grep -c 'A new version is available')" -eq 1 ]; then
        deb_url="$(wget -O - "$downloadpage" | grep 'name=\"linux-download\"' | grep -oP '(?<=value=\")https.*(?=\">Ubuntu)')"
        cd ~/Downloads && wget "$deb_url"
        sudo dpkg -i expressvpn*.deb
        rm -f expressvpn*.deb && cd -
        echo "Finished"
    else
        echo "No update available"
        exit 0
    fi
}
display() {
    status="$(expressvpn status | tail -1)"
    case $status in
        'Not Connected') output="N/A" ;;
        *) output="$(expressvpn status | grep 'onnect' | head -1 | cut -d'-' -f2 | tr -d '\[\;[0-9]m?' )" ;;
    esac
    echo " $output"
}
toggle() {
    status="$(expressvpn status | tail -1)"
    if [[ "$status" == "Not connected" ]]
    then
        expressvpn connect
    else
        expressvpn disconnect
    fi
}
main() {
    mode="$1"
    case $mode in
        'status') display ;;
        'toggle') toggle ;;
        'connect') expressvpn connect ;;
        'disconnect') expressvpn disconnect ;;
        'update') update ;;
        *) echo "Usage $0 {status|toggle|connect|disconnect|update}" && exit 1 ;;
    esac
}

main "$1"
