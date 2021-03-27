#!/bin/bash

readings="$HOME/dotfiles/.varfiles/readings"
mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
reading_folder="reading list"
browser="firefox"
thresh=50

help() {
    echo "Error Usage: $0 {update|pick|open|display}"
}
getReading() {
    grep '^reading:' "$mode_file" | cut -d':' -f2-
}
setReading() {
    sed -i "/^reading:/s/:.*/:$1/" "$mode_file"
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
    rnd_article="$(cat $readings | shuf | tail -1)"
    setReading "$rnd_article"
    killall -q "$(basename $0)" > /dev/null 2>&1 #restart zscroll with new article so scroll updates
}
open() {
    "$browser" --new-tab "$(cat $reading | cut -f2 -d'~')" #open article in browser
}
display() {
    #scroll article title if longer than $thresh characeters otherwise static display
    articlename="$(getReading | cut -f1 -d'~')"
    if [[ ${#articlename} -gt $thresh ]]; then
        ( zscroll -l "$thresh" -d 0.20 -b "" -a "" -p " /// " "$articlename" ) &
       wait
    else
        echo "$articlename"
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

