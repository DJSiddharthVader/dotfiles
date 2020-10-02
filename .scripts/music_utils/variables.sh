#!/bin/bash
music_dir="$HOME/Music/songs/"
playlist_dir="$HOME/.mpd/playlists/mostrecent.m3u"
art_dir="$HOME/Pictures/albumart"
tmp_dir="$HOME/Music/tmp"
format="mp3"
field_delimiter="__"

#For update-music
download_archive="$HOME/dotfiles/.varfiles/youtube-dl_downloads.txt"
source_playlist="https://www.youtube.com/playlist?list=PLMU-V2Iwwq69O1QA3kOtw_YTQ2q-sD-gT"
#youtubedl_format_str="./%(track)s$field_delimiter%(artist)s$field_delimiter%(album)s$field_delimiter%(genre)s$field_delimiter%(track_number)s$field_delimiter%(release_year)s$field_delimiter%(title)s$field_delimiter%(playlist_index)s$field_delimiter%(id)s.$format"
youtubedl_format_str="./%(title)s$field_delimiter%(playlist_index)s$field_delimiter%(id)s.$format"

#For organize-music
declare -A substitutionPatterns=( ["$"]="S" ["&"]="and" ["/"]="-" )
declare -A fieldNames=( ["Artist"]="Preformer" ["Title"]="Track Name" ["Album"]="Album" )


