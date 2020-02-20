#!/bin/bash
mpc pause
pulseaudio --kill
pulseaudio --kill
pulseaudio --kill
pulseaudio --start
~/dotfiles/.scripts/bar-manager.sh stay
