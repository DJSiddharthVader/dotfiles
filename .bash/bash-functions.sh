#!/bin/bash
# Functions
up() { # Goes up many dirs as the number passed as argument, if none goes up by 1 by default
    local d=""
    limit=$1
    for ((i=1 ; i <= limit ; i++)); do
        d=$d/..
    done
    d=$(echo $d | sed 's/^\///')
    if [[ -z "$d" ]]; then
        d=..
    fi
    cd $d
}
dirsize () { # List sub-directory sizes in pwd
    du -shx * .[a-zA-Z0-9_]* 2> /dev/null | egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
    egrep '^ *[0-9.]*M' /tmp/list
    egrep '^ *[0-9.]*G' /tmp/list
    rm -rf /tmp/list
}
prog() { # progress bar, print at a given percent
    local w=60 p=$1;  shift
    # create a string of spaces, then change them to dots
    printf -v dots "%*s" "$(( $p*$w/100 ))" ""; dots=${dots// /\#};
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
    read -p "Delete all empty folders recursively [y/N]: " OPT
    [[ $OPT == y ]] && find . -type d -empty -exec rm -fr {} \; &> /dev/null
}
dcols() {  # print column names and example data descriptively
    tsv="$1"
    rows="${2:-3}"
    head -$rows "$tsv" | tr '\t' '\n' | sed -e 's/\n$//' | pr -ts$'\t' --columns $rows | column -s$'\t' -t
}
slog() {
    # show most recent log from lsf with a given name
    name="$1"
    log_dir="./logs"
    log_num="$(ls "$log_dir" | grep "${name}" | cut -d'-' -f2 | cut -d'.' -f1 | sort -n | tail -1)"
    log_name="${log_dir}/${name}-${log_num}"
    cat ${log_name}.out ${log_name}.err | less
}
