#!/bin/bash

send_notif() {
    msg="$1"
    notify-send "$msg" -u critical
}

threshes=(10 15 20 25)
while true; do
    status="$(acpi -b | grep -o " [^ ]*Charging" | head -1)"
    if [[ "$status" = " Discharging" ]]; then
        power=$(acpi -b | cut -d' ' -f4 | cut -d'%' -f1 | head -1)
        for thresh in ${threshes[@]}; do
            if (( $power < $thresh )) ; then
                send_notif "Battery < $thresh%, Charge laptop"
                break
            fi
        done
    fi
    sleep 30
done
