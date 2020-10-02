#!/bin/bash
source ~/dotfiles/.scripts/music_utils/variables.sh
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

