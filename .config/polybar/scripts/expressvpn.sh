#!/bin/bash

function update() {
    downloadpage='https://www.expressvpn.com/latest?utm_source=linux_app#linux'
    deb_local='~/Downloads/latest_expressvpn.deb'
    if [ "$(expressvpn status | grep -c 'A new version is available')" -eq 1 ]; then
        deb_url="$(wget -O - "$downloadpage" | grep 'name=\"linux-download\"' | grep -oP '(?<=value=\")https.*(?=\">Ubuntu)')"
        wget "$deb_url" -O "$deb_local"
        sudo dpkg -i $deb_local
        \rm -f $deb_local
        echo "Finished"
    else
        echo "No update available"
        exit 0
    fi
}
function displayStatus() {
    status="$(expressvpn status)"
    case $status in
        'Not Connected')
            output="N/A"
            ;;
        *)
            output="$(expressvpn status | grep 'onnect' | head -1 | cut -d'-' -f2)"
            ;;
    esac
    echo "$output"
}
function toggleConnection() {
    status="$(expressvpn status)"
    if [[ "$status" == "Not connected" ]]
    then
        expressvpn connect
    else
        expressvpn disconnect
    fi
}
function main() {
    mode="$1"
    case $mode in
        'status')
            displayStatus
            ;;
        'toggle')
            toggleConnection
            ;;
        'connect')
            expressvpn connect
            ;;
        'disconnect')
            expressvpn disconnect
            ;;
        'update')
            update
            ;;
        *)
            echo "Usage $0 {status|toggle|connect|disconnect|update}"
            exit 1
            ;;
    esac
}

main "$1"
