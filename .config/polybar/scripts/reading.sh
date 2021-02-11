#!/bin/bash

readings="$HOME/dotfiles/.varfiles/readings"
reading="$HOME/dotfiles/.varfiles/reading"
reading_folder="reading list"
browser="firefox"
thresh=60

help() { echo "Error Usage: $0 {update|pick|open|display}" && exit 1 ; }
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
    cat $readings | shuf | tail -1 >| $reading   #pick new random article
    killall -q "$(basename $0)" > /dev/null 2>&1 #restart zscroll with new article so scroll updates
}
open() { "$browser" --new-tab "$(cat $reading | cut -f2 -d'~')" ; } #open article in browser
display() {
    #scroll article title if longer than $thresh characeters otherwise static display
    articlename="$(cat "$reading" | cut -f1 -d'~')"
    if [[ ${#articlename} -gt $thresh ]]; then
        ( zscroll -l "$thresh" -d 0.20 -b " " -a "" -p " /// " "$(cat "$reading" | cut -f1 -d'~')" ) &
       wait
    else
        echo " $articlename"
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

