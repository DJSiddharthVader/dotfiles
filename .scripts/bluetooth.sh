#!/bin/bash
shopt -s extglob
icon=""

help() {
    echo "Usage $0 {connect|disconnect|toggle|status} \$MAC_ADDR"
}
changeOutput() {
    case "$1" in
        'speakers' ) sink=1 ;;
        'both'     ) sink=2 ;;
        'bluetooth')  sink=3 ;;
        *) echo "Error: invalid sink" && exit 1
    esac
    sink="$(pactl list sinks | grep Name | cut -f2- -d' ' | head -n "$sink" | tail -1)"
    pactl set-default-sink "$sink"
    pactl list short sink-inputs | while read stream; do
        pactl move-sink-input "$(echo $stream|cut '-d ' -f1)" "$sink"
    done
}
isDeviceConnected() {
    device="$1" #uuid
    status="$(echo -e "info $device" | bluetoothctl | grep Connected | cut -d':' -f2)"
    [[ "$status" =~ 'yes' ]] && echo "yes" || echo "no"
}

disconnect() {
    echo -e "disconnect\n" | bluetoothctl > /dev/null 2>&1
    mpc pause
    changeOutput 'speakers'
}
connect() {
    device="$1"  # a uuid
    [[ "$(isDeviceConnected $device)" == 'no' ]] && echo -e "connect $device\n" | bluetoothctl
    sleep 5
    changeOutput 'bluetooth'
}
toggle() {
    device="$1"
    status="$(isDeviceConnected $device)"
    case "$status" in
        "no") connect "$device" ;;
        "yes") disconnect ;;
        *) echo "Error: invalid status message $status" && exit 1
    esac
}

getDeviceName() {
    mac="$1"
    echo -e "info $mac" | bluetoothctl | grep Name | cut -f2- -d' '
}
getConnectedDevice() {
    #check all paired devices and if connected and get name
    name=""
    while IFS= read -r uuid; do
        if [[ "$(isDeviceConnected $uuid)" == 'yes' ]]; then
            name="$name, $(getDeviceName $uuid)"
        fi
    done <<< "$(echo -e "paired-devices" | bluetoothctl | grep '^Device' | cut -f2 -d' ')"
    name="$(echo $name | sed -e 's/^, //')"
    [[ -n "$name" ]] && echo "$name" || echo "None"
}

main() {
    mode="$1"
    device="$2"
    case "$mode" in
        'connect') connect "$device" ;;
        'disconnect') disconnect "$device" ;;
        'toggle') toggle "$device" ;;
        'status') getConnectedDevice ;;
        *) help && exit 1 ;;
    esac
    #case "$mode" in
    #    connect|disconnect|toggle) ~/.scripts/bar-manager.sh reload ;;
    #    *) ;;
    #esac
    #polybar-msg hook bluetooth-ipc 1 &> /dev/null
}

if (( $# < 1 )); then
    mode="toggle"
    device="5C:C6:E9:35:57:42" #For HRF 3000 headphones
else
    mode="$1"
    device="$2"
fi

main "$mode" "$device"

