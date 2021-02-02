#!/bin/bash
source "$HOME/dotfiles/.scripts/music_utils/variables.sh"
size=50
mtime=$((60*24*7)) #1 week in minutes

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
function Unorganized(){
    #all songs modified in the past mtime minutes (1 week)
    playlist="$1"
    find $music_dir -maxdepth 1 -type f >| $playlist
}
function WholeLibrary(){
    #all songs in music dir
    playlist="$1"
    find $music_dir -maxdepth 99 -type f >| $playlist
}
function Genres(){
    #all songs in each genre
    playlist="$1"
    find $music_dir -maxdepth 99 -type f | cut -f2-  >| $playlist
}
function main(){
    TopMostRecentModified "$playlist_dir/mostrecent.m3u" $size
    ModifiedInPastTime "$playlist_dir/mostrecentadded.m3u" $mtime
    WholeLibrary "$playlist_dir/all.m3u"
    Unorganized "$playlist_dir/unorganized.m3u"
}

main
