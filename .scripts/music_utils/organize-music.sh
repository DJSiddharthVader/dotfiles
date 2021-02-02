#!/bin/bash
##TODO:
# - output plots of song data
#    - genre distributions
#    - length distributions
#    - common phrases/words in titles/albums/arists/lyrics
source ~/dotfiles/.scripts/music_utils/variables.sh
declare -A char_replacements=( ["&"]=+ [/]=_ [" "]=. ) #[""]=""

function usage(){
    echo "
Usage $0 { all | \$FILES }

   all:    organizes all files in $music_dir
   \$FILES: renames each file provided as an arg
" && exit 0
}
function subCharacters(){
    #substitues characters that may exist in a metadata field but are bad for filenames
    if (( $# == 0 )); then
        str="$(cat)"
    else
        str="$1"
    fi
    str="$(echo "$str" | sed -E 's/ (.) /\1/g')"
    for pattern in "${!char_replacements[@]}"; do
        str="$(echo $str | tr "$pattern" "${char_replacements[$pattern]}")"
    done
    echo "$str"
}
function getSongField(){
    #for a song file get the metadat field value of the specified field
    file="$(readlink -e "$1")"
    field="$2"
    mediainfo "$file" | grep "$field" | tail -1 | cut -d':' -f2- | \
    sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}
function makeFileName(){
    filename="$1"
    song="$(  getSongField "$filename" 'Track name' | subCharacters)"
    artist="$(getSongField "$filename" 'Performer'  | subCharacters)"
    album="$( getSongField "$filename" 'Album'      | subCharacters)"
    suffix="$(basename "$filename" | perl -pe 's/^(.+?)__(.+)$/\2/')"
    newname="$artist/$album/$song$field_delimiter$artist$field_delimiter$suffix"
    echo "$newname"
}
function renameSongFile(){
    file="$(readlink -e "$1")"
    newfilename="$(makeFileName "$file")"
    newdir="$music_dir/$(dirname "$newfilename")"
    mkdir -p "$newdir"
    mv "$file" "$music_dir/$newfilename"
    echo "$music_dir/$newfilename"
}
function organizeMusic(){
    counter=0
    total="$(find "$music_dir" -maxdepth 1 -type f | wc -l)"
    echo "Organizing mp3s, $total files"
    while IFS='' read -r -d '' file; do
        renameSongFile "$file" > /dev/null
        percent=$(printf "%.*f" 0 "$(echo "100*$counter/$total" | bc -l)")
        progress $percent
        let counter++
    done < <(find -L "$music_dir" -maxdepth 1 -type f -name '*.mp3' -print0)
    find "$music_dir" -maxdepth 99 -type d -empty -delete #delete empty directories
    echo ''
}
function reOrganizeMusic(){
    find "$music_dir" -maxdepth 99 -type f -name '*.mp3' -exec mv {} "$music_dir" \;
    organizeMusic
}

if (( $# < 1 )); then
    usage
elif [[ "$1" == 'all' ]]; then
    organizeMusic
elif [[ "$1" == 'redo' ]]; then
    reOrganizeMusic
else
    for file in "$@"; do
        renameSongFile "$file"
    done
fi

