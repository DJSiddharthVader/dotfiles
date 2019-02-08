#!/bin/bash
pulseaudio -k
pulseaudio --start
killall -q polybar
~/.scripts/polybar_launch
