#!/bin/bash
music_dir="$HOME/Music/songs/"
tmp_dir="$HOME/Music/tmp"
art_dir="$HOME/Pictures/albumart"
download_archive="$HOME/dotfiles/.varfiles/youtube-dl_downloads.txt"
source_playlist="https://www.youtube.com/playlist?list=PLMU-V2Iwwq69O1QA3kOtw_YTQ2q-sD-gT"
field_delimiter="__"
format="acc"
youtubedl_format_str="./%(track)s$field_delimiter%(artist)s$field_delimiter%(album)s$field_delimiter%(genre)s$field_delimiter%(track_number)s$field_delimiter%(release_year)s$field_delimiter%(title)s$field_delimiter%(playlist_index)s$field_delimiter%(id)s.$format"
declare -A substitutionPatterns=( ["$"]="S" ["&"]="and" ["/"]="-" )
declare -A fieldNames=( ["Artist"]="Preformer" ["Title"]="Track Name" ["Album"]="Album" )

##TODO:
# - fetch album from album/artist name for song -> download -> name correctly
# - get lyrics, write to file
# - get song metadata
#    - necessary are:
#      - title
#      - album
#      - artist
#    - would be nice:
#      - genre
#      - year
#      - track number
#      - Date
#      - Comment (youtube download ID)
# - output plots of song data
#    - genre distributions
#    - length distributions
#    - common phrases/words in titles/albums/arists/lyrics

function progress() {
    local w=60 p=$1;  shift
    # create a string of spaces, then change them to dots
    printf -v dots "%*s" "$(( $p*$w/100 ))" ""; dots=${dots// /#};
    # print those dots on a fixed-width space plus the percentage etc.
    printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*";
}
function convertToACC(){
    #from https://askubuntu.com/questions/65331/how-to-convert-a-m4a-sound-file-to-mp3
    toconvert="$1"
    filename="$(echo $toconvert | rev | cut -d'.' -f2- | rev )"
    #ffmpeg -v 5 -y -i "$m4afile" -acodec libmp3lame -ac 2 -ab 192k "$filename.mp3"
    ffmpeg -i "$toconvert" -acodec copy "$filename".aac > /dev/null 2>&1
    \rm "$m4afile"
}

function updateMusic() {
    sudo youtube-dl -U
    #cd $music_dir
    youtube-dl  --audio-quality 0                      \
                --audio-format "$format"               \
                --prefer-ffmpeg                        \
                --geo-bypass                           \
                -x                                     \
                -i                                     \
                --yes-playlist                         \
                --verbose                              \
                --max-downloads 5                      \
                -o "$youtubedl_format_str"             \
                "$source_playlist"
#                --download-archive "$download_archive" \
    cd -
}


function addMetadataToFile() {
    songfile="$1" #file with name specified by $youtubedl_format_str
    image="$2"
    lame --quiet --add-id3v2 --tl "$album" --ta "$artist" --tt "$title"               "$file" "$file"
    if [[ "$album" =~ 'Single' ]]; then #if no album art
        lame --quiet --ti "$image" "$file" "$file".keep
    fi
}
function getSongField() {
    #for a song file get the metadat field value of the specified field
    file="$1"
    field="$2"
    mediainfo "$file" | grep "$field" | tail -1 | cut -d':' -f2- | \
    sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}
function substituteInvalidCharacters() {
    #substitues characters that may exist in a metadata field but are bad for filenames
    # file can have all ASCII Characters
    str="$1"
    for pattern in "${!MYMAP[@]}"; do
        str="$(echo $str | tr "$pattern" "${substitutionPatterns[$pattern]}")"
    done
    echo "$str"
}
function makeFileName() {
    songfile="$1"
    titleformat="$2"
    extension="$(echo $songfile | rev | cut -d'.' -f1 | rev )"
    newfile=""
    for field in ${titleformat//$field_delimiter/$'\n'}; do
        toadd="$(getSongField $songfile $field)"
        newfile="$newfile$field_delimiter$toadd"
    done
    newfile="$(substituteInvalidCharacters $newfile)"
    echo "$newfile.$extension"
}
function organizeMusicFiles() {
    total="$(find "$music_dir" -type f | wc -l)"
    counter=0
    echo "Organizing mp3s, $total files"
    while IFS='' read -r -d '' file; do
        renameSongFile "$file" 2> /dev/null
        percent=$(printf "%.*f" 0 "$(echo "100*$counter/$total" | bc -l)")
        progress $percent
        let counter++
    done < <(find -L "$music_dir" -type f -name '*.mp3' -print0)
    find "$music_dir" -maxdepth 99 -type d -empty -delete #delete empty directories
}

#updateMusic
convertM4AToMP3 "$1"
