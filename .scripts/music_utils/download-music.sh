#!/bin/bash
source ~/dotfiles/.scripts/music_utils/variables.sh

function getStartIndex(){
    playlist_length="$(youtube-dl "$source_playlist" -J --flat-playlist | jq ".entries | length")"
    downloaded="$(wc -l "$download_archive" | sed -E 's/^([0-9]+)[^0-9].*$/\1/')"
    start_index=$(( $playlist_length - $downloaded + 2 )) #incase aborted last time +2 so it doesnt skip a song
    echo "$start_index"
}
function downloadMusic(){
    #sudo youtube-dl -U
    cd $music_dir
    #start_index="$(getStartIndex)"
    #echo "Downloading: $start_index songs"
    youtube-dl  -ix                                    \
                --audio-quality 0                      \
                --audio-format "$format"               \
                --prefer-ffmpeg                        \
                --yes-playlist                         \
                --playlist-reverse                     \
                --download-archive "$download_archive" \
                -o "$youtubedl_format_str"             \
                "$source_playlist"
    cd -
}

downloadMusic
