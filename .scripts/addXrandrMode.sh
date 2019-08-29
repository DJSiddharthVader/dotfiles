#!/bin/bash

hres="$1"
vres="$2"
name="$hres"x"$vres"

modeline="$(cvt "$hres" "$vres" | tail -1 | cut -d' ' -f3-)"
xrandr --newmode "$name" "$modeline"
monitor="$(xrandr | grep ' connected' | tail -1 | cut -d' ' -f1)"
xrandr --addmode "$monitor" "$name"
