#!/bin/bash

threshes=(10 15 20 25)

send_notif() {
    msg="$1"
    notify-send "$msg" -u critical
}
main() {
    while true; do
        status="$(acpi -b | grep -o " [^ ]*harging" | head -1)"
        if [[ "$status" = " Discharging" ]]; then
            power=$(acpi -b | grep -v "unavailable" | cut -d' ' -f4 | cut -d'%' -f1 | head -1)
            for thresh in ${threshes[@]}; do
                if (( $power < $thresh )) ; then
                    send_notif "Battery < $thresh%"
                    break
                fi
            done
        fi
        sleep 30
    done
}
main
