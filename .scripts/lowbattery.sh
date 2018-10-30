#!/bin/bash
while true
do
    battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
    if [ [$battery_level -le 5 ]; then
        notify-send "BATTERY AT 5% PLUG IN NOW" -u critical
    elif [ [$battery_level -le 10 ]; then
        notify-send "Battery at 10%!" "Charging: ${battery_level}%" -u critical
    elif [ [$battery_level -le 15 ]; then
        notify-send "Battery at 15%!" "Charging: ${battery_level}%"
    fi
    sleep 120
done]]
