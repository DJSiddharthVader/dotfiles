#!/bin/bash

port=2222
musicdir="$HOME/Music/songs/everything/"
destdir="~/SDCard/Music/Songs/"

ip="$1"

if [[ $# -eq 0 ]]; then
    echo 'Usage syncMusic.sh IP'
    exit 1
fi

rsync -e "ssh -p $port"     \
      --human-readable      \
      -rP                   \
      $musicdir $ip:$destdir
