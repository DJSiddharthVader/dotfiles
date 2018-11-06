#!/bin/bash

# Take /tmp/screen.pnga screenshot:

scrot ~/.config/i3/screen.png

#pixelate by downscaling and upscaling
convert -scale 10% ~/.config/i3/screen.png ~/.config/i3/screen.png
convert -scale 1000% ~/.config/i3/screen.png ~/.config/i3/screen.png
# Add the lock to the blurred image:
[[ -f ~/.scripts/lock.png ]] && convert ~/.config/i3/screen.png ~/.scripts/lock.png -geometry +605+305 -composite -matte ~/.config/i3/screen.png

#Pause music (mocp and mpd):
mpc pause

#Lock
i3lock -e -f 0 -i ~/.config/i3/screen.png

