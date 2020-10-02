#!/bin/bash
art_dir="$HOME/Pictures/albumart"
music_dir="$HOME/Music/songs/"

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


#utilities
progress() {
    local w=60 p=$1;  shift
    # create a string of spaces, then change them to dots
    printf -v dots "%*s" "$(( $p*$w/100 ))" ""; dots=${dots// /#};
    # print those dots on a fixed-width space plus the percentage etc.
    printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*";
}
subChars() {
#char substitutions
#$ -> S
#/   -> |
#field -> __
    echo "$1" | tr '/' '|' | sed 's/\$/S/g'
}
#get info for file
getArtist() {
    mediainfo "$file" | \
    grep 'Performer ' | \
    tail -1 | \
    cut -d':' -f2- | \
    sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}
getAlbum() {
    mediainfo "$1" | \
    grep 'Album ' | \
    head -1 | \
    cut -d':' -f2- | \
    sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}
getTitle() {
    mediainfo "$1" | \
    grep 'Track name' | \
    head -1 | \
    cut -d':' -f2- | \
    sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}
getYTVidID() {
    #pattern from this post
    #https://webapps.stackexchange.com/questions/54443/format-for-id-of-youtube-video
    file="$1"
    pattern="(?<=-)[0-9A-Za-z_-]{10}[048AEIMQUYcgkosw](?=.mp3)"
    basename "$file" | grep -oP "$pattern"
}
#apply to single files
renameSongFile() {
    file="$1"
    #song info
    album="$(getAlbum "$file")"
    artist="$(getArtist "$file")"
    title="$(getTitle "$file")"
    ytid="$(getYTVidID "$file")"
    #set new file name
    if [[ "$ytid" == "" ]]
    then
        newfile="$title"__"$artist"__"$album".mp3
    else
        newfile="$title"__"$artist"__"$album"__"$ytid.mp3"
    fi
    newfile="$(subChars "$newfile")"
    #set new file directory
    songdir="$(dirname "$file" | rev | cut -d'/' -f2 | rev )"
    if [[ "$songdir" == "$artist/$album" ]]
    then
        continue
    else
        songdir="$musicdir"/"$(subChars "$artist")"/"$(subChars "$album")"
        mkdir -p "$songdir"
    fi
    mv "$(readlink -e "$file")" "$songdir/$newfile"
}
addToTrack() {
    file="$(readlink -e "$1")"
    rm ~/.mismatchedAlbumCoverNames.txt
    #song info
    album="$(getAlbum "$file")"
    artist="$(getArtist "$file")"
    title="$(getTitle "$file")"
    if [[ "$album" =~ 'Single' ]] #if no album art
    then
        lame --quiet --add-id3v2 --tl "$album" --ta "$artist" --tt "$title"               "$file" "$file".keep
    else #if has album art
        image="$artdir/$(subChars "$artist - $album.jpeg")"
        ls "$image" 1> /dev/null 2>> ~/.mismatchedAlbumCoverNames.txt
        lame --quiet --add-id3v2 --tl "$album" --ta "$artist" --tt "$title" --ti "$image" "$file" "$file".keep
    fi
    mv "$file".keep "$file" #replace original file with new file created by lame
    renameSongFile "$file"
}
#loop over dirs
organizeMusicFiles() {
    musicdir="$(readlink -e "$1")"
    total="$(find "$musicdir" -type f | wc -l)"
    counter=0
    echo "Organizing mp3s, $total files"
    while IFS='' read -r -d '' file; do
        renameSongFile "$file" 2> /dev/null
        percent=$(printf "%.*f" 0 "$(echo "100*$counter/$total" | bc -l)")
        progress $percent
        let counter++
    done < <(find -L "$musicdir" -type f -name '*.mp3' -print0)
    find "$musicdir" -type d -empty -delete #delete empty directories
    rm -rf "$musicdir"/___*.mp3
}
mainNonRecursive() {
    #same as main, but only look at files in speficied directory, dont recurse into nested dirs
    #setup
    musicdir="$(readlink -e "$1")"
    total="$(find "$musicdir" -maxdepth 1 -type f | wc -l)"
    counter=0
    echo "Assigning album art, $total files"
    while IFS='' read -r -d '' file; do
        addToTrack "$file" 2> /dev/null
        percent=$(printf "%.*f" 0 "$(echo "100*$counter/$total" | bc -l)")
        progress $percent
        let counter++
    done < <(find -L "$musicdir" -maxdepth 1 -type f -name '*.mp3' -print0)
}
main() {
    #setup
    musicdir="$(readlink -e "$1")"
    total="$(find "$musicdir" -type f | wc -l)"
    counter=0
    echo "Assigning album art, $total files"
    while IFS='' read -r -d '' file; do
        addToTrack "$file" 2> /dev/null
        percent=$(printf "%.*f" 0 "$(echo "100*$counter/$total" | bc -l)")
        progress $percent
        let counter++
    done < <(find -L "$musicdir" -type f -name '*.mp3' -print0)
    #find "$musicdir" -name '*.keep'  -exec sh -c 'mv "$0" "${0%.mp3.keep}.mp3"' {} \;
}

#addToTrack "$1" # add art/metadata  to single track $1
#time main "$musicdir" #do for all tracks in library (musicdir)
#time mainNonRecursive "$(readlink -e "$1")" #same as main but with -maxdepth 1
#time organizeMusicFiles "$musicdir" #rename and place files
time mainNonRecursive "$musicdir"
