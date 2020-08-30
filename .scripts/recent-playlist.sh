#!/bin/bash

music_dir="$HOME/Music/songs/everything"

#$size most recent songs
playlist="$HOME/.mpd/playlists/mostrecent.m3u"
size=50
find $music_dir -maxdepth 99 -type f -printf "%T+\t%p\n" | sort -n | cut -f2- | tail -"$size" >| $playlist

#all songs modified within mtime minutes (1 week)
playlist="$HOME/.mpd/playlists/mostrecentadded.m3u"
if [[ $# > 0 ]];then
    mtime="$1"
else
    mtime=$((60*24*7)) #1 week in seconds
fi
find $music_dir -maxdepth 99 -type f -mmin -$mtime | cut -f2-  >| $playlist
