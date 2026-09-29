#!/usr/bin/bash

# kill compositor if running
pgrep picom
was_compositor_running=$?
[[ ${was_compositor_running} == 0 ]] && killall -9 picom 
# take screenshot + copy + remove cache
scrot /tmp/screenshot.png -s -e 'xclip -selection clipboard -t image/png -i $f' && sleep 1
rm /tmp/screenshot.png
# restart compositor if it was running 
[[ ${was_compositor_running} == 0 ]] && picom &
