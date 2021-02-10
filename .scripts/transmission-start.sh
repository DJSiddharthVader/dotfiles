#!/bin/bash

download_dir="$HOME/Torrents/"
torrent_dir="$HOME/.config/transmission-daemon/torrents"

transmission-daemon
transmission-remote -w "$download_dir"
for file in "$torrent_dir"/*.torrent; do
    transmission-remote -a "$file"
done
