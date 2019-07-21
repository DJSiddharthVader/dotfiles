#!/bin/bash
mpc pause
pulseaudio --kill
pulseaudio --kill
pulseaudio --kill
pulseaudio --start
~/.scripts/bar_manager.sh auto
