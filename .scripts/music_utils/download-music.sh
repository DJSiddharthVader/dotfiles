#!/bin/bash
source ~/dotfiles/.scripts/music_utils/variables.sh
function updateMusic() {
    sudo youtube-dl -U
    cd $music_dir
    youtube-dl  --audio-quality 0                      \
                --audio-format "$format"               \
                --prefer-ffmpeg                        \
                --geo-bypass                           \
                -x                                     \
                -i                                     \
                --yes-playlist                         \
                --playlist-reverse                     \
                --verbose                              \
                --max-downloads 5                      \
                --download-archive "$download_archive" \
                -o "$youtubedl_format_str"             \
                "$source_playlist"
    cd -
}
updateMusic
