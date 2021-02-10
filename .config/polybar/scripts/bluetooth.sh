#!/bin/bash

setDefaultSink() {
    case "$1" in
        'speakers' ) sink=1 ;;
        'both'     ) sink=2 ;;
        'bluetooth')  sink=3 ;;
        *) echo "Error: invalid sink" && exit 1
    esac
    sink="$(pactl list sinks | grep Name | cut -f2- -d' ' | head -n "$sink" | tail -1)"
    pactl set-default-sink "$sink"
}
isDeviceConnected() {
    device="$1" #uuid
    status="$(echo -e "info $device" | bluetoothctl | grep Connected | cut -d':' -f2)"
    [[ "$status" =~ 'yes' ]] && msg="yes" || msg="no"
    echo "$msg"
}
disconnect() {
    echo -e "disconnect\n" | bluetoothctl > /dev/null 2>&1
    setDefaultSink 'speakers'
}
connect() {
    device="$1"  # a uuid
    while [[ "$(isDeviceConnected $device)" == 'no' ]]; do
        echo -e "connect $device\n" | bluetoothctl /dev/null 2>&1
        sleep 10
    done
    setDefaultSink 'bluetooth'
}
toggle() {
    device="$1"
    status="$(isDeviceConnected $device)"
    case "$status" in
        "no") connect "$device" ;;
        "yes") disconnect ;;
        *) echo "Error: invalid status message $status" && exit 1
    esac
    ~/.scripts/bar-manager.sh reload
}

getDeviceName() {
    device="$1"
    echo -e "info $device" | bluetoothctl | grep Name | cut -f2- -d' '
}
getConnectedDevice() {
    #check all paired devices and if connected and get name
    name="None"
    while IFS= read -r uuid; do
        [[ "$(isDeviceConnected $uuid)" = 'yes' ]] && name="$(getDeviceName $uuid)" && break
    done <<< "$(echo -e "paired-devices" | bluetoothctl | cut -f2 -d' ')"
    echo " $name"
}

main() {
    mode="$1"
    device="$2"
    case "$mode" in
        'connect') connect "$device" ;;
        'disconnect') disconnect "$device" ;;
        'toggle') toggle "$device" ;;
        'status') getConnectedDevice ;;
        *)
    esac
}

if (( $# < 1 )); then
    mode="toggle"
    device="5C:C6:E9:35:57:42" #For HRF 3000 headphones
else
    mode="$1"
    device="$2"
fi

main "$mode" "$device"


#DEPRECIATED
#setDefaultSink() { #DOES NOT WORK
#    case "$1" in
#        'bluetooth') sink="$(pactl list short sinks | grep bluez | head -1 | tr -s '\t' ' ' | cut -d' ' -f1)" ;;
#        'speaker') sink="1" ;;
#        *) echo "invalid sink" && exit 1 ;;
#    esac
#    pactl set-default-sink "$sink"
#}
#isConnected() {
#    status=""
#    while IFS= read -r uuid; do #read all paired devices and check if connected
#        status="$status\n$(isDeviceConnected $uuid)"
#    done <<< "$(echo -e "paired-devices" | bluetoothctl | cut -f2 -d' ')"
#    [[ "$(uniq $status)" =~ 'yes' ]] && msg="yes" || msg="no"
#    echo "$msg"
#
#}
