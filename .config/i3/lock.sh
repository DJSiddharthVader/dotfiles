#!/bin/bash

# Take /tmp/screen.pnga screenshot:

scrot ~/.config/i3/screen.png

# Create a blur on the shot:
#convert /tmp/screen.png -paint 1 -swirl 360 /tmp/screen.png
#convert /tmp/screen.png -blur 0x8 /tmp/screen.png
convert -scale 10% ~/.config/i3/screen.png ~/.config/i3/screen.png
convert -scale 1000% ~/.config/i3/screen.png ~/.config/i3/screen.png
# Add the lock to the blurred image:
[[ -f ~/.config/i3/lock.png ]] && convert ~/.config/i3/screen.png ~/.config/i3/lock.png -geometry +620+320 -composite -matte ~/.config/i3/screen.png

# Pause music (mocp and mpd):
mpc pause

# Lock it up!
i3lock -e -f 0 -i ~/.config/i3/screen.png

# If still locked after 20 seconds, turn off screen.
#sleep 20 && pgrep i3lock && xset dpms force off
