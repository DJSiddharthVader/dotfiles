#!/bin/bash
mpc pause
pulseaudio --kill
pulseaudio --kill
pulseaudio --kill
pulseaudio --start
~/.scripts/togglebar.sh auto
