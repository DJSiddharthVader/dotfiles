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
get_status() {
    device="$1" #uuid
    [[ "$(isDeviceConnected $device)" == 'yes' ]] && echo "$icon $(getDeviceName $device)" || echo "$icon None"
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
    echo -e "info $mac" | bluetoothctl | grep Name | head -1 | cut -f2- -d' '
}
getConnectedDevice() {
    #check all paired devices and if connected and get name
    name=""
    while IFS= read -r uuid; do
        if [[ "$(isDeviceConnected $uuid)" == 'yes' ]]; then
            name="$name, $(getDeviceName $uuid)"
        fi
    done <<< "$(echo -e "paired-devices" | bluetoothctl | grep '^Device' | cut -f2 -d' ')"
    [[ -n "$name" ]] && echo "$icon $name" | sed -e 's/^[, ]*//' || echo "$icon None"
}
main() {
    mode="$1"
    device="$2"
    case "$mode" in
        connect   ) connect "$device" 
                    sleep 1
                    polybar-msg action "#bluetooth.hook.0" 
            ;;
        disconnect) disconnect "$device" 
                    sleep 1
                    polybar-msg action "#bluetooth.hook.0" 
            ;;
        toggle    ) toggle "$device" 
                    sleep 1
                    polybar-msg action "#bluetooth.hook.0" 
            ;;
        status    ) get_status "$device" 
            ;;
        *) help && exit 1 ;;
    esac
}
# Set default args if not given
[[ -n "$1" ]] && mode="$1" || mode='toggle'
[[ -n "$2" ]] && device="$2" || device="74:45:CE:F9:14:A8" # MTH20xBT
echo $mode $device
# Main 
main "$mode" "$device"
