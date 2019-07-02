#!/bin/bash

music='/home/sidreed/Music/songs/everything'
art='/home/sidreed/Pictures/albumart'

prog() {
    local w=60 p=$1;  shift
    # create a string of spaces, then change them to dots
    printf -v dots "%*s" "$(( $p*$w/100 ))" ""; dots=${dots// /#};
    # print those dots on a fixed-width space plus the percentage etc.
    printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*";
}
getArtist() {
    mediainfo "$file" | \
    grep 'Performer ' | \
    tail -1 | \
    cut -d':' -f2- | \
    sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | \
    sed 's/\$/S/g'
}
getAlbum() {
    mediainfo "$1" | \
    grep 'Album ' | \
    head -1 | \
    cut -d':' -f2- | \
    sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | \
    tr '/' '|' | \
    sed 's/\$/S/g'
}
main() {
    musicdir="$1"
    artdir="$2"
    total="$(find "$musicdir" -type f | wc -l)"
    counter=0
    echo 'Assigning album art'
    while IFS='' read -r -d '' file; do
        album="$(getAlbum "$file")"
        if [[ "$album" =~ 'Singles' ]]
        then
            continue
        fi
        artist="$(getArtist "$file")"
        image="$artdir/$artist - $album.jpeg"
        ls "$image" 1> /dev/null 2>> ~/.mismatchedAlbumCoverNames.txt
        lame --quiet --ti "$image" "$file"
        percent=$(printf "%.*f" 0 "$(echo "100*$counter/$total" | bc -l)")
        prog $percent
        let counter++
    done < <(find -L "$musicdir" -type f -print0)
}

main "$music" "$art"
