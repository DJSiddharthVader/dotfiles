#!/bin/bash

wallidfile="$HOME/dotfiles/.varfiles/wallidx"
wallpfile="$HOME/dotfiles/.varfiles/fehbg"
head -"$(cat $wallidfile)" "$wallpfile" | tail -1
