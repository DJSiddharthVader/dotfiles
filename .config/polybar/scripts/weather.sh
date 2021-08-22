#!/bin/bash

#Vars
API="https://api.openweathermap.org/data/2.5"
KEY="f8411a3dd03e0674a17b8e736c2d0df5"
CITY="Pittsburgh"
UNITS="metric"
SYMBOL="°"

icon() {
    case $1 in
        01d) icon="";;
        01n) icon="";;
        02d) icon="";;
        02n) icon="";;
        03*) icon="";;
        04*) icon="";;
        09d) icon="";;
        09n) icon="";;
        10d) icon="";;
        10n) icon="";;
        11d) icon="";;
        11n) icon="";;
        13d) icon="";;
        13n) icon="";;
        50d) icon="";;
        50n) icon="";;
        *) icon="";
    esac
    echo $icon
}
main() {
    if [ -n "$CITY" ]; then
        if [ "$CITY" -eq "$CITY" ] 2>/dev/null; then
            CITY_PARAM="id=$CITY"
        else
            CITY_PARAM="q=$CITY"
        fi
        weather=$(curl -sf "$API/weather?appid=$KEY&$CITY_PARAM&units=$UNITS")
    else #no city set
        location=$(curl -sf https://location.services.mozilla.com/v1/geolocate?key=geoclue)
        if [ -n "$location" ]; then
            lattitude="$(echo "$location" | jq '.location.lat')"
            longitude="$(echo "$location" | jq '.location.lng')"

            weather=$(curl -sf "$API/weather?appid=$KEY&lat=$lattitude&lon=$longitude&units=$UNITS")
        fi
    fi
    temp=$(echo "$weather" | jq ".main.temp" | cut -d "." -f 1)
    icon="$(icon "$(echo "$weather" | jq -r ".weather[0].icon")")"
    echo "$icon $temp$SYMBOL"
}

main
