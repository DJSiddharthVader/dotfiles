#!/bin/bash

readings="$HOME/.readings.txt"
mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
reading_folder="reading list"
browser="firefox"
thresh=60

help() {
    echo "Error Usage: $0 {update|pick|open|display}"
}
getArticle() {
    grep '^reading:' "$mode_file" | cut -d':' -f2- | cut -d'~' -f1
}
getLink() {
    grep '^reading:' "$mode_file" | cut -d':' -f2- | cut -d'~' -f2
}
setReading() {
    escaped=$(printf '%s\n' "$1" | sed -e 's/[\/&]/\\&/g') # link has funny chars, must escape for sed
    sed -i "/^reading:/s/:.*/:$escaped/" "$mode_file"
}

update() {
    #update list of readings to read for local file
    #isolates all readings in the reading_folder folder
    #formats so each line is: web page title~link
    buku --json -p | jq -a .                           \
                   | sed -e 's/\\u[0-9A-Za-z]\{4\}//g' \
                   | grep -A2 'reading list'           \
                   | grep 'title\|uri'                 \
                   | cut -f2- -d':'                    \
                   | sed -e 's/^ "\(.*\)"/\1/'         \
                   | perl -pe 's/,\n/~/'               \
                   | tr -s ' ' ' '                    >| $readings
}
pick() {
    setReading "$(cat $readings | shuf -n1)"
    #restart zscroll with new article so scroll updates
    killall -q "$(basename $0)" > /dev/null 2>&1
    #polybar-msg hook reading 1 # for ipc messaging to polybar
}
open() {
    "$browser" --new-tab "$(getLink)" #open article in browser
}
display() {
    #scroll article title if longer than $thresh characeters otherwise static display
    articlename="$(getArticle)"
    if [[ ${#articlename} -gt $thresh ]]; then
        ( zscroll -l "$thresh" -d 0.20 -b "" -a "" -p " /// " "$(getArticle)" ) &
        wait
    else
        # right pad with spaces until total length $thresh
        # keeps module width constant no matter article length
        printf "%-${thresh}s" "$(getArticle)"
    fi
}

main() {
    mode="$1"
    case "$mode" in
        'display') display ;;
        'open'   ) open ;;
        'pick'   ) pick ;;
        'update' ) update ;;
        *        ) help && exit 1 ;;
    esac
}

main "$1"

