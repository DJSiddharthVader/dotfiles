#!/bin/sh
#Script to scroll song name of current mpd song in polybar
spacechar="."
thresh=20
if ! mpc >/dev/null 2>&1; then
    echo Server offline
    exit 1
elif mpc status | grep -q playing; then
    if [ "$(mpc current | wc -c)" -gt "$thresh" ]; then
        ( zscroll -l "$thresh" -d 0.60 -b "" -a "" -p "///" "$(mpc current | sed -uEn 's/(^.*$)/ \1 /p' | tr '[:blank:]' "$spacechar" )" ) &
    else
        echo "$(mpc current)"
    fi
elif mpc status | grep -q paused; then
    echo "Paused"
else
    echo ""
fi
mpc idle >/dev/null
