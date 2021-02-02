#!/bin/bash
script_dir="$HOME/dotfiles/.scripts/music_utils"
music_dir="$HOME/Music/songs"
playlist_dir="$HOME/.mpd/playlists"
art_dir="$HOME/Pictures/albumart"
format="mp3"
field_delimiter="__"

#For update-music
download_archive="$HOME/dotfiles/.varfiles/youtube-dl_downloads.txt"
source_playlist="https://www.youtube.com/playlist?list=PLMU-V2Iwwq69O1QA3kOtw_YTQ2q-sD-gT"
youtubedl_format_str="./%(title)s$field_delimiter%(playlist_index)s$field_delimiter%(id)s.%(ext)s"


function progress() {
    local w=60 p=$1;  shift
    # create a string of spaces, then change them to dots
    printf -v dots "%*s" "$(( $p*$w/100 ))" ""; dots=${dots// /#};
    # print those dots on a fixed-width space plus the percentage etc.
    printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*";
}
