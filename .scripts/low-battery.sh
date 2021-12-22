#!/bin/bash
threshes=(10 15 20 25)
send_notif() {
    msg="$1"
    notify-send "$msg" -u critical
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
            for thresh in ${threshes[@]}; do
                if (( $(get_percent) < $thresh )) ; then
                    send_notif "Battery < $thresh%"
                    break
                fi
            done
        fi
        sleep 30
    done
}

main
