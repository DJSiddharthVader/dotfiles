#!/bin/bash

wallidfile="$HOME/dotfiles/.varfiles/wallidx"
wallpfile="$HOME/dotfiles/.varfiles/fehbg"
picdir="$HOME/Pictures/wallpapers"
name="$(head -"$(cat $wallidfile)" "$wallpfile" | tail -1)"
echo "$picdir/$name"
