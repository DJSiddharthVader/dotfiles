#!/bin/bash

DEFAULT_PLAYLIST="https://www.youtube.com/playlist?list=PLMU-V2Iwwq69O1QA3kOtw_YTQ2q-sD-gT"
ARCHIVE="$HOME/.varfiles/ytmdl_archive.txt"


if [[ -z "$1" ]]; then
    playlist="$DEFAULT_PLAYLIST"
elif [[ "$1" = 'default' ]]; then
    playlist="$DEFAULT_PLAYLIST"
else
    playlist="$1"
fi
args=("${@:2}")
ytmdl --download-archive "$ARCHIVE" \
      --on-meta-error 'manual' \
      --format 'mp3' \
      --ask-meta-name \
      --ignore-errors \
      --disable-sort \
     "${args[@]}" "$playlist"
