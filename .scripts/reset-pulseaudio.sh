#!/bin/bash
mpc pause
pulseaudio --kill
pulseaudio --kill
pulseaudio --kill
pulseaudio --start
~/.scripts/togglebar.sh "$(head -1 $HOME/dotfiles/.bartoggle)"
