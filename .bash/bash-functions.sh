#!/bin/bash

# Functions
ff() { # Find a file with a pattern in name
    find . -type f -iname '*'$*'*' -ls
}
fe() { # Find a file with pattern $1 in name and execute $2 on it
    find . -type f -iname '*'$1'*' -exec "${2:-file}" {} \;
}
fl() {
    # echo line $1 from file $2
    head -$1 $2 | tail -1;
}
jless() {
    jq . -C $1 | less -R;
}
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
hw() {
    #compile HW assignments with pandoc tempate
    mdfile="$(find . -type f -name '*HW*.md')" #hw answers in current dir
    pdffile="${mdfile%.*}.pdf"
    pandoc "$mdfile" -s -o "$pdffile"
}
pdfs() {
    tabbed -c zathura "$@" -e
}

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
extract() { # Archive Extractor {{{
  filename=`basename "$1"`
  case "${filename#*.}" in
    tar) tar x${3}f "$1" -C "$DESTDIR" ;;
    gz) tar x${3}fz "$1" -C "$DESTDIR" ;;
    tgz) tar x${3}fz "$1" -C "$DESTDIR" ;;
    xz) tar x${3}f -J "$1" -C "$DESTDIR" ;;
    bz2) tar x${3}fj "$1" -C "$DESTDIR" ;;
    zip) unzip "$1" -d "$DESTDIR" ;;
    rar) unrar x "$1" "$DESTDIR" ;;
    7z) 7za e "$1" -o"$DESTDIR" ;;
    *) echo -e "${clrstart}Unknown archieve format!" ;;
  esac
}
compress() {
# Archive Compress {{{
      if [[ -n "$1" ]]; then
        FILE=$1
        case $FILE in
        *.tar ) shift && tar cf $FILE $* ;;
    *.tar.bz2 ) shift && tar cjf $FILE $* ;;
     *.tar.gz ) shift && tar czf $FILE $* ;;
        *.tgz ) shift && tar czf $FILE $* ;;
        *.zip ) shift && zip $FILE $* ;;
        *.rar ) shift && rar $FILE $* ;;
        esac
      else
        echo "usage: compress <foo.tar.gz> ./foo ./bar"
      fi
    }
remindme() { sleep $1 && notify-send "$2" & }
# usage: remindme <time> <text>
# e.g.: remind 10m "omg, the pizza"

# Simple Calculator {{{
calc() {
  if which bc &>/dev/null; then
      echo "scale=3; $*" | bc -l
  else
      awk "BEGIN { print $* }"
  fi
}
compress() { # Archive Compress
      if [[ -n "$1" ]]; then
        FILE=$1
        case $FILE in
        *.tar ) shift && tar cf $FILE $* ;;
    *.tar.bz2 ) shift && tar cjf $FILE $* ;;
     *.tar.gz ) shift && tar czf $FILE $* ;;
        *.tgz ) shift && tar czf $FILE $* ;;
        *.zip ) shift && zip $FILE $* ;;
        *.rar ) shift && rar $FILE $* ;;
        esac
      else
        echo "usage: compress <foo.tar.gz> ./foo ./bar"
      fi
}
dirsize () { # List sub-directory sizes in pwd
    du -shx * .[a-zA-Z0-9_]* 2> /dev/null | egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
    egrep '^ *[0-9.]*M' /tmp/list
    egrep '^ *[0-9.]*G' /tmp/list
    rm -rf /tmp/list
}
fared() { # Find and remove empty directories
    read -p "Delete all empty folders recursively [y/N]: " OPT
    [[ $OPT == y ]] && find . -type d -empty -exec rm -fr {} \; &> /dev/null
}
remindme() { # usage: remindme <time> <text>
    # e.g.: remind 10m "omg, the pizza"
    sleep $1 && notify-send "$2" &
}
