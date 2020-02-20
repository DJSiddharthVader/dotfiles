#!/bin/bash

function displayStatus() {
    status="$(expressvpn status)"
    case $status in
        'Not Connected')
            output="N/A"
            ;;
        *)
            output="$(expressvpn status | grep 'onnec' | head -1 | cut -d'-' -f2)"
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
        *)
            echo "Usage $0 {status|toggle|connect|disconnect}"
            exit 1
            ;;
    esac
}

main "$1"
