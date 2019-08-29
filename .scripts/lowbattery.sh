#!/bin/bash

while true; do
    discharging=`acpi -b | grep -o Discharging`
    if [[ "$discharging" = "Discharging" ]]; then
        power=`acpi -b | cut -d' ' -f4 | cut -d'%' -f1`
        if (( $power < 5 )) ; then
            notify-send "BATTERY AT 5% PLUG IN NOW" -u critical
        elif (( $power < 10 )) ; then
            notify-send "Battery < 10%!" -u critical
        elif (( $power < 15 )) ; then
            notify-send "Battery < 15%!" -u critical
        fi
    fi
    sleep 60
done

#if [[ `echo $BATTINFO | grep Discharging` && `echo $BATTINFO | cut -d' ' -f 4 | cut -d'%' -f1` < 5 ]] ; then
#    notify-send "BATTERY AT 5% PLUG IN NOW" -u critical
#elif [[ `echo $BATTINFO | grep Discharging` && `echo $BATTINFO | cut -d' ' -f 4 | cut -d'%' -f1` < 10 ]] ; then
#    notify-send "Battery at 10%!" "Charging: ${battery_level}%" -u critical
#elif [[ `echo $BATTINFO | grep Discharging` && `echo $BATTINFO | cut -d' ' -f 4 | cut -d'%' -f1` < 15 ]] ; then
#fi
