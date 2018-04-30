#!/bin/sh
if ! mpc >/dev/null 2>&1; then
    echo Server offline
    exit 1
elif mpc status | grep -q playing; then
    ( mpc current | zscroll -l 15 -d 0.25 -p " ") &
elif mpc status | grep -q paused; then
    echo "    paused  "
else
    echo Not playing
fi
# Block until an event is emitted
mpc idle >/dev/null

