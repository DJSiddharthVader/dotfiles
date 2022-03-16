#!/bin/bash
THRESH=25

send_notif() {
    notify-send "$1" -u critical 
    mpv --volume=50 "$HOME/.varfiles/low_battery_alert.flac" > /dev/null 2>&1

}
get_status() {
    acpi -b | grep -v 'unavailable' | sed -e 's/^.* \([^ ]*harging\).*$/\1/'
}
get_percent() {
    acpi -b | grep -v 'unavailable' | sed -e 's/^.* \([0-9]*\)%.*$/\1/'
}
main() {
    while true; do
        if [[ "$(get_status)" == "Discharging" ]]; then
            if (( $(get_percent) < $THRESH )) ; then
                send_notif "Battery < $(get_percent)%"
            fi
        fi
        sleep 60
    done
}

main
