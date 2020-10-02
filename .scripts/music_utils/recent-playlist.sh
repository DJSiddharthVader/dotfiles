#!/bin/bash
source "$HOME/dotfiles/.scripts/music_utils/variables.sh"
size=50
mtime=$((60*24*7)) #1 week in seconds

function TopMostRecentModified(){
    #x most recent songs
    playlist="$1"
    size="$2"
    find $music_dir -maxdepth 99 -type f -printf "%T+\t%p\n" | sort -n | cut -f2- | tail -"$size" >| $playlist
}
function ModifiedInPastTime(){
    #all songs modified in the past mtime minutes (1 week)
    playlist="$1"
    mtime="$2"
    find $music_dir -maxdepth 99 -type f -mmin -$mtime | cut -f2-  >| $playlist
}
function main(){
    playlist="$playlist_dir/mostrecent.m3u"
    TopMostRecentModified $playlist $size
    playlist="$playlist_dir/mostrecentadded.m3u"
    ModifiedInPastTime $playlist $mtime
}

main
