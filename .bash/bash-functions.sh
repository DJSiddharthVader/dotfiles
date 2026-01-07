#!/bin/bash

prog() { # progress bar, print at a given percent
    local w=60 p=$1;  shift
    # create a string of spaces, then change them to dots
    printf -v dots "%*s" "$(( $p*$w/100 ))" ""; dots=${dots// /#};
    # print those dots on a fixed-width space plus the percentage etc.
    printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*";
}
mvpr() {
    #move with a progress bar
    dest="${@: -1}"
    counter=0
    total="$(echo $# -1 | bc -l)"
    echo 'Moving files...'
    for file in "${@: 1:$#-1}"; do
        mv "$file" "$dest"
        let counter++
        prc="$(echo "100*$counter/$total" | bc -l)"
        percent="$(printf "%.*f" 0 $prc )"
        prog "$percent"
    done
    echo ''
}
pdfs() {
    tabbed -c zathura "$@" -e
}
mkref() {
    getref "$1" | sed -e "s/\(@article{\).*/\1${2},/"
}
fared() { # Find and remove empty directories
    read -rp "Delete all empty folders recursively [y/N]: " OPT
    [[ $OPT == y ]] && find . -type d -empty -exec rm -fr {} \; &> /dev/null
}

dcols() {  # print column names and example data descriptively
    tsv="$1"
    rows="${2:-3}"
    head -"${rows}" "$tsv" | tr '\t' '\n' | sed -e 's/\n$//' | pr -ts$'\t' --columns $rows | column -s$'\t' -t
}

