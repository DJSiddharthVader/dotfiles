#!/bin/bash
mpc pause
pulseaudio --kill
pulseaudio --kill
pulseaudio --kill
pulseaudio --start
~/dotfiles/.scripts/bar_manager.sh auto
